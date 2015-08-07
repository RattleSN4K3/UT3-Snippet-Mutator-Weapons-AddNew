class XWeaponAddEditorSaver extends BrushBuilder;

event bool Build()
{
    SaveWeapons();
    return false;
}

function SaveWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local class<PickupFactory> WeaponFactoryClass;

	if (!class'XWeaponAddLocationInfo'.static.Create(LocInfo))
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

	GroupName=Example
    ToolTip="XMutatorWeaponAdd Saver"
}
