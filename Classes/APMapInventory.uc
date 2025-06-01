class APMapInventory extends Inventory config(APLadder);

var travel int UnlockedMask[5];
var travel int CompletedMask[5];
var config int SavedUnlocked[5];
var config int SavedCompleted[5];

var const string DMNames[15];
var const string DOMNames[9];
var const string CTFNames[11];
var const string ASNames[6];
var const string ChalNames[4];

var transient APTcpLinkConnector Bridge;
var const     int BridgePort;

var config int LastMatch;

function string NameFor( int LadderIdx, int MapIdx )
{
    switch ( LadderIdx )
    {
        case 0: return "DM-"  $ DMNames [MapIdx - 1];
        case 1: return "DOM-" $ DOMNames[MapIdx - 1];
        case 2: return "CTF-" $ CTFNames[MapIdx - 1];
        case 3: return "AS-"  $ ASNames [MapIdx - 1];
        default: return "DM-" $ ChalNames[MapIdx];
    }
}

function UpdateLastMatch( int SelectedMatch )
{
    Log("UpdateLastMatch: " $ SelectedMatch);
    LastMatch = SelectedMatch;
    Log("MapInventoryObj.LastMatch: " $ LastMatch);
    SaveConfig();

}

function UnlockByShortName( string Short )
{
    local int LadderIdx, MapIdx;

    // Log( "UnlockByShortName: " $ Short );

    if ( ParseShortName( Short, LadderIdx, MapIdx ) )
    {
        // Log( "UnlockByShortName: " $ LadderIdx $ " " $ MapIdx );
        switch ( LadderIdx )
        {
            case 0: UnlockMap( class'APLadderDM',  MapIdx ); break;
            case 1: UnlockMap( class'APLadderDOM', MapIdx ); break;
            case 2: UnlockMap( class'APLadderCTF', MapIdx ); break;
            case 3: UnlockMap( class'APLadderAS',  MapIdx ); break;
            case 4: UnlockMap( class'APLadderChal',MapIdx ); break;
        }
    }
}

function NotifyBeat( class<Ladder> L, int MapIdx )
{
    switch ( GetLadderIndex(L) )
    {
        case 0: class'APTcpLinkConnector'.static.SendBeat( Self, DMNames [MapIdx - 1] ); Log("Beat DM " $ DMNames [MapIdx - 1]); break;
        case 1: class'APTcpLinkConnector'.static.SendBeat( Self, DOMNames[MapIdx - 1] ); Log("Beat DOM " $ DOMNames[MapIdx - 1]); break;
        case 2: class'APTcpLinkConnector'.static.SendBeat( Self, CTFNames[MapIdx - 1] ); Log("Beat CTF " $ CTFNames[MapIdx - 1]); break;
        case 3: class'APTcpLinkConnector'.static.SendBeat( Self, ASNames [MapIdx - 1] ); Log("Beat AS " $ ASNames [MapIdx - 1]); break;
        default: class'APTcpLinkConnector'.static.SendBeat( Self, ChalNames[MapIdx] ); Log("Beat Chal " $ ChalNames[MapIdx]); break;
    }
    
}

function bool ParseShortName( string Short, out int Ladder, out int Map )
{
    local int MapI;
    local int LadderI;

    for ( LadderI=0 ; LadderI<5 ; ++LadderI )
        switch ( LadderI )
        {
            case 0:
                for ( MapI=0 ; MapI<15 ; ++MapI )
                    if ( DMNames[MapI] == Short )
                    {
                        Ladder = LadderI; Map = MapI + 1; return True;
                    }
                break;
            case 1:
                for ( MapI=0 ; MapI<9 ; ++MapI )
                    if ( DOMNames[MapI] == Short )
                    {
                        Ladder = LadderI; Map = MapI + 1; return True;
                    }
                break;
            case 2:
                for ( MapI=0 ; MapI<11 ; ++MapI )
                    if ( CTFNames[MapI] == Short )
                    {
                        Ladder = LadderI; Map = MapI + 1; return True;
                    }
                break;
            case 3:
                for ( MapI=0 ; MapI<6 ; ++MapI )
                    if ( ASNames[MapI] == Short )
                    {
                        Ladder = LadderI; Map = MapI + 1; return True;
                    }
                break;
            case 4:
                for ( MapI=0 ; MapI<4 ; ++MapI )
                    if ( ChalNames[MapI] == Short )
                    {
                        Ladder = LadderI; Map = MapI; return True;
                    }
                break;
        }
    return False;
    
}

static function int GetLadderIndex( class<Ladder> L )
{
	if (L == class'APLadderDM')       return 0;
	if (L == class'APLadderDOM')      return 1;
	if (L == class'APLadderCTF')      return 2;
	if (L == class'APLadderAS')       return 3;
	return 4;
}

function bool IsUnlocked( class<Ladder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    return (UnlockedMask[idx] & (1 << Map)) != 0;
}

function bool IsCompleted( class<Ladder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    return (CompletedMask[idx] & (1 << Map)) != 0;
}

function UnlockMap( class<Ladder> L, int Map )
{
    local int idx;
	local int loop;
    idx = GetLadderIndex(L);
    UnlockedMask[idx] = UnlockedMask[idx] | (1 << Map);
	for (loop = 0; loop < 5; loop++)
	{
		SavedUnlocked[loop] = UnlockedMask[loop];
	}
    BroadcastMessage( "Received unlock for " $ L$" "$Map );
    SaveConfig();
}

function MarkCompleted( class<Ladder> L, int Map )
{
    local int idx;
	local int loop;
    idx = GetLadderIndex(L);
    CompletedMask[idx] = CompletedMask[idx] | (1 << Map);
	for (loop = 0; loop < 5; loop++)
	{
		SavedCompleted[loop] = CompletedMask[loop];
	}
    SaveConfig();
}

function bool HasAnyUnlocked( int LadderIndex )
{
    return UnlockedMask[LadderIndex] != 0;
}

function PostBeginPlay()
{
	local int i;

    Super.PostBeginPlay();

    if ( Bridge == None )
        Bridge = class'APTcpLinkConnector'.static.Launch( Self );

	for (i = 0; i < 5; i++)
	{
		UnlockedMask[i] = SavedUnlocked[i];
		CompletedMask[i] = SavedCompleted[i];
	}
}
		
function Reset()
{
    local int Ladder;
	for (Ladder = 0 ; Ladder < 5 ; ++Ladder)
	{
		UnlockedMask[Ladder] = 0;
		CompletedMask[Ladder] = 0;
        SavedUnlocked[Ladder] = 0;
        SavedCompleted[Ladder] = 0;
	}
    SaveConfig();
    Log("Resetting APMapInventory");
}

function GiveTo( Pawn Other )
{
	Log(Self$" giveto "$Other);
	Super.GiveTo( Other );
}

function Destroyed()
{
	Log("Something destroyed an APMapInventory!!");
	Super.Destroyed();
}

defaultproperties
{
    bHidden=True
    bTravel=True

	DMNames(0)="DM-Oblivion"
    DMNames(1)="DM-Stalwart"
    DMNames(2)="DM-Fractal"
    DMNames(3)="DM-Turbine"
    DMNames(4)="DM-Codex"
    DMNames(5)="DM-Pressure"
    DMNames(6)="DM-ArcaneTemple"
    DMNames(7)="DM-Grinder"
    DMNames(8)="DM-Malevolence"
    DMNames(9)="DM-KGalleon"
    DMNames(10)="DM-Tempest"
    DMNames(11)="DM-Shrapnel]["
    DMNames(12)="DM-Liandri"
    DMNames(13)="DM-Conveyor"
    DMNames(14)="DM-Peak"

    DOMNames(0)="DOM-Condemned"
    DOMNames(1)="DOM-Ghardhen"
    DOMNames(2)="DOM-Cryptic"
    DOMNames(3)="DOM-Cinder"
    DOMNames(4)="DOM-Gearbolt"
    DOMNames(5)="DOM-Leadworks"
    DOMNames(6)="DOM-Olden"
    DOMNames(7)="DOM-Sesmar"
    DOMNames(8)="DOM-MetalDream"

    CTFNames(0)="CTF-Niven"
    CTFNames(1)="CTF-Face"
    CTFNames(2)="CTF-EternalCave"
    CTFNames(3)="CTF-Coret"
    CTFNames(4)="CTF-Gauntlet"
    CTFNames(5)="CTF-Dreary"
    CTFNames(6)="CTF-Command"
    CTFNames(7)="CTF-LavaGiant"
    CTFNames(8)="CTF-November"
    CTFNames(9)="CTF-Hydro16"
    CTFNames(10)="CTF-Orbital"

    ASNames(0)="AS-Frigate"
    ASNames(1)="AS-HiSpeed"
    ASNames(2)="AS-Rook"
    ASNames(3)="AS-Mazon"
    ASNames(4)="AS-OceanFloor"
    ASNames(5)="AS-Overlord"

    ChalNames(0)="DM-Phobos"
    ChalNames(1)="DM-Morpheus"
    ChalNames(2)="DM-Zeto"
    ChalNames(3)="DM-HyperBlast"

	BridgePort=  8787
}