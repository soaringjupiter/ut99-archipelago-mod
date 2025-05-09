//=============================================================================
// Ladder
// A ladder game ladder.
//=============================================================================
class APLadderLadder extends Ladder
	abstract
	config(APLadder);

defaultproperties
{
     Titles(0)="Untrained"
     Titles(1)="Contender"
     Titles(2)="Light Weight"
     Titles(3)="Heavy Weight"
     Titles(4)="Warlord"
     Titles(5)="Battle Master"
     Titles(6)="Champion"
     LadderTeams(0)=Class'APRatedTeamInfo1'
     LadderTeams(1)=Class'APRatedTeamInfo2'
     LadderTeams(2)=Class'APRatedTeamInfo3'
     LadderTeams(3)=Class'APRatedTeamInfo4'
     LadderTeams(4)=Class'APRatedTeamInfo5'
     LadderTeams(5)=Class'APRatedTeamInfo6'
     LadderTeams(6)=Class'APRatedTeamInfoS'
     LadderTeams(7)=Class'APRatedTeamInfoDemo1'
     LadderTeams(8)=Class'APRatedTeamInfoDemo2'
     NumTeams=7
}
