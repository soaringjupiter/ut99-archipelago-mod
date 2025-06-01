class APManagerWindow extends ManagerWindow Config(APLadder);

// Background
var texture BG1[4];
var texture BG2[4];
var texture BG3[4];
var string BGName1[4];
var string BGName2[4];
var string BGName3[4];

// Deathmatch Ladder
var NotifyButton DMLadderButton;
var localized string DMText;
var DoorArea DMDoor;

// Domination Ladder
var NotifyButton DOMLadderButton;
var localized string DOMText;
var DoorArea DOMDoor;

// CTF Ladder
var NotifyButton CTFLadderButton;
var localized string CTFText;
var DoorArea CTFDoor;

// Assault Ladder
var NotifyButton ASLadderButton;
var localized string ASText;
var DoorArea ASDoor;

// Challenge Ladder
var NotifyButton ChallengeLadderButton;
var localized string ChallengeText;
var DoorArea ChalDoor;
var localized string ChallengeString;
var localized string ChalPosString;

// Trophy Room
var NotifyButton TrophyButton;
var localized string TrophyText;
var DoorArea TrophyDoor;

var UTFadeTextArea InfoArea;

var NotifyButton BackButton;
var NotifyButton NextButton;

var int SelectedLadder;
var string LadderTypes[5];

var LadderInventory LadderObj;
var APMapInventory MapInventoryObj;

var localized string RankString[4];
var localized string MatchesString;

function Created() {
	local int W, H;
	local float XWidth, YHeight, XMod, YMod, XPos, YPos;
	local color TextColor;

	// Super.Created();

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

	// Check map inventory object.
	MapInventoryObj = APMapInventory(GetPlayerOwner().FindInventoryType(class'APMapInventory'));

	if (MapInventoryObj == None) {
		Log("APManagerWindow: Player has no APMapInventory!! Creating one.");
        MapInventoryObj = GetPlayerOwner().Spawn( class'APMapInventory' );
        MapInventoryObj.GiveTo( GetPlayerOwner() );   // attach to the pawn
	}

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

	// DM Door.
	if (!MapInventoryObj.HasAnyUnlocked(0)) {
		XPos = 83.0/1024 * XMod;
		YPos = 93.0/768 * YMod;
		XWidth = 332.0/1024 * XMod;
		YHeight = 63.0/768 * YMod;
		DMDoor = DoorArea(CreateWindow(class'DoorArea', XPos, YPos, XWidth, YHeight));
		DMDoor.bClosed = True;
	}

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

	// DOM Door.
	if (!MapInventoryObj.HasAnyUnlocked(1)) {
		XPos = 83.0/1024 * XMod;
		YPos = 222.0/768 * YMod;
		XWidth = 332.0/1024 * XMod;
		YHeight = 63.0/768 * YMod;
		DOMDoor = DoorArea(CreateWindow(class'DoorArea', XPos, YPos, XWidth, YHeight));
		DOMDoor.bClosed = True;
	}

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

	// CTF door.
	if (!MapInventoryObj.HasAnyUnlocked(2)) {
		XPos = 83.0/1024 * XMod;
		YPos = 356.0/768 * YMod;
		XWidth = 332.0/1024 * XMod;
		YHeight = 63.0/768 * YMod;
		CTFDoor = DoorArea(CreateWindow(class'DoorArea', XPos, YPos, XWidth, YHeight));
		CTFDoor.bClosed = True;
	}

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

	// AS Door.
	if (!MapInventoryObj.HasAnyUnlocked(3)) {
		XPos = 83.0/1024 * XMod;
		YPos = 488.0/768 * YMod;
		XWidth = 332.0/1024 * XMod;
		YHeight = 63.0/768 * YMod;
		ASDoor = DoorArea(CreateWindow(class'DoorArea', XPos, YPos, XWidth, YHeight));
		ASDoor.bClosed = True;
	}

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

	// Challenge door.
	if (!MapInventoryObj.HasAnyUnlocked(4)) {
		XPos = 83.0/1024 * XMod;
		YPos = 618.0/768 * YMod;
		XWidth = 332.0/1024 * XMod;
		YHeight = 63.0/768 * YMod;
		ChalDoor = DoorArea(CreateWindow(class'DoorArea', XPos, YPos, XWidth, YHeight));
		ChalDoor.bClosed = True;
	}

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

function Paint(Canvas C, float X, float Y)
{
	local int XOffset, YOffset;
	local int W, H;
	local float XWidth, YHeight, XMod, YMod, XPos, YPos;

	class'UTLadderStub'.Static.GetStubClass().Static.SetupWinParams(Self, Root, W, H);

	XMod = 4*W;
	YMod = 3*H;

	XOffset = (WinWidth - (4 * W)) / 2;
	YOffset = (WinHeight - (3 * H)) / 2;

	// Background
	DrawStretchedTexture(C, XOffset + (0 * W), YOffset + (0 * H), W+1, H+1, BG1[0]);
	DrawStretchedTexture(C, XOffset + (1 * W), YOffset + (0 * H), W+1, H+1, BG1[1]);
	DrawStretchedTexture(C, XOffset + (2 * W), YOffset + (0 * H), W+1, H+1, BG1[2]);
	DrawStretchedTexture(C, XOffset + (3 * W), YOffset + (0 * H), W+1, H+1, BG1[3]);

	DrawStretchedTexture(C, XOffset + (0 * W), YOffset + (1 * H), W+1, H+1, BG2[0]);
	DrawStretchedTexture(C, XOffset + (1 * W), YOffset + (1 * H), W+1, H+1, BG2[1]);
	DrawStretchedTexture(C, XOffset + (2 * W), YOffset + (1 * H), W+1, H+1, BG2[2]);
	DrawStretchedTexture(C, XOffset + (3 * W), YOffset + (1 * H), W+1, H+1, BG2[3]);
		
	DrawStretchedTexture(C, XOffset + (0 * W), YOffset + (2 * H), W+1, H+1, BG3[0]);
	DrawStretchedTexture(C, XOffset + (1 * W), YOffset + (2 * H), W+1, H+1, BG3[1]);
	DrawStretchedTexture(C, XOffset + (2 * W), YOffset + (2 * H), W+1, H+1, BG3[2]);
	DrawStretchedTexture(C, XOffset + (3 * W), YOffset + (2 * H), W+1, H+1, BG3[3]);

	if (C.ClipX < 512)
		return;

	if (LadderObj.DMRank == 6)
	{
		XPos = 95.0/1024 * XMod;
		YPos = 102.0/768 * YMod;
		XWidth = 60.0/1024 * XMod;
		YHeight = 60.0/1024 * YMod;
		DrawStretchedTexture(C, XPos, YPos, XWidth, YHeight, texture'TrophyDM');
	}
	if (LadderObj.DOMRank == 6)
	{
		XPos = 95.0/1024 * XMod;
		YPos = 231.0/768 * YMod;
		XWidth = 60.0/1024 * XMod;
		YHeight = 60.0/1024 * YMod;
		DrawStretchedTexture(C, XPos, YPos, XWidth, YHeight, texture'TrophyDOM');
	}
	if (LadderObj.CTFRank == 6)
	{
		XPos = 95.0/1024 * XMod;
		YPos = 363.0/768 * YMod;
		XWidth = 60.0/1024 * XMod;
		YHeight = 60.0/1024 * YMod;
		DrawStretchedTexture(C, XPos, YPos, XWidth, YHeight, texture'TrophyCTF');
	}
	if (LadderObj.ASRank == 6)
	{
		XPos = 95.0/1024 * XMod;
		YPos = 497.0/768 * YMod;
		XWidth = 60.0/1024 * XMod;
		YHeight = 60.0/1024 * YMod;
		DrawStretchedTexture(C, XPos, YPos, XWidth, YHeight, texture'TrophyAS');
	}
	if (LadderObj.ChalRank == 6)
	{
		XPos = 95.0/1024 * XMod;
		YPos = 627.0/768 * YMod;
		XWidth = 60.0/1024 * XMod;
		YHeight = 60.0/1024 * YMod;
		DrawStretchedTexture(C, XPos, YPos, XWidth, YHeight, texture'TrophyChal');
	}
}

function ShowWindow ()
{
	Super(UWindowWindow).ShowWindow();
	InfoArea.Clear();

	if ( Root.WinWidth < 512 ) {
		return;
	}

	InfoArea.AddText(RankString[0] @ Class'Ladder'.Static.GetRank(LadderObj.DMRank));
	InfoArea.AddText(MatchesString @ string(LadderObj.DMPosition - 1));

	if (LadderObj.DMPosition >= 3) {
		InfoArea.AddText("");
		InfoArea.AddText(RankString[1] @ Class'Ladder'.Static.GetRank(LadderObj.DOMRank));
		InfoArea.AddText(MatchesString @ string(LadderObj.DOMPosition - 1));
	}

	if (LadderObj.DOMPosition >= 2) {
		InfoArea.AddText("");
		InfoArea.AddText(RankString[2] @ Class'Ladder'.Static.GetRank(LadderObj.CTFRank));
		InfoArea.AddText(MatchesString @ string(LadderObj.CTFPosition - 1));
	}

	if (LadderObj.CTFPosition >= 3) {
		InfoArea.AddText("");
		InfoArea.AddText(RankString[3] @ Class'Ladder'.Static.GetRank(LadderObj.ASRank));
		InfoArea.AddText(MatchesString @ string(LadderObj.ASPosition - 1));
	}

	if ((LadderObj.DMRank == 6) && (LadderObj.DOMRank == 6) && (LadderObj.CTFRank == 6) && (LadderObj.ASRank == 6)) {
		InfoArea.AddText(" ");
		InfoArea.AddText(ChallengeString);
		InfoArea.AddText(ChalPosString @ Class'Ladder'.Static.GetRank(LadderObj.ChalRank));
	}
}

function Close(optional bool bByParent)
{
	Root.Console.bNoDrawWorld = Root.Console.ShowDesktop;
	Root.Console.bLocked = False;
	UMenuRootWindow(Root).MenuBar.ShowWindow();
	LadderObj = None;

	Super.Close(bByParent);
}

function HideWindow()
{
	Root.Console.bBlackOut = False;

	Super.HideWindow();
}

function Notify(UWindowWindow C, byte E)
{
	local Class<UWindowWindow> LadderWindow;

	switch (E)
	{
	case DE_Click:
		switch (C)
		{
		case DMLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 0;
			Lite(SelectedLadder);
			break;
		case DOMLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 1;
			Lite(SelectedLadder);
			break;
		case CTFLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 2;
			Lite(SelectedLadder);
			break;
		case ASLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 3;
			Lite(SelectedLadder);
			break;
		case ChallengeLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 4;
			Lite(SelectedLadder);
			break;
		case TrophyButton:
			Root.SetMousePos((Root.WinWidth*Root.GUIScale)/2, (Root.WinHeight*Root.GUIScale)/2);
			Close();
			Root.Console.CloseUWindow();
			GetPlayerOwner().ClientTravel("EOL_Statues.unr?Game=Botpack.TrophyGame", TRAVEL_Absolute, True);			
			break;
		case NextButton:
			LadderWindow = Class<UWindowWindow>(DynamicLoadObject(LadderTypes[SelectedLadder], class'Class'));
			LadderObj = None;
			HideWindow();
			Root.CreateWindow(LadderWindow, 100, 100, 200, 200, Root, True);
			break;
		case BackButton:
			Close();
			break;
		}
		break;
	case DE_Doubleclick:
		switch (C)
		{
		case DMLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 0;
			Lite(SelectedLadder);
			LadderWindow = Class<UWindowWindow>(DynamicLoadObject(LadderTypes[SelectedLadder], class'Class'));
			HideWindow();
			Root.CreateWindow(LadderWindow, 100, 100, 200, 200, Root, True);
			break;
		case DOMLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 1;
			Lite(SelectedLadder);
			LadderWindow = Class<UWindowWindow>(DynamicLoadObject(LadderTypes[SelectedLadder], class'Class'));
			HideWindow();
			Root.CreateWindow(LadderWindow, 100, 100, 200, 200, Root, True);
			break;
		case CTFLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 2;
			Lite(SelectedLadder);
			LadderWindow = Class<UWindowWindow>(DynamicLoadObject(LadderTypes[SelectedLadder], class'Class'));
			HideWindow();
			Root.CreateWindow(LadderWindow, 100, 100, 200, 200, Root, True);
			break;
		case ASLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 3;
			Lite(SelectedLadder);
			LadderWindow = Class<UWindowWindow>(DynamicLoadObject(LadderTypes[SelectedLadder], class'Class'));
			HideWindow();
			Root.CreateWindow(LadderWindow, 100, 100, 200, 200, Root, True);
			break;
		case ChallengeLadderButton:
			Unlite(SelectedLadder);
			SelectedLadder = 4;
			Lite(SelectedLadder);
			LadderWindow = Class<UWindowWindow>(DynamicLoadObject(LadderTypes[SelectedLadder], class'Class'));
			HideWindow();
			Root.CreateWindow(LadderWindow, 100, 100, 200, 200, Root, True);
			break;
		}
		break;
	}
}

function UnLite(int Ladder)
{
	local color UnLiteColor;

	UnLiteColor.R = 255;
	UnLiteColor.G = 0;
	UnLiteColor.B = 0;

	switch (Ladder)
	{
		case 0:
			DMLadderButton.SetTextColor(UnLiteColor);
			break;
		case 1:
			DOMLadderButton.SetTextColor(UnLiteColor);
			break;
		case 2:
			CTFLadderButton.SetTextColor(UnLiteColor);
			break;
		case 3:
			ASLadderButton.SetTextColor(UnLiteColor);
			break;
		case 4:
			ChallengeLadderButton.SetTextColor(UnLiteColor);
			break;
	}
}

function Lite(int Ladder)
{
	local color LiteColor;

	LiteColor.R = 255;
	LiteColor.G = 255;
	LiteColor.B = 0;

	switch (Ladder)
	{
		case 0:
			DMLadderButton.SetTextColor(LiteColor);
			break;
		case 1:
			DOMLadderButton.SetTextColor(LiteColor);
			break;
		case 2:
			CTFLadderButton.SetTextColor(LiteColor);
			break;
		case 3:
			ASLadderButton.SetTextColor(LiteColor);
			break;
		case 4:
			ChallengeLadderButton.SetTextColor(LiteColor);
			break;
	}
}

function SetupLadderButton( NotifyButton B, bool bEnabled )
{
    local color Yellow, Red;

    Yellow.R = 255; Yellow.G = 255; Yellow.B = 0;
    Red   .R = 255; Red   .G =   0; Red   .B = 0;

    if ( bEnabled )
    {
        B.bDisabled = False;
        B.SetTextColor( Yellow );
    }
    else
    {
        B.bDisabled = True;
        B.SetTextColor( Red );
    }
}

defaultproperties
{
    BGName1(0)="UTMenu.Sel11"
    BGName1(1)="UTMenu.Sel12"
    BGName1(2)="UTMenu.Sel13"
    BGName1(3)="UTMenu.Sel14"
    BGName2(0)="UTMenu.Sel21"
    BGName2(1)="UTMenu.Sel22"
    BGName2(2)="UTMenu.Sel23"
    BGName2(3)="UTMenu.Sel24"
    BGName3(0)="UTMenu.Sel31"
    BGName3(1)="UTMenu.Sel32"
    BGName3(2)="UTMenu.Sel33"
    BGName3(3)="UTMenu.Sel34"
    DMText="Deathmatch"
    DOMText="Domination"
    CTFText="Capture the Flag"
    ASText="Assault"
    ChallengeText="Challenge"
    ChallengeString="FINAL TOURNAMENT CHALLENGE"
    ChalPosString="Challenge Rank:"
    TrophyText="Trophy Room"
	LadderTypes(0)="Archipelago.APLadderDMMenu"
	LadderTypes(1)="Archipelago.APLadderDOMMenu"
	LadderTypes(2)="Archipelago.APLadderCTFMenu"
	LadderTypes(3)="Archipelago.APLadderASMenu"
	LadderTypes(4)="Archipelago.APLadderChalMenu"
    RankString(0)="Deathmatch Rank:"
    RankString(1)="Domination Rank:"
    RankString(2)="CTF Rank:"
    RankString(3)="Assault Rank:"
    MatchesString="Matches Completed:"
}