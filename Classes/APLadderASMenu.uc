class APLadderASMenu extends APLadder;

var int LastMatch;

function Created()
{
	Super.Created();
	SelectedMatch = GetDefaultSelection();
	SetupLadder(SelectedMatch, LadderObj.ASRank);
}

function FillInfoArea(int i)
{
	MapInfoArea.Clear();
	MapInfoArea.AddText(MapText$" "$Ladder.Static.GetMapTitle(i));
	MapInfoArea.AddText(Ladder.Static.GetDesc(i));
}

function NextPressed()
{
	local ObjectiveBrowser OB;

	if (PendingPos > ArrowPos) {
		return;
	}

	Super.UpdateLastMatch(SelectedMatch);

	HideWindow();
	OB = ObjectiveBrowser(Root.CreateWindow(class'APObjectiveBrowser', 100, 100, 200, 200, Root, True));
	OB.LadderWindow = Self;
	OB.Ladder = Ladder;
	OB.Match = SelectedMatch;
	OB.GameType = GameType;
	OB.Initialize();
}

function EvaluateMatch(optional bool bTrophyVictory)
{
	Super.EvaluateMatch();
}

defaultproperties {
	GameType="Botpack.Assault"
	TrophyMap="EOL_Assault.unr"
	LadderName="Assault"
	Ladder=Class'APLadderAS'
	LadderTrophy=Texture'UTMenu.Skins.TrophyAS'
}