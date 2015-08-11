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
	
	var class<Inventory> InventoryClass;

	var Vector Location;
	var Rotator Rotation;
	var float Scale;
	var Vector Scale3D;

	var string Base;
};

// Config properties stored in the config file (not the one specified in the class specifier)

/** MapName this profile was created for. This field is used to check for a created class */
var config string MapName;
/** Array of all factory to be placed in a level */
var config array<FactoryLocationInfo> Factories;

//**********************************************************************************
// Static funtions
//**********************************************************************************

/**
 * Static public method to create a profile for a given map name
 * @param OutInfo (Out) the created profile. Can be empty
 * @param InMapName an optional string for a custom overridden map name. If not present the current map will be used
 * @return true if a profile was successfully created and OutInfo is a valid object
 */
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

	// creating class with the current map name
	OutInfo = NewClass(ObjectName);
	if (OutInfo != none)
	{
		// init basic props
		OutInfo.Init(ObjectName);
		return true;
	}

	return false;
}

/** Check if a profile exists */
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

function StoreFactories(class<PickupFactory> FacClass, optional bool bUpdate = false)
{
	local Actor Factory;
	local WorldInfo WorldInfo;

	// clear old data
	Factories.Length = 0;

	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();
	`Log(name$"::StoreFactories",,'XMutatorWeaponAdd');
	foreach WorldInfo.DynamicActors(FacClass, Factory)
	{
		`Log(name$"::StoreFactories - Storing factory"@Factory,,'XMutatorWeaponAdd');
		StoreFactory(PickupFactory(Factory));

		// update pickup mesh
		if (bUpdate)
		{
			PickupFactory(Factory).InitializePickup();
		}
	}
}

function StoreFactory(PickupFactory Factory)
{
	local int i;
	if (Factory == none)
		return;

	// store current count, increase array size
	i = Factories.Length;
	Factories.Add(1);

	// store props in the last item of the array (which we created before)
	Factories[i].Name = Factory.Name;
	Factories[i].Location = Factory.Location;
	Factories[i].Rotation = Factory.Rotation;
	Factories[i].Scale = Factory.DrawScale;
	Factories[i].Scale3D = Factory.DrawScale3D;

	// store the inventory type. use weaponclass if a weapon pickup factory
	Factories[i].InventoryClass = UTWeaponPickupFactory(Factory) != none ? UTWeaponPickupFactory(Factory).WeaponPickupClass : Factory.InventoryType;

	// if base is set, store the fully qualified path (cannot store references in config)
	if (Factory.Base != none)
	{
		Factories[i].Base = PathName(Factory.Base);
	}
}

function RestoreFactories(class<PickupFactory> FacClass)
{
	local int i;
	local WorldInfo WorldInfo;
	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();

	// restore each stored weapon factory info
	for (i=0; i<Factories.Length; i++)
	{
		RestoreFactory(WorldInfo, FacClass, Factories[i]);
	}
}

function bool RestoreFactory(WorldInfo WorldInfo, class<PickupFactory> FacClass, FactoryLocationInfo FacInfo)
{
	local Actor Other;
	local PickupFactory Fac;
	local Object Obj;
	if (WorldInfo != none && FacClass != none)
	{
		// prevent adding the same factory twice
		foreach WorldInfo.AllActors(FacClass, Other)
		{
			if (Other.Class == FacClass)
			{
				if (VSize(Other.Location-FacInfo.Location) == 0.0)
				{
					return false;
				}
			}
		}

		Fac = WorldInfo.Spawn(FacClass, none,, FacInfo.Location, FacInfo.Rotation);
		if (Fac != none)
		{
			// only apply scale if stored values are valid
			if (FacInfo.Scale != 0.0) Fac.SetDrawScale(FacInfo.Scale);
			if (!IsZero(FacInfo.Scale3D)) Fac.SetDrawScale3D(FacInfo.Scale3D);

			// apply custom weapon class if present
			if (FacInfo.InventoryClass != none)
			{
				if (UTWeaponPickupFactory(Fac) != none && class<UTWeapon>(FacInfo.InventoryClass) != none)
				{
					UTWeaponPickupFactory(Fac).WeaponPickupClass = class<UTWeapon>(FacInfo.InventoryClass);
				}
				else
				{
					Fac.InventoryType = FacInfo.InventoryClass;
				}
				Fac.InitializePickup(); 
			}

			// if base was stored...
			if (name(FacInfo.Base) != '')
			{
				// ... try to find the actor/object in the current level by its fully qualified name
				Obj = FindObject(FacInfo.Base, class'Actor');

				// just apply the base and hard attach the factory to the ground (support for moving platforms etc.)
				Fac.SetBase(Actor(Obj));
				Fac.SetHardAttach(true);
			}

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
	// comparing each item with every other item in the array...
	for (i=Factories.Length-1; i>=0; i--)
	{
		// ... starting with the end and check every item before this one
		for (j=0; j<i; j++)
		{
			if (Factories[j] == Factories[i])
			{
				// remove duplicate
				Factories.Remove(i, 1);
			}
		}
	}

	return true;
}

//**********************************************************************************
// Private static funtions
//**********************************************************************************

/**
 * Creating a new class with the given name. Typically this would be the original
 * map name which then can be loaded for each specific map.
 * @param InMapName the name to create a class/config section for
 */
private static function XWeaponAddLocationInfo NewClass(string InMapName)
{
	local XWeaponAddLocationInfo Obj;

	// creating this class with the outer as the current package.
	// this will force the config file being creating in a config file
	// with the same name as the package (typcailly UTPackageName.ini)
	Obj = new(GetPackage(), InMapName) default.Class;
	return Obj;
}

/**
 * Retrieves the current package where this script file is located in.
 * @return a package object
 */
private static function Package GetPackage()
{
	local Object TempObj;
	local string Pack;
	Pack = ""$default.Class.GetPackageName();
	TempObj = new(default.Class.Outer, Pack) Class'Package';
	return Package(TempObj);
}

/**
 * Get the current running map name (including the prefix)
 * @return returns an emptry string if a WorldInfo cannot be found
 */
private static function string GetMapName()
{
	local WorldInfo WorldInfo;
	local string TeampMapName;
	WorldInfo = class'Engine'.static.GetCurrentWorldInfo();
	if (WorldInfo != none)
	{
		TeampMapName = WorldInfo.GetMapName(true);
	}

	return TeampMapName;
}

DefaultProperties
{
}
