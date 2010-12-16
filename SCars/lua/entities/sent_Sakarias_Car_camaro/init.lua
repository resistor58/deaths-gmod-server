--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/camaro_wow.mdl" )
resource.AddFile( "models/Splayn/camaro_wheel.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_camaro.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_camaro.vmt" )

resource.AddFile( "materials/Splayn/camaro/3C666666.vtf" )
resource.AddFile( "materials/Splayn/camaro/body2.vtf" )
resource.AddFile( "materials/Splayn/camaro/BODY3.vtf" )
resource.AddFile( "materials/Splayn/camaro/BODY4.vtf" )
resource.AddFile( "materials/Splayn/camaro/BODY5.vtf" )
resource.AddFile( "materials/Splayn/camaro/body_env.vtf" )
resource.AddFile( "materials/Splayn/camaro/camabody.vtf" )
resource.AddFile( "materials/Splayn/camaro/camaro1.vtf" )
resource.AddFile( "materials/Splayn/camaro/camaro2.vtf" )
resource.AddFile( "materials/Splayn/camaro/camaro3.vtf" )
resource.AddFile( "materials/Splayn/camaro/camaro4.vtf" )
resource.AddFile( "materials/Splayn/camaro/FF060606.vtf" )
resource.AddFile( "materials/Splayn/camaro/FF999999.vtf" )
resource.AddFile( "materials/Splayn/camaro/FFB4B4B4.vtf" )
resource.AddFile( "materials/Splayn/camaro/Glass.vtf" )
resource.AddFile( "materials/Splayn/camaro/liner_env.vtf" )
resource.AddFile( "materials/Splayn/camaro/numberplate.vtf" )
resource.AddFile( "materials/Splayn/camaro/remap_body.vtf" )
resource.AddFile( "materials/Splayn/camaro/tyre.vtf" )
resource.AddFile( "materials/Splayn/camaro/vehiclegeneric256.vtf" )
resource.AddFile( "materials/Splayn/camaro/vehiclelightsspl.vtf" )
resource.AddFile( "materials/Splayn/camaro/FF999999.vtf" )

resource.AddFile( "materials/Splayn/camaro/3C666666.vmt" )
resource.AddFile( "materials/Splayn/camaro/body2.vmt" )
resource.AddFile( "materials/Splayn/camaro/BODY3.vmt" )
resource.AddFile( "materials/Splayn/camaro/BODY4.vmt" )
resource.AddFile( "materials/Splayn/camaro/BODY5.vmt" )
resource.AddFile( "materials/Splayn/camaro/body_env.vmt" )
resource.AddFile( "materials/Splayn/camaro/camabody.vmt" )
resource.AddFile( "materials/Splayn/camaro/camaro1.vmt" )
resource.AddFile( "materials/Splayn/camaro/camaro2.vmt" )
resource.AddFile( "materials/Splayn/camaro/camaro3.vmt" )
resource.AddFile( "materials/Splayn/camaro/camaro4.vmt" )
resource.AddFile( "materials/Splayn/camaro/FF060606.vmt" )
resource.AddFile( "materials/Splayn/camaro/FF999999.vmt" )
resource.AddFile( "materials/Splayn/camaro/FFB4B4B4.vmt" )
resource.AddFile( "materials/Splayn/camaro/Glass.vmt" )
resource.AddFile( "materials/Splayn/camaro/liner_env.vmt" )
resource.AddFile( "materials/Splayn/camaro/numberplate.vmt" )
resource.AddFile( "materials/Splayn/camaro/remap_body.vmt" )
resource.AddFile( "materials/Splayn/camaro/tyre.vmt" )
resource.AddFile( "materials/Splayn/camaro/vehiclegeneric256.vmt" )
resource.AddFile( "materials/Splayn/camaro/vehiclelightsspl.vmt" )
resource.AddFile( "materials/Splayn/camaro/FF999999.vmt" )

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
resource.AddFile( "materials/Splayn/FMFGT/FF696969.vtf" )
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
resource.AddFile( "materials/Splayn/FMFGT/FF696969.vmt" )
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
ENT.CarModel = "models/Splayn/camaro_wow.mdl"
ENT.TireModel = "models/Splayn/camaro_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()


	
end

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = -2
	yPos = -18
	zPos = 20
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = -2
	yPos = 18
	zPos = 20	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -37
	yPos = 0
	zPos = 20	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -37
	yPos = -18
	zPos = 20		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -37
	yPos = 18
	zPos = 20		
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 73
	yPos = -32
	zPos = 12	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 73
	yPos = 32
	zPos = 12		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -67
	yPos = -32
	zPos = 12	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -67
	yPos = 32
	zPos = 12	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
		
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 112
	yPos = 28
	zPos = 28	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 112
	yPos = -28
	zPos = 28	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -115
	yPos = 24
	zPos = 35	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -115
	yPos = -24
	zPos = 35
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 82
	yPos = 0
	zPos = 42	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -104
	yPos = -32
	zPos = 16		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--The position of the exhaust2
	xPos = -104
	yPos = 32
	zPos = 16		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 17
	self.DefaultSoftnesRear = 17	
		
	--Setting up the SCar in the SCar base
	self:Setup()	
end


function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
