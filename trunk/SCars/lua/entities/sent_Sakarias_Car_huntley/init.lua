--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/huntley1.mdl" )
resource.AddFile( "models/huntleyw.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_huntley.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_huntley.vmt" )

resource.AddFile( "materials/models/huntley/78.vtf" )
resource.AddFile( "materials/models/huntley/78.vmt" )
resource.AddFile( "materials/models/huntley/78_normal.vtf" )
resource.AddFile( "materials/models/huntley/78_normal.vmt" )
resource.AddFile( "materials/models/huntley/cavalvade_interior.vtf" )
resource.AddFile( "materials/models/huntley/cavalvade_interior.vmt" )
resource.AddFile( "materials/models/huntley/huntley_badges.vtf" )
resource.AddFile( "materials/models/huntley/huntley_badges.vmt" )
resource.AddFile( "materials/models/huntley/huntley_lights.vtf" )
resource.AddFile( "materials/models/huntley/huntley_lights.vmt" )
resource.AddFile( "materials/models/huntley/vehicle_generic_detail2.vtf" )
resource.AddFile( "materials/models/huntley/vehicle_generic_detail2.vmt" )
resource.AddFile( "materials/models/huntley/vehicle_generic_glasswindows2.vtf" )
resource.AddFile( "materials/models/huntley/vehicle_generic_glasswindows2.vmt" )
resource.AddFile( "materials/models/huntley/vehicle_generic_tyrewallblack.vtf" )
resource.AddFile( "materials/models/huntley/vehicle_generic_tyrewallblack.vmt" )

resource.AddFile( "materials/models/huntley/vehicle_generic_detail2_normal.vtf" )
resource.AddFile( "materials/models/huntley/vehicle_generic_glasswindows2_normal.vtf" )
resource.AddFile( "materials/models/huntley/vehicle_generic_tyrewallblack_normal.vtf" )
]]--


ENT.NrOfSeats = 5
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
ENT.StabilisationMultiplier = 100 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/huntley1.mdl"
ENT.TireModel = "models/huntleyw.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 0
	yPos = -20
	zPos = 17
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 0
	yPos = 20
	zPos = 17	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -40
	yPos = 0
	zPos = 17	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -40
	yPos = -20
	zPos = 17		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -40
	yPos = 20
	zPos = 17
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	

	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 72
	yPos = -38
	zPos = -5
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 72
	yPos = 38
	zPos = -5		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -63
	yPos = -36
	zPos = -5	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -63
	yPos = 36
	zPos = -5	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 108
	yPos = 32
	zPos = 28	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 108
	yPos = -32
	zPos = 28	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -111
	yPos = 37
	zPos = 30	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -111
	yPos = -37
	zPos = 30
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 85
	yPos = 0
	zPos = 40	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -110
	yPos = -21
	zPos = 4		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	xPos = -110
	yPos = 21
	zPos = 4		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 18
	self.DefaultSoftnesRear = 18	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
