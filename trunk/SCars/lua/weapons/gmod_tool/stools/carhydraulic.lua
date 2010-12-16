
TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Hydraulics"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {
	SuspensionAddHeight    = "0",
	Active = "0",
}

if CLIENT then
	language.Add( "Tool_CarHydraulic_SuspensionAddHeight", "Suspension Add Height" )
	language.Add( "Tool_CarHydraulic_Active", "Active" )
	language.Add( "Tool_CarHydraulic_Active_desc", "Enable or disable this feature" )
	
	language.Add( "Tool_carhydraulic_name", "Car Hydraulics" )
	language.Add( "Tool_carhydraulic_desc", "Can change the hydraulic settings" )
	language.Add( "Tool_carhydraulic_0", "Primary fire to paste and secondary fire to copy" )
	
end

function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()


	local SuspensionAddHeight = self:GetClientNumber( "SuspensionAddHeight" )
	local newSuspensionAddHeight = SuspensionAddHeight * -1
	
	local allowHydraulics = GetConVarNumber("scar_allowHydraulics") 
	
	local Active 			  = self:GetClientNumber( "Active" )	
	
	if trace.Entity:IsValid()  then

		trace.Entity:EmitSound("carStools/hydraulic.wav",100,math.random(80,150))
		trace.Entity:SetSuspensionAddHeight( newSuspensionAddHeight )
		trace.Entity.SuspensionAddHeight = SuspensionAddHeight
		
		if allowHydraulics == 0 then
			Active = 0
		end
		
		trace.Entity:SetHydraulicActive( Active )
		trace.Entity.HydraulicActive = Active
		
	end
	return true

end

function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()

	local SuspensionAddHeight  = trace.Entity.SuspensionAddHeight
	local Active 			  = trace.Entity.HydraulicActive
	
	self:GetOwner():ConCommand("carhydraulic_SuspensionAddHeight "..SuspensionAddHeight)
	self:GetOwner():ConCommand("carhydraulic_Active "..Active)
	
	return true
end

function TOOL.BuildCPanel( CPanel )
	
	// HEADER
	CPanel:AddControl( "Header", { Text = "Carframes", Description	= "Spawn carframes" }  )	
	
	CPanel:AddControl( "Slider", { Label = "#Tool_CarHydraulic_SuspensionAddHeight",
									 Description = "",
									 Type = "float",
									 Min = 0,
									 Max = 40,
									 Command = "carhydraulic_SuspensionAddHeight" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_CarHydraulic_Active",
									 Description = "#Tool_CarHydraulic_Active_desc",
									 Command = "carhydraulic_Active" } )								 
									 
end
