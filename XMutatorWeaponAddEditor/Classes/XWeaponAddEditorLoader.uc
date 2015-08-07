class XWeaponAddEditorLoader extends BrushBuilder;

var() string CustomMapName;

event bool Build()
{
    LoadWeapons();
    return false;
}

function LoadWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local class<PickupFactory> WeaponFactoryClass;

	if (!class'XWeaponAddLocationInfo'.static.Exists(LocInfo, CustomMapName))
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
