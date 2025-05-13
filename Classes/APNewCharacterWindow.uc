class APNewCharacterWindow extends NewCharacterWindow;

function NextPressed () 
	{
	local int i;
	local APManagerWindow ManagerWindow;

	if (LadderObj.Sex ~= "F") {
		SexButton.Text = MaleText;
	} else {
		SexButton.Text = FemaleText;
	}

	SexPressed();
	LadderObj.DMRank = 0;
	LadderObj.DMPosition = -1;
	LadderObj.CTFRank = 0;
	LadderObj.CTFPosition = -1;
	LadderObj.DOMRank = 0;
	LadderObj.DOMPosition = -1;
	LadderObj.ASRank = 0;
	LadderObj.ASPosition = -1;
	LadderObj.ChalRank = 0;
	LadderObj.ChalPosition = 0;
	LadderObj = None;
	Super(NotifyWindow).Close();
	ManagerWindow = APManagerWindow(Root.CreateWindow(Class'APManagerWindow',100.0,100.0,200.0,200.0,Root,True));
}