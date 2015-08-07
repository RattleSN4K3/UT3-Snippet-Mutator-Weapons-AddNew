/**
 * A editor mutator to be placed into a map in the Editor. Won't work otherwise.
 * By placing the actor into a map and run PIE, the custom weapon factories will
 * be saved into a map profile of the currently running instance.
 */
class XWeaponAddEditorMutator extends XWeaponAddMutator
	HideCategories(Mutator, Advanced, Attachment, Debug, Physics)
	hidedropdown
	placeable;

var private bool bPreInitialized;

//**********************************************************************************
// Inherited funtions
//**********************************************************************************

function PreBeginPlay()
{
	local string Error;

	// don't allow having this mutator enabled for any other instance than PIE
	if (!WorldInfo.IsPlayInEditor())
	{
		Destroy();
		return;
	}

	// just a requirement for an embedded mutator
	if (!bPreInitialized )
	{
		bPreInitialized = true;

		NextMutator = WorldInfo.Game.BaseMutator; 

		WorldInfo.Game.BaseMutator = self;
		InitMutator(WorldInfo.Game.ServerOptions,Error);
	}

	super.PreBeginPlay();
}

function AddMutator(Mutator M)
{
	// skip calling AddMutator twice
	if (M == self) {
		return;
	}

	super.AddMutator(M);
}

// called when gameplay actually starts
function MatchStarting()
{
	super.MatchStarting();

	`Log(name$"::MatchStarting - Call saving factories",,'XMutatorWeaponAdd');
	SaveWeapons();
}

//**********************************************************************************
// Private funtions
//**********************************************************************************

// skip loading for editor mode for now
function LoadWeapons();

function SaveWeapons()
{
	local string MapName;
	local XWeaponAddLocationInfo LocInfo;

	MapName = GetMapName();
	`Log(name$"::PostBeginPlay - Map:"@MapName,,'XMutatorWeaponAdd');

	if (!class'XWeaponAddLocationInfo'.static.Create(LocInfo, MapName))
	{
		WorldInfo.Game.Broadcast(none, "Unable to create WeaponFactory profile.");
		return;
	}

	// clear old data
	LocInfo.ClearConfig();
	LocInfo.StoreFactories(WeaponFactoryClass);

	LocInfo.SaveConfig();
	WorldInfo.Game.Broadcast(none, "WeaponFactory data saved ("$LocInfo.FactoryCount()$" factories).");
}

function string GetMapName()
{
	local string MapName;

	MapName = WorldInfo.GetMapName(true);

	// strip the UEDPIE_ from the filename, if it exists (meaning this is a Play in Editor game)
	if (Left(MapName, 7) ~= "UEDPIE_")
	{
		MapName = Right(MapName, Len(MapName) - 7);
	}
	else if (Left(MapName, 10) ~= "UEDPOC_PS3")
	{
		MapName = Right(MapName, Len(MapName) - 10);
	}
	else if (Left(MapName, 12) ~= "UEDPOC_Xenon")
	{
		MapName = Right(MapName, Len(MapName) - 12);
	}

	return MapName;
}

DefaultProperties
{
	bExportMenuData=false
}