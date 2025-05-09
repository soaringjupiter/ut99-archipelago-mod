class APModMenuItem extends UMenuModMenuItem  // or UMenuModMenuItem, depending on your UT99 build
    config(APLadder);  // optional, if you have a custom config section

// Called when the user clicks our menu entry
function Execute()
{
    MenuItem.Owner.Root.CreateWindow(class'APMenuFramedWindow',100, 100, 200, 200);
}

defaultproperties
{
     MenuCaption="&Start Archipelago"
     MenuHelp="Start Archipelago Game"
}
