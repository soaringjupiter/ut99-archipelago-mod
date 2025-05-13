class APLadder extends UTLadder config(APLadder);

var APMapInventory MapInventoryObj;

function Created() {
	super.Created();
	MapInventoryObj = APMapInventory(GetPlayerOwner().FindInventoryType(class'APMapInventory'));
	if (MapInventoryObj == None)
	{
		Log("APLadder: Player has no APMapInventory!!");
	}
}

function EvaluateMatch(optional bool bTrophyVictory) {
	local string SaveString;
	local int Team, i;
	local class<Ladder> Dummy; // just to get a class reference

	if ( MapInventoryObj != None &&
		 MapInventoryObj.LastLadder >= 0 )
	{
		switch ( MapInventoryObj.LastLadder )
		{
			case 0 : Dummy = class'APLadderDM'   ; break;
			case 1 : Dummy = class'APLadderCTF'  ; break;
			case 2 : Dummy = class'APLadderDOM'  ; break;
			case 3 : Dummy = class'APLadderAS'   ; break;
			default: Dummy = class'APLadderChal'; break;
		}

		if ( !MapInventoryObj.IsCompleted( Dummy, MapInventoryObj.LastMap ) )
		{
			MapInventoryObj.MarkCompleted( Dummy, MapInventoryObj.LastMap );
			MapInventoryObj.UnlockRandomMap();   // exactly **one** fresh unlock
		}
		MapInventoryObj.LastLadder = -1;   // consume the marker
	}

	if (LadderObj != None) {
		SaveString = string(LadderObj.TournamentDifficulty);
		for (i=0; i<class'Ladder'.Default.NumTeams; i++) {
			if (class'Ladder'.Default.LadderTeams[i] == LadderObj.Team) {
				Team = i;
			}
		}
		SaveString = SaveString$"\\"$Team;
		SaveString = SaveString$"\\"$LadderObj.DMRank;
		SaveString = SaveString$"\\"$LadderObj.DMPosition;
		SaveString = SaveString$"\\"$LadderObj.DOMRank;
		SaveString = SaveString$"\\"$LadderObj.DOMPosition;
		SaveString = SaveString$"\\"$LadderObj.CTFRank;
		SaveString = SaveString$"\\"$LadderObj.CTFPosition;
		SaveString = SaveString$"\\"$LadderObj.ASRank;
		SaveString = SaveString$"\\"$LadderObj.ASPosition;
		SaveString = SaveString$"\\"$LadderObj.ChalRank;
		SaveString = SaveString$"\\"$LadderObj.ChalPosition;
		SaveString = SaveString$"\\"$LadderObj.Sex;
		SaveString = SaveString$"\\"$LadderObj.Face;
		SaveString = SaveString$"\\"$GetPlayerOwner().PlayerReplicationInfo.PlayerName;
		class'APSlotWindow'.Default.Saves[LadderObj.Slot] = SaveString;
		class'APSlotWindow'.Static.StaticSaveConfig();

		if (LadderObj.PendingPosition > 7) {
			SelectedMatch = LadderObj.PendingPosition;
			BaseMatch = LadderObj.PendingPosition - 7;
			ArrowPos = LadderObj.PendingPosition - 1;
			PendingPos = LadderObj.PendingPosition;
		}

		LadderObj.PendingPosition = 0;

		if (bTrophyVictory) {
			bTrophyTravelPending = True;
		}

		SelectedMatch = LadderPos;
		SetMapShot(LadderPos);
		FillInfoArea(LadderPos);
	}
}

function StartMap(string StartMap, int Rung, string GameType)
{
	if (MapInventoryObj != None)
	{
		MapInventoryObj.LastLadder = MapInventoryObj.GetLadderIndex( LadderObj.CurrentLadder );
		MapInventoryObj.LastMap    = Rung;
	}

	super.StartMap( StartMap, Rung, GameType );
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int i;
	local int W, H;
	local float XWidth, YHeight, XMod, YMod, XPos, YPos, YOffset;

	Super.BeforePaint(C, X, Y);

	class'UTLadderStub'.Static.GetStubClass().Static.SetupWinParams(Self, Root, W, H);

	XMod = 4*W;
	YMod = 3*H;

	// Title
	XPos = 74.0/1024 * XMod;
	YPos = 69.0/768 * YMod;
	XWidth = 352.0/1024 * XMod;
	YHeight = 41.0/768 * YMod;	
	Title1.WinLeft = XPos;
	Title1.WinTop = YPos;
	Title1.SetSize(XWidth, YHeight);
	Title1.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// Matches
	XPos = 168.0/1024 * XMod;
	YPos = 599.0/768 * YMod;
	XWidth = 256.0/1024 * XMod;
	YHeight = 64.0/768 * YMod;
	YOffset = 48.0/768 * YMod;
	if (BaseMatch > 0)
	{
		for (i=0; i<BaseMatch; i++)
			Matches[i].WinLeft = -2 * XMod;
	}
	for (i=BaseMatch+7; i<LadderObj.CurrentLadder.Default.Matches; i++)
		if (Matches[i] != None)
			Matches[i].WinLeft = -2 * XMod;	

	for (i=BaseMatch+7; i>BaseMatch-1; i--)
	{
		if ( (i >= 0) && (Matches[i] != None) )
		{
			Matches[i].WinLeft = XPos;
			Matches[i].WinTop = YPos - ((i-BaseMatch) * YOffset);
			Matches[i].SetSize(XWidth, YHeight);
		}
	}

	// Scrollup
	XPos = 354.0/1024 * XMod;
	YPos = 258.0/768 * YMod;
	XWidth = 32.0/1024 * XMod;
	YHeight = 16.0/768 * YMod;
	Scrollup.WinLeft = XPos;
	Scrollup.WinTop = YPos;
	Scrollup.SetSize(XWidth, YHeight);

	// Scrolldown
	XPos = 354.0/1024 * XMod;
	YPos = 632.0/768 * YMod;
	XWidth = 32.0/1024 * XMod;
	YHeight = 16.0/768 * YMod;
	Scrolldown.WinLeft = XPos;
	Scrolldown.WinTop = YPos;
	Scrolldown.SetSize(XWidth, YHeight);

	// Map Info
	XPos = 529.0/1024 * XMod;
	YPos = 590.0/768 * YMod;
	XWidth = 385.0/1024 * XMod;
	YHeight = 105.0/768 * YMod;
	MapInfoArea.WinLeft = XPos;
	MapInfoArea.WinTop = YPos;
	MapInfoArea.SetSize(XWidth, YHeight);
	MapInfoArea.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetSmallestFont(Root);

	// InfoScrollup
	XPos = 923.0/1024 * XMod;
	YPos = 590.0/768 * YMod;
	XWidth = 32.0/1024 * XMod;
	YHeight = 16.0/768 * YMod;
	InfoScrollup.WinLeft = XPos;
	InfoScrollup.WinTop = YPos;
	InfoScrollup.SetSize(XWidth, YHeight);

	// InfoScrolldown
	XPos = 923.0/1024 * XMod;
	YPos = 683.0/768 * YMod;
	XWidth = 32.0/1024 * XMod;
	YHeight = 16.0/768 * YMod;
	InfoScrolldown.WinLeft = XPos;
	InfoScrolldown.WinTop = YPos;
	InfoScrolldown.SetSize(XWidth, YHeight);

	// Back Button
	XPos = 192.0/1024 * XMod;
	YPos = 701.0/768 * YMod;
	XWidth = 64.0/1024 * XMod;
	YHeight = 64.0/768 * YMod;
	BackButton.WinLeft = XPos;
	BackButton.WinTop = YPos;
	BackButton.SetSize(XWidth, YHeight);

	// Next Button
	XPos = 256.0/1024 * XMod;
	YPos = 701.0/768 * YMod;
	XWidth = 64.0/1024 * XMod;
	YHeight = 64.0/768 * YMod;
	NextButton.WinLeft = XPos;
	NextButton.WinTop = YPos;
	NextButton.SetSize(XWidth, YHeight);

	// StaticArea
	XPos = 608.0/1024 * XMod;
	YPos = 90.0/768 * YMod;
	XWidth = 320.0/1024 * XMod;
	YHeight = 319.0/768 * YMod;
	MapStatic.WinLeft = XPos;
	MapStatic.WinTop = YPos;
	MapStatic.SetSize(XWidth, YHeight);

	if (LadderObj != None && MapInventoryObj != None)
	{
		for ( i = 0 ; i < LadderObj.CurrentLadder.Default.Matches ; ++i )
		{
			if ( MapInventoryObj.IsUnlocked( LadderObj.CurrentLadder, i ) )
			{
				Matches[i].bDisabled = False;
				Matches[i].bUnknown  = False;
				Matches[i].UpTexture = Matches[i].OtherTexture;
				Matches[i].OverTexture= Matches[i].OtherTexture;
			}
			else
			{
				Matches[i].bDisabled = True;
				Matches[i].bUnknown  = True;
				Matches[i].UpTexture = Matches[i].DisabledTexture;
				Matches[i].OverTexture= Matches[i].OldOverTexture;
			}
		}
	}
}

function EscClose()
{
	BackPressed();
}

function BackPressed()
{
	Root.CreateWindow(class'APManagerWindow', 100, 100, 200, 200, Root, True);
	Close();
}

function ShowWindow()
{
	LadderObj.CurrentLadder = Ladder;
	Super.ShowWindow();
}