TOOL.Category = "NPC Control 2: Specifics"
TOOL.Name = "Combine Soldiers"
TOOL.Command = nil
TOOL.ConfigName = ""

include("shared.lua")

selected_npcs_specific_combine = {{}}
local oldtarget = nil
local tothrowat = nil

TOOL.ClientConVar["action"] = "0"
TOOL.ClientConVar["newtactic"] = "0"

if (CLIENT) then
   language.Add("Tool_npc_specific_combine_name", "NPC Specifics: Combine Soldiers")
   language.Add("Tool_npc_specific_combine_desc", "Tell Combine Soldier's to do stuff!")
   language.Add("Tool_npc_specific_combine_0", "Left-Click to select multiple NPC, Right-Click to throw/shoot") //Throw grenades
   language.Add("Tool_npc_specific_combine_1", "Left-Click to change an NPC's tactics, Right-Click affects all selected NPCs") //Change variant
end

function TOOL:LeftClick( trace )
   if (SERVER) then
     local dohalt = false
     if (selected_npcs_specific_combine[self:GetOwner()] == nil) then selected_npcs_specific_combine[self:GetOwner()] = {} end
     if SERVER then
       if (GetConVarNumber("npc_allow_specifics") != 1 && !Singleplayer()) then
          npcc_doNotify("NPC-Specific tools are disabled on this server", "NOTIFY_ERROR", self:GetOwner())
          dohalt = true
       end
       if (!AdminCheck(self:GetOwner(), "NPC-Specific Controls")) then
          dohalt = true
       end
       if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then
          dohalt = true
       end
       if (!dohalt) then
         if (trace.Entity:IsValid() && trace.Entity:IsNPC() && trace.Entity:GetClass() == "npc_combine_s") then
            local stage = self:GetStage()
            if (stage == 0) then //STAGE 0
               if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then return true end
               if (selected_npcs_specific_combine[self:GetOwner()][trace.Entity] == nil) then
                  selected_npcs_specific_combine[self:GetOwner()][trace.Entity] = trace.Entity
                  npcc_doNotify("NPC Selected", "NOTIFY_GENERIC", self:GetOwner())
               else
                  selected_npcs_specific_combine[self:GetOwner()][trace.Entity] = nil
                  npcc_doNotify("NPC Disbanded", "NOTIFY_GENERIC", self:GetOwner())
               end
            end //STAGE 0 END
            if (stage == 1) then
               if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then return true end
               trace.Entity:SetKeyValue("tacticalvariant", self:GetClientNumber("newtactic"))
            end
           end
         end
       end
     end
   return true
end

function TOOL:RightClick( trace )
   local dohalt = false
   if (selected_npcs_specific_combine[self:GetOwner()] == nil) then selected_npcs_specific_combine[self:GetOwner()] = {} end
   if SERVER then
     if (GetConVarNumber("npc_allow_specifics") != 1 && !Singleplayer()) then
        npcc_doNotify("NPC-Specific tools are disabled on this server", "NOTIFY_ERROR", self:GetOwner())
        dohalt = true
     end
     if (!AdminCheck(self:GetOwner(), "NPC-Specific Controls")) then
        dohalt = true
     end
     if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then
        dohalt = true
     end

     local stage = self:GetStage()
     if (!dohalt) then
       if (stage == 0) then //STAGE 0
          if (trace.Hit) then
             for k, v in pairs(ents.FindByName(self:GetOwner():GetName() .. "_throwtarget")) do
                 v:SetName("deleteme") //By renaming it, it fixes the error where the combine wouldn't throw the second grenade
                 v:Remove()
             end
             tothrowat = ents.Create("info_target")
             tothrowat:SetName(self:GetOwner():GetName() .. "_throwtarget")
             tothrowat:SetPos(trace.HitPos)
             tothrowat:Spawn()
             for k, v in pairs(selected_npcs_specific_combine[self:GetOwner()]) do
                 if (v != nil && v:IsValid()) then
                    v:Fire("ThrowGrenadeAtTarget", self:GetOwner():GetName() .. "_throwtarget")
                 end
             end
             return true
          else
             return false
          end
       end //END STAGE 0
       if (stage == 1) then //STAGE 1
          for k, v in pairs(selected_npcs_specific_combine[self:GetOwner()]) do
              v:SetKeyValue("tacticalvariant", self:GetClientNumber("newtactic"))
          end
          npcc_doNotify("Selected NPCs' Tactics are now changed", "NOTIFY_ERROR", self:GetOwner())
       end //END STAGE 1
     end
   end
   return true
end

function TOOL.BuildCPanel( panel )
   panel:AddControl("Label", {Text = "Action:"})
   local data = {}
   data.Options = {}
   data.Options["Throw grenades/c-balls"] = {npc_specific_combine_action = 0}
   data.Options["Change Tactics"]         = {npc_specific_combine_action = 1}
   panel:AddControl("ComboBox", data)
   
   panel:AddControl("Label", {Text = ""}) //Spacer

   panel:AddControl("Label", {Text = "New Tactic:"})
   data = {}
   data.Options = {}
   data.Options["Normal Tactics"] = {npc_specific_combine_newtactic = "0"}
   data.Options["Pressure Enemy"] = {npc_specific_combine_newtactic = "1"}
   data.Options["Pressure for 30 feet"] = {npc_specific_combine_newtactic = "2"}
   panel:AddControl("ComboBox", data)
end

function TOOL:Think()
   if (self:GetClientNumber("action") == 0) then self:SetStage(0) end
   if (self:GetClientNumber("action") == 1) then self:SetStage(1) end
end
