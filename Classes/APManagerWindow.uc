class APManagerWindow extends ManagerWindow Config(APLadder);

function OpenDoors ()
{
	local bool bOneOpened;

	if ( LadderObj.DMPosition >= 3 ) {
		if ( (DOMDoorOpen[LadderObj.Slot] == 0) && (DOMDoor != None) ) {
			DOMDoorOpen[LadderObj.Slot] = 1;
			DOMDoor.Open();
			SaveConfig();
			bOneOpened = True;
		}
	}

	if ( LadderObj.DOMPosition >= 2 ) {
		if ( (CTFDoorOpen[LadderObj.Slot] == 0) && (CTFDoor != None) ) {
			CTFDoorOpen[LadderObj.Slot] = 1;
			CTFDoor.Open();
			SaveConfig();
			bOneOpened = True;
		}
	}

	if ( LadderObj.CTFPosition >= 3 ) {
		if ( (ASDoorOpen[LadderObj.Slot] == 0) && (ASDoor != None) ) {
			ASDoorOpen[LadderObj.Slot] = 1;
			ASDoor.Open();
			SaveConfig();
			bOneOpened = True;
		}
	}

	if ((LadderObj.DMRank == 6) && (LadderObj.DOMRank == 6) && (LadderObj.CTFRank == 6) && (LadderObj.ASRank == 6)) {
		if ( (ChalDoorOpen[LadderObj.Slot] == 0) && (ChalDoor != None) )
		{
			ChalDoorOpen[LadderObj.Slot] = 1;
			ChalDoor.Open();
			SaveConfig();
			bOneOpened = True;
		}
	}

	if ( (LadderObj.DMRank == 6) || (LadderObj.DOMRank == 6) || (LadderObj.CTFRank == 6) || (LadderObj.ASRank == 6) ) {
		if ( (TrophyDoorOpen[LadderObj.Slot] == 0) && (TrophyDoor != None) )
		{
			TrophyDoorOpen[LadderObj.Slot] = 1;
			TrophyDoor.Open();
			SaveConfig();
			bOneOpened = True;
		}
	}

	if ( bOneOpened ) {
		GetPlayerOwner().PlaySound(Sound'LadderSounds.ldoorsopen1b',SLOT_Interface);
	}
	bOpened = True;
}

function Created() {
	local float Xs, Ys;
	local int i;
	local int W, H;
	local float XWidth, YHeight, XMod, YMod, XPos, YPos;
	local color TextColor;

	Super.Created();

	// Window properties.
	bLeaveOnScreen = True;
	bAlwaysOnTop = True;
	class'UTLadderStub'.Static.GetStubClass().Static.SetupWinParams(Self, Root, W, H);

	XMod = 4*W;
	YMod = 3*H;

	// Background.
	BG1[0] = Texture(DynamicLoadObject(BGName1[0], Class'Texture'));
	BG1[1] = Texture(DynamicLoadObject(BGName1[1], Class'Texture'));
	BG1[2] = Texture(DynamicLoadObject(BGName1[2], Class'Texture'));
	BG1[3] = Texture(DynamicLoadObject(BGName1[3], Class'Texture'));
	BG2[0] = Texture(DynamicLoadObject(BGName2[0], Class'Texture'));
	BG2[1] = Texture(DynamicLoadObject(BGName2[1], Class'Texture'));
	BG2[2] = Texture(DynamicLoadObject(BGName2[2], Class'Texture'));
	BG2[3] = Texture(DynamicLoadObject(BGName2[3], Class'Texture'));
	BG3[0] = Texture(DynamicLoadObject(BGName3[0], Class'Texture'));
	BG3[1] = Texture(DynamicLoadObject(BGName3[1], Class'Texture'));
	BG3[2] = Texture(DynamicLoadObject(BGName3[2], Class'Texture'));
	BG3[3] = Texture(DynamicLoadObject(BGName3[3], Class'Texture'));

	// Window components.

// Check ladder object.
	LadderObj = LadderInventory(GetPlayerOwner().FindInventoryType(class'LadderInventory'));

	if (LadderObj == None) {
		Log("APManagerWindow: Player has no LadderInventory!!");
	}

	LadderObj.LastMatchType = 0;

	// TDM ladder.
	XPos = 95.0/1024 * XMod;
	YPos = 102.0/768 * YMod;
	XWidth = 307.0/1024 * XMod;
	YHeight = 44.0/768 * YMod;
	DMLadderButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	DMLadderButton.NotifyWindow = Self;
	DMLadderButton.bStretched = True;
	DMLadderButton.Text = DMText;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 0;
	DMLadderButton.SetTextColor(TextColor);
	DMLadderButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// DOM ladder.
	XPos = 95.0/1024 * XMod;
	YPos = 231.0/768 * YMod;
	XWidth = 307.0/1024 * XMod;
	YHeight = 44.0/768 * YMod;
	DOMLadderButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	DOMLadderButton.NotifyWindow = Self;
	DOMLadderButton.bStretched = True;
	DOMLadderButton.Text = DOMText;
	TextColor.R = 255;
	TextColor.G = 0;
	TextColor.B = 0;
	DOMLadderButton.SetTextColor(TextColor);
	DOMLadderButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// CTF ladder.
	XPos = 95.0/1024 * XMod;
	YPos = 363.0/768 * YMod;
	XWidth = 307.0/1024 * XMod;
	YHeight = 44.0/768 * YMod;
	CTFLadderButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	CTFLadderButton.NotifyWindow = Self;
	CTFLadderButton.bStretched = True;

	if (LadderObj.CTFRank == 6) {
		CTFLadderButton.Text = " "$CTFText;
	} else {
		CTFLadderButton.Text = CTFText;
	}

	TextColor.R = 255;
	TextColor.G = 0;
	TextColor.B = 0;
	CTFLadderButton.SetTextColor(TextColor);
	CTFLadderButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// AS Ladder.
	XPos = 95.0/1024 * XMod;
	YPos = 497.0/768 * YMod;
	XWidth = 307.0/1024 * XMod;
	YHeight = 44.0/768 * YMod;
	ASLadderButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	ASLadderButton.NotifyWindow = Self;
	ASLadderButton.bStretched = True;
	ASLadderButton.Text = ASText;
	TextColor.R = 255;
	TextColor.G = 0;
	TextColor.B = 0;
	ASLadderButton.SetTextColor(TextColor);
	ASLadderButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// Challenge ladder.
	XPos = 95.0/1024 * XMod;
	YPos = 627.0/768 * YMod;
	XWidth = 307.0/1024 * XMod;
	YHeight = 44.0/768 * YMod;
	ChallengeLadderButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	ChallengeLadderButton.NotifyWindow = Self;
	ChallengeLadderButton.bStretched = True;
	ChallengeLadderButton.Text = ChallengeText;
	TextColor.R = 255;
	TextColor.G = 0;
	TextColor.B = 0;
	ChallengeLadderButton.SetTextColor(TextColor);
	ChallengeLadderButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// Sala de Trofeos.
	XPos = 656.0/1024 * XMod;
	YPos = 63.0/768 * YMod;
	XWidth = 222.0/1024 * XMod;
	YHeight = 50.0/768 * YMod;
	TrophyButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	TrophyButton.NotifyWindow = Self;
	TrophyButton.bStretched = True;
	TrophyButton.Text = TrophyText;
	TextColor.R = 255;
	TextColor.G = 0;
	TextColor.B = 0;
	TrophyButton.SetTextColor(TextColor);
	TrophyButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	// Trophy door.
	if (TrophyDoorOpen[LadderObj.Slot] == 0) {
		XPos = 649.0/1024 * XMod;
		YPos = 57.0/768 * YMod;
		XWidth = 236.0/1024 * XMod;
		YHeight = 62.0/768 * YMod;
		TrophyDoor = DoorArea(CreateWindow(class'DoorArea', XPos, YPos, XWidth, YHeight));
		TrophyDoor.bClosed = True;
	}

	// Back button.
	XPos = 192.0/1024 * XMod;
	YPos = 701.0/768 * YMod;
	XWidth = 64.0/1024 * XMod;
	YHeight = 64.0/768 * YMod;
	BackButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	BackButton.DisabledTexture = Texture(DynamicLoadObject("UTMenu.LeftUp", Class'Texture'));
	BackButton.UpTexture = Texture(DynamicLoadObject("UTMenu.LeftUp", Class'Texture'));
	BackButton.DownTexture = Texture(DynamicLoadObject("UTMenu.LeftDown", Class'Texture'));
	BackButton.OverTexture = Texture(DynamicLoadObject("UTMenu.LeftOver", Class'Texture'));
	BackButton.NotifyWindow = Self;
	BackButton.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 0;
	BackButton.SetTextColor(TextColor);
	BackButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);
	BackButton.bStretched = True;
	BackButton.OverSound = sound'LadderSounds.lcursorMove';
	BackButton.DownSound = sound'LadderSounds.ladvance';

	// Next button.
	XPos = 256.0/1024 * XMod;
	YPos = 701.0/768 * YMod;
	XWidth = 64.0/1024 * XMod;
	YHeight = 64.0/768 * YMod;
	NextButton = NotifyButton(CreateWindow(class'NotifyButton', XPos, YPos, XWidth, YHeight));
	NextButton.DisabledTexture = Texture(DynamicLoadObject("UTMenu.RightUp", Class'Texture'));
	NextButton.UpTexture = Texture(DynamicLoadObject("UTMenu.RightUp", Class'Texture'));
	NextButton.DownTexture = Texture(DynamicLoadObject("UTMenu.RightDown", Class'Texture'));
	NextButton.OverTexture = Texture(DynamicLoadObject("UTMenu.RightOver", Class'Texture'));
	NextButton.NotifyWindow = Self;
	NextButton.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 0;
	NextButton.SetTextColor(TextColor);
	NextButton.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);
	NextButton.bStretched = True;
	NextButton.OverSound = sound'LadderSounds.lcursorMove';
	NextButton.DownSound = sound'LadderSounds.ladvance';

	// Info
	XPos = 617.0/1024 * XMod;
	YPos = 233.0/768 * YMod;
	XWidth = 303.0/1024 * XMod;
	YHeight = 440.0/768 * YMod;
	InfoArea = UTFadeTextArea(CreateWindow(Class<UWindowWindow>(DynamicLoadObject("UTMenu.UTFadeTextArea", Class'Class')), XPos, YPos, XWidth, YHeight));
	InfoArea.TextColor.R = 255;
	InfoArea.TextColor.G = 255;
	InfoArea.TextColor.B = 0;
	InfoArea.MyFont = class'UTLadderStub'.Static.GetStubClass().Static.GetSmallFont(Root);
	InfoArea.FadeFactor = 8;
	InfoArea.Clear();

	if (Root.WinWidth < 512) {
		return;
	}

	if (LadderObj.DMPosition == -1) {
		InfoArea.AddText(MatchesString@"0");
	} else {
		if (LadderObj.DMRank == 6) {
			InfoArea.AddText(MatchesString@LadderObj.DMPosition);
		} else {
			InfoArea.AddText(MatchesString@(LadderObj.DMPosition-1));
		}
	}

	if (LadderObj.DMPosition >= 4) {
		InfoArea.AddText(" ");
		InfoArea.AddText(RankString[1]@class'Ladder'.Static.GetRank(LadderObj.DOMRank));
		
		if (LadderObj.DOMPosition == -1) {
			InfoArea.AddText(MatchesString@"0");
		} else {
			if (LadderObj.DOMRank == 6) {
				InfoArea.AddText(MatchesString@LadderObj.DOMPosition);
			} else {
				InfoArea.AddText(MatchesString@(LadderObj.DOMPosition-1));
			}
		}
	}

	if (LadderObj.DOMPosition >= 4) {
		InfoArea.AddText(" ");
		InfoArea.AddText(RankString[2]@class'Ladder'.Static.GetRank(LadderObj.CTFRank));
		
		if (LadderObj.CTFPosition == -1) {
			InfoArea.AddText(MatchesString@"0");
		} else {
			if (LadderObj.CTFRank == 6) {
				InfoArea.AddText(MatchesString@LadderObj.CTFPosition);
			} else {
				InfoArea.AddText(MatchesString@(LadderObj.CTFPosition-1));
			}
		}
	}

	if (LadderObj.CTFPosition >= 4) {
		InfoArea.AddText(" ");
		InfoArea.AddText(RankString[3]@class'Ladder'.Static.GetRank(LadderObj.ASRank));
		if (LadderObj.ASPosition == -1) {
			InfoArea.AddText(MatchesString@"0");
		} else {
			if (LadderObj.ASRank == 6) {
				InfoArea.AddText(MatchesString@LadderObj.ASPosition);
			} else {
				InfoArea.AddText(MatchesString@(LadderObj.ASPosition-1));
			}
		}
	}

	if ((LadderObj.DMRank == 6) && (LadderObj.DOMRank == 6) && (LadderObj.CTFRank == 6) && (LadderObj.ASRank == 6)) {
		InfoArea.AddText(" ");
		InfoArea.AddText(ChallengeString);
		InfoArea.AddText(ChalPosString@class'Ladder'.Static.GetRank(LadderObj.ChalRank));
	}
	Root.Console.bBlackOut = True;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local LadderInventory LadderObj;
	local float Xs;
	local float Ys;
	local int i;
	local int W;
	local int H;
	local float XWidth;
	local float YHeight;
	local float XMod;
	local float YMod;
	local float XPos;
	local float YPos;

	Super.BeforePaint(C,X,Y);
	Class'UTLadderStub'.Static.GetStubClass().Static.SetupWinParams(self,Root,W,H);
	XMod = 4.0 * W;
	YMod = 3.0 * H;
	XPos = 95.0 / 1024 * XMod;
	YPos = 102.0 / 768 * YMod;
	XWidth = 307.0 / 1024 * XMod;
	YHeight = 44.0 / 768 * YMod;
	DMLadderButton.WinLeft = XPos;
	DMLadderButton.WinTop = YPos;
	DMLadderButton.SetSize(XWidth,YHeight);
	DMLadderButton.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);
	XPos = 95.0 / 1024 * XMod;
	YPos = 231.0 / 768 * YMod;
	XWidth = 307.0 / 1024 * XMod;
	YHeight = 44.0 / 768 * YMod;
	DOMLadderButton.WinLeft = XPos;
	DOMLadderButton.WinTop = YPos;
	DOMLadderButton.SetSize(XWidth,YHeight);
	DOMLadderButton.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	if (DOMDoor != None) {
		XPos = 83.0 / 1024 * XMod;
		YPos = 222.0 / 768 * YMod;
		XWidth = 332.0 / 1024 * XMod;
		YHeight = 63.0 / 768 * YMod;
		DOMDoor.WinLeft = XPos;
		DOMDoor.WinTop = YPos;
		DOMDoor.SetSize(XWidth,YHeight);
	}

	XPos = 95.0 / 1024 * XMod;
	YPos = 363.0 / 768 * YMod;
	XWidth = 307.0 / 1024 * XMod;
	YHeight = 44.0 / 768 * YMod;
	CTFLadderButton.WinLeft = XPos;
	CTFLadderButton.WinTop = YPos;
	CTFLadderButton.SetSize(XWidth,YHeight);
	CTFLadderButton.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	if (CTFDoor != None) {
		XPos = 83.0 / 1024 * XMod;
		YPos = 356.0 / 768 * YMod;
		XWidth = 332.0 / 1024 * XMod;
		YHeight = 63.0 / 768 * YMod;
		CTFDoor.WinLeft = XPos;
		CTFDoor.WinTop = YPos;
		CTFDoor.SetSize(XWidth,YHeight);
	}

	XPos = 95.0 / 1024 * XMod;
	YPos = 497.0 / 768 * YMod;
	XWidth = 307.0 / 1024 * XMod;
	YHeight = 44.0 / 768 * YMod;
	ASLadderButton.WinLeft = XPos;
	ASLadderButton.WinTop = YPos;
	ASLadderButton.SetSize(XWidth,YHeight);
	ASLadderButton.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	if (ASDoor != None) {
		XPos = 83.0 / 1024 * XMod;
		YPos = 488.0 / 768 * YMod;
		XWidth = 332.0 / 1024 * XMod;
		YHeight = 63.0 / 768 * YMod;
		ASDoor.WinLeft = XPos;
		ASDoor.WinTop = YPos;
		ASDoor.SetSize(XWidth,YHeight);
	}

	XPos = 95.0 / 1024 * XMod;
	YPos = 627.0 / 768 * YMod;
	XWidth = 307.0 / 1024 * XMod;
	YHeight = 44.0 / 768 * YMod;
	ChallengeLadderButton.WinLeft = XPos;
	ChallengeLadderButton.WinTop = YPos;
	ChallengeLadderButton.SetSize(XWidth,YHeight);
	ChallengeLadderButton.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	if ( ChalDoor != None ) {
		XPos = 83.0 / 1024 * XMod;
		YPos = 618.0 / 768 * YMod;
		XWidth = 332.0 / 1024 * XMod;
		YHeight = 63.0 / 768 * YMod;
		ChalDoor.WinLeft = XPos;
		ChalDoor.WinTop = YPos;
		ChalDoor.SetSize(XWidth,YHeight);
	}

	XPos = 656.0 / 1024 * XMod;
	YPos = 63.0 / 768 * YMod;
	XWidth = 222.0 / 1024 * XMod;
	YHeight = 50.0 / 768 * YMod;
	TrophyButton.WinLeft = XPos;
	TrophyButton.WinTop = YPos;
	TrophyButton.SetSize(XWidth,YHeight);
	TrophyButton.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetHugeFont(Root);

	if ( TrophyDoor != None )
	{
		XPos = 650.0 / 1024 * XMod;
		YPos = 58.0 / 768 * YMod;
		XWidth = 236.0 / 1024 * XMod;
		YHeight = 62.0 / 768 * YMod;
		TrophyDoor.WinLeft = XPos;
		TrophyDoor.WinTop = YPos;
		TrophyDoor.SetSize(XWidth,YHeight);
	}

	XPos = 192.0 / 1024 * XMod;
	YPos = 701.0 / 768 * YMod;
	XWidth = 64.0 / 1024 * XMod;
	YHeight = 64.0 / 768 * YMod;
	BackButton.SetSize(XWidth,YHeight);
	BackButton.WinLeft = XPos;
	BackButton.WinTop = YPos;
	XPos = 256.0 / 1024 * XMod;
	YPos = 701.0 / 768 * YMod;
	XWidth = 64.0 / 1024 * XMod;
	YHeight = 64.0 / 768 * YMod;
	NextButton.SetSize(XWidth,YHeight);
	NextButton.WinLeft = XPos;
	NextButton.WinTop = YPos;
	XPos = 617.0 / 1024 * XMod;
	YPos = 233.0 / 768 * YMod;
	XWidth = 303.0 / 1024 * XMod;
	YHeight = 440.0 / 768 * YMod;
	InfoArea.SetSize(XWidth,YHeight);
	InfoArea.WinLeft = XPos;
	InfoArea.WinTop = YPos;
	InfoArea.MyFont = Class'UTLadderStub'.Static.GetStubClass().Static.GetSmallFont(Root);
}

defaultproperties
{
	LadderTypes(0)="Archipelago.APLadderDMMenu"
	LadderTypes(1)="Archipelago.APLadderDOMMenu"
	LadderTypes(2)="Archipelago.APLadderCTFMenu"
	LadderTypes(3)="Archipelago.APLadderASMenu"
	LadderTypes(4)="Archipelago.APLadderChalMenu"
}