--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/cadillac.mdl" )
resource.AddFile( "models/Splayn/cadillac_wh.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_cadillac.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_cadillac.vmt" )

resource.AddFile( "materials/Splayn/Caddilac/59caddy.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/black.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/body2.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/Body3.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/Body4.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/Body5.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/cad_env.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/Crome.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/FFFFFFFF.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/Glass.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/lack.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/liner_env.vtf" )
resource.AddFile( "materials/Splayn/Caddilac/vehiclelights128.vtf" )

resource.AddFile( "materials/Splayn/Caddilac/59caddy.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/black.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/body2.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/Body3.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/Body4.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/Body5.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/cad_env.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/Crome.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/FFFFFFFF.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/Glass.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/lack.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/liner_env.vmt" )
resource.AddFile( "materials/Splayn/Caddilac/vehiclelights128.vmt" )

resource.AddFile( "materials/Splayn/chrome.vtf" )
resource.AddFile( "materials/Splayn/imp01.vtf" )
resource.AddFile( "materials/Splayn/imp02.vtf" )
resource.AddFile( "materials/Splayn/imp03.vtf" )
resource.AddFile( "materials/Splayn/imp_env.vtf" )
resource.AddFile( "materials/Splayn/liner222.vtf" )
resource.AddFile( "materials/Splayn/liner_env.vtf" )
resource.AddFile( "materials/Splayn/tireimp.vtf" )
resource.AddFile( "materials/Splayn/window.vtf" )

resource.AddFile( "materials/Splayn/chrome.vmt" )
resource.AddFile( "materials/Splayn/imp01.vmt" )
resource.AddFile( "materials/Splayn/imp02.vmt" )
resource.AddFile( "materials/Splayn/imp03.vmt" )
resource.AddFile( "materials/Splayn/imp_env.vmt" )
resource.AddFile( "materials/Splayn/liner222.vmt" )
resource.AddFile( "materials/Splayn/liner_env.vmt" )
resource.AddFile( "materials/Splayn/tireimp.vmt" )
resource.AddFile( "materials/Splayn/window.vmt" )
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
ENT.StabilisationMultiplier = 70 --70 is default

ENT.DefaultSound = "vehicles/Airboat/fan_motor_idle_loop1.wav"
ENT.CarModel = "models/Splayn/cadillac.mdl"
ENT.TireModel = "models/Splayn/cadillac_wh.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0


	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 30
	yPos = -25
	zPos = 25
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 30
	yPos = 25
	zPos = 25	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -12
	yPos = 0
	zPos = 25	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -12
	yPos = -25
	zPos = 25		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -12
	yPos = 25
	zPos = 25		
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	

	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 93
	yPos = -34
	zPos = 17	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 93
	yPos = 34
	zPos = 17		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -65
	yPos = -34
	zPos = 15	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -65
	yPos = 34
	zPos = 15	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 137
	yPos = 34
	zPos = 37
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 137
	yPos = -34
	zPos = 37	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -136
	yPos = 41
	zPos = 26	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -136
	yPos = -41
	zPos = 26
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 85
	yPos = 0
	zPos = 40	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -110
	yPos = -18
	zPos = 15		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--The position of the exhaust2
	xPos = -110
	yPos = 18
	zPos = 15		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
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
