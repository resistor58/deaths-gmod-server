--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
--[[
//Models
resource.AddFile( "models/Splayn/hummer_h2.mdl" )
resource.AddFile( "models/Splayn/hummerwh_h2.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_hummer.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_hummer.vmt" )

resource.AddFile( "materials/Splayn/h2/FF262601.vtf" )
resource.AddFile( "materials/Splayn/h2/FF595959.vtf" )
resource.AddFile( "materials/Splayn/h2/FFBABA01.vtf" )
resource.AddFile( "materials/Splayn/h2/Glass.vtf" )
resource.AddFile( "materials/Splayn/h2/Body5.vtf" )
resource.AddFile( "materials/Splayn/h2/h2body_S1.vtf" )
resource.AddFile( "materials/Splayn/h2/h2body_s2.vtf" )
resource.AddFile( "materials/Splayn/h2/h2body_s3.vtf" )
resource.AddFile( "materials/Splayn/h2/h2body_s4.vtf" )
resource.AddFile( "materials/Splayn/h2/h2body_s5.vtf" )
resource.AddFile( "materials/Splayn/h2/h2details.vtf" )
resource.AddFile( "materials/Splayn/h2/h2inside.vtf" )
resource.AddFile( "materials/Splayn/h2/h2inside2.vtf" )
resource.AddFile( "materials/Splayn/h2/h2parts.vtf" )
resource.AddFile( "materials/Splayn/h2/liner_env.vtf" )
resource.AddFile( "materials/Splayn/h2/wheel.vtf" )

resource.AddFile( "materials/Splayn/h2/FF262601.vmt" )
resource.AddFile( "materials/Splayn/h2/FF595959.vmt" )
resource.AddFile( "materials/Splayn/h2/FFBABA01.vmt" )
resource.AddFile( "materials/Splayn/h2/Glass.vmt" )
resource.AddFile( "materials/Splayn/h2/Body5.vmt" )
resource.AddFile( "materials/Splayn/h2/h2body_S1.vmt" )
resource.AddFile( "materials/Splayn/h2/h2body_s2.vmt" )
resource.AddFile( "materials/Splayn/h2/h2body_s3.vmt" )
resource.AddFile( "materials/Splayn/h2/h2body_s4.vmt" )
resource.AddFile( "materials/Splayn/h2/h2body_s5.vmt" )
resource.AddFile( "materials/Splayn/h2/h2details.vmt" )
resource.AddFile( "materials/Splayn/h2/h2inside.vmt" )
resource.AddFile( "materials/Splayn/h2/h2inside2.vmt" )
resource.AddFile( "materials/Splayn/h2/h2parts.vmt" )
resource.AddFile( "materials/Splayn/h2/liner_env.vmt" )
resource.AddFile( "materials/Splayn/h2/wheel.vmt" )
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

ENT.DefaultSound =  "vehicles/v8/fourth_cruise_loop2.wav"
ENT.CarModel = "models/Splayn/hummer_h2.mdl"
ENT.TireModel = "models/Splayn/hummerwh_h2.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 10
	yPos = -22
	zPos = -15
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 10
	yPos = 22
	zPos = -15	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -40
	yPos = 0
	zPos = -10	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -40
	yPos = -22
	zPos = -10		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -40
	yPos = 22
	zPos = -10		
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 73
	yPos = -38
	zPos = -37	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 73
	yPos = 38
	zPos = -37		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -73
	yPos = -38
	zPos = -37	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -73
	yPos = 38
	zPos = -37	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 109
	yPos = 23
	zPos = -5	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 109
	yPos = -23
	zPos = -5	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -106
	yPos = 37
	zPos = 5	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -106
	yPos = -37
	zPos = 5
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 87
	yPos = 0
	zPos = 8	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	--The position of the exhaust
	xPos = -100
	yPos = -21
	zPos = -37		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Stabilisation
	self.StabiliserOffset = Vector(0,0,-20)	
	self.StabilisationMultiplier = 150
	
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
