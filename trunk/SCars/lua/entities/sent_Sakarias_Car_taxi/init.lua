--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/taxi1.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_taxi.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_taxi.vmt" )

resource.AddFile( "materials/models/taxi/noose_lights.vtf" )
resource.AddFile( "materials/models/taxi/noose_lights.vmt" )
resource.AddFile( "materials/models/taxi/rom_stickers.vtf" )
resource.AddFile( "materials/models/taxi/rom_stickers.vmt" )
resource.AddFile( "materials/models/taxi/taxi_badges.vtf" )
resource.AddFile( "materials/models/taxi/taxi_badges.vmt" )
resource.AddFile( "materials/models/taxi/taxi_detail.vtf" )
resource.AddFile( "materials/models/taxi/taxi_detail.vmt" )
resource.AddFile( "materials/models/taxi/taxi_signs_1.vtf" )
resource.AddFile( "materials/models/taxi/taxi_signs_1.vmt" )
resource.AddFile( "materials/models/taxi/taxi_signs_1_normal.vtf" )
resource.AddFile( "materials/models/taxi/taxi_signs_1_normal.vmt" )
resource.AddFile( "materials/models/taxi/taxicolor.vtf" )
resource.AddFile( "materials/models/taxi/taxicolor.vmt" )
resource.AddFile( "materials/models/taxi/taxicolor_normal.vtf" )
resource.AddFile( "materials/models/taxi/taxicolor_normal.vmt" )
resource.AddFile( "materials/models/taxi/vehicle_generic_detail2.vtf" )
resource.AddFile( "materials/models/taxi/vehicle_generic_detail2.vmt" )
resource.AddFile( "materials/models/taxi/vehicle_generic_glasswindows2.vtf" )
resource.AddFile( "materials/models/taxi/vehicle_generic_glasswindows2.vmt" )
resource.AddFile( "materials/models/taxi/vehicle_generic_interior.vtf" )
resource.AddFile( "materials/models/taxi/vehicle_generic_interior.vmt" )
resource.AddFile( "materials/models/taxi/vehicle_generic_tyrewallblack.vtf" )
resource.AddFile( "materials/models/taxi/vehicle_generic_tyrewallblack.vmt" )

resource.AddFile( "materials/models/taxi/vehicle_generic_detail2_normal.vtf" )
resource.AddFile( "materials/models/taxi/vehicle_generic_glasswindows2_normal.vtf" )
resource.AddFile( "materials/models/taxi/vehicle_generic_tyrewallblack_normal.vtf" )
]]--


ENT.NrOfSeats = 5
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
ENT.CarModel = "models/taxi1.mdl"
ENT.TireModel = "models/Splayn/impala88_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 5
	yPos = -23
	zPos = 0
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 5
	yPos = 12
	zPos = 0	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -30
	yPos = -5
	zPos = 0	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -30
	yPos = -23
	zPos = 0		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -30
	yPos = 12
	zPos = 0
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 60
	yPos = -33
	zPos = 0	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 60
	yPos = 22
	zPos = 0		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -44
	yPos = -33
	zPos = 0	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -44
	yPos = 22
	zPos = 0	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	


	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 91
	yPos = -15
	zPos = 17	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 91
	yPos = 26
	zPos = 17	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -93
	yPos = 30
	zPos = 	20
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -93
	yPos = -19
	zPos = 20
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 62
	yPos = 0
	zPos = 30	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	

	--The position of the exhaust
	xPos = -90
	yPos = 25
	zPos = 3		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 27
	self.DefaultSoftnesRear = 27	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
