--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/ford_mustang_fastback_gt.mdl" )
resource.AddFile( "models/Splayn/mustang_wheel.mdl" )
resource.AddFile( "models/nova/airboat_seat.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_mustang.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_mustang.vmt" )

resource.AddFile( "materials/Splayn/FMFGT/661C1C1C.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/bfgood.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_2.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_3.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_4.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_5.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bullitt1.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bullitt2.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Bullitt3.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Carpet.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Carpet2.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/chrome.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Discbrake.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/FF000000.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/FF00006E.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/FFFFFFFF.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/Glass.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/liner_env.vtf" )
resource.AddFile( "materials/Splayn/FMFGT/tyre64a.vtf" )

resource.AddFile( "materials/Splayn/FMFGT/661C1C1C.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/bfgood.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_2.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_3.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_4.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bodytex_5.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bullitt1.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bullitt2.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Bullitt3.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Carpet.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Carpet2.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/chrome.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Discbrake.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/FF000000.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/FF00006E.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/FFFFFFFF.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/Glass.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/liner_env.vmt" )
resource.AddFile( "materials/Splayn/FMFGT/tyre64a.vmt" )
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

ENT.DefaultSound = "vehicles/Airboat/fan_motor_fullthrottle_loop1.wav"
ENT.CarModel = "models/Splayn/ford_mustang_fastback_gt.mdl"
ENT.TireModel = "models/Splayn/mustang_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	//POSITIONS

	

	




end

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = -5
	yPos = -20
	zPos = 13
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = -5
	yPos = 20
	zPos = 13	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -38
	yPos = 0
	zPos = 13	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -38
	yPos = -20
	zPos = 13		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -38
	yPos = 20
	zPos = 13		
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 77
	yPos = -32
	zPos = 5	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 77
	yPos = 32
	zPos = 5		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -63
	yPos = -32
	zPos = 5	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -63
	yPos = 32
	zPos = 5	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 111
	yPos = 32
	zPos = 24	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 111
	yPos = -32
	zPos = 24	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -113
	yPos = 31
	zPos = 26	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -113
	yPos = -31
	zPos = 26
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 74
	yPos = 0
	zPos = 34	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -108
	yPos = -20.5
	zPos = 8		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--The position of the exhaust
	xPos = -108
	yPos = 20.5
	zPos = 8		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 16
	self.DefaultSoftnesRear = 16	
		
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
