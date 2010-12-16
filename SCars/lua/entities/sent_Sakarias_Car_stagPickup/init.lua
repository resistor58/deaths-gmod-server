--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/Splayn/stagpickup1.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_stagPickup.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_stagPickup.vmt" )

resource.AddFile( "materials/models/vigilante8/StagPickup/beeplate.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/beeplate.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/bf.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/bf.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/black_396.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/black_396.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Body1.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Body2.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Body3.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/body3.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/chrome.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/chrome.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/extras.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/extras.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/gm_engine.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/gm_engine.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/metal_door_02.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/metal_door_02.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/tekstura.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/tekstura.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Trailerside.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Trailerside.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Trailersidestripe.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Trailersidestripe.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_chrome_colour.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_chrome_colour.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_detail2.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_detail2".vmt )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_glasswindows2.vmt" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehiclelights128.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehiclelights128.vmt" )

resource.AddFile( "materials/models/vigilante8/StagPickup/beeplate_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Body_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/chrome_norm.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/flat_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/Trailerside_normal.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_glasswindows.vtf" )
resource.AddFile( "materials/models/vigilante8/StagPickup/vehicle_generic_glasswindows2_normal.vmt" )
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
ENT.StabilisationMultiplier = 100 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/Vigilante8/stagpickup1.mdl"
ENT.TireModel = "models/bobcatw.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 15
	yPos = -20
	zPos = 20
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 15
	yPos = 20
	zPos = 20	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	

	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 86
	yPos = -37
	zPos = 10	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 86
	yPos = 37
	zPos = 10		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -64
	yPos = -37
	zPos = 10	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -64
	yPos = 37
	zPos = 10	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	

	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 120
	yPos = 33
	zPos = 27	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 120
	yPos = -33
	zPos = 27	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -123
	yPos = 43
	zPos = 30	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -123
	yPos = -43
	zPos = 30
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )


	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 89
	yPos = 0
	zPos = 46
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	

	--The position of the exhaust
	xPos = -114
	yPos = -31
	zPos = 7		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	xPos = -114
	yPos = 31
	zPos = 7		
	self.exhaustPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 15
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
