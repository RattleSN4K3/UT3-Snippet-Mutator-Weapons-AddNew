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
	if (class'XWeaponAddLocationInfo'.static.Exists(LocInfo))
	{
		LocInfo.RestoreFactories(WeaponFactoryClass);
	}
}

Defaultproperties
{
	WeaponFactoryClass=class'XWeaponAddFactory'
}