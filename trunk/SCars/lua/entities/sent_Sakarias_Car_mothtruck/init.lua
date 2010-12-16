--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Vigilante8/mothtruck.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_mothtruck.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_mothtruck.vmt" )

resource.AddFile( "materials/models/vigilante8/MothTruck/flat_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/MothTruck/flatnose_truck.vmt" )
resource.AddFile( "materials/models/vigilante8/MothTruck/flatnose_truck.vtf" )
resource.AddFile( "materials/models/vigilante8/MothTruck/flatnose_truck_glass.vmt" )
resource.AddFile( "materials/models/vigilante8/MothTruck/flatnose_truck_glass.vtf" )
resource.AddFile( "materials/models/vigilante8/MothTruck/flatnose_truck_normal.vtf" )
]]--

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
ENT.CarMass = 1500
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 300 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/Vigilante8/mothtruck.mdl"
ENT.TireModel = "models/Splayn/hummerwh_h2.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 81
	yPos = -18
	zPos = 60
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 81
	yPos = 18
	zPos = 60
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
		
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 150
	yPos = -48
	zPos = 18	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 150
	yPos = 48
	zPos = 18		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -16
	yPos = -48
	zPos = 18	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -16
	yPos = 48
	zPos = 18	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 182.5
	yPos = -40
	zPos = 55
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 182.5
	yPos = 40
	zPos = 55	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -65
	yPos = -15
	zPos = 20	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -65
	yPos = 15
	zPos = 20	
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 163
	yPos = 0
	zPos = 109	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position of the exhaust
	xPos = 48
	yPos = 30
	zPos = 165		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	xPos = 48
	yPos = -30
	zPos = 165		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Stabilisation
	self.StabiliserOffset = Vector(0,0,50)
	self.StabilisationMultiplier = 150
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 60
	self.DefaultSoftnesRear = 60	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
	
	
	self.SteerResponse = 0.1
	self.Entity.SteerResponse = 0.1
	self.SteerForce = 3
	self.Entity.SteerForce = 3	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
