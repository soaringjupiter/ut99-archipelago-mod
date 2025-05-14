// ============================================================================
//  Archipelago – Unreal Tournament 99  ↔  Python bridge (localhost:8787)
//  Replacement for the earlier proof-of-concept HttpLinkConnector
//
//  • keeps a single long-poll open and re-opens it every few seconds
//  • parses the reply body into individual command lines
//  • understands   chat <text>      → prints to all players
//                  unlock <mapname> → broadcasts an event you can hook on
//  • provides a static helper  SendBeat( MapName )  that fires the
//    /beat?m=… request in its own transient connector.
//
//  Author: 2025-05-09
// ============================================================================
class APHttpLinkConnector extends IpDrv.TcpLink
    config(APLadder);

// ---------------------------------------------------------------------------
// configurable bits (may be adjusted in Archipelago.ini)
/** host of the local bridge – change only if you moved it */
var config string BridgeHost;
/** port of the local bridge */
var config int    BridgePort;
/** how long to wait (seconds) before re-opening /poll after it closed */
var config float  PollInterval;

/** how many seconds we allow a connection attempt to take */
var config float  ConnectTimeout;

// ---------------------------------------------------------------------------
// runtime helpers
var        string  CurrentPath;      // "/poll"  or "/beat?m=…"
var        bool    bReadingBody;     // true once we saw the blank header line
var        string  BodyLines;       // accumulates body lines of the reply
var        float   ConnectTimer;     // counts up while LinkState==Connecting

var APMapInventory CachedInv;   // we’ll resolve this once per session

// ===========================================================================
////////////////////////////  PUBLIC  INTERFACE  /////////////////////////////
// ===========================================================================

/** spawn one connector (in the Entry level!) and start polling immediately */
static function APHttpLinkConnector Launch( Actor Owner )
{
    local APHttpLinkConnector H;
    H = Owner.Spawn( class'APHttpLinkConnector' );
    if ( H != None )
        H.StartPoll();
    return H;
}

static function string URLEncode(string S)
{
    local int i, L;
    local string Out;
    local byte C;

    L = Len(S);
    for (i = 1; i <= L; i++)
    {
        C = Asc( Mid(S, i, 1) );
        if (C == 32)               // space
            Out = Out $ "%20";
        else
            Out = Out $ Chr(C);
    }
    return Out;
}

/** tell Archipelago we have beaten a map – uses a short-lived connector */
static function SendBeat( Actor Owner, string MapName )
{
    local APHttpLinkConnector B;
    local string Enc;

    //  very small “URL encode” – blanks to %20, the ladder script never emits
    //  other special chars anyway
    Enc = URLEncode( MapName );

    B = Owner.Spawn( class'APHttpLinkConnector' );
    if ( B != None )
        B.StartGet( default.BridgeHost, default.BridgePort,
                    "/beat?m="$ Enc );
}

// ---------------------------------------------------------------------------
// everything below is “private” glue
// ---------------------------------------------------------------------------

/** open a long-poll connection */
function StartPoll()
{
    Log( Name $ ": opening /poll to " $ BridgeHost $ ":" $ BridgePort );
    StartGet( BridgeHost, BridgePort, "/poll" );
}

/** fire an HTTP GET towards BridgeHost:BridgePort$Path */
function StartGet( string HostName, int PortNum, string Path )
{
    // reset state
    bReadingBody  = False;
    BodyLines     = "";
    CurrentPath   = Path;
    ConnectTimer  = 0.f;

    // DNS lookup -> Resolved() will continue
    Log( Name $ ": Resolve → " $ HostName $ CurrentPath );
    Resolve( HostName );
}

// called after DNS succeeded
event Resolved( IpAddr Ip )
{
    Log( Name $ ": Resolved ⇒ "$ Ip.Addr );
    if ( Ip.Addr == 0 )
    {
        Log( Name $ ": DNS failed for " $ BridgeHost, 'ScriptWarning' );
        RetryLater();
        return;
    }

    // open async connection
    if ( BindPort( 0, False ) != -1 )
    {
        Ip.Port = BridgePort;
        Open( Ip );
    }
    else
    {
        Log( Name $ ": BindPort() failed", 'ScriptWarning' );
        RetryLater();
    }
}

// track time-out while attempting to connect
event Tick( float Delta )
{
}

// socket connected – send the GET request
event Opened()
{
    local string Req;

    Req = "GET "    $ CurrentPath $ " HTTP/1.1" $ Chr(13)$Chr(10)
        $ "Host: "  $ BridgeHost   $ Chr(13)$Chr(10)
        $ "Connection: close"      $ Chr(13)$Chr(10)
        $ Chr(13)$Chr(10);

    Log( Name $ ": connected, sending GET " $ CurrentPath );

    SendText( Req );
}

// ---------------------------------------------------------------------------
// receive path

event ReceivedText(string Text)
{
    local int i;
    Log("HTTP(chunk)>> " $ Text);
    // set BodyLines to the part of Text that starts after the headers
    // (which are terminated by a blank line)
    i = InStr(Text, Chr(13)$Chr(10) $ Chr(13)$Chr(10));
    if ( i > 0 )
    {
        BodyLines = Mid( Text, i + 4 );
        bReadingBody = True;
    }
}

event Closed()
{
    Log( Name $ ": closed (" $ CurrentPath $ ")" );

    if ( bReadingBody && BodyLines != "" ) {
        Log( Name $ ": body: " $ BodyLines );
        ProcessBody();
    }

    // if we just finished /poll → schedule next poll
    if ( CurrentPath == "/poll" )
        SetTimer( PollInterval, False );
    else
        Destroy();  // short-lived /beat connector
}

event Timer()
{
    StartPoll();
}

// ---------------------------------------------------------------------------
// parse each command line coming from the bridge
function ProcessBody()
{
    local int i;
    local string L;

    // old implementation when BodyLines was a string array
    // for ( i = 0 ; i < BodyLines.Length ; ++i )
    // {
    //     L = BodyLines[i];
    //     Log( Name $ ": body line " $ i $ ": " $ L );
    //     if ( Left( L, 5 ) ~= "chat " )
    //         BroadcastChat( Mid( L, 5 ) );
    //     else if ( Left( L, 7 ) ~= "unlock " )
    //         HandleUnlock( Mid( L, 7 ) );
    //     else
    //         Log( Name $ ": unknown bridge command: "$ L );
    // }
    // BodyLines.Length = 0;

    // new implementation with a single string. each line that starts with unlock needs to be handled as above
    // and the rest is just logged
    i = InStr( BodyLines, Chr(10) );
    while ( i > 0 )
    {
        Log( Name $ ": i: " $ i );
        L = Left( BodyLines, i);
        BodyLines = Mid( BodyLines, i + 1 );
        Log( Name $ ": body line: " $ L );
        if ( Left( L, 5 ) ~= "chat " )
            BroadcastChat( Mid( L, 5 ) );
        else if ( Left( L, 7 ) ~= "unlock " )
            HandleUnlock( Mid( L, 7 ) );
        else
            Log( Name $ ": unknown bridge command: "$ L );
        i = InStr( BodyLines, Chr(10) );
        if ( i == -1 ) {
            // handle the last line
            if ( BodyLines != "" )
            {
                Log( Name $ ": body line: " $ BodyLines );
                if ( Left( BodyLines, 5 ) ~= "chat " )
                    BroadcastChat( Mid( BodyLines, 5 ) );
                else if ( Left( BodyLines, 7 ) ~= "unlock " )
                    HandleUnlock( Mid( BodyLines, 7 ) );
                else
                    Log( Name $ ": unknown bridge command: "$ BodyLines );
            }
        }
    }
}

// ---------------------------------------------------------------------------
// helpers for concrete game integration  – adapt as you like
function BroadcastChat( string Msg )
{
    local Pawn P;
    for ( P=Level.PawnList ; P!=None ; P=P.NextPawn )
        if ( P.IsA('PlayerPawn') )
            PlayerPawn(P).ClientMessage( Msg, 'Say', True );
}

/** called when the bridge asks us to unlock a map.
 *  Override in a subclass or register dynamically (e.g. delegate) to
 *  forward into your MapInventory logic.                                                  */
function HandleUnlock( string MapShortName )
{
    local Pawn P;
    Log( Name $ ": unlock -> " $ MapShortName );
    for ( P=Level.PawnList ; P!=None ; P=P.NextPawn )
        if ( P.IsA('PlayerPawn') )
        {
            Log( Name $ ": unlock for " $ PlayerPawn(P).PlayerReplicationInfo.PlayerName );
            APMapInventory(PlayerPawn(P).FindInventoryType( class'APMapInventory' ))
                .UnlockByShortName( MapShortName );
        }
}

// ---------------------------------------------------------------------------
// utility
function RetryLater()
{
    Log( Name $ ": retrying in " $ PollInterval $ " seconds" );
    // wait a few seconds, then try to re-establish /poll
    if ( CurrentPath == "/poll" )
        SetTimer( PollInterval, False );
    else
        Destroy();
}

defaultproperties
{
    BridgeHost   = "127.0.0.1"
    BridgePort   = 8787
    PollInterval = 3.0
    ConnectTimeout = 5.0

    bAlwaysTick  = True
}
