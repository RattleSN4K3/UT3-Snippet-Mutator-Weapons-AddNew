/**
 * Basic profile class for storing weapon factory related properties for
 * spawning these on runtime.
 */

class XWeaponAddLocationInfo extends Object
	config(XMutatorWeaponAdd_LocInfo)
	PerObjectConfig;

var config string MapName;
var config array<Vector> FactoryLocations;

//**********************************************************************************
// Static funtions
//**********************************************************************************

static function bool Create(out XWeaponAddLocationInfo OutInfo)
{
	local string ObjectName;

	ObjectName = GetMapName();
	OutInfo = NewClass(ObjectName);
	if (OutInfo != none)
	{
		OutInfo.Init(ObjectName);
		return true;
	}

	return false;
}

static function bool Exists(optional out XWeaponAddLocationInfo OutInfo)
{
	local string TempMapName;

	TempMapName = GetMapName();
	OutInfo = NewClass(TempMapName);
	return OutInfo != none && OutInfo.MapName ~= TempMapName && OutInfo.Validate();
}

//**********************************************************************************
// Private funtions
//**********************************************************************************

private function Init(string InMapName)
{
	MapName = InMapName;
}

private function bool Validate()
{
	local Vector EmptyVector;
	FactoryLocations.RemoveItem(EmptyVector);
	return true;
}

//**********************************************************************************
// Private static funtions
//**********************************************************************************

private static function XWeaponAddLocationInfo NewClass(string InMapName)
{
	local XWeaponAddLocationInfo Obj;
	Obj = new(GetPackage(), InMapName) default.Class;
	return Obj;
}

private static function Package GetPackage()
{
	local Object TempObj;
	local string Pack;
	Pack = ""$default.Class.GetPackageName();
	TempObj = new(default.Class.Outer, Pack) Class'Package';
	return Package(TempObj);
}

private static function string GetMapName()
{
	local WorldInfo WorldInfo;
	local string MapName;
	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();
	if (WorldInfo != none)
	{
		MapName = WorldInfo.GetMapName(true);
	}

	return MapName;
}

DefaultProperties
{
}
