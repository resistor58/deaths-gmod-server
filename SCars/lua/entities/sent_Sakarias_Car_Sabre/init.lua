--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/sabregt_sep.mdl" )
resource.AddFile( "models/sabregt_wheel.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Sabre.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Sabre.vmt" )

resource.AddFile( "materials/models/sabregt/sabregt_badges.vtf" )
resource.AddFile( "materials/models/sabregt/sabregt_badges.vmt" )
resource.AddFile( "materials/models/sabregt/sabregt_interior.vtf" )
resource.AddFile( "materials/models/sabregt/sabregt_interior.vmt" )
resource.AddFile( "materials/models/sabregt/sabreturbo_lights_glass.vtf" )
resource.AddFile( "materials/models/sabregt/sabreturbo_lights_glass.vmt" )
resource.AddFile( "materials/models/sabregt/skin2.vtf" )
resource.AddFile( "materials/models/sabregt/skin2.vmt" )
resource.AddFile( "materials/models/sabregt/skin3.vtf" )
resource.AddFile( "materials/models/sabregt/skin3.vmt" )
resource.AddFile( "materials/models/sabregt/skin4.vtf" )
resource.AddFile( "materials/models/sabregt/skin4.vmt" )
resource.AddFile( "materials/models/sabregt/skin5.vtf" )
resource.AddFile( "materials/models/sabregt/skin5.vmt" )
resource.AddFile( "materials/models/sabregt/skin6.vtf" )
resource.AddFile( "materials/models/sabregt/skin6.vmt" )
resource.AddFile( "materials/models/sabregt/steed_black.vtf" )
resource.AddFile( "materials/models/sabregt/steed_black.vmt" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_detail2.vtf" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_detail2.vmt" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_glasswindows2.vtf" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_glasswindows2.vmt" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_tyrewallblack.vtf" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_tyrewallblack.vmt" )

resource.AddFile( "materials/models/sabregt/steed_black_normal.vtf" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_detail2_normal.vtf" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_glasswindows2_normal.vtf" )
resource.AddFile( "materials/models/sabregt/vehicle_generic_tyrewallblack_normal.vtf" )
--]]


ENT.NrOfSeats = 2
ENT.NrOfExhausts = 2

ENT.SeatPos1 = NULL
ENT.SeatPos2 = NULL
ENT.SeatPos3 = NULL
ENT.SeatPos4 = NULL
ENT.SeatPos5 = NULL
ENT.FLwheelPos = NULL

ENT.FRwheelPos = NULL
ENT.RLwheelPos = NULL	
ENT.RRwheelPos = NULL

ENT.effectPos = NULL
ENT.exhaustPos = NULL
ENT.exhaustPos2 = NULL

ENT.DefaultSoftnesFront = 15
ENT.DefaultSoftnesRear = 15
ENT.CarMass = 500
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 70 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/sabregt_sep.mdl"
ENT.TireModel = "models/dean/gtaiv/vehicles/bansheewheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"

------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 0
	yPos = -19
	zPos = 13
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 0
	yPos = 19
	zPos = 13	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )



	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 73
	yPos = -33
	zPos = 8	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 73
	yPos = 33
	zPos = 8		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -50
	yPos = -33
	zPos = 8	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -50
	yPos = 33
	zPos = 8	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 108
	yPos = -26.5
	zPos = 27.5	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 108
	yPos = 26.5
	zPos = 27.5	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -102
	yPos = -25.5
	zPos = 24
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -102
	yPos = 25.5
	zPos = 24
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 86
	yPos = 0
	zPos = 40
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	

	--The position of the exhaust
	xPos = -100.5
	yPos = -23.5
	zPos = 15	
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	xPos = -100.5
	yPos = 23.5
	zPos = 15	
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 20
	self.DefaultSoftnesRear = 25	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end

