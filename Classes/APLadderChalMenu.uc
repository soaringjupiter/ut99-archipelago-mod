class APLadderChalMenu extends APLadder;

function Created() {
	Super.Created();

	SelectedMatch = LadderObj.ChalPosition;
	SetupLadder(LadderObj.ChalPosition, LadderObj.ChalRank);
}

function FillInfoArea(int i) {
	MapInfoArea.Clear();
	MapInfoArea.AddText(MapText$" "$Ladder.Static.GetMapTitle(i));
	MapInfoArea.AddText(FragText$" "$Ladder.Static.GetFragLimit(i));
	MapInfoArea.AddText(Ladder.Static.GetDesc(i));
}

function NextPressed() {
	local APEnemyBrowser EB;

	if (PendingPos > ArrowPos) {
		return;
	}

	HideWindow();
	EB = APEnemyBrowser(Root.CreateWindow(class'APEnemyBrowser', 100, 100, 200, 200, Root, True));
	EB.LadderWindow = Self;
	EB.Ladder = Ladder;
	EB.Match = SelectedMatch;

	if (SelectedMatch == 3) {
		EB.GameType = "Botpack.ChallengeDMP";
	} else {
		EB.GameType = GameType;
	}

	EB.Initialize();
}

function EvaluateMatch(optional bool bTrophyVictory) {
	if (LadderObj.PendingPosition > LadderObj.ChalPosition) {
		PendingPos = LadderObj.PendingPosition;
		LadderObj.ChalPosition = LadderObj.PendingPosition;
	}

	if (LadderObj.PendingRank > LadderObj.ChalRank) {
		LadderObj.ChalRank = LadderObj.PendingRank;
		LadderObj.PendingRank = 0;
	}

	LadderPos = LadderObj.ChalPosition;
	LadderRank = LadderObj.ChalRank;

	class'APManagerWindow'.static.ReportMatchResult( Ladder, SelectedMatch );

	if (LadderObj.ChalRank == 6) {
		Super.EvaluateMatch(True);
	} else {
		Super.EvaluateMatch();
	}

	Super.EvaluateMatch();
}

defaultproperties {
	GameType="Botpack.ChallengeDMP"
	TrophyMap="EOL_Challenge.unr"
	LadderName="Final Challenge"
	Ladder=Class'APLadderChal'
	LadderTrophy=Texture'UTMenu.Skins.TrophyChal'
}