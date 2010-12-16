--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/dean/gtaiv/vehicles/comet.mdl" )
resource.AddFile( "models/dean/gtaiv/vehicles/comet_sep.mdl" )
resource.AddFile( "models/dean/gtaiv/vehicles/cometwheel.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Comet.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Comet.vmt" )

resource.AddFile( "materials/models/gtaiv/vehicles/comet/black.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/black.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/blue.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/blue.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_badges.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_badges.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_interior.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_interior.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_lights.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_lights.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/gaybow.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/gaybow.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/green.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/green.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/red.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/red.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/white.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/white.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/yellow.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/yellow.vmt" )

resource.AddFile( "materials/models/gtaiv/vehicles/comet/comet_badges_n.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/comet/gaybow_n.vtf" )
--]]

ENT.NrOfSeats = 2
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

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/dean/gtaiv/vehicles/comet_sep.mdl"
ENT.TireModel = "models/dean/gtaiv/vehicles/bansheewheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"

------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = -5
	yPos = -16
	zPos = 10
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = -5
	yPos = 16
	zPos = 10	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )



	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 50
	yPos = -28
	zPos = 11	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 50
	yPos = 28
	zPos = 11		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -44
	yPos = -31
	zPos = 10.5	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -44
	yPos = 31
	zPos = 10.5	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	


	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 75
	yPos = -25
	zPos = 26	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 75
	yPos = 25
	zPos = 26	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -80
	yPos = -22
	zPos = 27.5	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -80
	yPos = 22
	zPos = 27.5
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )



	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 61
	yPos = 0
	zPos = 34
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	

	--The position of the exhaust
	xPos = -81
	yPos = -19
	zPos = 11.5		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	xPos = -81
	yPos = 19
	zPos = 11.5			
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 20
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

