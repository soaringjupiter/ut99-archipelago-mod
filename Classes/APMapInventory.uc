class APMapInventory extends Inventory;

// ---------------  RANDOM-MAP CAMPAIGN  ---------------
var travel int   UnlockedMask[5]; // DM, DOM, CTF, AS, CHAL  (keep order!)
var travel int   CompletedMask[5];
var travel int           LastLadder;
var travel int           LastMap;

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
    idx = GetLadderIndex(L);
    UnlockedMask[idx] = UnlockedMask[idx] | (1 << Map);
}

function MarkCompleted( class<Ladder> L, int Map )
{
    local int idx;
    idx = GetLadderIndex(L);
    CompletedMask[idx] = CompletedMask[idx] | (1 << Map);
}

function bool HasAnyUnlocked( int LadderIndex )
{
    return UnlockedMask[LadderIndex] != 0;
}

function UnlockRandomMap()
{
	local int   LadderN, MapN, i, Loops;
	local class<Ladder> L;
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
			default: L = class'APLadderChal'; break;
		}
		if ( !IsUnlocked(L, MapN) )
		{
			Log("APMapInventory: Unlocking "$L$" map "$MapN);
			UnlockMap(L, MapN);
			return;
		}
	}
}

// Remember the map we just sent the player to.
// Filled in APLadder.StartMap(), read back in APLadder.EvaluateMatch().
		
function Reset()
{
	for (LastLadder = 0 ; LastLadder < 5 ; ++LastLadder)
	{
		UnlockedMask [LastLadder] = 0;
		CompletedMask[LastLadder] = 0;
	}
	LastLadder = -1;
	LastMap = -1;
	UnlockRandomMap();
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
