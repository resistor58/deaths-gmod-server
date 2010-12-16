
TOOL.Category		= "Sakarias88 Cars"
TOOL.Name			= "#Suspension adjustment"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.LiveEnt = NULL
TOOL.UpdateHeight = CurTime()
TOOL.UpdateDelay = 0


TOOL.ClientConVar = {
	SoftnesFront    = "0",
	SoftnesRear   = "0",
	liveAction = "0",
	liveAction2 = "0",	
	HeightFront = "0",
	HeightRear = "0",
}

if CLIENT then
	language.Add( "Tool_Car_SoftnesFront", "Front: Soft - Hard" )
	language.Add( "Tool_Car_SoftnesRear", "Rear: Soft - Hard" )	

	language.Add( "Tool_Car_HeightFront", "Front: Suspension Height" )
	language.Add( "Tool_Car_HeightRear", "Rear: Suspension Height" )	
	
	language.Add( "Tool_Car_LiveAction", "Live Action" )
	language.Add( "Tool_Car_LiveAction_desc", "Sets the suspensionsettings live" )
	
	language.Add( "Tool_carsuspension_name", "Car Suspension" )
	language.Add( "Tool_carsuspension_desc", "Can adjust the suspension" )
	language.Add( "Tool_carsuspension_0", "Primary fire to paste and secondary fire to copy" )
	
end

function TOOL:LeftClick( trace )


	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
		
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()

	trace.Entity:EmitSound("carStools/hydraulic.wav",100,math.random(80,150))
	local SoftnesFront			= self:GetClientNumber( "SoftnesFront" )
	local SoftnesRear			= self:GetClientNumber( "SoftnesRear" )
	local HeightFront           = self:GetClientNumber( "HeightFront" )
	local HeightRear            = self:GetClientNumber( "HeightRear" )
	
	local NewHeightFront = HeightFront * -1
	local NewHeightRear  = HeightRear * -1
	
	if trace.Entity:IsValid()  then
		trace.Entity:SetSoftnesFront( SoftnesFront )
		trace.Entity.SoftnesFront = SoftnesFront
		trace.Entity:SetSoftnesRear( SoftnesRear )
		trace.Entity.SoftnesRear = SoftnesRear		

		trace.Entity:SetHeightFront( NewHeightFront )
		trace.Entity.HeightFront = HeightFront
		trace.Entity:SetHeightRear( NewHeightRear )
		trace.Entity.HeightRear = HeightRear	
		
		self.LiveEnt = trace.Entity
	end
	return true

end

function TOOL:RightClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	if not(string.find( trace.Entity:GetClass( ), "sent_sakarias_car" )) then return false end
	if string.find( trace.Entity:GetClass( ), "sent_sakarias_carwheel" ) or string.find( trace.Entity:GetClass( ), "sent_Sakarias_carwheel_punked" ) or trace.Entity.IsDestroyed == 1 then return false end 
	
	if (CLIENT) then return true end
	local ply = self:GetOwner()
	
	self.LiveEnt = NULL
	local SoftnesFront  = trace.Entity.SoftnesFront
	local SoftnesRear   = trace.Entity.SoftnesRear

	local HeightFront   = trace.Entity.HeightFront
	local HeightRear    = trace.Entity.HeightRear	
	
	self:GetOwner():ConCommand("carsuspension_SoftnesFront "..SoftnesFront)
	self:GetOwner():ConCommand("carsuspension_SoftnesRear "..SoftnesRear)

	self:GetOwner():ConCommand("carsuspension_HeightFront "..HeightFront)
	self:GetOwner():ConCommand("carsuspension_HeightRear "..HeightRear)
		
	return true
end

function TOOL:Think()

		local live = self:GetClientNumber( "liveAction" )
		local live2 = self:GetClientNumber( "liveAction2" )
		
		if self.LiveEnt != NULL && self.LiveEnt != nil && self.LiveEnt:IsValid() && string.find( self.LiveEnt:GetClass( ), "sent_sakarias_car" ) && not(string.find( self.LiveEnt:GetClass( ), "sent_Sakarias_CarWheel" )) && not(self.LiveEnt.IsDestroyed == 1)  then
		
			if live2 == 1 then
				local SoftnesFront			= self:GetClientNumber( "SoftnesFront" )
				local SoftnesRear			= self:GetClientNumber( "SoftnesRear" )		
				
				self.LiveEnt:SetSoftnesFront( SoftnesFront )
				self.LiveEnt.SoftnesFront = SoftnesFront
				self.LiveEnt:SetSoftnesRear( SoftnesRear )
				self.LiveEnt.SoftnesRear = SoftnesRear		
			end
			
			if live == 1 then
				local HeightFront           = self:GetClientNumber( "HeightFront" )
				local HeightRear            = self:GetClientNumber( "HeightRear" )
				
				local NewHeightFront = HeightFront * -1
				local NewHeightRear  = HeightRear * -1
				
				if self.UpdateHeight < CurTime() then
					self.UpdateHeight = CurTime() + self.UpdateDelay
					self.LiveEnt:SetHeightFront( NewHeightFront )
					self.LiveEnt.HeightFront = HeightFront
					self.LiveEnt:SetHeightRear( NewHeightRear )
					self.LiveEnt.HeightRear = HeightRear
				end		
			end
			
		end

end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "Carframes", Description	= "Spawn carframes" }  )
	
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_SoftnesFront",
									 Description = "",
									 Type = "float",
									 Min = -10,
									 Max = 30,
									 Command = "carsuspension_SoftnesFront" } )
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_SoftnesRear",
									 Description = "",
									 Type = "float",
									 Min = -10,
									 Max = 30,
									 Command = "carsuspension_SoftnesRear" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_LiveAction",
									 Description = "#Tool_Car_LiveAction_desc",
									 Command = "carsuspension_liveAction2" } )								 
									 
CPanel:AddControl( "Label", { Text = "________________________________________", Description = "" } )									 
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_HeightFront",
									 Description = "",
									 Type = "float",
									 Min = -30,
									 Max = 30,
									 Command = "carsuspension_HeightFront" } )
									 
	CPanel:AddControl( "Slider", { Label = "#Tool_Car_HeightRear",
									 Description = "",
									 Type = "float",
									 Min = -30,
									 Max = 30,
									 Command = "carsuspension_HeightRear" } )									 
									 
	CPanel:AddControl( "CheckBox", { Label = "#Tool_Car_LiveAction",
									 Description = "#Tool_Car_LiveAction_desc",
									 Command = "carsuspension_liveAction" } )
									 
end
