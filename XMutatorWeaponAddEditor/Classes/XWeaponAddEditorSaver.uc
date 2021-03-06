class XWeaponAddEditorSaver extends BrushBuilder;

// with parenthesis, the field is shown in the dialog
var() string ProfileName;

// Build is called once the user clicks on the button 
// or chooses "Build" in the advanced menu
event bool Build()
{
    SaveWeapons();
    return false;
}

function SaveWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local class<PickupFactory> WeaponFactoryClass;

	// don't save any data for invalid maps (when no map is loaded for instance)
	if (!class'XWeaponAddLocationInfo'.static.Create(LocInfo, ProfileName))
	{
		BadParameters("Unable to create WeaponFactory profile.");
		return;
	}

	// retrieve the specific factory class from the mutator properties
	WeaponFactoryClass = class'XWeaponAddMutator'.default.WeaponFactoryClass;

	// clear old data, store new data and save it
	LocInfo.ClearConfig();
	LocInfo.StoreFactories(WeaponFactoryClass);
	LocInfo.SaveConfig();
}

DefaultProperties
{
	// not button icon for now
    //BitmapFilename="UnrealExTunnel" // Binaries\EditorRes\Cancel.png

    ToolTip="XMutatorWeaponAdd Saver"
}
