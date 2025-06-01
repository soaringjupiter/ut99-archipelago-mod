class APTcpLinkConnector extends IpDrv.TcpLink
    config(APLadder);

var config string BridgeHost;
var config int    BridgePort;
var config float  ConnectTimeout;

var bool bIsConnected;
var string PendingSendQueue[16]; // Simple queue for messages if not connected
var int PendingSendCount;
var string CheckedLocationsBuffer;

// Persistent connector singleton per level
static function APTcpLinkConnector Launch(Actor Owner)
{
    local APTcpLinkConnector H;
    local APChatMonitor ChatMon;

    // Try to find an existing connector
    foreach Owner.AllActors(class'APTcpLinkConnector', H)
        if (H != None && H.bIsConnected)
            return H;
    // Otherwise, spawn a new one
    H = Owner.Spawn(class'APTcpLinkConnector');
    if (H != None)
        H.Connect();
    // Ensure APChatMonitor exists
    foreach Owner.AllActors(class'APChatMonitor', ChatMon)
        if (ChatMon != None)
            return H;
    Owner.Spawn(class'APChatMonitor');
    return H;
}

function Connect()
{
    local IpAddr Addr;
    if (!StringToIpAddr(BridgeHost, Addr))
    {
        Log("AP bridge: Invalid BridgeHost: " $ BridgeHost, 'ScriptWarning');
        return;
    }
    Addr.Port = BridgePort;
    BindPort(0, false);
    Open(Addr);
}

event Opened()
{
    bIsConnected = true;
    Log("AP bridge connected!");
    // Send any queued messages
    FlushPendingSends();
    // Request all current unlocks
    SendJSON("{\"action\": \"poll\"}");
    // Request all checked locations
    RequestCheckedLocations();
}

event Closed()
{
    bIsConnected = false;
    Log("AP bridge closed, will retry...");
    SetTimer(3, false); // Try to reconnect after 3 seconds
}

event Timer()
{
    Connect();
}

event ReceivedText(string Text)
{
    // Handle each line (may receive multiple lines at once)
    local int i, j, length;
    local string Line, NewLine;

    NewLine = Chr(10);
    length = Len(Text);
    i = 0;
    while (i < length)
    {
        j = InStr(Mid(Text, i), NewLine);
        if (j == -1)
        {
            Line = Mid(Text, i);
            i = length;
        }
        else
        {
            Line = Left(Mid(Text, i), j);
            i = i + j + 1;
        }
        HandleJSONLine(Line);
    }
}

function HandleJSONLine(string Line)
{
    if (InStr(Line, "\"action\": \"checked_locations\"") != -1)
    {
        UpdateCompletedFromCheckedLocations(ParseJSONValue(Line, "maps"));
    }
    else if (InStr(Line, "\"action\": \"unlock\"") != -1)
    {
        HandleUnlock(ParseJSONValue(Line, "map"));
    }
    else if (InStr(Line, "\"action\": \"chat\"") != -1)
    {
        BroadcastChat(ParseJSONValue(Line, "msg"));
    }
    else if (InStr(Line, "\"action\": \"error\"") != -1)
    {
        Log("AP bridge error: " $ ParseJSONValue(Line, "msg"));
    }
    // Add more actions as needed
}

function string ParseJSONValue(string Line, string Key)
{
    // Extracts the value for a given key from a flat JSON object (no nested objects)
    local int k, v, q1, q2;
    local string Search, Value, Quote;
    Quote = Chr(34);
    Search = Quote $ Key $ Quote $ ":";
    k = InStr(Line, Search);
    if (k == -1)
        return "";
    v = k + Len(Search);
    // Skip whitespace
    while (Mid(Line, v, 1) == " " || Mid(Line, v, 1) == "\t")
        v++;
    if (Mid(Line, v, 1) == Quote)
    {
        q1 = v + 1;
        q2 = InStr(Mid(Line, q1), Quote);
        if (q2 != -1)
            Value = Left(Mid(Line, q1), q2);
        else
            Value = Mid(Line, q1);
    }
    else
    {
        // Not a quoted value
        q2 = InStr(Mid(Line, v), ",");
        if (q2 == -1)
            Value = Mid(Line, v);
        else
            Value = Left(Mid(Line, v), q2);
    }
    Log("AP bridge: Parsed value for " $ Key $ ": " $ Value);
    return Value;
}

function BroadcastChat(string Msg)
{
    local Pawn P;
    for (P = Level.PawnList; P != None; P = P.NextPawn)
        if (P.IsA('PlayerPawn'))
            PlayerPawn(P).ClientMessage(Msg, 'Say', true);
}

function HandleUnlock(string MapShortName)
{
    local Inventory Inv;
    Inv = Level.PawnList.Inventory;
    while (Inv != None)
    {
        Log("AP bridge: Handling unlock for " $ MapShortName);
        if (Inv.IsA('APMapInventory'))
        {
            APMapInventory(Inv).UnlockByShortName(MapShortName);
            return;
        }
        Inv = Inv.Inventory;
    }
}

function SendJSON(string Msg)
{
    local string NewLine;
    NewLine = Chr(13) $ Chr(10);
    if (bIsConnected)
    {
        Log("AP bridge sending: " $ Msg);
        SendText(Msg $ NewLine);
    }
    else if (PendingSendCount < 16)
    {
        PendingSendQueue[PendingSendCount++] = Msg;
        Log("AP bridge not connected, queued: " $ Msg);
    }
    else
    {
        Log("AP bridge send queue full, dropping: " $ Msg);
    }
}

function FlushPendingSends()
{
    local int i;
    local string NewLine;
    NewLine = Chr(13) $ Chr(10);
    for (i = 0; i < PendingSendCount; ++i)
        SendText(PendingSendQueue[i] $ NewLine);
    PendingSendCount = 0;
}

function RequestCheckedLocations()
{
    SendJSON("{\"action\": \"checked_locations\"}");
}

function UpdateCompletedFromCheckedLocations(string MapsArray)
{
    // MapsArray is a JSON array of map names, e.g. ["DM-Stalwart","DOM-Ghardhen"]
    local string MapName;
    local int i, start, end, length;
    local APMapInventory Inv;
    Inv = None;
    if (Level.PawnList != None)
        Inv = APMapInventory(Level.PawnList.Inventory);
    if (Inv == None)
        return;
    // Clear completed mask
    Inv.ClearCompleted();
    length = Len(MapsArray);
    i = 0;
    while (i < length)
    {
        // Find next quoted string
        start = InStr(Mid(MapsArray, i), Chr(34));
        if (start == -1)
            break;
        start = i + start + 1;
        end = InStr(Mid(MapsArray, start), Chr(34));
        if (end == -1)
            break;
        MapName = Left(Mid(MapsArray, start), end);
        Inv.MarkCompletedByShortName(MapName);
        i = start + end + 1;
    }
    Log("AP bridge: Updated completed maps from checked_locations");
}

static function SendBeat(Actor Owner, string MapName)
{
    local APTcpLinkConnector Bridge;
    Bridge = Launch(Owner);
    if (Bridge != None)
        Bridge.SendJSON("{\"action\": \"beat\", \"map\": \"" $ MapName $ "\"}");
}

defaultproperties
{
    BridgeHost="127.0.0.1"
    BridgePort=8787
    ConnectTimeout=5.0
    bAlwaysTick=True
}


