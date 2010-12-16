include("shared.lua")

TOOL.Category = "NPC Control 2"
TOOL.Name = "NPC Health"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["newhealth"] = "100"

if (CLIENT) then
   language.Add("Tool_npc_health_name", "NPC Health")
   language.Add("Tool_npc_health_desc", "Change an NPC's health")
   language.Add("Tool_npc_health_0", "Left-Click to change an NPC's health")
end

function TOOL:LeftClick( trace )
   if (SERVER) then
     local dohalt = false
     if (GetConVarNumber("npc_allow_health") != 1 && !SinglePlayer()) then
        npcc_doNotify("NPC Health control is disabled on this server", "NOTIFY_ERROR", self:GetOwner())
        dohalt = true
     end
     if (!AdminCheck( self:GetOwner(), "Health control" )) then
        dohalt = true
     end

     if (trace.Entity:IsValid() && !trace.Entity:IsPlayer() && !dohalt) then
        if (!NPCProtectCheck( self:GetOwner(), trace.Entity )) then return true end
        local maxhealth = trace.Entity:GetMaxHealth()
        local newhealth = maxhealth * self:GetClientNumber("newhealth")/100
        newhealth = newhealth
        self:GetOwner():PrintMessage(HUD_PRINTTALK, "The NPC's new health is " .. newhealth .. "/" .. maxhealth)
        trace.Entity:SetHealth(newhealth)
        return true
     end
   end
end

function TOOL.BuildCPanel( panel )
   panel:AddControl("Slider", {Label = "New Health:", min = 1, max = 100, Command = "npc_health_newhealth"})
end
