class XWeaponAddEditorLoader extends BrushBuilder;

event bool Build()
{
    LoadWeapons();
    return false;
}

function LoadWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local class<PickupFactory> WeaponFactoryClass;

	if (!class'XWeaponAddLocationInfo'.static.Exists(LocInfo))
	{
		BadParameters("No stored profile for this map.");
		return;
	}

	WeaponFactoryClass = class'XWeaponAddMutator'.default.WeaponFactoryClass;
	LocInfo.RestoreFactories(WeaponFactoryClass);
}

DefaultProperties
{
	// not button icon for now
    //BitmapFilename="UnrealExTunnel" // Binaries\EditorRes\Cancel.png

	GroupName=Example
    ToolTip="XMutatorWeaponAdd Loader"
}
