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
			LocInfo.RestoreFactory_Temp(WorldInfo, WeaponFactoryClass, LocInfo.FactoryLocations[i]);
		}
	}
}

Defaultproperties
{
	WeaponFactoryClass=class'XWeaponAddFactory'
}