class APLadderInventory extends Inventory;

// Game
var travel int			Slot;					// Savegame slot.

// Ladder
var travel int			TournamentDifficulty;
var travel int			PendingChange;			// Pending Change 
												// 0 = None  1 = DM
												// 2 = CTF   3 = DOM
												// 4 = AS
var travel int			PendingRank;
var travel int			PendingPosition;
var travel int			LastMatchType;
var travel Class<APLadderLadder> CurrentLadder;

// Deathmatch
var travel int			DMRank;						// Rank in the ladder.
var travel int			DMPosition;					// Position in the ladder.

// Capture the Flag
var travel int			CTFRank;
var travel int			CTFPosition;

// Domination
var travel int			DOMRank;
var travel int			DOMPosition;

// Assault
var travel int			ASRank;
var travel int			ASPosition;

// Challenge
var travel int			ChalRank;
var travel int			ChalPosition;

// TeamInfo
var travel class<APRatedTeamInfo> Team;

var travel int			Face;
var travel string		Sex;

var travel string		SkillText;

var travel int          UnlockedMask[5]; // DM, DOM, CTF, AS, CHAL
var travel int          CompletedMask[5];
var travel int          LastLadder;
var travel int          LastMap;


function int GetLadderIndex( class<APLadderLadder> L )
{
	if (L == class'APLadderDM')       return 0;
	if (L == class'APLadderDOM')      return 1;
	if (L == class'APLadderCTF')      return 2;
	if (L == class'APLadderAS')       return 3;
	return 4; // Challenge
}

function bool IsUnlocked( class<APLadderLadder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    return (UnlockedMask[idx] & (1 << Map)) != 0;
}

function bool IsCompleted( class<APLadderLadder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    return (CompletedMask[idx] & (1 << Map)) != 0;
}

function UnlockMap( class<APLadderLadder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    UnlockedMask[idx] = UnlockedMask[idx] | (1 << Map);
}

function MarkCompleted( class<APLadderLadder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    CompletedMask[idx] = CompletedMask[idx] | (1 << Map);
}

function UnlockRandomMap()
{
	local int   LadderN, MapN, i, Loops;
	local class<APLadderLadder> L;
	local int Matches[5];

	Matches[0] = class'APLadderDM'   .Default.Matches;
	Matches[1] = class'APLadderDOM'  .Default.Matches;
	Matches[2] = class'APLadderCTF'  .Default.Matches;
	Matches[3] = class'APLadderAS'   .Default.Matches;
	Matches[4] = class'APLadderChal' .Default.Matches;

	for (Loops = 0 ; Loops < 1024 ; ++Loops)  // failsafe
	{
		LadderN = Rand(5);
		MapN    = Rand(Matches[LadderN]);
		switch (LadderN)
		{
			case 0 : L = class'APLadderDM'   ; break;
			case 1 : L = class'APLadderDOM'  ; break;
			case 2 : L = class'APLadderCTF'  ; break;
			case 3 : L = class'APLadderAS'   ; break;
			default: L = class'APLadderChal' ; break;
		}
		if ( !IsUnlocked(L, MapN) && (MapN != 0) )
		{
            Log("Unlocking map "$L$" "$MapN);
			UnlockMap(L, MapN);
			return;
		}
	}
}
		
function Reset()
{
	TournamentDifficulty = 0;
	PendingChange = 0;
	PendingRank = 0;
	PendingPosition = 0;
	LastMatchType = 0;
	CurrentLadder = None;
	DMRank = 0;
	DMPosition = 0;
	CTFRank = 0;
	CTFPosition = 0;
	DOMRank = 0;
	DOMPosition = 0;
	ASRank = 0;
	ASPosition = 0;
	ChalRank = 0;
	ChalPosition = 0;
	Face = 0;
	Sex = "";

    for (LastLadder = 0 ; LastLadder < 5 ; ++LastLadder)
	{
		UnlockedMask [LastLadder] = 0;
		CompletedMask[LastLadder] = 0;
	}
	LastLadder = -1;
    LastMap = -1;

	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
	UnlockRandomMap();
}

function TravelPostAccept()
{
	if (APDeathMatchPlus(Level.Game) != None)
	{
		Log("APLadderInventory: Calling InitRatedGame");
		APDeathMatchPlus(Level.Game).InitRatedGame(Self, PlayerPawn(Owner));
	}
}

function GiveTo( Pawn Other )
{
	Log(Self$" giveto "$Other);
	Super.GiveTo( Other );
}

function Destroyed()
{
	Log("Something destroyed a APLadderInventory!");
	Super.Destroyed();
}

function bool HasAnyUnlocked( int LadderIndex )
{
    return UnlockedMask[LadderIndex] != 0;
}

defaultproperties
{
     TournamentDifficulty=1
     bHidden=True
}
