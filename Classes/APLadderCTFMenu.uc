class APLadderCTFMenu extends APLadder;

var int LastMatch;

function Created() {
	Super.Created();
	SelectedMatch = GetDefaultSelection();
	SetupLadder(SelectedMatch, LadderObj.CTFRank);
}

function FillInfoArea(int i) {
	MapInfoArea.Clear();
	MapInfoArea.AddText(MapText$" "$LadderObj.CurrentLadder.Static.GetMapTitle(i));
	MapInfoArea.AddText(TeamScoreText$" "$LadderObj.CurrentLadder.Static.GetGoalTeamScore(i));
	MapInfoArea.AddText(LadderObj.CurrentLadder.Static.GetDesc(i));
}

function NextPressed() {
	local APTeamBrowser TB;
	local string MapName;

	if (PendingPos > ArrowPos) {
		return;
	}

	Super.UpdateLastMatch(SelectedMatch);

	if (SelectedMatch == 0) {
		MapName = LadderObj.CurrentLadder.Default.MapPrefix$Ladder.Static.GetMap(0);
		CloseUp();
		StartMap(MapName, 0, "Botpack.TrainingCTF");
	} else {
		if (LadderObj.CurrentLadder.Default.DemoDisplay[SelectedMatch] == 1) {
			return;
		}

		HideWindow();
		TB = APTeamBrowser(Root.CreateWindow(class'APTeamBrowser', 100, 100, 200, 200, Root, True));
		TB.LadderWindow = Self;
		TB.Ladder = LadderObj.CurrentLadder;
		TB.Match = SelectedMatch;
		TB.GameType = GameType;
		TB.Initialize();
	}
}

function EvaluateMatch(optional bool bTrophyVictory) {
	Super.EvaluateMatch();
}

function CheckOpenCondition() {
	Super.CheckOpenCondition();
}

defaultproperties {
	GameType="Botpack.CTFGame"
	TrophyMap="EOL_CTF.unr"
	LadderName="Capture The Flag"
	Ladder=Class'APLadderCTF'
	LadderTrophy=Texture'UTMenu.Skins.TrophyCTF'
}