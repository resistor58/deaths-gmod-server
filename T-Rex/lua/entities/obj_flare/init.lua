
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:SpawnFunction(pl, tr)
	if !tr.Hit then return end
	local pos = tr.HitPos +Vector(0,0,20)
	local ang = tr.HitNormal:Angle() +Angle(90,0,0)
	local entFlare = ents.Create("prop_physics")
	entFlare:SetModel("models/props_junk/flare.mdl")
	entFlare:SetKeyValue("classname", "obj_flare")
	entFlare:SetPos(pos)
	entFlare:SetAngles(ang)
	entFlare:Spawn()
	entFlare:Activate()
	entFlare:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	entFlare:NoCollide("player")
	local index = entFlare:EntIndex()
	local function RemoveHooks()
		hook.Remove("GravGunPunt", "flarePickup" .. index); hook.Remove("GravGunOnPickedUp", "flarePickup" .. index)
	end
	hook.Add("GravGunOnPickedUp", "flarePickup" .. index, function(pl, ent)
		if !ValidEntity(entFlare) then RemoveHooks()
		elseif ValidEntity(ent) && ent == entFlare then
			entFlare.tmIgnition = CurTime()
			RemoveHooks()
		end
	end)
	hook.Add("GravGunPunt", "flarePickup" .. index, function(pl, ent)
		if !ValidEntity(entFlare) then RemoveHooks()
		elseif ValidEntity(ent) && ent == entFlare then
			entFlare.tmIgnition = CurTime()
			RemoveHooks()
		end
	end)
	entFlare:CallOnRemove("CleanUpHooks", function(entFlare)
		RemoveHooks()
	end)
    undo.Create("Flare")
        undo.AddEntity(entFlare)
		undo.SetPlayer(pl)
    undo.Finish()
	undo.Create("SENT")
        undo.AddEntity(entFlare)
		undo.SetPlayer(pl)
		undo.SetCustomUndoText("Undone Flare")
	undo.Finish("Scripted Entity (Flare)")
	cleanup.Add(pl, "sents", entFlare)
	return ent
end
