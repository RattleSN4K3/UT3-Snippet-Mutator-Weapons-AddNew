/** 
 * Basic weapon factory to spawn in the level on runtime
 */
class XWeaponAddFactory extends UTWeaponPickupFactory
	abstract;

// We only want to change basic properties to allow runtime spawning
// and additional support for multipler. Special replication is set
// to support scaling, rotation and mirroring. Factory are replicated fine
DefaultProperties
{
	// allow dynamic spawn
    bStatic=false
    bNoDelete=false

	// allow basing on moveable actors (such as lifts)
	bMovable=true

	// replicate initial rotation
	bNetInitialRotation=true
	bNeverReplicateRotation=false // just set is for safety

	// replicate all other props (not only the 'hidden' flag)
	bOnlyReplicateHidden=false
}
