class XWeaponAddEditorSaver extends BrushBuilder;

var() string ProfileName;

event bool Build()
{
    SaveWeapons();
    return false;
}

function SaveWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local class<PickupFactory> WeaponFactoryClass;

	if (!class'XWeaponAddLocationInfo'.static.Create(LocInfo, ProfileName))
	{
		BadParameters("Unable to create WeaponFactory profile.");
		return;
	}

	WeaponFactoryClass = class'XWeaponAddMutator'.default.WeaponFactoryClass;

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
