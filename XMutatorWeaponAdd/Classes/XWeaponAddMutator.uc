/**
 * Mutator to initialize the map profile containing the locations 
 * for the new weapon factories
 */

class XWeaponAddMutator extends UTMutator;

var class<PickupFactory> WeaponFactoryClass;

function PostBeginPlay()
{
    super.PostBeginPlay();
	LoadWeapons();
}

function LoadWeapons(optional string ProfileName = "")
{
	local XWeaponAddLocationInfo LocInfo;
	if (class'XWeaponAddLocationInfo'.static.Exists(LocInfo, ProfileName))
	{
		LocInfo.RestoreFactories(WeaponFactoryClass);
	}
}

Defaultproperties
{
	WeaponFactoryClass=class'XWeaponAddFactory'
}