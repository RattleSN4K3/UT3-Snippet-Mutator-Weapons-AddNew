/**
 * Mutator to initialize the map profile containing the locations 
 * for the new weapon factories
 */

class XWeaponAddMutator extends UTMutator;

function PostBeginPlay()
{
	// once this mutator gets loaded, it will initialize loading the weapons

    super.PostBeginPlay();
	LoadWeapons();
}

function LoadWeapons(optional string ProfileName = "")
{
	local XWeaponAddLocationInfo LocInfo;
	// "Exists" automatically checks for a valid profile and returns that one in LocInfo
	if (class'XWeaponAddLocationInfo'.static.Exists(LocInfo, ProfileName))
	{
		// ... we enforce to restores factories with our custom factory
		LocInfo.RestoreFactories();
	}
}

Defaultproperties
{
}