--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/belair.mdl" )
resource.AddFile( "models/Splayn/belair_wheel.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_belair.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_belair.vmt" )

resource.AddFile( "materials/Splayn/belair/black64.vtf" )
resource.AddFile( "materials/Splayn/belair/vehiclelights128.vtf" )
resource.AddFile( "materials/Splayn/belair/body2.vtf" )
resource.AddFile( "materials/Splayn/belair/Body3.vtf" )
resource.AddFile( "materials/Splayn/belair/Body4.vtf" )
resource.AddFile( "materials/Splayn/belair/Body5.vtf" )
resource.AddFile( "materials/Splayn/belair/FF0000FF.vtf" )
resource.AddFile( "materials/Splayn/belair/FF6B6B6E.vtf" )
resource.AddFile( "materials/Splayn/belair/FF00628E.vtf" )
resource.AddFile( "materials/Splayn/belair/FFFF0000.vtf" )
resource.AddFile( "materials/Splayn/belair/FFFFFFFF.vtf" )
resource.AddFile( "materials/Splayn/belair/Glass.vtf" )
resource.AddFile( "materials/Splayn/belair/grey64.vtf" )
resource.AddFile( "materials/Splayn/belair/lack.vtf" )
resource.AddFile( "materials/Splayn/belair/liner_env.vtf" )
resource.AddFile( "materials/Splayn/belair/lm01.vtf" )
resource.AddFile( "materials/Splayn/belair/main.vtf" )
resource.AddFile( "materials/Splayn/belair/mychref.vtf" )
resource.AddFile( "materials/Splayn/belair/Numberplate.vtf" )
resource.AddFile( "materials/Splayn/belair/red64.vtf" )
resource.AddFile( "materials/Splayn/belair/tirelm.vtf" )

resource.AddFile( "materials/Splayn/belair/black64.vmt" )
resource.AddFile( "materials/Splayn/belair/vehiclelights128.vmt" )
resource.AddFile( "materials/Splayn/belair/body2.vmt" )
resource.AddFile( "materials/Splayn/belair/Body3.vmt" )
resource.AddFile( "materials/Splayn/belair/Body4.vmt" )
resource.AddFile( "materials/Splayn/belair/Body5.vmt" )
resource.AddFile( "materials/Splayn/belair/FF0000FF.vmt" )
resource.AddFile( "materials/Splayn/belair/FF6B6B6E.vmt" )
resource.AddFile( "materials/Splayn/belair/FF00628E.vmt" )
resource.AddFile( "materials/Splayn/belair/FFFF0000.vmt" )
resource.AddFile( "materials/Splayn/belair/FFFFFFFF.vmt" )
resource.AddFile( "materials/Splayn/belair/Glass.vmt" )
resource.AddFile( "materials/Splayn/belair/grey64.vmt" )
resource.AddFile( "materials/Splayn/belair/lack.vmt" )
resource.AddFile( "materials/Splayn/belair/liner_env.vmt" )
resource.AddFile( "materials/Splayn/belair/lm01.vmt" )
resource.AddFile( "materials/Splayn/belair/main.vmt" )
resource.AddFile( "materials/Splayn/belair/mychref.vmt" )
resource.AddFile( "materials/Splayn/belair/Numberplate.vmt" )
resource.AddFile( "materials/Splayn/belair/red64.vmt" )
resource.AddFile( "materials/Splayn/belair/tirelm.vmt" )
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

ENT.DefaultSound = "vehicles/Airboat/fan_motor_idle_loop1.wav"
ENT.CarModel = "models/Splayn/belair.mdl"
ENT.TireModel = "models/Splayn/belair_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 17
	yPos = -19
	zPos = 20
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 17
	yPos = 19
	zPos = 20	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -18
	yPos = 0
	zPos = 20	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -18
	yPos = -19
	zPos = 20		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -18
	yPos = 19
	zPos = 20		
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	

	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 81
	yPos = -35
	zPos = 7	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 81
	yPos = 35
	zPos = 7		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -52
	yPos = -35
	zPos = 10	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -52
	yPos = 35
	zPos = 10	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	


	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 117
	yPos = 35
	zPos = 26	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 117
	yPos = -35
	zPos = 26	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -115
	yPos = 32
	zPos = 32	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -115
	yPos = -32
	zPos = 32
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 87
	yPos = 0
	zPos = 40	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -115
	yPos = -37.5
	zPos = 15		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 17
	self.DefaultSoftnesRear = 22	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end

