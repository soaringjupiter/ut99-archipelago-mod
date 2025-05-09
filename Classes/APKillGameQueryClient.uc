class APKillGameQueryClient extends KillGameQueryClient;

var SlotWindow SlotWindow;

function YesPressed () {
	if (SlotWindow != None) {
		SlotWindow.Saves[SlotIndex] = "";
		SlotWindow.SaveConfig();
		SlotWindow.SlotButton[SlotIndex].Text = class'APSlotWindow'.Default.EmptyText;
		class'APManagerWindow'.Default.DOMDoorOpen[SlotIndex] = 0;
		class'APManagerWindow'.Default.CTFDoorOpen[SlotIndex] = 0;
		class'APManagerWindow'.Default.ASDoorOpen[SlotIndex] = 0;
		class'APManagerWindow'.Default.ChalDoorOpen[SlotIndex] = 0;
		class'APManagerWindow'.Default.TrophyDoorOpen[SlotIndex] = 0;
		class'APManagerWindow'.StaticSaveConfig();
	}
	Close();
}

defaultproperties {
	QueryText="Are you sure you want to delete this session?"
	YesText="Yes."
	NoText="No."
}