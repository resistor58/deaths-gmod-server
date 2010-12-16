--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')



//Models
resource.AddFile( "models/Splayn/studebaker_lark.mdl" )
resource.AddFile( "models/Splayn/studebaker_wh.mdl" )
resource.AddFile( "models/nova/airboat_seat.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_studebaker.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_studebaker.vmt" )

resource.AddFile( "materials/Splayn/Studebaker/2obivka.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/body.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/Body2.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/Body3.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/Body4.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/Body5.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/body_chrom.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/dvigatel.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/Glass.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/IMG_1176.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/liner_env.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/lack.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/obivka.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/plate.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/pokruska.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/underbody.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/vehiclegeneric256.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/vehiclelights128.vtf" )
resource.AddFile( "materials/Splayn/Studebaker/vette_dam.vtf" )

resource.AddFile( "materials/Splayn/Studebaker/2obivka.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/body.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/Body2.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/Body3.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/Body4.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/Body5.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/body_chrom.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/dvigatel.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/Glass.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/IMG_1176.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/liner_env.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/lack.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/obivka.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/plate.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/pokruska.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/underbody.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/vehiclegeneric256.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/vehiclelights128.vmt" )
resource.AddFile( "materials/Splayn/Studebaker/vette_dam.vmt" )

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
ENT.StabilisationMultiplier = 50 --50 is default

ENT.DefaultSound = "vehicles/Airboat/fan_motor_idle_loop1.wav"
ENT.CarModel = "models/Splayn/studebaker_lark.mdl"
ENT.TireModel = "models/Splayn/studebaker_wh.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0
	
	
	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 5
	yPos = -16
	zPos = 20
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 5
	yPos = 16
	zPos = 20	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 3 (Middle rear seat)	
	xPos = -45
	yPos = 0
	zPos = 24	
	self.SeatPos3 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 4 (Left rear seat)	
	xPos = -45
	yPos = -16
	zPos = 24		
	self.SeatPos4 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Seat Position 5 (Right rear seat)	
	xPos = -45
	yPos = 16
	zPos = 24		
	self.SeatPos5 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 73
	yPos = -27
	zPos = 12	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 73
	yPos = 27
	zPos = 12		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -70
	yPos = -27
	zPos = 12	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -70
	yPos = 27
	zPos = 12
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 107
	yPos = 31
	zPos = 33	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 107
	yPos = -31
	zPos = 33	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -113
	yPos = 32
	zPos = 35	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -113
	yPos = -32
	zPos = 35
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 80
	yPos = 0
	zPos = 46	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -115
	yPos = -18
	zPos = 19		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 25
	self.DefaultSoftnesRear = 25	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end
