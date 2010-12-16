//Do not edit, please.
//See "custom_spawnlist.lua" for adding npcs and ect.
//NPC Spawn Data

local ep2content = CreateClientConVar("npc_ep2content", "1", true, false):GetBool()

MsgAll("-NPC Control-\n")
NPCSpawnList = {}
ActorAnims = {}
NPCWepList = {}
NPCSpawnData = {}
NPCSpawnData["Base"] = { spawnflags = "516" } //For the generic NPC, applied to all spawned NPCs

function npc_AddNPC( npcclass, npcdata )
   if (NPCSpawnData[npcclass] == nil) then
      NPCSpawnData[npcclass] = npcdata
   else
      MsgAll("Error: Tried to add npc class '" .. npcclass .. "' to the spawnlist, but it already exists!")
   end
end

function npc_AddSpawn( name, class ) //Used to add an NPC to the spawn menu
   if (NPCSpawnList[name] == nil) then
      NPCSpawnList[name] = class
   else
      MsgAll("Error: Tried to add npc '" .. name .. "' to the spawnlist, but it already exists!")
   end
end

function npc_AddActor( model ) //Used to add an Actor to the spawn menu
   list.Set( "ActorsSpawn", model, {} )
end

function npc_AddWeapon( name, convar )
   NPCWepList[name] = convar
end

function npc_AddAnimation( name, durseq, postseq, grp )
   if (ActorAnims[grp] == nil) then ActorAnims[grp] = {} end
   if (ActorAnims[grp][name] == nil) then
      ActorAnims[grp][name] = { seq = durseq, post = postseq }
   else
      MsgAll("Error: Tried to add animation '" .. name .. "', but it's already in that group!")
   end
end

include("custom_spawnlist.lua") //Load custom weapons, actors, and NPCs

//Humans/Resistance
npc_AddNPC( "refugee", { expressiontype = "2", spawnflags = "262660", citizentype = "2", class = "citizen" } )
npc_AddNPC( "rebel", { expressiontype = "2", spawnflags = "262660", citizentype = "3", class = "citizen" } )
npc_AddNPC( "citizen", { expressiontype = "2", spawnflags = "262660", citizentype = "0" } )
npc_AddSpawn("G-Man", "gman")
npc_AddSpawn("Mr. Breen", "breen")
npc_AddSpawn("Dr. Kleiner", "kleiner")
npc_AddSpawn("Father Grigori", "monk")
npc_AddSpawn("Dr. Mossman", "mossman")
npc_AddSpawn("Alyx", "alyx")
npc_AddSpawn("Vortigaunt", "vortigaunt")
npc_AddSpawn("Barney", "barney")
npc_AddSpawn("Citizen", "citizen")
npc_AddSpawn("Rebel", "rebel")
npc_AddSpawn("Refugee", "refugee")
npc_AddSpawn("DOG", "dog")
npc_AddSpawn("Eli Vance", "eli")

//Combine
npc_AddNPC( "combine_s", { model = "models/combine_soldier.mdl" } ) //Combine soldier
npc_AddNPC( "combine_e", { model = "models/combine_super_soldier.mdl", class = "combine_s" } ) //Combine Elite soldier
npc_AddNPC( "combine_p", { model = "models/combine_soldier_prisonguard.mdl", class = "combine_s" } ) //Combine Prison-Guard
npc_AddNPC( "metropolice", { weapondrawn = "1" } )
npc_AddNPC( "turret_floor", { spawnflags = "32" } )
npc_AddNPC( "combine_mine", { spawnflags = "0", noprefix = true } )
npc_AddSpawn( "Manhack", "manhack" )
npc_AddSpawn( "Metro Cop", "metropolice" )
npc_AddSpawn( "Rollermine", "rollermine" )
npc_AddSpawn( "Combine Soldier", "combine_s" )
npc_AddSpawn( "Combine Elite Soldier", "combine_e" )
npc_AddSpawn( "Combine Prison-Guard", "combine_p" )
npc_AddSpawn( "Stalker", "stalker" )
npc_AddSpawn( "Turret", "turret_floor" )
npc_AddSpawn( "Combine Mine", "combine_mine" )

//Zombies and Antlions
npc_AddSpawn( "Antlion", "antlion" )
npc_AddSpawn( "Antlion Guard", "antlionguard" )
npc_AddSpawn( "Zombie", "zombie" )
npc_AddSpawn( "Zombie Torso", "zombie_torso" )
npc_AddSpawn( "Fast Zombie", "fastzombie" )
npc_AddSpawn( "Fast Zombie Torso", "fastzombie_torso" )
npc_AddSpawn( "Poison Zombie", "poisonzombie" )
npc_AddSpawn( "Headcrab", "headcrab" )
npc_AddSpawn( "Fast Headcrab", "headcrab_fast" )
npc_AddSpawn( "Poison Headcrab", "headcrab_black" )

npc_AddWeapon( "SMG", "smg1" )
//Did not work
//npc_AddWeapon( "Alyx's Gun", "alyxgun" )
npc_AddWeapon( "AR2", "ar2" )
npc_AddWeapon( "Stunstick", "stunstick" )
npc_AddWeapon( "Pistol", "pistol" )
npc_AddWeapon( "Shotgun", "shotgun" )
npc_AddWeapon( "RPG", "rpg" )
npc_AddWeapon( "Annabelle", "annabelle" )

npc_AddActor( "models/gman_high.mdl" )
for i=1, 3, 1 do
  for k=1, 7, 1 do
    if (k != 5) then npc_AddActor("models/humans/group0" .. tostring(i) .. "/female_0" .. tostring(k) .. ".mdl") end
  end
end
for i=1, 3, 1 do
  for k=1, 9, 1 do
    npc_AddActor("models/humans/group0" .. tostring(i) .. "/male_0" .. tostring(k) .. ".mdl")
  end
end
for i=1, 7, 1 do
    if (i != 5) then npc_AddActor("models/humans/group03m/female_0" .. tostring(i) .. ".mdl") end
end
for i=1, 9, 1 do
    npc_AddActor("models/humans/group03m/male_0" .. tostring(i) .. ".mdl")
end
npc_AddActor("models/combine_soldier.mdl")
npc_AddActor("models/combine_super_soldier.mdl")
npc_AddActor("models/combine_soldier_prisonguard.mdl")
npc_AddActor("models/barney.mdl")
npc_AddActor("models/eli.mdl")
npc_AddActor("models/kleiner.mdl")
npc_AddActor("models/breen.mdl")
npc_AddActor("models/vortigaunt.mdl")
npc_AddActor("models/vortigaunt_doctor.mdl")
npc_AddActor("models/vortigaunt_slave.mdl")
npc_AddActor("models/alyx.mdl")

if CLIENT then
   language.Add("cycler_actor", "Actor")
end

//Citizens
npc_AddAnimation( "Waiting In Line (1)", "", "LineIdle01", "Citizens" )
npc_AddAnimation( "Waiting In Line (2)", "", "LineIdle02", "Citizens" )
npc_AddAnimation( "Waiting In Line (3)", "", "LineIdle03", "Citizens" )
//npc_AddAnimation( "Crouch", "StandToCrouchD", "Crouch_idleD", "Citizens" )
npc_AddAnimation( "Being Arrested (Wall)", "", "apcarrestidle", "Citizens" )
npc_AddAnimation( "Being Arrested (Ground)", "", "arrestidle", "Citizens" )
npc_AddAnimation( "Cheer (1)", "cheer1", "", "Citizens" )
npc_AddAnimation( "Cheer (2)", "cheer2", "", "Citizens" )
npc_AddAnimation( "Cower", "cower", "cower_idle", "Citizens" )
npc_AddAnimation( "Wounded (1)", "", "d1_town05_Wounded_Idle_1", "Citizens" )
npc_AddAnimation( "Wounded (2)", "", "d1_town05_Wounded_Idle_2", "Citizens" )
npc_AddAnimation( "Tired", "", "d2_coast03_PostBattle_Idle02", "Citizens" )
npc_AddAnimation( "Fear Reaction", "Fear_Reaction", "Fear_Reaction_Idle", "Citizens" )
npc_AddAnimation( "What?", "g_armsout", "", "Citizens" )
npc_AddAnimation( "What?!", "g_armsout_high", "", "Citizens" )
npc_AddAnimation( "Open Door", "Open_door_away", "", "Citizens" )


MsgAll("Main Content Loaded\n")

//Episode 2 Content
//Missing an NPC? Contact me at Benjy355@gmail.com!
if (ep2content) then
   npc_AddNPC( "antlionworker", { spawnflags = "262144", class = "antlion" } )
   npc_AddNPC( "antlion_grub", { spawnflags = "0" } )
   npc_AddNPC( "friendlymine", { spawnflags = "0", Modification = "1", noprefix = true, class = "combine_mine" } )
   npc_AddSpawn("Antlion Worker", "antlionworker")
   npc_AddSpawn("Antlion Grub", "antlion_grub")
   npc_AddSpawn("Hunter", "hunter")
   npc_AddSpawn("Dr. Magnusson", "magnusson")
   npc_AddSpawn("Zombine", "zombine")
   npc_AddSpawn("Friendly Mine", "friendlymine")

   npc_AddActor("models/alyx_ep2.mdl")
   npc_AddActor("models/magnusson.mdl")
   MsgAll("Episode 2 Content Loaded!\n")
end
MsgAll("--------------------\n")
