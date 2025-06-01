//=============================================================================
// LadderAS
//=============================================================================
class APLadderAS extends LadderAS;

// Objective Shots
static function int GetObjectiveCount(int Index, AssaultInfo AI)
{
	AI = AssaultInfo(DynamicLoadObject(Default.MapPrefix$Default.Maps[Index]$".AssaultInfo0", class'AssaultInfo'));
	return AI.NumObjShots;
}

static function texture GetObjectiveShot(int Index, int ShotNum, AssaultInfo AI)
{
	AI = AssaultInfo(DynamicLoadObject(Default.MapPrefix$Default.Maps[Index]$".AssaultInfo0", class'AssaultInfo'));
	return AI.ObjShots[ShotNum];
}

static function string GetObjectiveString(int Index, int StringNum, AssaultInfo AI)
{
	AI = AssaultInfo(DynamicLoadObject(Default.MapPrefix$Default.Maps[Index]$".AssaultInfo0", class'AssaultInfo'));
	return AI.ObjDesc[StringNum];
}

defaultproperties
{
     Matches=6
     bTeamGame=True
     MapPrefix="AS-"
     Maps(0)="Frigate.unr"
     Maps(1)="HiSpeed.unr"
     Maps(2)="Rook.unr"
     Maps(3)="Mazon.unr"
     Maps(4)="OceanFloor.unr"
     Maps(5)="Overlord.unr"
     MapAuthors(0)="Shane Caudle"
     MapAuthors(1)="Juan Pancho Eekels"
     MapAuthors(2)="Alan Willard 'Talisman'"
     MapAuthors(3)="Shane Caudle"
     MapAuthors(4)="Juan Pancho Eekels"
     MapAuthors(5)="Dave Ewing"
     MapTitle(0)="Frigate"
     MapTitle(1)="High Speed"
     MapTitle(2)="Rook"
     MapTitle(3)="Mazon"
     MapTitle(4)="Ocean Floor"
     MapTitle(5)="Overlord"
     MapDescription(0)="A somewhat antiquated Earth warship, the restored SS Victory is still seaworthy. A dual security system prevents intruders from activating the guns by only allowing crew members to open the control room portal. However, should the aft boiler be damaged beyond repair the door will auto-release, allowing access to anyone."
     MapDescription(1)="Always looking to entertain the public, LC refitted this 200 mph high speed train for Tournament purposes. This time the combatants will have the added danger of being able to fall off a train. Get your popcorn out people and enjoy the show!"
     MapDescription(2)="This ancient castle, nestled in the highlands of Romania, was purchased by Xan Kriegor as a personal training ground for his opponents, hoping to cull the best of the best to challenge him. The attacking team must open the main gates and escape the castle by breaking free the main winch in the library and throwing the gatehouse lever, while the defending team must prevent their escape."
     MapDescription(3)="Nestled deep within the foothills of the jungle planet Zeus 6 lies Mazon Fortress, a seemingly impregnable stronghold. Deep within the bowels of the base resides an enormous shard of the rare and volatile element Tarydium. The shard is levitating between two enormous electron rods above a pool of superconductive swamp water."
     MapDescription(4)="Oceanfloor Station5, built by universities around the globe for deep sea research, almost ran out of money when LC came to the rescue. Jerl Liandri President LC: 'If we can't ensure education for our children, what will come of this world?'"
     MapDescription(5)="The tournament organizers at Liandri have decided that the recreation of arguably the Earth's most violent war would create the perfect arena of combat. Storming the beaches of Normandy in WWII was chosen in particular because of the overwhelming odds facing each member of the attacking force. Defending this beach, however, will prove to be no less of a daunting task."
     RankedGame(0)=1
     RankedGame(1)=2
     RankedGame(2)=3
     RankedGame(3)=4
     RankedGame(4)=5
     RankedGame(5)=6
     MatchInfo(0)="Archipelago.APRatedMatchAS1"
     MatchInfo(1)="Archipelago.APRatedMatchAS2"
     MatchInfo(2)="Archipelago.APRatedMatchAS3"
     MatchInfo(3)="Archipelago.APRatedMatchAS4"
     MatchInfo(4)="Archipelago.APRatedMatchAS5"
     MatchInfo(5)="Archipelago.APRatedMatchAS6"
}
