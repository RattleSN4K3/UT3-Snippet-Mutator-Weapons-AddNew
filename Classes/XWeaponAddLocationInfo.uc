/**
 * Basic profile class for storing weapon factory related properties for
 * spawning these on runtime.
 */

class XWeaponAddLocationInfo extends Object
	config(XMutatorWeaponAdd_LocInfo)
	PerObjectConfig;

struct FactoryLocationInfo
{
	var Vector Location;
	var Rotator Rotation;
	var float Scale;
	var Vector Scale3D;
};

var config string MapName;
var config array<Vector> FactoryLocations;

//**********************************************************************************
// Static funtions
//**********************************************************************************

static function bool Create(out XWeaponAddLocationInfo OutInfo, optional string InMapName = "")
{
	local string ObjectName;

	ObjectName = InMapName != "" ? InMapName : GetMapName();
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
// Public funtions
//**********************************************************************************

function StoreFactories(class<PickupFactory> FacClass)
{
	local Actor Factory;
	local WorldInfo WorldInfo;

	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();
	`Log(name$"::StoreFactories",,'XMutatorWeaponAdd');
	foreach WorldInfo.DynamicActors(FacClass, Factory)
	{
		`Log(name$"::StoreFactories - Storing factory"@Factory,,'XMutatorWeaponAdd');
		StoreFactory(PickupFactory(Factory));
	}
}

function StoreFactory(PickupFactory Factory)
{
	if (Factory == none)
		return;

	FactoryLocations.AddItem(Factory.Location);
}

function RestoreFactories(class<PickupFactory> FacClass)
{
	local int i;
	local WorldInfo WorldInfo;
	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();

	for (i=0; i<FactoryLocations.Length; i++)
	{
		RestoreFactory_Temp(WorldInfo, FacClass, FactoryLocations[i]);
	}
}

function bool RestoreFactory_Temp(WorldInfo WorldInfo, class<PickupFactory> FacClass, Vector InLocation)
{
	local FactoryLocationInfo FacInfo;
	FacInfo.Location = InLocation;
	return RestoreFactory(WorldInfo, FacClass, FacInfo);
}

function bool RestoreFactory(WorldInfo WorldInfo, class<PickupFactory> FacClass, FactoryLocationInfo FacInfo)
{
	local PickupFactory Fac;
	if (WorldInfo != none && FacClass != none)
	{
		Fac = WorldInfo.Spawn(FacClass, none,, FacInfo.Location, FacInfo.Rotation);
		if (Fac != none)
		{
			if (FacInfo.Scale > 0) Fac.SetDrawScale(FacInfo.Scale);
			if (!IsZero(FacInfo.Scale3D)) Fac.SetDrawScale3D(FacInfo.Scale3D);
			return true;
		}
	}

	return false;
}

function int FactoryCount()
{
	return FactoryLocations.Length;
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
