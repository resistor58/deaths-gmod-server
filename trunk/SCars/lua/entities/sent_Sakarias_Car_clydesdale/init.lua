--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Vigilante8/clydesdale.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_clydesdale.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_clydesdale.vmt" )

resource.AddFile( "materials/models/vigilante8/Clydesdale/flat_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks.vmt" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks6.vmt" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks_3.vmt" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks_3.vtf" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks_3_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks_6.vmt" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks_glass.vmt" )
resource.AddFile( "materials/models/vigilante8/Clydesdale/pickup_trucks_glass.vtf" )
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
ENT.CarModel = "models/Vigilante8/clydesdale1.mdl"
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
	xPos = 85
	yPos = -38
	zPos = -5	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 85
	yPos = 38
	zPos = -5		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -53
	yPos = -38
	zPos = -5	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -53
	yPos = 38
	zPos = -5	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 121
	yPos = -35
	zPos = 22	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 121
	yPos = 35
	zPos = 22
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -100
	yPos = -42
	zPos = 20	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -100
	yPos = 42
	zPos = 20	
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 93
	yPos = 0
	zPos = 44	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -96
	yPos = -24
	zPos = 0		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 25
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
