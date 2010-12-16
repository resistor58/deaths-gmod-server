--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Ratmobile/Ratmobile.mdl" )
resource.AddFile( "models/Ratmobile/Ratmobile_wheel.mdl" )
resource.AddFile( "models/nova/airboat_seat.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Ratmobile.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Ratmobile.vmt" )

resource.AddFile( "materials/models/Ratmobile/Ratmobile.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_blue.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_red.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_ilumination.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_blue_ilumination.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_red_ilumination.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_destroyed.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_lightwarp.vtf" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_normal.vtf" )

resource.AddFile( "materials/models/Ratmobile/Ratmobile.vmt" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_blue.vmt" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_red.vmt" )
resource.AddFile( "materials/models/Ratmobile/Ratmobile_destroyed.vmt" )
]]--

ENT.NrOfSeats = 1
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

ENT.DefaultSound = "vehicles/Ratmobile/fourth_cruise_loop2.wav"
ENT.CarModel = "models/DIPRIP/Ratmobile/Ratmobile.mdl"
ENT.TireModel = "models/DIPRIP/Ratmobile/Ratmobile_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = -24
	yPos = 0
	zPos = -14
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 50
	yPos = -40
	zPos = -13	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 50
	yPos = 40
	zPos = -13		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -78
	yPos = -40
	zPos = -13	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -78
	yPos = 40
	zPos = -13	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 78
	yPos = -30
	zPos = -6	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 78
	yPos = 30
	zPos = -6	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -93
	yPos = -32
	zPos = 4	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -93
	yPos = 32
	zPos = 4
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 57
	yPos = 0
	zPos = 7	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -92
	yPos = -21
	zPos = -7		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--The position of the exhaust
	xPos = -92
	yPos = 21
	zPos = -7		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = 6
	yPos = -44
	zPos = 14		
	self.exhaustPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = 6
	yPos = 44
	zPos = 14		
	self.exhaustPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -2
	yPos = -44
	zPos = 14		
	self.exhaustPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -2
	yPos = 44
	zPos = 14		
	self.exhaustPos6 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -8
	yPos = -44
	zPos = 14		
	self.exhaustPos7 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -8
	yPos = 44
	zPos = 14		
	self.exhaustPos8 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 15
	self.DefaultSoftnesRear = 15	
		
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
