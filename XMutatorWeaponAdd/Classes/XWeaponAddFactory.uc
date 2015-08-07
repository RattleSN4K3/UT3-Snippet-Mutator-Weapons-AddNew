/** 
 * Basic weapon factory to spawn in the level on runtime
 */

class XWeaponAddFactory extends UTWeaponPickupFactory;

DefaultProperties
{
	// allow dynamic spawn
    bStatic=false
    bNoDelete=false

    WeaponPickupClass=class'UTWeap_ShockRifle'

	// replicate initial rotation
	bNetInitialRotation=true
	bNeverReplicateRotation=false // just set is for safety

	// replicate all other props (not only the 'hidden' flag)
	bOnlyReplicateHidden=false
}
