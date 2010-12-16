--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/impala88.mdl" )
resource.AddFile( "models/Splayn/impala88_wheel.mdl" )

resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_impala88.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_impala88.vmt" )

--It's kind of hard to find all the textures for some cars.
--Not sure if these are the correct textures but let's hope so
resource.AddFile( "materials/Splayn/chrome.vtf" )
resource.AddFile( "materials/Splayn/chrome.vmt" )
resource.AddFile( "materials/Splayn/imp01.vtf" )
resource.AddFile( "materials/Splayn/imp01.vmt" )
resource.AddFile( "materials/Splayn/imp02.vtf" )
resource.AddFile( "materials/Splayn/imp02.vmt" )
resource.AddFile( "materials/Splayn/imp03.vtf" )
resource.AddFile( "materials/Splayn/imp03.vmt" )
resource.AddFile( "materials/Splayn/imp_env.vtf" )
resource.AddFile( "materials/Splayn/imp_env.vmt" )
resource.AddFile( "materials/Splayn/liner222.vtf" )
resource.AddFile( "materials/Splayn/liner222.vmt" )
resource.AddFile( "materials/Splayn/liner_env.vtf" )
resource.AddFile( "materials/Splayn/liner_env.vmt" )
resource.AddFile( "materials/Splayn/tireimp.vtf" )
resource.AddFile( "materials/Splayn/tireimp.vmt" )
resource.AddFile( "materials/Splayn/window.vtf" )
resource.AddFile( "materials/Splayn/window.vmt" )
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
ENT.CarModel = "models/Splayn/impala88_sep.mdl"
ENT.TireModel = "models/Splayn/impala88_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 6
	yPos = -19
	zPos = 5
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 6
	yPos = 19
	zPos = 5	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -31
	yPos = 0
	zPos = 5	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -31
	yPos = -19
	zPos = 5		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -31
	yPos = 19
	zPos = 5
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 68
	yPos = -35
	zPos = -2	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 68
	yPos = 35
	zPos = -2		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -56
	yPos = -35
	zPos = -2	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -56
	yPos = 35
	zPos = -2	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 106
	yPos = 32
	zPos = 18	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 106
	yPos = -32
	zPos = 18	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -107
	yPos = 28
	zPos = 18	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -107
	yPos = -28
	zPos = 18
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 77
	yPos = 0
	zPos = 32	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -97
	yPos = -23
	zPos = 3		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 21
	self.DefaultSoftnesRear = 26	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
