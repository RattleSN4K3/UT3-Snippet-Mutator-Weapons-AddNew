/**
 * Basic profile class for storing weapon factory related properties for
 * spawning these on runtime.
 */

class XWeaponAddLocationInfo extends Object
	config(XMutatorWeaponAdd_LocInfo)
	PerObjectConfig;

struct FactoryLocationInfo
{
	// not required. just for convenience
	var name Name;
	
	var Vector Location;
	var Rotator Rotation;
	var float Scale;
	var Vector Scale3D;
};

var config string MapName;
var config array<FactoryLocationInfo> Factories;

//**********************************************************************************
// Static funtions
//**********************************************************************************

static function bool Create(out XWeaponAddLocationInfo OutInfo, optional string InMapName = "")
{
	local string ObjectName;

	// only check for existing map if a custom name is not present
	// (when the user doesn't want a custom name)
	if (InMapName == "")
	{
		ObjectName = GetMapName();
		if (!class'WorldInfo'.static.MapExists(ObjectName))
		{
			return false;
		}
	}
	else
	{
		ObjectName = InMapName;
	}

	LogInternal("Mapname:"@ObjectName);
	OutInfo = NewClass(ObjectName);
	if (OutInfo != none)
	{
		OutInfo.Init(ObjectName);
		return true;
	}

	return false;
}

static function bool Exists(optional out XWeaponAddLocationInfo OutInfo, optional string InMapName = "")
{
	local string TempMapName;

	TempMapName = InMapName != "" ? InMapName : GetMapName();
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
	local int i;
	if (Factory == none)
		return;

	i = Factories.Length;
	Factories.Add(1);

	Factories[i].Name = Factory.Name;
	Factories[i].Location = Factory.Location;
	Factories[i].Rotation = Factory.Rotation;
	Factories[i].Scale = Factory.DrawScale;
	Factories[i].Scale3D = Factory.DrawScale3D;
}

function RestoreFactories(class<PickupFactory> FacClass)
{
	local int i;
	local WorldInfo WorldInfo;
	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();

	for (i=0; i<Factories.Length; i++)
	{
		RestoreFactory(WorldInfo, FacClass, Factories[i]);
	}
}

function bool RestoreFactory(WorldInfo WorldInfo, class<PickupFactory> FacClass, FactoryLocationInfo FacInfo)
{
	local PickupFactory Fac;
	if (WorldInfo != none && FacClass != none)
	{
		Fac = WorldInfo.Spawn(FacClass, none,, FacInfo.Location, FacInfo.Rotation);
		if (Fac != none)
		{
			if (FacInfo.Scale != 0.0) Fac.SetDrawScale(FacInfo.Scale);
			if (!IsZero(FacInfo.Scale3D)) Fac.SetDrawScale3D(FacInfo.Scale3D);
			return true;
		}
	}

	return false;
}

function int FactoryCount()
{
	return Factories.Length;
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
	local int i, j;

	// removing invalid entries
	for (i=Factories.Length-1; i>=0; i--)
	{
		if (IsZero(Factories[i].Location) && Factories[i].Name == '')
		{
			Factories.Remove(i, 1);
		}
	}

	// removing double entries
	for (i=Factories.Length-1; i>=0; i--)
	{
		for (j=0; j<i; j++)
		{
			if (Factories[j] == Factories[i])
			{
				Factories.Remove(i, 1);
			}
		}
	}

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
