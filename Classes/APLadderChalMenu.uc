class APLadderChalMenu extends APLadder;

var int LastMatch;

function Created() {
	Super.Created();

	SelectedMatch = GetDefaultSelection();
	SetupLadder(SelectedMatch, LadderObj.ChalRank);
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

	Super.UpdateLastMatch(SelectedMatch);

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
	Super.EvaluateMatch();
}

defaultproperties {
	GameType="Botpack.ChallengeDMP"
	TrophyMap="EOL_Challenge.unr"
	LadderName="Final Challenge"
	Ladder=Class'APLadderChal'
	LadderTrophy=Texture'UTMenu.Skins.TrophyChal'
}