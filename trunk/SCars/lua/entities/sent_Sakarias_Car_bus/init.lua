--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/bus.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_bus.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_bus.vmt" )

resource.AddFile( "materials/models/Borderlands/Bus/BusExterior1.vmt" )
resource.AddFile( "materials/models/Borderlands/Bus/BusExterior1.vtf" )
resource.AddFile( "materials/models/Borderlands/Bus/BusExterior2.vmt" )
resource.AddFile( "materials/models/Borderlands/Bus/BusExterior2.vtf" )
resource.AddFile( "materials/models/Borderlands/Bus/BusSkin1.vmt" )
resource.AddFile( "materials/models/Borderlands/Bus/BusSkin1.vtf" )
resource.AddFile( "materials/models/Borderlands/Bus/BusSkin2.vmt" )
resource.AddFile( "materials/models/Borderlands/Bus/BusSkin2.vtf" )

resource.AddFile( "materials/models/Borderlands/Bus/Special/BusExterior1-BumpMap.vtf" )
resource.AddFile( "materials/models/Borderlands/Bus/Special/BusExterior2-BumpMap.vtf" )
resource.AddFile( "materials/models/Borderlands/Bus/Special/BusSkin1-BumpMap.vtf" )
resource.AddFile( "materials/models/Borderlands/Bus/Special/BusSkin2-BumpMap.vtf" )
--]]

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
ENT.CarMass = 1500
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 70 --70 is default


ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/Borderlands/Bus/bus.mdl"
ENT.TireModel = "models/Splayn/hummerwh_h2.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 132
	yPos = -34
	zPos = 75
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = -18
	yPos = 33.5
	zPos = 71	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -81
	yPos = 33.5
	zPos = 71	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -18
	yPos = -33.5
	zPos = 71		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -81
	yPos = -33.5
	zPos = 71
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	


	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 96
	yPos = -50
	zPos = 45	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 96
	yPos = 50
	zPos = 45		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -100
	yPos = -50
	zPos = 45	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -100
	yPos = 50
	zPos = 45	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	


	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 173
	yPos = 38
	zPos = 78	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 173
	yPos = -38
	zPos = 78	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -195
	yPos = 52
	zPos = 85	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -195
	yPos = -52
	zPos = 85
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = -195
	yPos = 0
	zPos = 82	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position of the exhaust
	xPos = -210
	yPos = 30.5
	zPos = 115		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Stabilisation
	self.StabiliserOffset = Vector(0,0,50)
	self.StabilisationMultiplier = 150
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 36
	self.DefaultSoftnesRear = 36	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
	
	
	self.SteerResponse = 0.1
	self.Entity.SteerResponse = 0.1
	self.SteerForce = 1
	self.Entity.SteerForce = 1	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
