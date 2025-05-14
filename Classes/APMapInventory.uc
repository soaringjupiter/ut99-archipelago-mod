class APMapInventory extends Inventory config(APLadder);

// ---------------  RANDOM-MAP CAMPAIGN  ---------------
var travel int UnlockedMask[5]; // DM, DOM, CTF, AS, CHAL  (keep order!)
var travel int CompletedMask[5];
var config int SavedUnlocked[5];
var config int SavedCompleted[5];
var travel int LastLadder;
var travel int LastMap;

var const string DMNames[16] ; // Oblivion … Peak
var const string DOMNames[9] ; // Condemned … MetalDream
var const string CTFNames[11]; // Niven … Orbital
var const string ASNames[6]  ; // Frigate … Overlord
var const string ChalNames[4]  ; // Phobos … HyperBlast

var transient APHttpLinkConnector Bridge;
var const     int BridgePort; // keep in sync with Python

function string NameFor( int LadderIdx, int MapIdx )
{
    switch ( LadderIdx )
    {
        case 0: return "DM-"  $ DMNames [MapIdx];
        case 1: return "DOM-" $ DOMNames[MapIdx];
        case 2: return "CTF-" $ CTFNames[MapIdx];
        case 3: return "AS-"  $ ASNames [MapIdx];
        default: return "DM-" $ ChalNames[MapIdx];  // challenge uses DM prefix
    }
}

function UnlockByShortName( string Short )
{
    local int LadderIdx, MapIdx;

    Log( "UnlockByShortName: " $ Short );

    if ( ParseShortName( Short, LadderIdx, MapIdx ) )
    {
        Log( "UnlockByShortName: " $ LadderIdx $ " " $ MapIdx );
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
    class'APHttpLinkConnector'.static.SendBeat( Self, NameFor( GetLadderIndex(L), MapIdx )$" - Beaten" );
}

function bool ParseShortName( string Short, out int Ladder, out int Map )
{
    local int MapI;
    local int LadderI;

    for ( LadderI=0 ; LadderI<5 ; ++LadderI )
        switch ( LadderI )
        {
            case 0:
                for ( MapI=0 ; MapI<16 ; ++MapI )
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
                        Ladder = LadderI; Map = MapI + 1; return True;
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
	return 4; // Challenge
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

	 // create the long-poll connector once
    if ( Bridge == None )
        Bridge = class'APHttpLinkConnector'.static.Launch( Self );

	for (i = 0; i < 5; i++)
	{
		UnlockedMask[i] = SavedUnlocked[i];
		CompletedMask[i] = SavedCompleted[i];
	}
}
		
function Reset()
{
	for (LastLadder = 0 ; LastLadder < 5 ; ++LastLadder)
	{
		UnlockedMask[LastLadder] = 0;
		CompletedMask[LastLadder] = 0;
	}
	LastLadder = -1;
	LastMap = -1;
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

	DMNames(0)="Oblivion"
    DMNames(1)="Stalwart"
    DMNames(2)="Fractal"
    DMNames(3)="Turbine"
    DMNames(4)="Codex"
    DMNames(5)="Pressure"
    DMNames(6)="ArcaneTemple"
    DMNames(7)="Grinder"
    DMNames(8)="Malevolence"
    DMNames(9)="KGalleon"
    DMNames(10)="Tempest"
    DMNames(11)="Barricade"
    DMNames(12)="Shrapnel]["
    DMNames(13)="Liandri"
    DMNames(14)="Conveyor"
    DMNames(15)="Peak"

    DOMNames(0)="Condemned"
    DOMNames(1)="Ghardhen"
    DOMNames(2)="Cryptic"
    DOMNames(3)="Cinder"
    DOMNames(4)="Gearbolt"
    DOMNames(5)="Leadworks"
    DOMNames(6)="Olden"
    DOMNames(7)="Sesmar"
    DOMNames(8)="MetalDream"

    CTFNames(0)="Niven"
    CTFNames(1)="Facing Worlds"
    CTFNames(2)="EternalCave"
    CTFNames(3)="Coret"
    CTFNames(4)="Gauntlet"
    CTFNames(5)="Dreary"
    CTFNames(6)="Command"
    CTFNames(7)="LavaGiant"
    CTFNames(8)="November"
    CTFNames(9)="Hydro16"
    CTFNames(10)="Orbital"

    ASNames(0)="Frigate"
    ASNames(1)="HiSpeed"
    ASNames(2)="Rook"
    ASNames(3)="Mazon"
    ASNames(4)="OceanFloor"
    ASNames(5)="Overlord"

    ChalNames(0)="Phobos"
    ChalNames(1)="Morpheus"
    ChalNames(2)="Zeto"
    ChalNames(3)="HyperBlast"

	BridgePort=  8787
}