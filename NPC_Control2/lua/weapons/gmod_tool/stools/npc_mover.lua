include("shared.lua")

selected_npcs_movement = {{}}
//local npcselectedlist = nil

TOOL.Category = "NPC Control 2"
TOOL.Name = "NPC Movement"
TOOL.Command = nil
TOOL.ConfigName = ""

if (CLIENT) then
   language.Add("Tool_npc_mover_name", "NPC Movement")
   language.Add("Tool_npc_mover_desc", "Make NPCs move around!")
   language.Add("Tool_npc_mover_0", "Left-Click to select multiple NPCs, Right-Click to move")
end

TOOL.ClientConVar["dorun"] = "1"

function TOOL:LeftClick( trace )
   if SERVER then
   if (selected_npcs_movement[self:GetOwner()] == nil) then selected_npcs_movement[self:GetOwner()] = {} end
     if (!trace.Entity:IsValid() || !trace.Entity:IsNPC()) then return true end
     if (GetConVarNumber("npc_allow_moving") == 0 && !SinglePlayer()) then
        npcc_doNotify("NPC Movement is disabled on this server", "NOTIFY_ERROR", self:GetOwner())
        return false
     end
     if (!AdminCheck(self:GetOwner(), "NPC Movement")) then
        return false
     end
     if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then
        return true
     end

     if (selected_npcs_movement[self:GetOwner()][trace.Entity] == nil) then
        selected_npcs_movement[self:GetOwner()][trace.Entity] = trace.Entity
        npcc_doNotify("NPC Selected", "NOTIFY_GENERIC", self:GetOwner())
     else
        selected_npcs_movement[self:GetOwner()][trace.Entity] = nil
        npcc_doNotify("NPC Disbanded", "NOTIFY_GENERIC", self:GetOwner())
     end
   end
   return true
end

function TOOL:RightClick( trace )
   if SERVER then
     if (selected_npcs_movement[self:GetOwner()] == nil) then selected_npcs_movement[self:GetOwner()] = {} end
     if (trace.HitWorld && !trace.HitSky && SERVER) then
        local action = SCHED_FORCED_GO
        if (self:GetClientNumber("dorun") == 1) then action = SCHED_FORCED_GO_RUN end
        for k, v in pairs(selected_npcs_movement[self:GetOwner()]) do
           if (v != nil && v:IsValid() && v:IsNPC()) then
              v:SetLastPosition( trace.HitPos )
              v:SetSchedule( action )
           end
        end
     end
   end
   return true
end

function TOOL:Reload( trace )
   for k, v in pairs(selected_npcs_movement[self:GetOwner()]) do
      v = nil
   end
   npcc_doNotify("All NPCs disbanded", "NOTIFY_ERROR", self:GetOwner())
end
function TOOL.BuildCPanel( panel )
   panel:AddControl("CheckBox", {Label = "Run to position", Command = "npc_mover_dorun"})
end
