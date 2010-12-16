--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/dean/gtaiv/vehicles/banshee.mdl" )
resource.AddFile( "models/dean/gtaiv/vehicles/bansheewheel.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Banshee.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_Banshee.vmt" )

resource.AddFile( "materials/models/gtaiv/vehicles/black.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/black.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/blue.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/blue.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/green.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/green.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/red.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/red.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_carbon.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_carbon.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_detail2.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_detail2.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_doorshut.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_doorshut.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_glasswindows2.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_glasswindows2.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_tyrewallblack.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_tyrewallblack.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/white.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/white.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/yellow.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/yellow.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_carbon_normal.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_detail2_normal.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_doorshut_normal.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/vehicle_generic_tyrewall_normal.vtf" )

resource.AddFile( "materials/models/gtaiv/vehicles/banshee/banshee_badges.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/banshee/banshee_badges.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/banshee/banshee_interior.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/banshee/banshee_interior.vmt" )
resource.AddFile( "materials/models/gtaiv/vehicles/banshee/banshee_lights_glass.vtf" )
resource.AddFile( "materials/models/gtaiv/vehicles/banshee/banshee_lights_glass.vmt" )
]]--

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
ENT.CarModel = "models/dean/gtaiv/vehicles/banshee_sep.mdl"
ENT.TireModel = "models/dean/gtaiv/vehicles/bansheewheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"

------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = -16
	yPos = -19
	zPos = 10
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = -16
	yPos = 19
	zPos = 10	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 63
	yPos = -35
	zPos = 9.5	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 63
	yPos = 35
	zPos = 9.5		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -48
	yPos = -35
	zPos = 9.5	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -48
	yPos = 35
	zPos = 9.5	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 87
	yPos = 25
	zPos = 30	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 87
	yPos = -25
	zPos = 30	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -98
	yPos = 20.5
	zPos = 29	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -98
	yPos = -20.5
	zPos = 29
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 61
	yPos = 0
	zPos = 37
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	

	--The position of the exhaust
	xPos = -28.3
	yPos = -40.7
	zPos = 6.5		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	xPos = -28.3
	yPos = 40.7
	zPos = 6.5		
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

