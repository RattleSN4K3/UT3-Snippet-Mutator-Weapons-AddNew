class XWeaponAddEditorLoader extends BrushBuilder;

// with parenthesis, the field is shown in the dialog
var() string ProfileName;

// Build is called once the user clicks on the button 
// or chooses "Build" in the advanced menu
event bool Build()
{
    LoadWeapons();
    return false;
}

function LoadWeapons()
{
	local XWeaponAddLocationInfo LocInfo;

	// ensure a profile exists
	if (!class'XWeaponAddLocationInfo'.static.Exists(LocInfo, ProfileName))
	{
		BadParameters("No stored profile for this map.");
		return;
	}

	// restores and automatically create factories in the editor instance
	LocInfo.RestoreFactories();
}

DefaultProperties
{
	// not button icon for now
    //BitmapFilename="UnrealExTunnel" // Binaries\EditorRes\Cancel.png

    ToolTip="XMutatorWeaponAdd Loader"
}
