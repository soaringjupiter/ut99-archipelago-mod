class APHttpLinkConnector extends IpDrv.TcpLink
    config(APLadder);

var config string BridgeHost;
var config int    BridgePort;

var config float  ConnectTimeout;

var        string  CurrentPath;      // "/poll"  or "/beat?m=…"
var        bool    bReadingBody;
var        string  BodyLines;
var        float   ConnectTimer;

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
    for (i = 0; i <= L; i++)
    {
        C = Asc( Mid(S, i, 1) );
        if (C == 32)               // space
            Out = Out $ "%20";
        else
            Out = Out $ Chr(C);
    }
    return Out;
}

static function SendBeat( Actor Owner, string MapName )
{
    local APHttpLinkConnector B;
    local string Enc;

    Enc = URLEncode( MapName );

    B = Owner.Spawn( class'APHttpLinkConnector' );
    if ( B != None )
        B.StartGet( default.BridgeHost, default.BridgePort,
                    "/beat?m="$ Enc );
}

function StartPoll()
{
    Log( Name $ ": opening /poll to " $ BridgeHost $ ":" $ BridgePort );
    StartGet( BridgeHost, BridgePort, "/poll" );
}

function StartGet( string HostName, int PortNum, string Path )
{
    bReadingBody  = False;
    BodyLines     = "";
    CurrentPath   = Path;
    ConnectTimer  = 0.f;

    Log( Name $ ": Resolve → " $ HostName $ CurrentPath );
    Resolve( HostName );
}

event Resolved( IpAddr Ip )
{
    Log( Name $ ": Resolved ⇒ "$ Ip.Addr );
    if ( Ip.Addr == 0 )
    {
        Log( Name $ ": DNS failed for " $ BridgeHost, 'ScriptWarning' );
        RetryLater();
        return;
    }

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

event Tick( float Delta )
{
}

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

event ReceivedText(string Text)
{
    local int i;
    Log("HTTP(chunk)>> " $ Text);
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

    if ( CurrentPath == "/poll" ) {
        SetTimer( 2, False );
    }
    else
        Destroy();
}
function ProcessBody()
{
    local int i;
    local string L;
    i = InStr( BodyLines, Chr(10) );
    if ( i == -1 )
    {
        // handle only one map unlock
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
    else
    {
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
    
}

function BroadcastChat( string Msg )
{
    local Pawn P;
    for ( P=Level.PawnList ; P!=None ; P=P.NextPawn )
        if ( P.IsA('PlayerPawn') )
            PlayerPawn(P).ClientMessage( Msg, 'Say', True );
}
                                          */
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

function RetryLater()
{
    Log( Name $ ": retrying in " $ 2 $ " seconds" );
    // wait a few seconds, then try to re-establish /poll
    if ( CurrentPath == "/poll" ) {
        SetTimer( 2, False );
    }
    else
        Destroy();
}

function Timer()
{
    StartPoll();
}

defaultproperties
{
    BridgeHost   = "127.0.0.1"
    BridgePort   = 8787
    ConnectTimeout = 5.0

    bAlwaysTick  = True
}
