--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/chevy66.mdl" )
resource.AddFile( "models/Splayn/chevy66_wheel.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_chevy66.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_chevy66.vmt" )

resource.AddFile( "materials/Splayn/chevy66/black.vtf" )
resource.AddFile( "materials/Splayn/chevy66/boden.vtf" )
resource.AddFile( "materials/Splayn/chevy66/body_env.vtf" )
resource.AddFile( "materials/Splayn/chevy66/chrome.vtf" )
resource.AddFile( "materials/Splayn/chevy66/darkgrey.vtf" )
resource.AddFile( "materials/Splayn/chevy66/engine.vtf" )
resource.AddFile( "materials/Splayn/chevy66/Innerself.vtf" )
resource.AddFile( "materials/Splayn/chevy66/leather.vtf" )
resource.AddFile( "materials/Splayn/chevy66/ledera.vtf" )
resource.AddFile( "materials/Splayn/chevy66/lederb.vtf" )
resource.AddFile( "materials/Splayn/chevy66/orange.vtf" )
resource.AddFile( "materials/Splayn/chevy66/plateback1.vtf" )
resource.AddFile( "materials/Splayn/chevy66/profil.vtf" )
resource.AddFile( "materials/Splayn/chevy66/red.vtf" )
resource.AddFile( "materials/Splayn/chevy66/remappremier92body128.vtf" )
resource.AddFile( "materials/Splayn/chevy66/shegrey.vtf" )
resource.AddFile( "materials/Splayn/chevy66/tex1.vtf" )
resource.AddFile( "materials/Splayn/chevy66/tex2.vtf" )
resource.AddFile( "materials/Splayn/chevy66/tex2_env.vtf" )
resource.AddFile( "materials/Splayn/chevy66/white64.vtf" )
resource.AddFile( "materials/Splayn/chevy66/white_s.vtf" )
resource.AddFile( "materials/Splayn/chevy66/whitea128.vtf" )
resource.AddFile( "materials/Splayn/chevy66/windscreen.vtf" )
resource.AddFile( "materials/Splayn/chevy66/wood50.vtf" )
resource.AddFile( "materials/Splayn/chevy66/Wood_env.vtf" )

resource.AddFile( "materials/Splayn/chevy66/black.vmt" )
resource.AddFile( "materials/Splayn/chevy66/boden.vmt" )
resource.AddFile( "materials/Splayn/chevy66/darkgrey.vmt" )
resource.AddFile( "materials/Splayn/chevy66/engine.vmt" )
resource.AddFile( "materials/Splayn/chevy66/Innerself.vmt" )
resource.AddFile( "materials/Splayn/chevy66/leather.vmt" )
resource.AddFile( "materials/Splayn/chevy66/ledera.vmt" )
resource.AddFile( "materials/Splayn/chevy66/lederb.vmt" )
resource.AddFile( "materials/Splayn/chevy66/orange.vmt" )
resource.AddFile( "materials/Splayn/chevy66/plateback1.vmt" )
resource.AddFile( "materials/Splayn/chevy66/profil.vmt" )
resource.AddFile( "materials/Splayn/chevy66/red.vmt" )
resource.AddFile( "materials/Splayn/chevy66/remappremier92body128.vmt" )
resource.AddFile( "materials/Splayn/chevy66/shegrey.vmt" )
resource.AddFile( "materials/Splayn/chevy66/tex1.vmt" )
resource.AddFile( "materials/Splayn/chevy66/tex2.vmt" )
resource.AddFile( "materials/Splayn/chevy66/white.vmt" )
resource.AddFile( "materials/Splayn/chevy66/white64.vmt" )
resource.AddFile( "materials/Splayn/chevy66/white_s.vmt" )
resource.AddFile( "materials/Splayn/chevy66/whitea128.vmt" )
resource.AddFile( "materials/Splayn/chevy66/windscreen.vmt" )
resource.AddFile( "materials/Splayn/chevy66/wood50.vmt" )
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
ENT.CarModel = "models/Splayn/chevy66.mdl"
ENT.TireModel = "models/Splayn/chevy66_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 10
	yPos = -19
	zPos = 20
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 10
	yPos = 19
	zPos = 20	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -25
	yPos = 0
	zPos = 20	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -25
	yPos = -19
	zPos = 20		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -25
	yPos = 19
	zPos = 20
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 71
	yPos = -32
	zPos = 10	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 71
	yPos = 32
	zPos = 10		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -60
	yPos = -32
	zPos = 10	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -60
	yPos = 32
	zPos = 10	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 105
	yPos = 32
	zPos = 27	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 105
	yPos = -32
	zPos = 27	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -113
	yPos = 30
	zPos = 35	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -113
	yPos = -30
	zPos = 35
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 60
	yPos = 0
	zPos = 40	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -95
	yPos = -18
	zPos = 20		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 20
	self.DefaultSoftnesRear = 20	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
