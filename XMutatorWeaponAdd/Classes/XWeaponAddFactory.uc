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
}
