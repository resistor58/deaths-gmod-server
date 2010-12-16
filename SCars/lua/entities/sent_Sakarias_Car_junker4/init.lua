--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Models
resource.AddFile( "models/seat_m/seat_02.mdl" )
resource.AddFile( "models/seat_m/seat_02_phy.mdl" )
resource.AddFile( "models/seat_m/seat_chairl.mdl" )
resource.AddFile( "models/seat_m/seat_doorb.mdl" )
resource.AddFile( "models/seat_m/seat_doorl.mdl" )
resource.AddFile( "models/seat_m/seat_doorr.mdl" )
resource.AddFile( "models/seat_m/seat_hood.mdl" )

//Materials
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_junker4.vtf" )
resource.AddFile( "materials/VGUI/entities/sent_Sakarias_Car_junker4.vmt" )

resource.AddFile( "materials/models/seat_m/seat_D_B.vmt" )
resource.AddFile( "materials/models/seat_m/seat_D_B.vtf" )
resource.AddFile( "materials/models/seat_m/seat_D_G.vmt" )
resource.AddFile( "materials/models/seat_m/seat_D_G.vtf" )
resource.AddFile( "materials/models/seat_m/seat_D_R.vmt" )
resource.AddFile( "materials/models/seat_m/seat_D_R.vtf" )
resource.AddFile( "materials/models/seat_m/seat_wheel_D.vmt" )
resource.AddFile( "materials/models/seat_m/seat_wheel_D.vtf" )
resource.AddFile( "materials/models/seat_m/seat_NS.vtf" )
resource.AddFile( "materials/models/seat_m/seat_wheel_NS.vtf" )
resource.AddFile( "materials/models/seat_m/seat_windshield_DA.vmt" )
resource.AddFile( "materials/models/seat_m/seat_windshield_DA.vtf" )
]]--

ENT.NrOfSeats = 2
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
ENT.StabilisationMultiplier = 150 --70 is default

ENT.DefaultSound = "vehicles/v8/v8_firstgear_rev_loop1.wav"
ENT.CarModel = "models/seat_m/seat_02.mdl"
ENT.TireModel = "models/props_vehicles/carparts_wheel01a.mdl"
ENT.SeatModel = "models/nova/airboat_seat.mdl"

ENT.DefaultSound = "vehicles/APC/apc_cruise_loop3.wav"

--Special variables
ENT.PropSeat1 = NULL
ENT.PropSeat2 = NULL
ENT.LeftDoor = NULL
ENT.RightDoor = NULL
ENT.Hood = NULL
ENT.BackDoor = NULL

ENT.LeftDoorConstraint = NULL
ENT.RightDoorConstraint = NULL
ENT.HoodConstraint = NULL
ENT.BackDoorConstraint = NULL
ENT.LeftDoorConstraint2 = NULL
ENT.RightDoorConstraint2 = NULL
ENT.HoodConstraint2 = NULL
ENT.BackDoorConstraint2 = NULL

ENT.PartLevel = 0
ENT.PercentLevel = 0.9
ENT.FixConstraints = false
ENT.CarCol = 0

function ENT:Initialize()

	local xPos = 0
	local yPos = 0
	local zPos = 0

	//SEAT POSITIONS
	--Seat Position 1 (Driver seat)
	xPos = 1
	yPos = -15
	zPos = 20
	self.SeatPos1 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--Seat Position 2 (Right front seat)
	xPos = 1
	yPos = 15
	zPos = 20	
	self.SeatPos2 = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//WHEEL POSITIONS
	--Front Left wheel
	xPos = 52
	yPos = -23
	zPos = 7	
	self.FLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right wheel
	xPos = 52
	yPos = 23
	zPos = 7		
	self.FRwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left wheel
	xPos = -51
	yPos = -23
	zPos = 7	
	self.RLwheelPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	--Rear Left wheel
	xPos = -51
	yPos = 23
	zPos = 7	
	self.RRwheelPos =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )	
	
	
	
	//LIGHT POSITIONS	
	--Front Left light
	xPos = 76
	yPos = 20
	zPos = 31	
	self.FLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Front Right light
	xPos = 76
	yPos = -20
	zPos = 31	
	self.FRlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Left light
	xPos = -76
	yPos = 24
	zPos = 32	
	self.RLlightPos  = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	--Rear Right light
	xPos = -76
	yPos = -24
	zPos = 32
	self.RRlightPos  =  ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )

	
	--The position where the fire and smoke effects will be placed when the car is damaged
	xPos = 61
	yPos = 0
	zPos = 35	
	self.effectPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	--The position of the exhaust
	xPos = -72
	yPos = -20
	zPos = 10		
	self.exhaustPos = ( self.Entity:GetForward() * xPos ) + ( self.Entity:GetRight() * yPos ) + ( self.Entity:GetUp() * zPos )
	
	
	//SUSPENSION
	--The higher the number is the harder the suspension will be
	--Recommend not to change these numbers
	self.DefaultSoftnesFront = 20
	self.DefaultSoftnesRear = 20	
	

	--SPAWNING MISC PROPS
	constraint.NoCollide( self.Seat1, self.Seat2, 0, 0 )
	local pos = ( self.Entity:GetForward() * 1 ) + ( self.Entity:GetRight() * -15 ) + ( self.Entity:GetUp() * 35 )
	self.PropSeat1 = ents.Create( "prop_physics" )
	self.PropSeat1:SetModel( "models/seat_m/seat_chairl.mdl" ) 
	self.PropSeat1:SetPos( self.Entity:GetPos() + pos )
	self.PropSeat1:SetOwner(self.Owner)		
	self.PropSeat1:SetAngles((self.Entity:GetAngles() + Angle(0,-90,0) + Angle(0,180,0)))
	self.PropSeat1:Spawn()	

	pos = ( self.Entity:GetForward() * 1 ) + ( self.Entity:GetRight() * 15 ) + ( self.Entity:GetUp() * 35 )
	self.PropSeat2 = ents.Create( "prop_physics" )
	self.PropSeat2:SetModel( "models/seat_m/seat_chairl.mdl" ) 
	self.PropSeat2:SetPos( self.Entity:GetPos() + pos )
	self.PropSeat2:SetOwner(self.Owner)		
	self.PropSeat2:SetAngles((self.Entity:GetAngles() + Angle(0,-90,0) + Angle(0,180,0)))
	self.PropSeat2:Spawn()

	pos = ( self.Entity:GetForward() * -67.5 ) + ( self.Entity:GetUp() * 44 )
	self.BackDoor = ents.Create( "prop_physics" )
	self.BackDoor:SetModel( "models/seat_m/seat_doorb.mdl" ) 
	self.BackDoor:SetPos( self.Entity:GetPos() + pos )
	self.BackDoor:SetOwner(self.Owner)		
	self.BackDoor:SetAngles(self.Entity:GetAngles() + Angle(-6,0,0) )
	self.BackDoor:Spawn()
	self.BackDoor:SetSkin(newskin)
	
	pos = ( self.Entity:GetForward() * 55 ) + ( self.Entity:GetUp() * 36 )
	self.Hood = ents.Create( "prop_physics" )
	self.Hood:SetModel( "models/seat_m/seat_hood.mdl" ) 
	self.Hood:SetPos( self.Entity:GetPos() + pos )
	self.Hood:SetOwner(self.Owner)		
	self.Hood:SetAngles(self.Entity:GetAngles() + Angle(6,0,0) )
	self.Hood:Spawn()
	self.Hood:SetSkin(newskin)
	
	pos = ( self.Entity:GetForward() * 3.5 ) + ( self.Entity:GetRight() * -28 ) + ( self.Entity:GetUp() * 37.5 )
	self.LeftDoor = ents.Create( "prop_physics" )
	self.LeftDoor:SetModel( "models/seat_m/seat_doorl.mdl" ) 
	self.LeftDoor:SetPos( self.Entity:GetPos() + pos )
	self.LeftDoor:SetOwner(self.Owner)		
	self.LeftDoor:SetAngles(self.Entity:GetAngles() + Angle(0,5,0 ))
	self.LeftDoor:Spawn()
	self.LeftDoor:SetSkin(newskin)
	
	pos = ( self.Entity:GetForward() * 3.5 ) + ( self.Entity:GetRight() * 28 ) + ( self.Entity:GetUp() * 37.5 )
	self.RightDoor = ents.Create( "prop_physics" )
	self.RightDoor:SetModel( "models/seat_m/seat_doorr.mdl" ) 
	self.RightDoor:SetPos( self.Entity:GetPos() + pos )
	self.RightDoor:SetOwner(self.Owner)		
	self.RightDoor:SetAngles(self.Entity:GetAngles() + Angle(0,-5,0 ))
	self.RightDoor:Spawn()
	self.RightDoor:SetSkin(newskin)

	
	--Setting up the SCar in the SCar base
	self:Setup()	
end


function ENT:SpecialThink()

	--Attatching everything to the SCar
	if self.FixConstraints == false then
		self.FixConstraints = true
	end

	local percent = self.CarHealth / self.CarMaxHealth
	
	if self.PartLevel < 8 && percent < self.PercentLevel then
		self.PartLevel = self.PartLevel + 1
		self.PercentLevel = self.PercentLevel - 0.1
		self:RemoveRandomPart()		
	end
	

	--Changing skin on all the parts if we need to
	local currentskin = self.Entity:GetSkin()

	if self.CarCol != currentskin then
		self.CarCol = currentskin
			
		if self.PropSeat1 != NULL && self.PropSeat1 != nil then
			self.PropSeat1:SetSkin(currentskin)
		end
		
		if self.PropSeat2 != NULL && self.PropSeat2 != nil then	
			self.PropSeat2:SetSkin(currentskin)
		end
			
		if self.LeftDoor != NULL && self.LeftDoor != nil then	
			self.LeftDoor:SetSkin(currentskin)
		end
			
		if self.RightDoor != NULL && self.RightDoor != nil then	
			self.RightDoor:SetSkin(currentskin)
		end
			
		if self.Hood != NULL && self.Hood != nil then	
			self.Hood:SetSkin(currentskin)
		end
			
		if self.BackDoor != NULL && self.BackDoor != nil then	
			self.BackDoor:SetSkin(currentskin)
		end		
		
	end

	
end
-------------------------------------------ON REMOVE
function ENT:SpecialRemove()	
	
	--Removing the parts
	if self.PropSeat1 != NULL && self.PropSeat1 != nil then
		self.PropSeat1:Remove()
	end
	
	if self.PropSeat2 != NULL && self.PropSeat2 != nil then	
		self.PropSeat2:Remove()
	end
		
	if self.LeftDoor != NULL && self.LeftDoor != nil then	
		self.LeftDoor:Remove()
	end
		
	if self.RightDoor != NULL && self.RightDoor != nil then	
		self.RightDoor:Remove()
	end
		
	if self.Hood != NULL && self.Hood != nil then	
		self.Hood:Remove()
	end
		
	if self.BackDoor != NULL && self.BackDoor != nil then	
		self.BackDoor:Remove()
	end
		
	
end

function ENT:RemoveRandomPart()

	local removed = false
	local counter = 0
	local start = math.random(1,8)
	
	while removed == false && counter <= 8 do
	
		if start == 1 && self.LeftDoorConstraint != NULL && self.LeftDoorConstraint != nil && self.LeftDoorConstraint:IsValid() then
			self.LeftDoorConstraint:Remove()
			self.LeftDoorConstraint = NULL
			removed = true
			
		elseif start == 2 && self.RightDoorConstraint != NULL && self.RightDoorConstraint != nil && self.RightDoorConstraint:IsValid() then
			self.RightDoorConstraint:Remove()
			self.RightDoorConstraint = NULL
			removed = true
			
		elseif start == 3 && self.HoodConstraint != NULL && self.HoodConstraint != nil && self.HoodConstraint:IsValid() then
			self.HoodConstraint:Remove()			
			self.HoodConstraint = NULL
			removed = true			
			
		elseif start == 4 && self.BackDoorConstraint != NULL && self.BackDoorConstraint != nil && self.BackDoorConstraint:IsValid() then
			self.BackDoorConstraint:Remove()		
			self.BackDoorConstraint = NULL
			removed = true		
			
		elseif start == 5 && self.LeftDoorConstraint2 != NULL && self.LeftDoorConstraint2 != nil && self.LeftDoorConstraint2:IsValid() then
			self.LeftDoorConstraint2:Remove()
			self.LeftDoorConstraint2 = NULL
			removed = true
			
		elseif start == 6 && self.RightDoorConstraint2 != NULL && self.RightDoorConstraint2 != nil && self.RightDoorConstraint2:IsValid() then
			self.RightDoorConstraint2:Remove()
			self.RightDoorConstraint2 = NULL
			removed = true
			
		elseif start == 7 && self.HoodConstraint2 != NULL && self.HoodConstraint2 != nil && self.HoodConstraint2:IsValid() then
			self.HoodConstraint2:Remove()			
			self.HoodConstraint2 = NULL
			removed = true			
			
		elseif start == 8 && self.BackDoorConstraint2 != NULL && self.BackDoorConstraint2 != nil && self.BackDoorConstraint2:IsValid() then
			self.BackDoorConstraint2:Remove()		
			self.BackDoorConstraint2 = NULL
			removed = true				
		end
	
	
		start = start + 1
		counter = counter + 1
		
		if start > 8 then
			start = 1
		end
	end

end

function ENT:SpecialReposition()

	local pos = ( self.Entity:GetForward() * 1 ) + ( self.Entity:GetRight() * -15 ) + ( self.Entity:GetUp() * 35 )
	self.PropSeat1:SetPos( self.Entity:GetPos() + pos )
	self.PropSeat1:SetAngles((self.Entity:GetAngles() + Angle(0,-90,0) + Angle(0,180,0)))
	
	pos = ( self.Entity:GetForward() * 1 ) + ( self.Entity:GetRight() * 15 ) + ( self.Entity:GetUp() * 35 )
	self.PropSeat2:SetPos( self.Entity:GetPos() + pos )
	self.PropSeat2:SetAngles((self.Entity:GetAngles() + Angle(0,-90,0) + Angle(0,180,0)))
	
	pos = ( self.Entity:GetForward() * -67.5 ) + ( self.Entity:GetUp() * 44 )
	self.BackDoor:SetPos( self.Entity:GetPos() + pos )
	self.BackDoor:SetAngles(self.Entity:GetAngles() + Angle(-6,0,0) )
	
	pos = ( self.Entity:GetForward() * 55 ) + ( self.Entity:GetUp() * 36 )
	self.Hood:SetPos( self.Entity:GetPos() + pos )
	self.Hood:SetAngles(self.Entity:GetAngles() + Angle(6,0,0) )
	
	pos = ( self.Entity:GetForward() * 3.5 ) + ( self.Entity:GetRight() * -28 ) + ( self.Entity:GetUp() * 37.5 )
	self.LeftDoor:SetPos( self.Entity:GetPos() + pos )
	self.LeftDoor:SetAngles(self.Entity:GetAngles() + Angle(0,5,0 ))
	
	pos = ( self.Entity:GetForward() * 3.5 ) + ( self.Entity:GetRight() * 28 ) + ( self.Entity:GetUp() * 37.5 )
	self.RightDoor:SetPos( self.Entity:GetPos() + pos )
	self.RightDoor:SetAngles(self.Entity:GetAngles() + Angle(0,-5,0 ))

		constraint.Weld( self.Entity, self.PropSeat1, 0, 0, 0, 1 ) 
		constraint.Weld( self.Entity, self.PropSeat2, 0, 0, 0, 1 ) 	
		constraint.NoCollide( self.Entity, self.PropSeat1, 0, 0 )
		constraint.NoCollide( self.Entity, self.PropSeat2, 0, 0 )	
		constraint.NoCollide( self.PropSeat1, self.Seat1, 0, 0 )	
		constraint.NoCollide( self.PropSeat2, self.Seat2, 0, 0 )		
		constraint.NoCollide( self.PropSeat1, selfStabilizerProp, 0, 0 )		
		constraint.NoCollide( self.PropSeat2, selfStabilizerProp, 0, 0 )

		self.BackDoorConstraint = constraint.Weld( self.Entity, self.BackDoor, 0, 0, 0, 1 ) 	
		self.BackDoorConstraint2 = constraint.Axis( self.BackDoor, self.Entity, 0, 0, Vector(-11, 1000, 16.5) , Vector(-60,0,62) , 0, 0, 1, 0 )		

		self.HoodConstraint = constraint.Weld( self.Entity, self.Hood, 0, 0, 0, 1 ) 	
		self.HoodConstraint2 = constraint.Axis( self.Hood, self.Entity, 0, 0, Vector(-22.3, 100, 3) , Vector(35,0,40) , 0, 0, 1, 0 )
		
		constraint.NoCollide( self.PropSeat1, self.LeftDoor, 0, 0 )	
		constraint.NoCollide( self.LeftDoor, self.Seat1, 0, 0 )		
		constraint.NoCollide( self.LeftDoor, self.Entity, 0, 0 )	
		self.LeftDoorConstraint = constraint.Weld( self.Entity, self.LeftDoor, 0, 0, 0, 1 ) 
		self.LeftDoorConstraint2 = constraint.Axis( self.LeftDoor, self.Entity, 0, 0, Vector(25, -4, 1000) , Vector(26,27.5,43) , 0, 0, 1, 0 )

		constraint.NoCollide( self.PropSeat2, self.RightDoor, 0, 0 )	
		constraint.NoCollide( self.RightDoor, self.Seat2, 0, 0 )	
		constraint.NoCollide( self.RightDoor, self.Entity, 0, 0 )		
		self.RightDoorConstraint = constraint.Weld( self.Entity, self.RightDoor, 0, 0, 0, 1 ) 
		self.RightDoorConstraint2 = constraint.Axis( self.RightDoor, self.Entity, 0, 0, Vector(25, 4, 1000) , Vector(26,-27.5,43) , 0, 0, 1, 0 )	
	
end
