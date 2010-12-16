TOOL.Category = "NPC Control 2: Actors"
TOOL.Name = "Actor Spawner"
TOOL.Command = nil
TOOL.ConfigName = ""

//Looks similar to NPC Spawner, doesn't it?

include("shared_cl.lua")
include("shared.lua")
TOOL.ClientConVar["actortospawn"] = "models\gman_high.mdl"
TOOL.ClientConVar["wep"] = ""
TOOL.ClientConVar["facing"] = "0"

if (CLIENT) then
   language.Add("Tool_npc_actor_spawner_name", "Actor Spawner")
   language.Add("Tool_npc_actor_spawner_desc", "Spawn and destroy Actors")
   language.Add("Tool_npc_actor_spawner_0", "Left-Click to spawn an Actor, Right-Click to remove them")
end

function TOOL:LeftClick( trace )
   if SERVER then
   local dohalt = false
   //Are they allowed to spawn?
   if (GetConVarNumber("npc_allow_actors") != 1 && !SinglePlayer()) then
      self:GetOwner():PrintMessage(HUD_PRINTTALK, "Actor Spawning is not allowed on this server")
      dohalt = true
   end
   if (!AdminCheck(self:GetOwner(), "Actor Spawning")) then
      dohalt = true
   end

   if (trace.HitWorld && !trace.HitSky && !dohalt) then
        if (npcc_LimitControlCheck(self:GetOwner(), "npcs", "NPC")) then
           local newactor = ents.Create("cycler_actor")
           newactor:SetPos(trace.HitPos + Vector(0,1,0))
           local spawnangle = Vector(0, self:GetOwner():GetAngles().y, 0)
           if (self:GetClientNumber("facing") == 1) then spawnangle = spawnangle + Vector(0, 180, 0) end
           newactor:SetAngles(spawnangle)
           newactor:SetKeyValue("spawnflags", "532")
           newactor:SetKeyValue("model", self:GetClientInfo("actortospawn"))
           newactor:Spawn()
           spawnednpcs[newactor] = self:GetOwner()
           self:GetOwner():AddCount("npcs", newactor)
           undo.Create("npc")
              undo.AddEntity(newactor)
              undo.SetPlayer(self:GetOwner())
           undo.Finish()
           cleanup.Add( self:GetOwner(), "npcs", newactor )
           //if (self:GetClientInfo("wep") != "") then newactor:SetKeyValue("additionalequipment", "weapon_" .. self:GetClientInfo("wep")) end
        end
     end
   end
   return true
end

function TOOL:RightClick( trace )
   if (trace.Entity:IsValid() && trace.Entity:GetClass() == "cycler_actor") then
     if (SERVER) then
       if (NPCProtectCheck( self:GetOwner(), trace.Entity )) then
          trace.Entity:Remove()
       end
     end
     return true
   end
end

function TOOL.BuildCPanel(panel)
   local spawnables = {}
   spawnables.Label = "NPCs"
   spawnables.Catagory = "NPCs"
   spawnables.Height = 4
   spawnables.Models = list.Get( "ActorsSpawn" )
   spawnables.ConVar = "npc_actor_spawner_actortospawn"
   panel:AddControl("PropSelect", spawnables)

   panel:AddControl("CheckBox", {Label = "Spawn facing you", Command = "npc_actor_spawner_facing"})
end
