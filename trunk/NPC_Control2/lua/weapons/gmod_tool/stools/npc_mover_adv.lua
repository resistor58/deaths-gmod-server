include("shared.lua")

TOOL.Category = "NPC Control 2"
TOOL.Name = "NPC Adv. Movement"
TOOL.Command = nil
TOOL.ConfigName = ""

//selected_npcs_movement
TOOL.ClientConVar["dorun"] = "1"

existing_paths = {}
existing_schedule = {}

local function CreateWayPoint( pos, ply ) //returns the waypoint
   if (SERVER) then
      if (existing_paths[ply] == nil) then existing_paths[ply] = {} end
      local newwaypoint = nil
      newwaypoint = ents.Create("path_track")
      local i = 1
      for k, v in pairs(existing_paths[ply]) do
         if (v:IsValid()) then
            i = i+1
         end
      end
      newwaypoint:SetName(ply:GetName() .. "_path" .. tostring(i))
      newwaypoint:SetPos(pos)
      newwaypoint:SetKeyValue("orientationtype", "0")
      newwaypoint:SetKeyValue("target", ply:GetName() .. "_path" .. tostring(i+1))
      newwaypoint:Spawn()
      ply:AddCount("waypoint", newwaypoint)
      undo.Create("waypoint")
         undo.AddEntity(newwaypoint)
         undo.SetPlayer(ply)
      undo.Finish()
      cleanup.Add(ply, "waypoint", newwaypoint)
      existing_paths[ply][i] = newwaypoint
      return newwaypoint
   end
end

if (CLIENT) then
   language.Add("Tool_npc_mover_adv_name", "NPC Advanced Movement")
   language.Add("Tool_npc_mover_adv_desc", "Make NPCs move around!")
   language.Add("Tool_npc_mover_adv_0", "Left-Click to create a waypoint, Right-Click to move selected NPCs (Selected with NPC Mover); Reload deletes all waypoints")
   language.Add("Undone_waypoint", "Undone Waypoint")
   language.Add("Cleanup_npc_waypoint", "Movement Waypoints")
end

function TOOL:LeftClick( trace )
   if SERVER then
   if (!trace.HitWorld || trace.HitSky) then return false end
   if (GetConVarNumber("npc_allow_moving") == 0 && !SinglePlayer()) then
      npcc_doNotify("NPC Movement is disabled on this server", "NOTIFY_ERROR", self:GetOwner())
      dohalt = true
   end
   if (!AdminCheck(self:GetOwner(), "NPC Movement")) then
      dohalt = true
   end
   if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then
      dohalt = true
   end
   if (!npcc_LimitControlCheck(self:GetOwner(), "waypoints", "Waypoint")) then
      dohalt = true
   end
   if (!dohalt) then
       local newwaypoint = CreateWayPoint( trace.HitPos, self:GetOwner() )
       //if (existing_schedule[self:GetOwner()] == nil) then existing_schedule[self:GetOwner()] = nil end
       if (existing_schedule[self:GetOwner()] == nil || !existing_schedule[self:GetOwner()]:IsValid()) then
          existing_schedule = ents.Create("aiscripted_schedule")
          existing_schedule:SetPos(Vector(0,0,0))
          existing_schedule:SetKeyValue("goalent", self:GetOwner():GetName() .. "_path1")
          existing_schedule:SetKeyValue("interruptability", "2")
          existing_schedule:SetKeyValue("m_iszEntity", self:GetOwner():GetName() .. "_makemerun")
          existing_schedule:SetKeyValue("spawnflags", "4")
          existing_schedule:SetKeyValue("graball", "1")
          existing_schedule:Spawn()
          //Not needed
          //existing_schedule:SetName(self:GetOwner():GetName() .. "_schedule")
       end
       if (self:GetClientNumber("dorun") != 1) then
          existing_schedule:SetKeyValue("schedule", "4")
       else
          existing_schedule:SetKeyValue("schedule", "5")
       end
     end
   end
   return true
end

function TOOL:RightClick( trace )
   if SERVER then
   local dohalt = false
   if (selected_npcs_movement[self:GetOwner()] == nil) then selected_npcs_movement[self:GetOwner()] = {} end
   if (GetConVarNumber("npc_allow_moving") == 0 && !SinglePlayer()) then
      npcc_doNotify("NPC Movement is disabled on this server", "NOTIFY_ERROR", self:GetOwner())
      dohalt = true
   end
   if (!AdminCheck(self:GetOwner(), "NPC Movement")) then
      dohalt = true
   end

   if (!dohalt) then
         for k, v in pairs(ents.FindByName(self:GetOwner():GetName() .. "_makemerun")) do
            v:SetName("")
         end
         for k, v in pairs(selected_npcs_movement[self:GetOwner()]) do
            if (v:IsValid()) then v:SetName(self:GetOwner():GetName() .. "_makemerun") end
         end
         if (existing_schedule[self:GetOwner()] == nil || !existing_schedule[self:GetOwner()]:IsValid()) then
            existing_schedule = ents.Create("aiscripted_schedule")
            existing_schedule:SetPos(Vector(0,0,0))
            existing_schedule:SetKeyValue("goalent", self:GetOwner():GetName() .. "_path1")
            existing_schedule:SetKeyValue("interruptability", "2")
            existing_schedule:SetKeyValue("m_iszEntity", self:GetOwner():GetName() .. "_makemerun")
            existing_schedule:SetKeyValue("spawnflags", "4")
            existing_schedule:SetKeyValue("graball", "1")
            existing_schedule:Spawn()
            //Not needed
            //existing_schedule:SetName(self:GetOwner():GetName() .. "_schedule")
         end
         if (self:GetClientNumber("dorun") != 1) then
              existing_schedule:SetKeyValue("schedule", "4")
         else
              existing_schedule:SetKeyValue("schedule", "5")
         end
         existing_schedule:Fire("StartSchedule", "", 0)
      end
   end
end

function TOOL:Reload( trace )
   if (SERVER) then
      for k, v in pairs(existing_paths[self:GetOwner()]) do
          if (v:IsValid()) then
             v:SetName("deleteme") //Don't ask, don't remove
             v:Remove()
          end
          existing_paths[k] = nil
      end
      npcc_doNotify("Waypoints deleted", "NOTIFY_ERROR", self:GetOwner())
   end
end

function TOOL.BuildCPanel( panel )
   panel:AddControl("CheckBox", {Label = "Run through waypoints", Command = "npc_mover_adv_dorun"})
   panel:AddControl("Label", {Text = "You can undo waypoints"})
end
