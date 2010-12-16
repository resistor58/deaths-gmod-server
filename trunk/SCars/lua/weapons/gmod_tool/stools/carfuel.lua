
TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Fuel"
TOOL.Command		= nil
TOOL.ConfigName		= ""


TOOL.ClientConVar = {

	FuelConsumptionUse = "0",
	FuelConsumption = "100",
}
cleanup.Register( "Fuel" )

if CLIENT then

	language.Add( "Tool_Car_FuelConsumptionUse", "Fuel Consumption:" )	

	language.Add( "Tool_Car_fuel", "Fuel Consumption" )
	language.Add( "Tool_Car_fuel_desc", "Turn Fuel consumption on or off" )
	
	language.Add( "Tool_carfuel_name", "Car Fuel" )
	language.Add( "Tool_carfuel_desc", "Change the fuel properties on the car" )
	language.Add( "Tool_carfuel_0", "Primary fire to paste, secondary fire to copy, reload to spawn gas pump" )

	language.Add( "Undone_Fuel", "Undone Gas Pump" )
	language.Add( "Cleanup_Fuel", "SCar Gas Pump" )
	language.Add( "Cleaned_Fuel", "Gas Pump Removed" )	
	
end

function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	 
	local FuelConsumptionUse = self:GetClientNumber( "FuelConsumptionUse" )
	local FuelConsumption = self:GetClientNumber( "FuelConsumption" )
	
	local AllowDisablingFuelConsumption = GetConVarNumber("scar_fuelconsumptionuse")
	local MinFuelConsumption = GetConVarNumber("scar_fuelconsumption")
	
	if FuelConsumption < MinFuelConsumption then
		FuelConsumption = MinFuelConsumption
	end
	
	// If we shot a 
	if trace.Entity:IsValid()  then
	
		trace.Entity:EmitSound("carStools/tune.wav",80,math.random(100,150))
	
		if AllowDisablingFuelConsumption == 0 && FuelConsumptionUse == 0 then
			FuelConsumptionUse = 1
		end
		
		if MinFuelConsumption > FuelConsumption then
			FuelConsumption = MinFuelConsumption
		end
	
		trace.Entity:SetFuelConsumptionUse( FuelConsumptionUse )
		trace.Entity.FuelConsumptionUse = FuelConsumptionUse	

		trace.Entity:SetFuelConsumption( FuelConsumption )
		trace.Entity.FuelConsumption = FuelConsumption	
		
		return true

	end
	return true

end

function TOOL:RightClick( trace )
	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end

	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	if trace.Entity:IsValid() && trace.Entity != NULL && trace.Entity != nil then


		local FuelConsumptionUse = trace.Entity.FuelConsumptionUse
		local FuelConsumption = trace.Entity.FuelConsumption
		
		self:GetOwner():ConCommand("carfuel_FuelConsumptionUse "..FuelConsumptionUse)
		self:GetOwner():ConCommand("carfuel_FuelConsumption "..FuelConsumption)		

		return true
	end
	
	
	return true
end

function TOOL:Reload(trace)

	if (CLIENT) then return true end
	local ply = self:GetOwner()
		
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local FuelProp = ents.Create( "sent_Sakarias_GasPump" )	
	FuelProp:SetPos(trace.HitPos)	
	FuelProp:SetAngles(Ang)
	FuelProp:Spawn()	
	
	local min = FuelProp:OBBMins()
	FuelProp:SetPos( trace.HitPos - trace.HitNormal * min.z )	

	
	undo.Create("Fuel")
	undo.AddEntity( FuelProp )
	undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "Fuel", FuelProp )

end

function TOOL.BuildCPanel( CPanel )
											 
					 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_FuelConsumptionUse",
									 Description = "",
									 Type = "float",
									 Min = 0.5,
									 Max = 20,
									 Command = "carfuel_FuelConsumption" } )										 
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_fuel",
									 Description = "#Tool_Car_fuel_desc",
									 Command = "carfuel_FuelConsumptionUse" } )	
									 
	CPanel:AddControl( "Label", { Text = "Press RELOAD to spawn a gas pump", Description = "" } )	
end
