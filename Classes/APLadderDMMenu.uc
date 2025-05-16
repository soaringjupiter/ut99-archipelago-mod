class APLadderDMMenu extends APLadder;

function Created() {
	Super.Created();

	if (LadderObj.DMPosition == -1) {
		LadderObj.DMPosition = 1;
		SelectedMatch = 0;
	} else {
		SelectedMatch = LadderObj.DMPosition;
	}

	SetupLadder(LadderObj.DMPosition, LadderObj.DMRank);
}

function FillInfoArea(int i) {
	MapInfoArea.Clear();
	MapInfoArea.AddText(MapText$" "$LadderObj.CurrentLadder.Static.GetMapTitle(i));
	MapInfoArea.AddText(FragText$" "$LadderObj.CurrentLadder.Static.GetFragLimit(i));
	MapInfoArea.AddText(LadderObj.CurrentLadder.Static.GetDesc(i));
}

function NextPressed() {
	local APEnemyBrowser EB;
	local string MapName;

	if (PendingPos > ArrowPos) {
		return;
	}

	Super.UpdateLastMatch(SelectedMatch);

	if (SelectedMatch == 0) {
		MapName = LadderObj.CurrentLadder.Default.MapPrefix$Ladder.Static.GetMap(0);
		CloseUp();
		StartMap(MapName, 0, "Botpack.TrainingDM");
	} else {
		HideWindow();
		EB = APEnemyBrowser(Root.CreateWindow(class'APEnemyBrowser', 100, 100, 200, 200, Root, True));
		EB.LadderWindow = Self;
		EB.Ladder = LadderObj.CurrentLadder;
		EB.Match = SelectedMatch;
		EB.GameType = GameType;
		EB.Initialize();
	}
}

function StartMap(string StartMap, int Rung, string GameType) {
	local Class<GameInfo> GameClass;

	GameClass = Class<GameInfo>(DynamicLoadObject(GameType, Class'Class'));
	GameClass.Static.ResetGame();

	StartMap = StartMap$"?Game="$GameType$"?Mutator="$"?Tournament="$Rung$"?Name="
		$GetPlayerOwner().PlayerReplicationInfo.PlayerName$"?Team=255";

	Root.Console.CloseUWindow();
	GetPlayerOwner().ClientTravel(StartMap, TRAVEL_Absolute, True);
}

function EvaluateMatch(optional bool bTrophyVictory)
{
	Super.EvaluateMatch();
}

function CheckOpenCondition() {
	Super.CheckOpenCondition();
}

defaultproperties {
    GameType="Botpack.DeathMatchPlus"
    TrophyMap="EOL_DeathMatch.unr"
    LadderName="Deathmatch"
	Ladder=Class'APLadderDM'
    // GOTYLadder=Class'APLadderDMGOTY'
	LadderTrophy=Texture'UTMenu.Skins.TrophyDM'
}