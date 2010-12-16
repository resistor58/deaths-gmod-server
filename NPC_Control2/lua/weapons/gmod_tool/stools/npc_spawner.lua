TOOL.Category = "NPC Control 2"
TOOL.Name = "NPC Spawner"
TOOL.Command = nil
TOOL.ConfigName = ""

include("shared_cl.lua")
include("shared.lua")
TOOL.ClientConVar["npctospawn"] = "gman"
TOOL.ClientConVar["wep"] = ""

TOOL.ClientConVar["autoselect"] = "1"
TOOL.ClientConVar["facing"] = "0"

if (CLIENT) then
   language.Add("Tool_npc_spawner_name", "NPC Spawner")
   language.Add("Tool_npc_spawner_desc", "Spawn and destroy NPCs")
   language.Add("Tool_npc_spawner_0", "Left-Click to spawn an NPC, Right-Click to remove them")
end

function TOOL:LeftClick(trace)
   if (SERVER) then
   local dohalt = false
   //Are they allowed to spawn?
   if (GetConVarNumber("npc_allow_spawning") != 1 && !SinglePlayer()) then
      self:GetOwner():PrintMessage(HUD_PRINTTALK, "NPC Spawning is not allowed on this server")
      dohalt = true
   end
   if (!AdminCheck(self:GetOwner(), "NPC Spawning")) then
      dohalt = true
   end

   if (trace.HitWorld && !trace.HitSky && !dohalt) then
        if (npcc_LimitControlCheck(self:GetOwner(), "npcs", "NPC")) then
           local npcname = self:GetClientInfo("npctospawn", "gman")
           local npctospawn = npcname
           local addprefix = true
           local spawnednpc = nil
           if (NPCSpawnData[npcname] != nil) then
             for k, v in pairs(NPCSpawnData[npcname]) do
                if (k == "noprefix") then
                   if (v) then addprefix = false end
                end
                if (k == "class") then
                   npctospawn = v
                end
             end
           end
           if (addprefix) then spawnednpc = ents.Create("npc_" .. npctospawn) else spawnednpc = ents.Create(npctospawn) end
           if (spawnednpc == nil) then return false end //Prevents LUA errors from coming up, better to thing their gun didn't register
           for k, v in pairs(NPCSpawnData["Base"]) do
              spawnednpc:SetKeyValue(k, v) //Shouldn't have errors if nobody edits the file :D
           end
           if (NPCSpawnData[npcname] != nil) then
             for k, v in pairs(NPCSpawnData[npcname]) do
                if (k != "class" && k != "noprefix") then spawnednpc:SetKeyValue(k, v) end
             end
           end
           spawnednpc:SetPos(trace.HitPos + Vector(0, 1, 0)) //That extra 1 in the Vector prevents NPCs from spawning in a permenant crouch
           local spawnangle = Vector(0, self:GetOwner():GetAngles().y, 0)
           if (self:GetClientNumber("facing") == 1) then spawnangle = spawnangle + Vector(0, 180, 0) end
           spawnednpc:SetAngles(spawnangle)
           if (self:GetClientInfo("wep") != "") then spawnednpc:SetKeyValue("additionalequipment", "weapon_" .. self:GetClientInfo("wep")) end
           spawnednpc:Spawn()
           self:GetOwner():AddCount("npcs", spawnednpc)
           undo.Create("npc")
              undo.AddEntity(spawnednpc)
              undo.SetPlayer(self:GetOwner())
           undo.Finish()
           cleanup.Add( self:GetOwner(), "npcs", spawnednpc)
           spawnednpcs[spawnednpc] = self:GetOwner()
           //AUTOSELECT
           if (self:GetClientNumber("autoselect") == 1) then
              if (selected_npcs_relations[self:GetOwner()] == nil) then selected_npcs_relations[self:GetOwner()] = {} end
              if (selected_npcs_movement[self:GetOwner()] == nil) then selected_npcs_movement[self:GetOwner()] = {} end
              selected_npcs_movement[self:GetOwner()][spawnednpc] = spawnednpc
              selected_npcs_relations[self:GetOwner()][spawnednpc] = spawnednpc
           end
        end
     end
   end
   return true
end

function TOOL:RightClick(trace)
   if (trace.Entity:IsValid() && trace.Entity:IsNPC()) then
      if (SERVER) then
         if (NPCProtectCheck( self:GetOwner(), trace.Entity )) then
            trace.Entity:Remove()
         end
      end
      return true
   end
end

function TOOL.BuildCPanel(panel)
   local listdata = {}
   listdata.Label = "NPCs"
   listdata.Height = 120
   listdata.Options = {}
   for k, v in pairs(NPCSpawnList) do
      listdata.Options[k] = {npc_spawner_npctospawn = v}
   end
   panel:AddControl("ListBox", listdata)

   listdata = {}
   listdata.Label = "Weapon: " //For when someone on Team Garry fixes the combobox labels; if they're even broken... >.>
   listdata.Options = {}
   listdata.Options["None"] = {npc_spawner_wep = ""}
   for k, v in pairs(NPCWepList) do
      listdata.Options[k] = {npc_spawner_wep = v}
   end
   panel:AddControl("ComboBox", listdata)
   panel:AddControl("CheckBox", {Label = "Spawn facing you", Command = "npc_spawner_facing"})
   panel:AddControl("CheckBox", {Label = "Autoselect", Command = "npc_spawner_autoselect"})
end
