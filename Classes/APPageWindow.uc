// ============================================================
//  UCMenuUCClientWindow
// ============================================================

class APPageWindow expands UMenuPageWindow;

var UWindowSmallButton ladder, resume, menubar;
var float ControlOffset;

var UWindowCheckbox DMCheck;
var localized string DMText;
var localized string DMHelp;

var UWindowCheckbox CTFCheck;
var localized string CTFText;
var localized string CTFHelp;

var UWindowCheckbox LMSCheck;
var localized string LMSText;
var localized string LMSHelp;

var UWindowCheckbox MTDCheck;
var localized string MTDText;
var localized string MTDHelp;

var UWindowCheckbox CDMCheck;
var localized string CDMText;
var localized string CDMHelp;

function Created()
{
	Super.Created();
	ControlOffset = 15;

	ladder = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 35, ControlOffset, 210, 16));
	ladder.SetText("&Start Archipelago Ladder Run");
	ladder.Align = TA_Left;
	ladder.SetFont(F_Normal);
	ladder.SetHelpText("Select to start a new Unreal Tournament game!");
	ControlOffset += 25;

	resume = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 35, ControlOffset, 210, 16));
	resume.SetText("&Resume Saved Archipelago Ladder Run");
	resume.Align = TA_Left;
	resume.SetFont(F_Normal);
	resume.SetHelpText("Select to resume a saved Unreal Tournament game.");
	ControlOffset += 25;

	menubar = UWindowSmallButton(CreateControl(class'UWindowSmallButton', 35, ControlOffset, 210, 16));
	menubar.SetText("Reset Unreal Tournament");
	menubar.Align = TA_Left;
	menubar.SetFont(F_Normal);
	menubar.SetHelpText("Select to reset the Unreal Tournament's original Ladders");
	ControlOffset += 20;
}

function Notify(UWindowDialogControl C, byte E)
{
  	Super.Notify(C, E);
  	switch(E) 
	{
    		case DE_Click:
    		switch(C)
    		{
  		case ladder:
			InitConsole();
			GetPlayerOwner().ClientTravel( "UT-Logo-Map.unr?Game=Archipelago.APLadderNewGame", TRAVEL_Absolute, True );
      		break;
    		case resume:
			InitConsole();
			GetPlayerOwner().ClientTravel( "UT-Logo-Map.unr?Game=Archipelago.APLadderLoadGame", TRAVEL_Absolute, True );
      		break;
  		case menubar:
			ResetConsole();
	    		break;
       	}
   		break;
  	}
}

function AfterCreate()
{
	DesiredWidth = 220;
	DesiredHeight = ControlOffset;
}

function InitConsole()
{
    log("Championship Mode");
    UTConsole(GetPlayerOwner().Player.Console).ManagerWindowClass="Archipelago.APManagerWindow";
    UTConsole(GetPlayerOwner().Player.Console).UTLadderDMClass="Archipelago.APLadderDMMenu";
    UTConsole(GetPlayerOwner().Player.Console).UTLadderCTFClass="Archipelago.APLadderCTFMenu";
    UTConsole(GetPlayerOwner().Player.Console).UTLadderDOMClass="Archipelago.APLadderDOMMenu";
    UTConsole(GetPlayerOwner().Player.Console).UTLadderASClass="Archipelago.APLadderASMenu";
    UTConsole(GetPlayerOwner().Player.Console).UTLadderChalClass="Archipelago.APLadderChalMenu";
    UTConsole(GetPlayerOwner().Player.Console).InterimObjectType="Archipelago.APNewGameInterimObject";
    UTConsole(GetPlayerOwner().Player.Console).SlotWindowType="Archipelago.APSlotWindow";
}

function ResetConsole()
{
	log("Tournament Mode");
	UTConsole(GetPlayerOwner().Player.Console).ManagerWindowClass="UTMenu.ManagerWindow";
	UTConsole(GetPlayerOwner().Player.Console).UTLadderDMClass="UTMenu.UTLadderDM";
	UTConsole(GetPlayerOwner().Player.Console).UTLadderCTFClass="UTMenu.UTLadderCTF";
	UTConsole(GetPlayerOwner().Player.Console).UTLadderDOMClass="UTMenu.UTLadderDOM";
	UTConsole(GetPlayerOwner().Player.Console).UTLadderASClass="UTMenu.UTLadderAS";
	UTConsole(GetPlayerOwner().Player.Console).UTLadderChalClass="UTMenu.UTLadderChal";
	UTConsole(GetPlayerOwner().Player.Console).InterimObjectType="UTMenu.NewGameInterimObject";
	UTConsole(GetPlayerOwner().Player.Console).SlotWindowType="UTMenu.SlotWindow";
}