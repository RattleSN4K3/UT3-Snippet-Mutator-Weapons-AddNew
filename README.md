XMutatorWeaponAdd
-----------------
Adding weapons to maps by config profile

Test mutator for adding a specified weapon pickup factory with its specific weapon to maps whose profile is stored in the config file. This basic code can be used to create a mutator which adds a weapon to any map you create a profile for. Such profile can be created with the editor itself by opening the maps and placing the custom factory to your maps. Within the editor, you are able to load and save the setup for the opened map.

# Compiling

The mutator comes with all the needed files. Before the code can be compiled, the engine must be aware of the installed source files and the source files must be placed into the correct folder.

## Setup

For referencing purpose, `%basedir%` would be the local profile folder `%userprofile%\Documents\My Games\Unreal Tournament 3\UTGame`

- Download the [latest source files](/../../archive/master.zip)
- Extract the zipped source files
- Copy/symlink the **`XMutatorWeaponAdd`** folder of the source files into `%basedir%\Src`
- Copy/symlink the **`XMutatorWeaponAddEditor`** folder of the source files into `%basedir%\Src`
- Copy/symlink `XMutatorWeaponAdd\Config\UTXMutatorWeaponAdd.ini` to `%basedir%\Src\Config`

And finally add the packages to the compiling packages of the engine.

- Open `%basedir%\Config\UTEditor.ini`
- Search for the section `[ModPackages]`
- Add **`ModPackages=XMutatorWeaponAdd`** and **`ModPackages=XMutatorWeaponAddEditor`** at the end of the section (before the next section starts)  
```
ModPackages=XMutatorWeaponAdd
ModPackages=XMutatorWeaponAddEditor
```

## Make

Compile the packages with:  
```
ut3 make -final_release
```

The `final_release` switch will strip the log entries from the code.

## Testing

Copy/move `%basedir%\Unpublished\CookedPC\Script\XMutatorWeaponAdd.u` and `%basedir%\Unpublished\CookedPC\Script\XMutatorWeaponAddEditor.u` to the public script folder `%basedir%\Published\CookedPC\Script\` and run the game.

Without copying/moving the file, the game must be started with the *UseUnpublished* command line argument:
```
ut3 -useunpublished
```

# Creating map profile

You can create a map profile in two ways. Each would require some setup. The usage is different in both ways. One would be integrated into the editor UI and the other method needs to load the mutator in the Play-In-Editor session (PIE).

## Play-In-Editor

- Open the editor
- Open the _Generic browser_ and switch to the `Actor classes` tab
- Open the package **XMutatorWeaponAddEditor** with _File_>_Open_
- Place `XWeaponAddFactory` at any locations you like  
  `Actor` > `NavigationPoint` > `PickupFactory` > `UTPickupFactory` > `UTWeaponPickupFactory` > `XWeaponAddFactory`
- Open the properties window _Actor Properties_ of that placed weapon factory (Hotkey: F4) and choose a weapon pickup type with **WeaponPickupClass** under the section named `XWeaponAddFactory`
-  Place `XWeaponAddMutator` in the the level  
  `Actor` > `Info` > `Mutator` > `UTMutator` > `XWeaponAddMutator` > `XWeaponAddMutatorEditor`  

  or open [PASTE.txt](PASTE.txt), copy the content and paste it into a viewport in the editor. This will place a mutator actor into the world
- Start the level in PIE mode (_Build_>_Play Level_ or right-click `Play From Here`)
- A map profile is automatically saved

You can also use the console command `mutate SaveWeapons` in the PIE session to save the map profile. This requires to have the mutator activated (placed in the level). You can append a map name to the command to save the map profile data to a different map profile with a custom name.

```
mutate SaveWeapons CustomProfileName
```

## UI

If you compiled the source code, you can skip this step of adding the package to the _startup packages_ as you already have it specified as _ModPackage_. Otherwise:
- Open the Config\\UTEngine.ini
- Search for the section `[Engine.StartupPackages]`
- Add **`Package=XMutatorWeaponAddEditor`** after the section header

This step is required to load the package at the startup of the editor which results into the _builder buttons_ being initialized. **Note**: To not conflict any cooking process, keep in mind to remove the startup package once you're done working with it.

You can continue using the mutator.

- Open a map in the editor
- Place `XWeaponAddFactory` at any locations you like  
  `Actor` > `NavigationPoint` > `PickupFactory` > `UTPickupFactory` > `UTWeaponPickupFactory` > `XWeaponAddFactory`
- Open the properties window _Actor Properties_ of that placed weapon factory (Hotkey: F4) and choose a weapon pickup type with **WeaponPickupClass** under the section named `XWeaponAddFactory`
- Use the **_XMutatorWeaponAdd Saver_** button at the left toolbar to save locations into a map profile of the currently opened map
- If you need to edit the locations, you can use the **_XMutatorWeaponAdd Loader_** button to load the locations from the map profile of the current map

As a note, you can use the advanced menu for each button (rightclick on the button) where you are able to save the profile under a different name. Keep in mind, the mutator in the game only loads the map profile with the exact given name.

A map profile is stored in the config file `UTXMutatorWeaponAdd.ini`. Such profile would look like this:
```
[DM-Deck XWeaponAddLocationInfo]
MapName=DM-Deck
Factories=(Name="XWeaponAddFactory_0",Location=(X=1079.000000,Y=1963.000000,Z=-624.000000))
Factories=(Name="XWeaponAddFactory_1",Location=(X=1963.000000,Y=2163.000000,Z=-623.000000))
Factories=(Name="XWeaponAddFactory_2",Location=(X=-34.000000,Y=2192.000000,Z=-624.000000))
```

If such map profile exists and the mutator will be activated, the weapon pickup factories are loaded and created at the configured locations.


# License
Available under [the MIT license](http://opensource.org/licenses/mit-license.php).

# Author
RattleSN4K3
