class XWeaponAddEditorLoader extends BrushBuilder;

event bool Build()
{
    LoadWeapons();
    return false;
}

function LoadWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local int i;
	local WorldInfo WI;
	local class<PickupFactory> WeaponFactoryClass;

	if (!class'XWeaponAddLocationInfo'.static.Exists(LocInfo))
	{
		BadParameters("No stored profile for this map.");
		return;
	}

	WI = class'Engine'.static.GetCurrentWorldInfo();
	WeaponFactoryClass = class'XWeaponAddMutator'.default.WeaponFactoryClass;
	for (i=0; i<LocInfo.FactoryLocations.Length; i++)
	{
		LocInfo.RestoreFactory_Temp(WI, WeaponFactoryClass, LocInfo.FactoryLocations[i]);
	}
}

DefaultProperties
{
	// not button icon for now
    //BitmapFilename="UnrealExTunnel" // Binaries\EditorRes\Cancel.png

	GroupName=Example
    ToolTip="XMutatorWeaponAdd Loader"
}
