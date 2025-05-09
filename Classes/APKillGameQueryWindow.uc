class APKillGameQueryWindow extends KillGameQueryWindow;

function BeginPlay () {
	ClientClass = Class'APKillGameQueryClient';
}

defaultproperties {
	WindowTitle="Delete saved game?"
}