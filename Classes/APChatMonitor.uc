class APChatMonitor extends Actor;

var string LastMessages[64]; // Cache for last message per player
var int LastCount;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(0.2, true); // Check every 0.2 seconds
}

event Timer()
{
    local Pawn P;
    local Console C;
    local int idx;
    local string Msg;
    idx = 0;
    for (P = Level.PawnList; P != None; P = P.NextPawn)
    {
        if (P.IsA('PlayerPawn'))
        {
            C = PlayerPawn(P).Player.Console;
            if (C != None)
            {
                for (idx = 0; idx < 64; idx++)
                {
                    Msg = C.MsgText[idx];
                    if (Msg != "")
                    {
                        // only send to the connector if the message is not new
                        if (IsNewMessage(Msg) && (C.GetMsgPlayer(idx) == P.PlayerReplicationInfo) && (C.GetMsgType(idx) == 'Say' || C.GetMsgType(idx) == 'TeamSay'))
                        {
                            RelayChatToAP(Msg);
                            Log("APChatMonitor: Msg: " $ Msg);
                            LastMessages[idx] = Msg;
                            break;
                        }
                    }
                }
            }
        }
    }
}

function bool IsNewMessage(string Msg)
{
    local int idx;
    for (idx = 0; idx < 64; idx++)
    {
        if (LastMessages[idx] == Msg)
        {
            return false;
        }
    }
    return true;
}

function RelayChatToAP(string Msg)
{
    local APTcpLinkConnector Bridge;
    Bridge = None;
    foreach AllActors(class'APTcpLinkConnector', Bridge)
        break;
    if (Bridge != None)
        Bridge.SendJSON("{\"action\": \"chat\", \"msg\": \"" $ EscapeJSON(Msg) $ "\"}");
}

function string EscapeJSON(string S)
{
    // Escape quotes and backslashes for JSON
    local string Out;
    local int i, length;
    local string C;
    Out = "";
    length = Len(S);
    for (i = 0; i < length; ++i)
    {
        C = Mid(S, i, 1);
        if (C == "\"")
            Out = Out $ "\\\"";
        else if (C == "\\")
            Out = Out $ "\\\\";
        else
            Out = Out $ C;
    }
    return Out;
}

defaultproperties
{
    bHidden=True
    bAlwaysTick=True
} 