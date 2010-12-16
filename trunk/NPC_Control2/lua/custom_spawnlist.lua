//How to use:
//Using the functions described below, you can add NPCs and Actors to the spawnlists (also, weapons)

//Function: npc_AddSpawn( Name, Class )
//Adds an npc class to the NPC spawnlist

//Function: npc_AddNPC( Class, KeyValues )
//OPTIONAL: Used to set custom data for NPCs that spawn with that class (IE. spawnflags, and Hammer described values)

//Function: npc_AddActor( Model )
//Used to add an Actor to the spawnlist

//Function: npc_AddWeapon( Name, Weapon )
//Used to add a weapon to the spawnlist (Don't use weapon_!)

// npc_AddAnimation( Name, Sequence, Group )
// Used to add a custom animation to the animation list

//Custom KeyValues (Not used in-game, but used by the STool)
//noprefix: Should npc_ be infront of the name? (Def. False)
//class: What's the NPC's REAL class? (Used if you have a custom spawnclass for the NPC, like Combine Mine's and Friendly Combine Mines)
//All other values will be sent into the NPCs KeyValues

//Examples:
// npc_AddNPC( "friendlymine", { spawnflags = "0", Modification = "1", noprefix = true, class = "combine_mine" } )
// npc_AddSpawn("Friendly Mine", "friendlymine")

// npc_AddNPC( "antlionworker", { spawnflags = "262144", class = "antlion" } )
// npc_AddSpawn( "Antlion Worker", "antlionworker" )

//npc_AddAnimation( "LOL, IDLE?", "Idle01", "MAH ANIMATIONS" )