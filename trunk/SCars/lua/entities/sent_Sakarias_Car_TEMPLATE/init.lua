--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--It's important that these nubers are correct.
ENT.NrOfSeats = 5
ENT.NrOfExhausts = 1


--Don't change these NULL values
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

--You shouldn't change these either. Don't unless you know what you are doing.
ENT.DefaultSoftnesFront = 15
ENT.DefaultSoftnesRear = 15
ENT.CarMass = 500
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 50 --50 is default


--Set the models you want to use here
ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/Splayn/chevy66.mdl"
ENT.TireModel = "models/Splayn/chevy66_wheel.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"
------------------------------------VARIABLES END

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	--All you need to do is to change all the x,y and z positions.
	--The positions tell the entity where to put things.
	--The tuner stool can help you get the positions.
	--Go to line 71 in "SCars\lua\weapons\gmod_tool\stools\cartuning.lua" and uncomment the line.
	--Whenever you use the stool it will print out the local position.
	
	
	--X Positive = forward
	--X Negative = backwards

	--Y Positive = Right	
	--Y Negative = Left
	
	--Z Positive = Up
	--Z Negative = Down
	
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
	self.DefaultSoftnesFront = 15
	self.DefaultSoftnesRear = 15	
	
	
	--Setting up the SCar in the SCar base
	self:Setup()	
	
	--You can change the cars default characteristics here if you want to but you shouldn't unless you really need it.
	--You can always change these values in game with the tuner stool anyway.
	//Characteristics
	self.BreakEfficiency = 0.999
	self.DefaultBreakEfficiency = 0.96
	self.ReverseForce = 1000
	self.ReverseMaxSpeed = 200
	self.TurboEffect = 2
	self.TurboDuration = 4
	self.TurboDelay = 10
	self.Acceleration = 3000
	self.SteerForce = 5
	self.RealSteerForce = 0
	self.SteerResponse = 0.3
	self.MaxSpeed = 1500
	self.NrOfGears = 5
	self.AntiSlide = 1
	
	--When you are done you will also need to add your car in the SCar spawner stool.
	--Goto "SCars\lua\weapons\gmod_tool\stools\carspawner.lua" and add your car there.
	--The list is at the bottom of the file.
end


--The SCars special think function.
--This function is called every time the SCar base think function runs.
--You probablyh won't need this unless you want some kind of special effects or events.
function ENT:SpecialThink()
end

--If you for some reason need to spawn a prop or something like that you should remove it in this function.
--This function runs when the SCar base remove function runs.
function ENT:SpecialRemove()	
end

--This function runs only once when the car is spawned.
--Probably won't need this function either.
--A good exaple when to use it is in the Junker4 car.
--I need to create props and also need to reposition them when the SCar is spawned.
function ENT:SpecialReposition()
end
