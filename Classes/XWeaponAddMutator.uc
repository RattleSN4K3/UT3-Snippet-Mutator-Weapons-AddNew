/**
 * Mutator to initialize the map profile containing the locations 
 * for the new weapon factories
 */

class XWeaponAddMutator extends UTMutator
	config(XMutatorWeaponAdd);

var array<Vector> WeaponLocations;
var class<PickupFactory> WeaponFactoryClass;

function PostBeginPlay()
{
    super.PostBeginPlay();

	LoadWeapons();
}

function LoadWeapons()
{
	local XWeaponAddLocationInfo LocInfo;
	local int i;

	if (class'XWeaponAddLocationInfo'.static.Exists(LocInfo))
	{
		for (i=0; i<LocInfo.FactoryLocations.Length; i++)
		{
			SpawnFactory(LocInfo.FactoryLocations[i]);
		}
	}
}

function SpawnFactory(vector InLocation)
{
	Spawn(WeaponFactoryClass, none,, InLocation);
}

Defaultproperties
{
	WeaponFactoryClass=class'XWeaponAddFactory'
}