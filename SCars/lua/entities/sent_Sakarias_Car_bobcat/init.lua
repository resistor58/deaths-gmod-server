--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/bobcat.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_bobcat.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_bobcat.vmt" )

resource.AddFile( "materials/models/bobcat/1.vtf" )
resource.AddFile( "materials/models/bobcat/1.vmt" )
resource.AddFile( "materials/models/bobcat/78.vtf" )
resource.AddFile( "materials/models/bobcat/78.vmt" )
resource.AddFile( "materials/models/bobcat/bobcat_badges.vtf" )
resource.AddFile( "materials/models/bobcat/bobcat_badges.vmt" )
resource.AddFile( "materials/models/bobcat/bobcat_interior.vtf" )
resource.AddFile( "materials/models/bobcat/bobcat_interior.vmt" )
resource.AddFile( "materials/models/bobcat/bobcat_lights_glass.vtf" )
resource.AddFile( "materials/models/bobcat/bobcat_lights_glass.vmt" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_detail2.vtf" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_detail2.vmt" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_glasswindows2.vtf" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_glasswindows2.vmt" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_tyrewallblack.vtf" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_tyrewallblack.vmt" )

resource.AddFile( "materials/models/bobcat/1_normal.vtf" )
resource.AddFile( "materials/models/bobcat/78_normal.vtf" )
resource.AddFile( "materials/models/bobcat/bobcat_lights_glass_normal.vtf" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_detail2_normal.vtf" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_glasswindows2_normal.vtf" )
resource.AddFile( "materials/models/bobcat/vehicle_generic_tyrewallblack_normal.vtf" )
]]--

ENT.NrOfSeats = 2
ENT.NrOfExhausts = 1

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
ENT.CarModel = "models/bobcat.mdl"
ENT.TireModel = "models/bobcatw.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 15
	yPos = -19
	zPos = 15
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 15
	yPos = 19
	zPos = 15	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
		
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 83
	yPos = -35
	zPos = 0	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 83
	yPos = 35
	zPos = 0		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -58
	yPos = -35
	zPos = 0
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -58
	yPos = 35
	zPos = 0
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 117
	yPos = -33
	zPos = 27	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 117
	yPos = 33
	zPos = 27	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -98
	yPos = -34
	zPos = 20
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -98
	yPos = 34
	zPos = 20
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 88
	yPos = 0
	zPos = 43	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -86
	yPos = 22
	zPos = -1.5		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 21
	self.DefaultSoftnesRear = 21	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
	self.SteerForce = 3
	self.Entity.SteerForce = 3	
	self.SteerResponse = 0.3	
	self.Entity.SteerResponse = 0.3
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
