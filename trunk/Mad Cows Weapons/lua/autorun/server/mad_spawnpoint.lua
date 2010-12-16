/*---------------------------------------------------------
------mmmm---mmmm-aaaaaaaa----ddddddddd---------------------------------------->
     mmmmmmmmmmmm aaaaaaaaa   dddddddddd	  Name: Mad Cows Weapons
     mmm mmmm mmm aaa    aaa  ddd     ddd	  Author: Worshipper
    mmm  mmm  mmm aaaaaaaaaaa ddd     ddd	  Project Start: October 23th, 2009
    mmm       mmm aaa     aaa dddddddddd	  File: mad_spawnpoint.lua
---mmm--------mmm-aaa-----aaa-ddddddddd---------------------------------------->
---------------------------------------------------------*/

// Shhhh! It's a secret script to set your own spawnpoint!

function MAD.SetSpawnpoint(ply, command, args)

	ply.SpawnPoint = ply:GetPos()
	ply:ChatPrint("Spawnpoint set.")
end
concommand.Add("mad_spawnpoint", MAD.SetSpawnpoint)

local function PlayerSpawn(ply)

	if ply.SpawnPoint then 
		ply:SetPos(ply.SpawnPoint + Vector(0, 0, 16)) 
	end
end
hook.Add("PlayerSpawn", "PlayerSpawn", PlayerSpawn) 