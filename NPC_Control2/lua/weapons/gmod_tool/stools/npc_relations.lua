include("shared.lua")

selected_npcs_relations = {}

TOOL.Category = "NPC Control 2"
TOOL.Name = "NPC Relations"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["newdisp"] = "1"
//TOOL.ClientConVar["doface"] = "1"
TOOL.ClientConVar["priority"] = "10"
TOOL.ClientConVar["viceversa"] = "1"

if (CLIENT) then
   language.Add("Tool_npc_relations_name", "NPC Relations")
   language.Add("Tool_npc_relations_desc", "Make NPCs love or hate things!")
   language.Add("Tool_npc_relations_0", "Left-Click to select an NPC, Right-Click to make them change their disposition")
end

function TOOL:LeftClick( trace )
   if SERVER then
   local dohalt = false
   if (selected_npcs_relations[self:GetOwner()] == nil) then selected_npcs_relations[self:GetOwner()] = {} end
     if (GetConVarNumber("npc_allow_relations") != 1 && !SinglePlayer()) then
        npcc_doNotify("NPC Disposition control is disabled on this server", "NOTIFY_ERROR", self:GetOwner())
        dohalt = true
     end
     if (!AdminCheck( self:GetOwner(), "Relations control" )) then
        dohalt = true
     end
     if (!trace.Entity:IsValid() || !trace.Entity:IsNPC()) then dohalt = true end
     if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then dohalt = true end

     if (!dohalt) then
       if (selected_npcs_relations[self:GetOwner()][trace.Entity] == nil) then
          selected_npcs_relations[self:GetOwner()][trace.Entity] = trace.Entity
          npcc_doNotify("NPC Selected", "NOTIFY_GENERIC", self:GetOwner())
       else
          selected_npcs_relations[self:GetOwner()][trace.Entity] = nil
          npcc_doNotify("NPC Disbanded", "NOTIFY_GENERIC", self:GetOwner())
       end
     end
   end
   return true
end

function TOOL:RightClick( trace )
   if SERVER then
   local dohalt = false
   if (selected_npcs_relations[self:GetOwner()] == nil) then selected_npcs_relations[self:GetOwner()] = {} end
     if (GetConVarNumber("npc_allow_relations") != 1) then
        npcc_doNotify("NPC Disposition control is disabled on this server", "NOTIFY_ERROR", self:GetOwner())
        dohalt = true
     end
     if (!AdminCheck( self:GetOwner(), "Relations control" )) then
        dohalt = true
     end
     
     if (!trace.Entity:IsValid()) then dohalt = true end
     
     if (trace.Entity:IsPlayer() && GetConVarNumber("npc_allow_attacking_players") != 1) then
        npcc_doNotify("You can't target players", "NOTIFY_ERROR", self:GetOwner())
        dohalt = true
     end
     local viceversa = self:GetClientNumber("viceversa")
     if (!dohalt) then
       for k, v in pairs(selected_npcs_relations[self:GetOwner()]) do
          if (v:IsValid() && v:IsNPC()) then
             v:AddEntityRelationship( trace.Entity, self:GetClientNumber("newdisp"), self:GetClientNumber("priority") )
             if (viceversa == 1 && trace.Entity:IsNPC()) then trace.Entity:AddEntityRelationship( v, self:GetClientNumber("newdisp"), self:GetClientNumber("priority") ) end
          end
       end
     end
   end
   return true
end

function TOOL:Reload( trace )
   if SERVER then
     for k, v in pairs(selected_npcs_relations[self:GetOwner()]) do
        v = nil
     end
     npcc_doNotify("All NPCs disbanded", "NOTIFY_ERROR", self:GetOwner())
   end
end

function TOOL.BuildCPanel( panel )
   panel:AddControl("Label", {Text = "New Disposition:"})
   local data = {}
   //data.Label = "New Disposition:"
   data.MenuButton = 0
   data.Options = {}
   data.Options["Hate"] = {npc_relations_newdisp = "1"}
   data.Options["Like"] = {npc_relations_newdisp = "3"}
   data.Options["Fear"] = {npc_relations_newdisp = "2"}
   data.Options["Neutral"] = {npc_relations_newdisp = "4"}
   panel:AddControl("ComboBox", data)
   //panel:AddControl("CheckBox", {Label = "Make NPC(s) face new enemy", Command = "npc_relations_doface"})
   panel:AddControl("CheckBox", {Label = "Affect target aswell", Comand = "npc_relations_viceversa"})
   panel:AddControl("Slider", {Label = "Priority:", min = 1, max = 200, Command = "npc_relations_priority"})
   panel:AddControl("Label", {Text = "Combine Mines' dispositions will never change."})
end
