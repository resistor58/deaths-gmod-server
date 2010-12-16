--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/fordgt.mdl" )
resource.AddFile( "models/Splayn/fordgt_wh.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_fordGT.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_fordGT.vmt" )

resource.AddFile( "materials/Splayn/fordgt/black.vtf" )
resource.AddFile( "materials/Splayn/fordgt/body2.vtf" )
resource.AddFile( "materials/Splayn/fordgt/Body3.vtf" )
resource.AddFile( "materials/Splayn/fordgt/Body4.vtf" )
resource.AddFile( "materials/Splayn/fordgt/Body5.vtf" )
resource.AddFile( "materials/Splayn/fordgt/brake.vtf" )
resource.AddFile( "materials/Splayn/fordgt/conti.vtf" )
resource.AddFile( "materials/Splayn/fordgt/conti-sc2.vtf" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_BADGING.vtf" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_ENGINE.vtf" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_INTERIOR.vtf" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_KIT00_BRAKELIGHT_OFF.vtf" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_KIT00_HEADLIGHT_ON.vtf" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_MISC.vtf" )
resource.AddFile( "materials/Splayn/fordgt/lack.vtf" )
resource.AddFile( "materials/Splayn/fordgt/lex10.vtf" )
resource.AddFile( "materials/Splayn/fordgt/liner_env.vtf" )
resource.AddFile( "materials/Splayn/fordgt/metal1.vtf" )
resource.AddFile( "materials/Splayn/fordgt/mirror_tex.vtf" )
resource.AddFile( "materials/Splayn/fordgt/remap_ford.vtf" )
resource.AddFile( "materials/Splayn/fordgt/underbody.vtf" )
resource.AddFile( "materials/Splayn/fordgt/vehiclelights128.vtf" )
resource.AddFile( "materials/Splayn/fordgt/window.vtf" )

resource.AddFile( "materials/Splayn/fordgt/black.vmt" )
resource.AddFile( "materials/Splayn/fordgt/body2.vmt" )
resource.AddFile( "materials/Splayn/fordgt/Body3.vmt" )
resource.AddFile( "materials/Splayn/fordgt/Body4.vmt" )
resource.AddFile( "materials/Splayn/fordgt/Body5.vmt" )
resource.AddFile( "materials/Splayn/fordgt/brake.vmt" )
resource.AddFile( "materials/Splayn/fordgt/conti.vmt" )
resource.AddFile( "materials/Splayn/fordgt/conti-sc2.vmt" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_BADGING.vmt" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_ENGINE.vmt" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_INTERIOR.vmt" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_KIT00_BRAKELIGHT_OFF.vmt" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_KIT00_HEADLIGHT_ON.vmt" )
resource.AddFile( "materials/Splayn/fordgt/FORDGT_MISC.vmt" )
resource.AddFile( "materials/Splayn/fordgt/lack.vmt" )
resource.AddFile( "materials/Splayn/fordgt/lex10.vmt" )
resource.AddFile( "materials/Splayn/fordgt/liner_env.vmt" )
resource.AddFile( "materials/Splayn/fordgt/metal1.vmt" )
resource.AddFile( "materials/Splayn/fordgt/mirror_tex.vmt" )
resource.AddFile( "materials/Splayn/fordgt/remap_ford.vmt" )
resource.AddFile( "materials/Splayn/fordgt/underbody.vmt" )
resource.AddFile( "materials/Splayn/fordgt/vehiclelights128.vmt" )
resource.AddFile( "materials/Splayn/fordgt/window.vmt" )
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

ENT.DefaultSound = "vehicles/APC/apc_cruise_loop3.wav"
ENT.CarModel = "models/Splayn/fordgt.mdl"
ENT.TireModel = "models/Splayn/fordgt_wh.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 1
	yPos = -19
	zPos = 14
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 1
	yPos = 19
	zPos = 14
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 69
	yPos = -30
	zPos = 15	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 69
	yPos = 30
	zPos = 15		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -65
	yPos = -30
	zPos = 15	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -65
	yPos = 30
	zPos = 15	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 110
	yPos = 32
	zPos = 31	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 110
	yPos = -32
	zPos = 31	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -107
	yPos = 31
	zPos = 32	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -107
	yPos = -31
	zPos = 32
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 92
	yPos = 0
	zPos = 35	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -104
	yPos = 0
	zPos = 20		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
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
