--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
resource.AddFile( "models/nova/airboat_seat.mdl" )
--]]
ENT.AutoStraighten = 0


ENT.WeaponSystem = NULL

ENT.ThirdPView = 0
ENT.SwitchViewDelay = CurTime()

ENT.StartDel = CurTime()
ENT.StartOnce = false
ENT.IgnoreStartSound = false

ENT.UseDelay = CurTime()
ENT.ShiftTime = CurTime()
ENT.ShiftSpeed = 0
ENT.Gear = 0
ENT.RealGear = 0
ENT.OldGear = 0
ENT.Pitch = 40
ENT.RealPitch = 40
ENT.IsInAirCount = 0
ENT.TurboTime = 0
ENT.TurboCant = 0
ENT.UsingTurbo = false
ENT.AutoRemoveDel = NULL
ENT.AutoRepairWheels = false

ENT.SmokeEffect = NULL
ENT.UseHud = 1
ENT.Owner = NULL
ENT.Breaking = false
ENT.StartBoost = CurTime()

//Fuel
ENT.Fuel = 20000
ENT.FuelConsumption = 2
ENT.UsesFuelConsumption = 1
ENT.UpdateFuelDel = CurTime()

//Exhaust
ENT.exhaustEffect = NULL
ENT.exhaustEffect2 = NULL
ENT.exhaustIsOn = 0

//Health
ENT.CarHealth = 200
ENT.CarMaxHealth = 200
ENT.CanTakeDamage = 1
ENT.DamageLevel = 0
ENT.TakeHealthDel = CurTime()
ENT.FireEffect = NULL
ENT.CanTakeWheelDamage = 1

//Seats
ENT.Seat1 = NULL
ENT.Seat2 = NULL
ENT.Seat3 = NULL
ENT.Seat4 = NULL
ENT.Seat5 = NULL
ENT.UsingSeat1 = false
ENT.UsingSeat2 = false
ENT.UsingSeat3 = false
ENT.UsingSeat4 = false
ENT.UsingSeat5 = false
ENT.User1 = NULL
ENT.User2 = NULL
ENT.User3 = NULL
ENT.User4 = NULL
ENT.User5 = NULL

//Removed Wheels
ENT.RemovedFL = 0
ENT.RemovedFR = 0
ENT.RemovedRL = 0
ENT.RemovedRR = 0

//Break constraint
ENT.breakFL = NULL
ENT.breakFR = NULL
ENT.breakRL = NULL
ENT.breakRR = NULL
ENT.handBreak = false

//Wheel constraints
ENT.axisFL = NULL
ENT.axisFR = NULL
ENT.axisRL = NULL
ENT.axisRR = NULL

//Sounds
ENT.StartSound = NULL
ENT.OffSound = NULL
ENT.PlayOnce = 0
ENT.Skid = NULL
ENT.TurboStartSound = NULL
ENT.TurboStopSound = NULL
ENT.FireSound = NULL
ENT.WheelSkid = NULL

//Wheels
ENT.WfrontLeft = NULL
ENT.WfrontRight = NULL
ENT.WrearLeft = NULL
ENT.WrearRight = NULL

ENT.InAirCount = 0
ENT.physMat = "rubber"

//Skidding
ENT.DoesWheelSkid = false
ENT.TireSmokeLeft = NULL
ENT.TireSmokeRight = NULL
ENT.SkidType = 0

//Lights
ENT.LightOn = 0
ENT.FLlight = NULL
ENT.FRlight = NULL

ENT.FLlightSprite = NULL
ENT.FRlightSprite = NULL
ENT.RLlightSprite = NULL
ENT.RRlightSprite = NULL

ENT.FLlightPos = NULL
ENT.FRlightPos = NULL
ENT.RLlightPos = NULL
ENT.RRlightPos = NULL

ENT.useRT = 0
ENT.switchLightDelay = 0
ENT.breakInitiated = false

//Suspension hydraulics
ENT.HydraulicHeight = 0
ENT.HydraulicActive = 0
ENT.HydActiveFL = 0
ENT.HydActiveFR = 0
ENT.HydActiveRL = 0
ENT.HydActiveRR = 0
ENT.HydActivateFL = 0
ENT.HydActivateFR = 0
ENT.HydActivateRL = 0
ENT.HydActivateRR = 0
ENT.HydUse = 0

ENT.UseFrontH = 0
ENT.UseBackH = 0
ENT.UseLeftH = 0
ENT.UseRightH = 0

ENT.UseFrontLeftH = 0
ENT.UseFrontRightH = 0
ENT.UseRearLeftH = 0
ENT.UseRearRightH = 0

//Characteristics
ENT.BreakEfficiency = 0.999
ENT.DefaultBreakEfficiency = 0.96
ENT.ReverseForce = 1000
ENT.ReverseMaxSpeed = 200

ENT.TurboEffect = 2
ENT.TurboDuration = 4
ENT.TurboDelay = 10

ENT.Acceleration = 3000
ENT.SteerForce = 5
ENT.RealSteerForce = 1
ENT.SteerResponse = 0.3
ENT.MaxSpeed = 1500
ENT.NrOfGears = 5

ENT.SoftnesFront = 0
ENT.SoftnesRear = 0
ENT.DefaultSoftnesFront = 20
ENT.DefaultSoftnesRear = 20

ENT.HeightFront = 0
ENT.HeightRear = 0
ENT.AntiSlide = 10

//Stabilizer
ENT.StabilizerProp = NULL
ENT.StabilizerConstaint = NULL
ENT.Stabilisation = 2000
ENT.EntType = NULL


function ENT:Setup()

	self.EntType = info_target
	self.infot = ents.Create("info_target")
	self.infot:SetPos(self.Entity:GetPos())
	self.infot:Spawn()
	self.infot:Activate()
	self.infot:SetParent(self.Entity)


	self.Entity:SetModel(self.CarModel)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
	phys:SetMass(self.CarMass)
	
	construct.SetPhysProp( self.Owner,  self.Entity, 0, nil, { GravityToggle = 1, Material = "metal" })

	--Spawning seats
	--Seat1
	if self.NrOfSeats >= 1 then
		self.Seat1 = ents.Create("prop_vehicle_prisoner_pod")  
		self.Seat1:SetKeyValue("vehiclescript","scripts/vehicles/CarSeat.txt")  
		self.Seat1:SetModel( self.SeatModel ) 
		self.Seat1:SetPos( self.Entity:GetPos() + self.SeatPos1 )  
		self.Seat1:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat1:SetKeyValue("limitview", "0")  
		self.Seat1:SetColor(255,255,255,0)
		self.Seat1:Spawn()  
		self.Seat1:GetPhysicsObject():EnableGravity(true);
		self.Seat1:GetPhysicsObject():SetMass(1)
		self.Seat1:SetNetworkedInt( "SCarSeat" , 1 )
		self.Seat1:SetNetworkedInt( "SCarFuel", self.Fuel )
		self.Seat1.Owner = self.Entity.Owner
		self.Seat1:SetNetworkedEntity( "SCarEnt", self.Entity )
		self.Seat1:SetNetworkedInt( "SCarCameraCorrection", 0 )
		self.Seat1.SCarSeatNum = 1
		self.Seat1.OwnerEnt = self.Entity
		self.Seat1:SetNetworkedInt( "SCarUseHud" , 1 )
		self.Seat1:SetNotSolid( true )
		self.Seat1:GetPhysicsObject():EnableDrag(false)
	end
	
	--Seat2
	if self.NrOfSeats >= 2 then
		self.Seat2 = ents.Create("prop_vehicle_prisoner_pod")  
		self.Seat2:SetKeyValue("vehiclescript","scripts/vehicles/CarSeat.txt")  
		self.Seat2:SetModel( self.SeatModel ) 
		self.Seat2:SetPos( self.Entity:GetPos() + self.SeatPos2 )  
		self.Seat2:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat2:SetKeyValue("limitview", "0")  
		self.Seat2:SetColor(255,255,255,0)
		self.Seat2:Spawn()  
		self.Seat2:GetPhysicsObject():EnableGravity(true);
		self.Seat2:GetPhysicsObject():SetMass(1)		
		self.Seat2.Owner = self.Entity.Owner
		self.Seat2.SCarSeatNum = 2
		self.Seat2.OwnerEnt = self.Entity
		self.Seat2:SetNotSolid( true )
		self.Seat2:GetPhysicsObject():EnableDrag(false)		
	end
	
	--Seat3
	if self.NrOfSeats >= 3 then	
		self.Seat3 = ents.Create("prop_vehicle_prisoner_pod")  
		self.Seat3:SetKeyValue("vehiclescript","scripts/vehicles/CarSeat.txt")  
		self.Seat3:SetModel( self.SeatModel ) 
		self.Seat3:SetPos( self.Entity:GetPos() + self.SeatPos3 )  
		self.Seat3:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat3:SetKeyValue("limitview", "0")  
		self.Seat3:SetColor(255,255,255,0)
		self.Seat3:Spawn()  
		self.Seat3:GetPhysicsObject():EnableGravity(true);
		self.Seat3:GetPhysicsObject():SetMass(1)		
		self.Seat3.Owner = self.Entity.Owner
		self.Seat3.SCarSeatNum = 3
		self.Seat3.OwnerEnt = self.Entity
		self.Seat3:SetNotSolid( true )
		self.Seat3:GetPhysicsObject():EnableDrag(false)		
	end
	
	--Seat4
	if self.NrOfSeats >= 4 then
		self.Seat4 = ents.Create("prop_vehicle_prisoner_pod")  
		self.Seat4:SetKeyValue("vehiclescript","scripts/vehicles/CarSeat.txt")  
		self.Seat4:SetModel( self.SeatModel ) 
		self.Seat4:SetPos( self.Entity:GetPos() + self.SeatPos4 )  
		self.Seat4:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat4:SetKeyValue("limitview", "0")  
		self.Seat4:SetColor(255,255,255,0)
		self.Seat4:Spawn()  
		self.Seat4:GetPhysicsObject():EnableGravity(true);
		self.Seat4:GetPhysicsObject():SetMass(1)
		self.Seat4.Owner = self.Entity.Owner
		self.Seat4.SCarSeatNum = 4
		self.Seat4.OwnerEnt = self.Entity
		self.Seat4:SetNotSolid( true )
		self.Seat4:GetPhysicsObject():EnableDrag(false)		
	end
	
	--Seat5
	if self.NrOfSeats >= 5 then
		self.Seat5 = ents.Create("prop_vehicle_prisoner_pod")  
		self.Seat5:SetKeyValue("vehiclescript","scripts/vehicles/CarSeat.txt")  
		self.Seat5:SetModel( self.SeatModel ) 
		self.Seat5:SetPos( self.Entity:GetPos() + self.SeatPos5 )  
		self.Seat5:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat5:SetKeyValue("limitview", "0")  
		self.Seat5:SetColor(255,255,255,0)
		self.Seat5:Spawn()  
		self.Seat5:GetPhysicsObject():EnableGravity(true);
		self.Seat5:GetPhysicsObject():SetMass(1)	
		self.Seat5.Owner = self.Entity.Owner
		self.Seat5.SCarSeatNum = 5
		self.Seat5.OwnerEnt = self.Entity	
		self.Seat5:SetNotSolid( true )
		self.Seat5:GetPhysicsObject():EnableDrag(false)		
	end
	
	self.Entity.SeatOne = self.Seat1
	self.Entity.SeatTwo = self.Seat2
	self.Entity.SeatThree = self.Seat3
	self.Entity.SeatFour = self.Seat4
	self.Entity.SeatFive = self.Seat5
	
	
	--Spawning wheels	
	//FrontLeft
	self.WfrontLeft = ents.Create( "sent_Sakarias_CarWheel" )		
	self.WfrontLeft.TireModel = self.TireModel
	self.WfrontLeft:SetPos( self.Entity:GetPos() + self.FLwheelPos)
	self.WfrontLeft:SetOwner(self.Owner)		
	self.WfrontLeft:SetAngles(self.Entity:GetAngles() + Angle(0,180,0))
	self.WfrontLeft.SCarOwner = self.Entity	
	self.WfrontLeft.EntOwner = self.Entity	
	self.WfrontLeft:Spawn()
	self.WfrontLeft:GetPhysicsObject():SetMass(self.DefaultSoftnesFront)
	
	//FrontRight
	self.WfrontRight = ents.Create( "sent_Sakarias_CarWheel" )	
	self.WfrontRight.TireModel = self.TireModel	
	self.WfrontRight:SetPos( self.Entity:GetPos() + self.FRwheelPos)
	self.WfrontRight:SetOwner(self.Owner)		
	self.WfrontRight:SetAngles(self.Entity:GetAngles())
	self.WfrontRight.SCarOwner = self.Entity	
	self.WfrontRight.EntOwner = self.Entity		
	self.WfrontRight:Spawn()	
	self.WfrontRight:GetPhysicsObject():SetMass(self.DefaultSoftnesFront)
	
	//RearLeft
	self.WrearLeft = ents.Create( "sent_Sakarias_CarWheel" )
	self.WrearLeft.TireModel = self.TireModel	
	self.WrearLeft:SetPos( self.Entity:GetPos() + self.RLwheelPos)
	self.WrearLeft:SetOwner(self.Owner)		
	self.WrearLeft:SetAngles(self.Entity:GetAngles() + Angle(0,180,0))
	self.WrearLeft.EntOwner = self.Entity		
	self.WrearLeft:Spawn()	
	self.WrearLeft:GetPhysicsObject():SetMass(self.DefaultSoftnesRear)
	self.Entity.RLwheel = self.WrearLeft
	
	//RearRight
	self.WrearRight = ents.Create( "sent_Sakarias_CarWheel" )
	self.WrearRight.TireModel = self.TireModel	
	self.WrearRight:SetPos( self.Entity:GetPos() + self.RRwheelPos)
	self.WrearRight:SetOwner(self.Owner)		
	self.WrearRight:SetAngles(self.Entity:GetAngles())
	self.WrearRight.EntOwner = self.Entity		
	self.WrearRight:Spawn()		
	self.WrearRight:GetPhysicsObject():SetMass(self.DefaultSoftnesRear)
	self.Entity.RRwheel = self.WrearRight

	--Welding seats
	constraint.Weld( self.Entity, self.Seat1, 0, 0, 0, 1 ) 
	constraint.Weld( self.Entity, self.Seat2, 0, 0, 0, 1 ) 
	constraint.Weld( self.Entity, self.Seat3, 0, 0, 0, 1 ) 
	constraint.Weld( self.Entity, self.Seat4, 0, 0, 0, 1 ) 
	constraint.Weld( self.Entity, self.Seat5, 0, 0, 0, 1 ) 

	--Nocolliding seats
	constraint.NoCollide( self.Seat1, self.Seat3, 0, 0 )	
	constraint.NoCollide( self.Seat1, self.Seat4, 0, 0 )
	constraint.NoCollide( self.Seat2, self.Seat3, 0, 0 )	
	constraint.NoCollide( self.Seat2, self.Seat4, 0, 0 )
	constraint.NoCollide( self.Seat3, self.Seat4, 0, 0 )
	constraint.NoCollide( self.Seat3, self.Seat5, 0, 0 )
	
	constraint.NoCollide( self.Seat5, self.WrearRight, 0, 0 )
	constraint.NoCollide( self.Seat4, self.WrearLeft, 0, 0 )
	//Stabilizer
	
	if self.StabiliserOffset == NULL then
		self.StabiliserOffset = Vector(0,0,20)
	end
	
	self.StabilizerProp = ents.Create( "prop_physics" )
	self.StabilizerProp:SetModel("models/props_junk/sawblade001a.mdl")		
	self.StabilizerProp:SetPos(self.Entity:GetPos() + self.StabiliserOffset.x * self.Entity:GetForward() + self.StabiliserOffset.y * self.Entity:GetRight() + self.StabiliserOffset.z * self.Entity:GetUp() )
	self.StabilizerProp:SetOwner(self.Owner)		
	self.StabilizerProp:SetAngles(self.Entity:GetAngles())
	self.StabilizerProp:SetColor(255,255,255,0)
	self.StabilizerProp:Spawn()
	self.StabilizerProp:GetPhysicsObject():EnableGravity(false)	
	constraint.Weld( self.Entity, self.StabilizerProp, 0, 0, 0, 1 )
	self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, Angle(0,0,0) , 0, self.Stabilisation)
	self.StabilizerProp:SetCollisionGroup( GROUP_DEBRIS )	
	self.Entity.Stabilizer = self.StabilizerProp
	self.StabilizerProp:GetPhysicsObject():SetMass(self.StabilisationMultiplier)
	self.StabilizerProp:SetNotSolid( true )
	
	constraint.NoCollide( self.Seat1, self.StabilizerProp, 0, 0 )	
	constraint.NoCollide( self.Seat2, self.StabilizerProp, 0, 0 )	
	constraint.NoCollide( self.Seat3, self.StabilizerProp, 0, 0 )	
	constraint.NoCollide( self.Seat4, self.StabilizerProp, 0, 0 )	
	constraint.NoCollide( self.Seat5, self.StabilizerProp, 0, 0 )

	--Front Wheels
	self.axisFL = constraint.Axis( self.WfrontLeft, self.Entity, 0, 0, Vector(0,1,0) , self.FLwheelPos, 0, 0, 1, 0 )
	self.axisFR = constraint.Axis( self.WfrontRight, self.Entity, 0, 0, Vector(0,-1,0) , self.FRwheelPos, 0, 0, 1, 0 )
	
	--RearWheels
	self.axisRL = constraint.Axis( self.WrearLeft, self.Entity, 0, 0, Vector(0,1,0) , self.RLwheelPos, 0, 0, 1, 0 )
	self.axisRR = constraint.Axis( self.WrearRight, self.Entity, 0, 0, Vector(0,-1,0) , self.RRwheelPos, 0, 0, 1, 0 )	
		
	constraint.NoCollide( self.Entity, self.WfrontLeft, 0, 0 )		
	constraint.NoCollide( self.Entity, self.WfrontRight, 0, 0 )
	constraint.NoCollide( self.Entity, self.WrearLeft, 0, 0 )
	constraint.NoCollide( self.Entity, self.WrearRight, 0, 0 )
	
	--Sounds	
	self.StartSound   = CreateSound(self.Entity,self.DefaultSound)	
	self.OffSound   = CreateSound(self.Entity,"vehicles/junker/jnk_stop1.wav")		
	self.Skid = CreateSound(self.Entity,"vehicles/v8/skid_highfriction.wav")	
	self.TurboStartSound = CreateSound(self.Entity,"car/nosstart.wav")	
	self.TurboStopSound = CreateSound(self.Entity,"car/nosstop.wav")	
	self.FireSound = CreateSound(self.Entity,"ambient/fire/fire_big_loop1.wav")
	self.WheelSkid = CreateSound(self.Entity,"car/skid.wav")
	
	self.Entity.BreakEfficiency = self.BreakEfficiency
	self.Entity.ReverseForce = self.ReverseForce	
	self.Entity.ReverseMaxSpeed = self.ReverseMaxSpeed 
	self.Entity.TurboEffect = self.TurboEffect						
	self.Entity.Acceleration = self.Acceleration
	self.Entity.SteerForce	= self.SteerForce
	self.Entity.MaxSpeed = self.MaxSpeed
	self.Entity.NrOfGears = self.NrOfGears			
	self.Entity.TurboDuration = self.TurboDuration	
	self.Entity.TurboDelay = self.TurboDelay
	self.Entity.EngineSound = self.DefaultSound	
	
	self.Entity.SoftnesFront = self.SoftnesFront
	self.Entity.SoftnesRear = self.SoftnesRear		
	self.Entity.HeightFront = self.HeightFront
	self.Entity.HeightRear = self.HeightRear
	self.Entity.WheelModel = self.TireModel
	self.Entity.handBreakDel = 0	
	self.Entity.IsDestroyed = 0
	self.Entity.useRT = self.useRT
	self.Entity.SuspensionAddHeight = self.HydraulicHeight
	self.Entity.HydraulicActive = self.HydraulicActive
	self.Entity.UseHUD = self.UseHud
	self.Entity.FuelConsumptionUse = self.UsesFuelConsumption	
	self.Entity.FuelConsumption = self.FuelConsumption	
	self.Entity.CanTakeWheelDamage = self.CanTakeWheelDamage
	self.Entity.SteerResponse = self.SteerResponse	
	self.Entity.Stabilisation = self.Stabilisation	
	self.Entity.ThirdPersonView = 0
	self.Entity.CameraCorrection = 0
	self.Entity.physMat = self.physMat
	self.Entity.AntiSlide = self.AntiSlide
	
	--Setting a random ski
	local skins = self.Entity:SkinCount()	
	if skins != 1 then
		local currentskin = self.Entity:GetSkin()
		newskin = math.random(skins)
		self.Entity:SetSkin(newskin)
	end	
		
	local scale = (self.MaxSpeed / self.NrOfGears)
	self.Seat1:SetNetworkedInt( "SCarRevScale" , scale )		
	
	self.Entity:SetNetworkedInt( "SCarNumberOfSeats" , self.NrOfSeats )
	
	if self.Entity.handBreakDel == nil or self.Entity.handBreakDel == NULL then
		self.Entity.handBreakDel = 0
	end
	
end



-------------STOOL FUNCTIONS						

function ENT:SetBreakEfficiency(BreakEfficiency)
	self.BreakEfficiency = BreakEfficiency
end

function ENT:SetReverseForce(ReverseForce)
	self.ReverseForce = ReverseForce
end

function ENT:SetReverseMaxSpeed(ReverseMaxSpeed)
	self.ReverseMaxSpeed = ReverseMaxSpeed
end

function ENT:SetTurboEffect(TurboEffect)
	self.TurboEffect = TurboEffect
end

function ENT:SetAcceleration(Acceleration)
	self.Acceleration = Acceleration
end

function ENT:SetSteerForce(SteerForce)
	self.SteerForce = SteerForce
end

function ENT:SetMaxSpeed(MaxSpeed)
	self.MaxSpeed = MaxSpeed
	local scale = (self.MaxSpeed / self.NrOfGears)
	self.Seat1:SetNetworkedInt( "SCarRevScale" , scale )		
end

function ENT:SetNrOfGears(NrOfGears)
	self.NrOfGears = NrOfGears
	local scale = (self.MaxSpeed / self.NrOfGears)
	self.Seat1:SetNetworkedInt( "SCarRevScale" , scale )	
end

function ENT:SetEngineSound( EngineSound )

		self.StartSound:Stop()
		self.StartSound   = CreateSound(self.Entity,EngineSound)
		
		if self.UsingSeat1 then
			self.StartSound:Play()
		end
		
end

function ENT:SetSoftnesFront(SoftnesFront)
	self.SoftnesFront = SoftnesFront
	
	local mass = self.DefaultSoftnesFront + self.SoftnesFront
	
	if mass < 1 then
		mass = 1
	end	
	
	if self.WfrontLeft:IsValid() && self.WfrontLeft != NULL && self.WfrontLeft != nil then
		local phys = self.WfrontLeft:GetPhysicsObject()
		phys:SetMass( mass )
	end

	if self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil then
		local phys = self.WfrontRight:GetPhysicsObject()
		phys:SetMass( mass )
	end	
	
end

function ENT:SetSoftnesRear(SoftnesRear)
	self.SoftnesRear = SoftnesRear
	
	local mass = self.DefaultSoftnesRear + self.SoftnesRear
	
	if mass < 1 then
		mass = 1
	end

	if self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil then
		local phys = self.WrearLeft:GetPhysicsObject()
		phys:SetMass( mass )
	end

	if self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil then
		local phys = self.WrearRight:GetPhysicsObject()
		phys:SetMass( mass )
	end	
	
end

function ENT:SetHeightFront(HeightFront)
	self.HeightFront = HeightFront
	
	local ang = self.Entity:GetAngles()
	
	self.Entity:SetAngles(Angle( 0, 0, 0 ))
	
	--Removing handBreak
	self.Entity.handBreakDel = CurTime() + 1	
	
	if self.handBreak == true then
		if ValidEntity(self.breakFL) && ValidEntity(self.WfrontLeft) then
			self.breakFL:Remove()	
			self.breakFL = NULL		
		end

		if ValidEntity(self.breakFR) && ValidEntity(self.WfrontRight) then	
			self.breakFR:Remove()	
			self.breakFR = NULL		
		end
		
		if ValidEntity(self.breakRL) && ValidEntity(self.WrearLeft) then
			self.breakRL:Remove()	
			self.breakRL = NULL				
		end

		if ValidEntity(self.breakRR) && ValidEntity(self.WrearRight) then	
			self.breakRR:Remove()	
			self.breakRR = NULL					
		end	
	end
	
	self.handBreak = false
	
	if self.axisFL:IsValid() && self.axisFL != NULL && self.axisFL != nil then
		self.axisFL:Remove()
	end
	
	if self.axisFR:IsValid() && self.axisFR != NULL && self.axisFR != nil then
		self.axisFR:Remove()
	end	
	
	if self.WfrontLeft:IsValid() && self.WfrontLeft != NULL && self.WfrontLeft != nil then
		local newPos = self.FLwheelPos + Vector(0,0,HeightFront)
		local oldPos = self.WfrontLeft:GetPos()
		local oldAng = self.WfrontLeft:GetAngles()
		self.WfrontLeft:SetPos(self.Entity:GetPos() + newPos )
		self.WfrontLeft:SetAngles( self.Entity:GetAngles() + Angle(0,180,0))
		self.axisFL = constraint.Axis( self.WfrontLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )						
		self.WfrontLeft:SetPos( oldPos )
		self.WfrontLeft:SetAngles( oldAng )	
	end

	if self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil then	
		newPos = self.FRwheelPos + Vector(0,0,HeightFront)	
		oldPos = self.WfrontRight:GetPos()
		oldAng = self.WfrontRight:GetAngles()	
		self.WfrontRight:SetPos(self.Entity:GetPos() + newPos )
		self.WfrontRight:SetAngles( self.Entity:GetAngles() )	
		self.axisFR = constraint.Axis( self.WfrontRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )	
		self.WfrontRight:SetPos( oldPos )
		self.WfrontRight:SetAngles( oldAng )
	end
	
	self.Entity:SetAngles( ang )
end


function ENT:SetHeightRear(HeightRear)
	self.HeightRear = HeightRear
	

	local ang = self.Entity:GetAngles()
	
	self.Entity:SetAngles(Angle( 0, 0, 0 ))
	
	--Removing handBreak
	self.Entity.handBreakDel = CurTime() + 1
	
	if self.handBreak == true then
		if ValidEntity(self.breakFL) && ValidEntity(self.WfrontLeft) then
			self.breakFL:Remove()	
			self.breakFL = NULL		
		end

		if ValidEntity(self.breakFR) && ValidEntity(self.WfrontRight) then	
			self.breakFR:Remove()	
			self.breakFR = NULL		
		end
		
		if ValidEntity(self.breakRL) && ValidEntity(self.WrearLeft) then
			self.breakRL:Remove()	
			self.breakRL = NULL				
		end

		if ValidEntity(self.breakRR) && ValidEntity(self.WrearRight) then	
			self.breakRR:Remove()	
			self.breakRR = NULL					
		end	
	end
	
	self.handBreak = false
	
	if self.axisRL:IsValid() && self.axisRL != NULL && self.axisRL != nil then
		self.axisRL:Remove()
	end
	
	if self.axisRR:IsValid() && self.axisRR != NULL && self.axisRR != nil then
		self.axisRR:Remove()
	end	
	
	if self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil then
		local newPos = self.RLwheelPos + Vector(0,0,HeightRear)
		local oldPos = self.WrearLeft:GetPos()
		local oldAng = self.WrearLeft:GetAngles()
		self.WrearLeft:SetPos(self.Entity:GetPos() + newPos )
		self.WrearLeft:SetAngles( self.Entity:GetAngles() + Angle(0,180,0) )
		self.axisRL = constraint.Axis( self.WrearLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )						
		self.WrearLeft:SetPos( oldPos )
		self.WrearLeft:SetAngles( oldAng )	
	end

	if self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil then	
		newPos = self.RRwheelPos + Vector(0,0,HeightRear)	
		oldPos = self.WrearRight:GetPos()
		oldAng = self.WrearRight:GetAngles()	
		self.WrearRight:SetPos(self.Entity:GetPos() + newPos )
		self.WrearRight:SetAngles( self.Entity:GetAngles())	
		self.axisRR = constraint.Axis( self.WrearRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )	
		self.WrearRight:SetPos( oldPos )
		self.WrearRight:SetAngles( oldAng )
	end
	
	self.Entity:SetAngles( ang )
	
	
end


function ENT:ChangeWheel( model , physMat)

	local ang = self.Entity:GetAngles()
	self.physMat = physMat
	self.Entity:SetAngles(Angle( 0, 0, 0 ))

	--Removing handBreak
	self.RemovedFL = 0
	self.RemovedFR = 0
	self.RemovedRL = 0
	self.RemovedRR = 0
	
	--Removing handBreak
	self.Entity.handBreakDel = CurTime() + 1
	
	if self.handBreak == true then
		if ValidEntity(self.breakFL) && ValidEntity(self.WfrontLeft) then
			self.breakFL:Remove()	
			self.breakFL = NULL		
		end

		if ValidEntity(self.breakFR) && ValidEntity(self.WfrontRight) then	
			self.breakFR:Remove()	
			self.breakFR = NULL		
		end
		
		if ValidEntity(self.breakRL) && ValidEntity(self.WrearLeft) then
			self.breakRL:Remove()	
			self.breakRL = NULL				
		end

		if ValidEntity(self.breakRR) && ValidEntity(self.WrearRight) then	
			self.breakRR:Remove()	
			self.breakRR = NULL					
		end		
	end
	
	self.handBreak = false
	
	self.breakFL = NULL	
	self.breakFR = NULL		
	self.breakRL = NULL		
	self.breakRR = NULL	



	local wasValid = false
	
	--Spawning new wheels
	local oldPos = NULL
	local oldAng = NULL
		
	--Front left
	if ValidEntity(self.WfrontLeft) && self.WfrontLeft.IsDestroyed == 0 then
		wasValid = true
	else
		wasValid = false
		if ValidEntity(self.WfrontLeft) then
			self.WfrontLeft:Remove()
		end	
	end
	
	if wasValid == true then
		oldPos = self.WfrontLeft:GetPos()
		oldAng = self.WfrontLeft:GetAngles()
		self.WfrontLeft:Remove()
	end
	
	local newPos = self.FLwheelPos + Vector(0,0,(self.HeightFront *-1))
	
	//FrontLeft
	self.WfrontLeft = ents.Create( "sent_Sakarias_CarWheel" )		
	self.WfrontLeft.TireModel = model
	self.WfrontLeft:SetPos(self.Entity:GetPos() + newPos )
	self.WfrontLeft:SetOwner(self.Owner)		
	self.WfrontLeft:SetAngles(self.Entity:GetAngles() + Angle(0,180,0))
	self.WfrontLeft.SCarOwner = self.Entity	
	self.WfrontLeft.EntOwner = self.Entity	
	self.WfrontLeft:Spawn()
	self.WfrontLeft:SetCanTakeDamage( self.CanTakeWheelDamage )
	self.axisFL = constraint.Axis( self.WfrontLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )
	construct.SetPhysProp( self.Owner,  self.WfrontLeft, 0, nil, { GravityToggle = 1, Material = self.physMat })
	
	if wasValid == true	then
		self.WfrontLeft:SetPos( oldPos )
		self.WfrontLeft:SetAngles( oldAng )
	end
	
	--Front right
	if self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil && self.WfrontRight.IsDestroyed == 0 then
		wasValid = true
	else
		wasValid = false
		if self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil then
			self.WfrontRight:Remove()
		end	
	end

	if wasValid == true then
		oldPos = self.WfrontRight:GetPos()
		oldAng = self.WfrontRight:GetAngles()	
		self.WfrontRight:Remove()
	end
	
	newPos = self.FRwheelPos + Vector(0,0,(self.HeightFront *-1))
	
	//FrontRight
	self.WfrontRight = ents.Create( "sent_Sakarias_CarWheel" )	
	self.WfrontRight.TireModel = model	
	self.WfrontRight:SetPos( self.Entity:GetPos() + newPos)
	self.WfrontRight:SetOwner(self.Owner)		
	self.WfrontRight:SetAngles(self.Entity:GetAngles())
	self.WfrontRight.SCarOwner = self.Entity	
	self.WfrontRight.EntOwner = self.Entity	
	self.WfrontRight:Spawn()	
	self.WfrontRight:SetCanTakeDamage( self.CanTakeWheelDamage )
	self.axisFR = constraint.Axis( self.WfrontRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )
	construct.SetPhysProp( self.Owner,  self.WfrontRight, 0, nil, { GravityToggle = 1, Material = self.physMat })
	
	if wasValid == true then
		self.WfrontRight:SetPos( oldPos )
		self.WfrontRight:SetAngles( oldAng )
	end
	
	--Rear left
	if self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil && self.WrearLeft.IsDestroyed == 0 then
		wasValid = true
	else
		wasValid = false
		if self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil then
			self.WrearLeft:Remove()
		end
	end	
	
	if wasValid == true then
	oldPos = self.WrearLeft:GetPos()
	oldAng = self.WrearLeft:GetAngles()	
	self.WrearLeft:Remove()
	end
	
	newPos = self.RLwheelPos + Vector(0,0,(self.HeightRear *-1))
	
	//RearLeft
	self.WrearLeft = ents.Create( "sent_Sakarias_CarWheel" )
	self.WrearLeft.TireModel = model	
	self.WrearLeft:SetPos( self.Entity:GetPos() + newPos)
	self.WrearLeft:SetOwner(self.Owner)		
	self.WrearLeft:SetAngles(self.Entity:GetAngles() + Angle(0,180,0) )
	self.WrearLeft.EntOwner = self.Entity	
	self.WrearLeft:Spawn()
	self.WrearLeft:SetCanTakeDamage( self.CanTakeWheelDamage )
	self.axisRL = constraint.Axis( self.WrearLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )	
	construct.SetPhysProp( self.Owner,  self.WrearLeft, 0, nil, { GravityToggle = 1, Material = self.physMat })
	
	if wasValid == true then
		self.WrearLeft:SetPos( oldPos )	
		self.WrearLeft:SetAngles( oldAng )	
	end
	
	--Rear Right
	if self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil && self.WrearRight.IsDestroyed == 0 then
		wasValid = true
	else
		wasValid = false
		if self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil then
			self.WrearRight:Remove()
		end
	end	
	
	if wasValid == true then
		oldPos = self.WrearRight:GetPos()
		oldAng = self.WrearRight:GetAngles()
		self.WrearRight:Remove()
	end	
	
	newPos = self.RRwheelPos + Vector(0,0,(self.HeightRear *-1))	
	
	//RearRight
	self.WrearRight = ents.Create( "sent_Sakarias_CarWheel" )
	self.WrearRight.TireModel = model	
	self.WrearRight:SetPos( self.Entity:GetPos() + newPos)
	self.WrearRight:SetOwner(self.Owner)		
	self.WrearRight:SetAngles(self.Entity:GetAngles()  )
	self.WrearRight.EntOwner = self.Entity	
	self.WrearRight:Spawn()	
	self.WrearRight:SetCanTakeDamage( self.CanTakeWheelDamage )
	self.axisRR = constraint.Axis( self.WrearRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )
	construct.SetPhysProp( self.Owner,  self.WrearRight, 0, nil, { GravityToggle = 1, Material = self.physMat })
	
	if wasValid == true then
		self.WrearRight:SetPos( oldPos )		
		self.WrearRight:SetAngles( oldAng )
	end

	self.Entity:SetAngles(ang)
	
	
	--Nocolliding the wheels
	if self.WfrontLeft.Rim && self.WfrontLeft.Rim:IsValid() then
		constraint.NoCollide( self.Entity, self.WfrontLeft.Rim, 0, 0 )	
	end

	if self.WfrontRight.Rim && self.WfrontRight.Rim:IsValid() then
		constraint.NoCollide( self.Entity, self.WfrontRight.Rim, 0, 0 )	
	end

	if self.WrearLeft.Rim && self.WrearLeft.Rim:IsValid() then
		constraint.NoCollide( self.Entity, self.WrearLeft.Rim, 0, 0 )	
	end

	if self.WrearRight.Rim && self.WrearRight.Rim:IsValid() then
		constraint.NoCollide( self.Entity, self.WrearRight.Rim, 0, 0 )	
	end					
	
	constraint.NoCollide( self.Entity, self.WfrontLeft, 0, 0 )		
	constraint.NoCollide( self.Entity, self.WfrontRight, 0, 0 )		
	constraint.NoCollide( self.Entity, self.WrearLeft , 0, 0 )		
	constraint.NoCollide( self.Entity, self.WrearRight, 0, 0 )
	
	--Setting Owner
	self.WfrontLeft:SetCarOwner( self.Owner )
	self.WfrontRight:SetCarOwner( self.Owner )
	self.WrearLeft:SetCarOwner( self.Owner )	
	self.WrearRight:SetCarOwner( self.Owner )		
	
end

function ENT:SetSuspensionAddHeight( SuspensionAddHeight )
	self.HydraulicHeight = SuspensionAddHeight
end

function ENT:SetHydraulicActive( Active )
	self.HydraulicActive = Active
end

function ENT:SetTurboDuration( TurboDuration )
	self.TurboDuration  = TurboDuration
end

function ENT:SetTurboDelay( TurboDelay )
	self.TurboDelay = TurboDelay
end

function ENT:SetCarHealth( CarHealth )
	self.CarHealth = CarHealth
	self.CarMaxHealth = CarHealth
	
	
	if self.DamageLevel <= 2 && self.DamageLevel != 0 then
		self.SmokeEffect:Remove()
	elseif self.DamageLevel > 2 then
		self.FireEffect:Remove()
	end
	
	self.DamageLevel = 0
	self.FireSound:Stop()

end

function ENT:Repair()
	self.CarHealth = self.CarMaxHealth
	
	self.Entity:SetColor(255,255,255,255)
	self.Entity.IsDestroyed = 0
	
	if self.DamageLevel <= 2 && self.DamageLevel != 0 then
		self.SmokeEffect:Remove()
	elseif self.DamageLevel > 2 then
		self.FireEffect:Remove()
	end

	self.DamageLevel = 0
	self.FireSound:Stop()		
	
	--repair wheels
	self.AutoRepairWheels = true	
end

function ENT:SetCanTakeDamage( CanTakeDamage, CanTakeWheelDamage )
	self.CanTakeDamage = CanTakeDamage
	self.CanTakeWheelDamage = CanTakeWheelDamage
	
	if self.WfrontLeft != NULL && self.WfrontLeft != nil && self.WfrontLeft:IsValid() then
		self.WfrontLeft:SetCanTakeDamage( CanTakeWheelDamage )
	end

	if self.WfrontRight != NULL && self.WfrontRight != nil && self.WfrontRight:IsValid() then
		self.WfrontRight:SetCanTakeDamage( CanTakeWheelDamage )
	end

	if self.WrearLeft != NULL && self.WrearLeft != nil && self.WrearLeft:IsValid() then
		self.WrearLeft:SetCanTakeDamage( CanTakeWheelDamage )
	end
	
	if self.WrearRight != NULL && self.WrearRight != nil && self.WrearRight:IsValid() then
		self.WrearRight:SetCanTakeDamage( CanTakeWheelDamage )
	end	

end

function ENT:SetUseRT( useRT )
	self.useRT = useRT
end

function ENT:SetUseHUD( UseHUD )
	self.UseHud = UseHUD
	self.Seat1:SetNetworkedInt( "SCarUseHud" , UseHUD )
end

function ENT:SetFuelConsumptionUse( FuelConsumptionUse )
	self.UsesFuelConsumption = FuelConsumptionUse
end

function ENT:SetFuelConsumption( FuelConsumption )
	self.FuelConsumption = FuelConsumption
end

function ENT:Refuel()
	self.Fuel = 20000
end

function ENT:Reposition(ply)

	self.Owner = ply

	self.StabilizerProp:SetPos(self.Entity:GetPos())
	
	//FrontLeft	
	local newPos = (self.Entity:GetForward() * self.FLwheelPos.x) + (self.Entity:GetRight() * self.FLwheelPos.y * -1) + (self.Entity:GetUp() * (self.FLwheelPos.z + self.HeightFront))
	self.WfrontLeft:SetPos(self.Entity:GetPos() + newPos )	
	self.WfrontLeft:SetAngles(self.Entity:GetAngles() + Angle(0,180,0) )
	self.WfrontLeft.Owner = ply
	
	//FrontRight
	newPos = (self.Entity:GetForward() * self.FRwheelPos.x) + (self.Entity:GetRight() * self.FRwheelPos.y * -1) + (self.Entity:GetUp() * (self.FRwheelPos.z + self.HeightFront))	
	self.WfrontRight:SetPos( self.Entity:GetPos() + newPos)	
	self.WfrontRight:SetAngles(self.Entity:GetAngles()  )
	self.WfrontRight.Owner = ply
	
	//RearLeft
	newPos = (self.Entity:GetForward() * self.RLwheelPos.x) + (self.Entity:GetRight() * self.RLwheelPos.y * -1) + (self.Entity:GetUp() * (self.RLwheelPos.z + self.HeightRear))
	self.WrearLeft:SetPos( self.Entity:GetPos() + newPos)	
	self.WrearLeft:SetAngles(self.Entity:GetAngles() + Angle(0,180,0))	
	self.WrearLeft.Owner = ply
	
	//RearRight
	newPos = (self.Entity:GetForward() * self.RRwheelPos.x) + (self.Entity:GetRight() * self.RRwheelPos.y * -1) + (self.Entity:GetUp() * (self.RRwheelPos.z + self.HeightRear))		
	self.WrearRight:SetPos( self.Entity:GetPos() + newPos)
	self.WrearRight:SetAngles(self.Entity:GetAngles()  )
	self.WrearRight.Owner = ply

	//Seat1
	if self.NrOfSeats >= 1 then
		newPos = (self.Entity:GetForward() * self.SeatPos1.x) + (self.Entity:GetRight() * self.SeatPos1.y * -1) + (self.Entity:GetUp() * self.SeatPos1.z)		
		self.Seat1:SetPos( self.Entity:GetPos() + newPos )  
		self.Seat1:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat1.Owner = ply
	end
	
	//Seat2
	if self.NrOfSeats >= 2 then
		newPos = (self.Entity:GetForward() * self.SeatPos2.x) + (self.Entity:GetRight() * self.SeatPos2.y * -1) + (self.Entity:GetUp() * self.SeatPos2.z)			
		self.Seat2:SetPos( self.Entity:GetPos() + newPos )  
		self.Seat2:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat2.Owner = ply
	end
	
	//Seat3
	if self.NrOfSeats >= 3 then
		newPos = (self.Entity:GetForward() * self.SeatPos3.x) + (self.Entity:GetRight() * self.SeatPos3.y) + (self.Entity:GetUp() * self.SeatPos3.z)			
		self.Seat3:SetPos( self.Entity:GetPos() + newPos )  
		self.Seat3:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat3.Owner = ply
	end
	
	//Seat4
	if self.NrOfSeats >= 4 then
		newPos = (self.Entity:GetForward() * self.SeatPos4.x) + (self.Entity:GetRight() * self.SeatPos4.y * -1) + (self.Entity:GetUp() * self.SeatPos4.z)			
		self.Seat4:SetPos( self.Entity:GetPos() + newPos )  
		self.Seat4:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))
		self.Seat4.Owner = ply
	end
	
	//Seat5
	if self.NrOfSeats >= 5 then
		newPos = (self.Entity:GetForward() * self.SeatPos5.x) + (self.Entity:GetRight() * self.SeatPos5.y * -1) + (self.Entity:GetUp() * self.SeatPos5.z)			
		self.Seat5:SetPos( self.Entity:GetPos() + newPos )  
		self.Seat5:SetAngles(self.Entity:GetAngles() + Angle(0,-90,0))	
		self.Seat5.Owner = ply	
	end
	
	self:SpecialReposition()
end

function ENT:SetCarOwner( ply )
	self.Owner = ply
	
	--ASS prop protection
	self.Entity:SetNetworkedEntity("ASS_Owner", self.Owner)
	self.Entity:SetVar( "ASS_Owner", self.Owner )
	self.Entity:SetVar("ASS_OwnerOverride", true)
	
	self.WfrontLeft:SetCarOwner( ply )
	self.WfrontRight:SetCarOwner( ply )
	self.WrearLeft:SetCarOwner( ply )	
	self.WrearRight:SetCarOwner( ply )
	
	--Falcos prop protection
	self.Entity.Owner = ply
	self.Entity.OwnerID = ply:SteamID()
	self.OwnerID = ply:SteamID()
	
	--UPS prop protection
	gamemode.Call( "UPSAssignOwnership", ply, self )
	
end

function ENT:SetSteerResponse( SteerResponse )
	self.RealSteerForce = SteerResponse
end

function ENT:SetStabilisation( Stabilisation )
	self.Stabilisation = Stabilisation
	
	if ValidEntity(self.StabilizerConstaint) then
		self.StabilizerConstaint:Remove()
		self.StabilizerConstaint = NULL
	end
	
	local EntAng = self.Entity:GetAngles()
	local StabAng = self.StabilizerProp:GetAngles()
	self.Entity:SetAngles(Angle( 0, 0, 0 ))	
	self.StabilizerProp:SetAngles(Angle( 0, 0, 0 ))	
	self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, Angle(0,0,0) , 0, self.Stabilisation)	
	self.Entity:SetAngles(EntAng)
	self.StabilizerProp:SetAngles(StabAng)	
end

function ENT:SetThirdPersonView( ThirdPersonView )
	self.Seat1:SetNetworkedInt( "SCarThirdPersonView", ThirdPersonView )
end

function ENT:UpdateAllCharacteristics()

	local NewAcceleration = GetConVarNumber("scar_acceleration")
	local NewMaxSpeed = GetConVarNumber("scar_maxspeed")
	local NewTurboEffect = GetConVarNumber("scar_turborffect")
	local NewTurboDuration = GetConVarNumber("scar_turboduration")
	local NewTurboDelay = GetConVarNumber("scar_turbodelay")
	local NewReverseForce = GetConVarNumber("scar_reverseforce")
	local NewReverseMaxSpeed = GetConVarNumber("scar_reversemaxspeed")
	local NewBreakEfficiency = GetConVarNumber("scar_breakEfficiency")
	local NewSteerForce = GetConVarNumber("scar_steerforce")
	local NewSteerResponse = GetConVarNumber("scar_steerresponse")
	local NewStabilisation = GetConVarNumber("scar_stabilisation")
	local NewNrOfGears = GetConVarNumber("scar_nrofgears")
	local NewuseRT = GetConVarNumber("scar_usert")
	local NewUseHUD = GetConVarNumber("scar_usehud")
	local NewThirdPersonView = GetConVarNumber("scar_thirdpersonview")
	local NewFuelConsumptionUse = GetConVarNumber("scar_fuelconsumptionuse")
	local NewFuelConsumption = GetConVarNumber("scar_fuelconsumption")
	local NewHydraulicActive = GetConVarNumber("scar_allowHydraulics") 
	local NewCarHealth = GetConVarNumber("scar_maxhealth") 
	local NewCanTakeDamage = GetConVarNumber("scar_cardamage") 
	local NewCanTakeWheelDamage = GetConVarNumber("scar_tiredamage") 	
	local NewMaxAntiSlide = GetConVarNumber("scar_maxantislide")
	local NewMaxAutoStraighten = GetConVarNumber("scar_maxautostraighten")
	

	if self.Acceleration > NewAcceleration then
		self:SetAcceleration( NewAcceleration )
		self.Entity.Acceleration = NewAcceleration
	end
	
	if self.MaxSpeed > NewMaxSpeed then
		self:SetMaxSpeed( NewMaxSpeed )
		self.Entity.MaxSpeed = NewMaxSpeed
	end
	
	if self.TurboEffect > NewTurboEffect then
		self:SetTurboEffect( NewTurboEffect )
		self.Entity.TurboEffect = NewTurboEffect	
	end
	
	if self.TurboDuration > NewTurboDuration then
		self:SetTurboDuration(NewTurboDuration)
		self.Entity.TurboDuration = NewTurboDuration
	end
	
	if self.TurboDelay < NewTurboDelay then
		self:SetTurboDelay(NewTurboDelay)
		self.Entity.TurboDelay = NewTurboDelay
	end
	
	if self.ReverseForce > NewReverseForce then
		self:SetReverseForce(NewReverseForce)
		self.Entity.ReverseForce = NewReverseForce
	end
	
	if self.ReverseMaxSpeed > NewReverseMaxSpeed then
		self:SetReverseMaxSpeed(NewReverseMaxSpeed)
		self.Entity.ReverseMaxSpeed = NewReverseMaxSpeed 
	end
	
	if self.BreakEfficiency > NewBreakEfficiency then
		self:SetBreakEfficiency(NewBreakEfficiency)
		self.Entity.BreakEfficiency = NewBreakEfficiency
	end
	
	if self.SteerForce > NewSteerForce then
		self:SetSteerForce(NewSteerForce)
		self.Entity.SteerForce	= NewSteerForce
	end
	
	if self.SteerResponse > NewSteerResponse then
		self:SetSteerResponse(NewSteerResponse) 
		self.Entity.SteerResponse = NewSteerResponse
	end
	
	if self.Stabilisation > NewStabilisation then
		self:SetStabilisation(NewStabilisation)
		self.Entity.Stabilisation = NewStabilisation	
	end
	
	if self.NrOfGears < NewNrOfGears then
		self:SetNrOfGears(NewNrOfGears)
		self.Entity.NrOfGears = NewNrOfGears
	end
	
	if NewuseRT == 0 && self.useRT == 1 then
		self:SetUseRT(NewuseRT)
		self.Entity.useRT = 0			
	end


	if NewUseHUD == 0 && self.UseHUD == 1 then
		self:SetUseHUD(NewUseHUD)
		self.Entity.UseHUD = NewUseHUD	
		self.Seat1:SetNetworkedInt( "SCarUseHud" , 0 )		
	end
	
	if self.AntiSlide > NewMaxAntiSlide then
		self.AntiSlide = NewMaxAntiSlide
		self.Entity.AntiSlide = self.AntiSlide		
	end	

	if self.AutoStraighten > NewMaxAutoStraighten then
		self.AutoStraighten = NewMaxAutoStraighten
	end	
	
	
	
	local thrdPer = self.Seat1:GetNetworkedInt( "SCarThirdPersonView")
	if NewThirdPersonView == 0 && thrdPer == 1 then
		self.Seat1:SetNetworkedInt( "SCarThirdPersonView", 0)
		self.Entity.ThirdPersonView = NewThirdPersonView		
	end

	if NewFuelConsumptionUse == 0 && self.UsesFuelConsumption == 0 then
		self:SetFuelConsumptionUse( 1 )
		self.Entity.FuelConsumptionUse = 1			
	end
	
	if self.FuelConsumption < NewFuelConsumption then
		self:SetFuelConsumption( NewFuelConsumption )
		self.Entity.FuelConsumption = NewFuelConsumption		
	end
	
	if NewHydraulicActive == 0 && self.HydraulicActive == 1 then
		self.Entity:SetHydraulicActive( NewHydraulicActive )
		self.Entity.HydraulicActive = NewHydraulicActive	
	end
	
	if self.CarMaxHealth > NewCarHealth then
		self.Entity:SetCarHealth( NewCarHealth )
		self.Entity.CarHealth = NewCarHealth	
	end
	
	if NewCanTakeDamage == 0 && self.CanTakeDamage == 0 then
		self.CanTakeDamage = 1
		self.Entity.CanTakeDamage = 1
	end
	
	if NewCanTakeWheelDamage == 0 && self.CanTakeWheelDamage == 0 then
		self.CanTakeWheelDamage = 1
		self.Entity.CanTakeWheelDamage = 1
		
		if self.WfrontLeft != NULL && self.WfrontLeft != nil && self.WfrontLeft:IsValid() then
			self.WfrontLeft:SetCanTakeDamage( 1 )
		end

		if self.WfrontRight != NULL && self.WfrontRight != nil && self.WfrontRight:IsValid() then
			self.WfrontRight:SetCanTakeDamage( 1 )
		end

		if self.WrearLeft != NULL && self.WrearLeft != nil && self.WrearLeft:IsValid() then
			self.WrearLeft:SetCanTakeDamage( 1 )
		end
		
		if self.WrearRight != NULL && self.WrearRight != nil && self.WrearRight:IsValid() then
			self.WrearRight:SetCanTakeDamage( 1 )
		end			
		
	end
 	
end

function ENT:SetCameraCorrection( CameraCorrection )
	self.Seat1:SetNetworkedInt( "SCarCameraCorrection", CameraCorrection )
end

function ENT:SetAntiSlide( AntiSlide )
	self.AntiSlide = AntiSlide
end

-------------------------------------------USE
function ENT:Use( activator, caller )	

	//If the ent is still functioning and there is no one in it you will be able to enter it 
	if activator:IsPlayer() && self.UseDelay < CurTime() && self.DamageLevel != 4 && (activator.EnterSCarDel == nil or activator.EnterSCarDel < CurTime()) && self.Entity:WaterLevel() <= 1 then
	
		if activator.EnterSCarDel == nil then
			activator.EnterSCarDel = 0
		end
	
		self.UseDelay = CurTime() + 1
	
		self.UsingSeat1 = false
		self.UsingSeat2 = false
		self.UsingSeat3 = false
		self.UsingSeat4 = false
		self.UsingSeat5 = false		
		local snapEye = false
	
		--Which seats are currently being used?
		for k,v in pairs(player.GetAll()) do
			if v:InVehicle( ) then
				local PlyUsedVeh = v:GetVehicle()						
				
				if PlyUsedVeh == self.Seat1 && self.NrOfSeats >= 1 then
					self.UsingSeat1 = true
					self.User1.EnterSCarDel = CurTime() + 1
				end
				
				if PlyUsedVeh == self.Seat2 && self.NrOfSeats >= 2 then
					self.UsingSeat2 = true
					self.User2.EnterSCarDel = CurTime() + 1				
				end

				if PlyUsedVeh == self.Seat3 && self.NrOfSeats >= 3 then
					self.UsingSeat3 = true	
					self.User3.EnterSCarDel = CurTime() + 1				
				end

				if PlyUsedVeh == self.Seat4 && self.NrOfSeats >= 4 then
					self.UsingSeat4 = true		
					self.User4.EnterSCarDel = CurTime() + 1					
				end

				if PlyUsedVeh == self.Seat5 && self.NrOfSeats >= 5 then
					self.UsingSeat5 = true	
					self.User5.EnterSCarDel = CurTime() + 1					
				end						
				
			end
		end
		
		if self.UsingSeat1 == false && self.NrOfSeats >= 1 then
			activator:EnterVehicle( self.Seat1 )
			self.User1 = activator
			self.UsingSeat1 = true
			snapEye = true
			
			if self.ThirdPView == 1 && self.User1:GetViewEntity():GetClass() == "player" then
				self.User1:SetViewEntity(self.Seat1)
			end
			
		elseif self.UsingSeat2 == false && self.NrOfSeats >= 2 then 
			activator:EnterVehicle( self.Seat2 )
			self.User2 = activator			
			self.UsingSeat2 = true
			snapEye = true
			
		elseif self.UsingSeat3 == false && self.NrOfSeats >= 3 then 
			activator:EnterVehicle( self.Seat3 )
			self.User3 = activator			
			self.UsingSeat3 = true
			snapEye = true
			
		elseif self.UsingSeat4 == false && self.NrOfSeats >= 4 then 
			activator:EnterVehicle( self.Seat4 )
			self.User4 = activator	
			self.UsingSeat4 = true
			snapEye = true
			
		elseif self.UsingSeat5 == false && self.NrOfSeats >= 5 then 
			activator:EnterVehicle( self.Seat5 )
			self.User5 = activator			
			self.UsingSeat5 = true	
			snapEye = true			
		end	
		
		
		if 	snapEye == true then
			local viewAng = self.Entity:GetAngles():Forward()
			viewAng.y = viewAng.y + 90
			activator:SetEyeAngles( viewAng )
		end
		
	end	
end


-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
 
	local LastSpeed = data.OurOldVelocity:Length()
	local NewVelocity = phys:GetVelocity():Length()
	local difference = LastSpeed - NewVelocity
	
	if difference > 200 then
		local ranSound = math.random(1,4)	

		if self.CanTakeDamage == 1 then
			local damage = difference / 50
			self.CarHealth = self.CarHealth - damage
		end
		
		if difference < 500 then
			self.Entity:EmitSound("vehicles/v8/vehicle_impact_medium"..ranSound..".wav",80,math.random(80,120))
		elseif difference >= 500 then
			self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy"..ranSound..".wav",80,math.random(80,120))			
		end
	end
	
end
-------------------------------------------PHYSICS =D
function ENT:PhysicsUpdate( physics )	

	if self.UsingSeat1 && ValidEntity(self.User1) && self.Fuel > 0 && self.Entity:WaterLevel() <= 1 && self.StartDel < CurTime() then

		
		local SPEEDMULTIPLIER = 2
	
		local vel = self.Entity:GetVelocity():Length()
		
		local entphys = self.Entity:GetPhysicsObject()			
	
		local isInAir = false
		
		local curVel = self.Entity:GetVelocity():Normalize()
		local front = self.Entity:GetForward()
		
		local speedDir = curVel:DotProduct(front)
			
			
		
		if ((self.WrearRight.IsColliding == 0 and self.WrearLeft.IsColliding == 0) or (self.RemovedRL == 1 && self.RemovedRR == 1 )) then
			isInAir = true
		end
		
	
		--Changing the pitch of the engine sound.
		if self.PlayOnce == 1 && isInAir == false && not(self.User1:KeyDown( IN_JUMP )) && (self.User1:KeyDown( IN_FORWARD ) or (self.User1:KeyDown( IN_BACK ))) && not(self.User1:KeyDown( IN_FORWARD ) && self.User1:KeyDown( IN_BACK )) then			
			local scale = (self.MaxSpeed / self.NrOfGears)
			local addPitch = 40
			
			if  !(self.User1:KeyDown( IN_BACK )) then
				self.Gear = math.floor( vel / scale )
				self.RealGear = self.Gear
			end
			
			if self.Gear != 0 then
				addPitch = 70
			end
			
			self.RealPitch = (vel - self.Gear * scale)
			self.RealPitch = (self.RealPitch / scale) * 170 + addPitch
	
			if self.Gear >= self.NrOfGears then
				self.Gear = self.Gear - 1
				self.RealGear = self.Gear
				self.RealPitch = 170 + addPitch
			end
			
			if self.User1:KeyDown( IN_BACK ) && speedDir < 0 then
				self.RealPitch = ( vel / self.ReverseMaxSpeed ) * 170
			end			
			
		end
		
		if (((self.User1:KeyDown( IN_FORWARD ) or self.User1:KeyDown( IN_BACK ) ) && isInAir == true) or (self.User1:KeyDown( IN_JUMP ) && (self.User1:KeyDown( IN_FORWARD ) or self.User1:KeyDown( IN_BACK ) ))) && not(self.User1:KeyDown( IN_ATTACK )) or self.SkidType == 1 then
			self.RealPitch = self.RealPitch + 5
		
		elseif not(self.User1:KeyDown( IN_FORWARD )) or not(self.User1:KeyDown( IN_BACK )) then
			self.RealPitch = self.RealPitch - 1
		end		
	

	
		if self.RealPitch < 40 then
			self.RealPitch = 40
		
		elseif self.RealPitch > 210 then
			self.RealPitch = 210
		end		
		
		self.Pitch = math.Approach( self.Pitch, self.RealPitch, ((self.RealPitch - self.Pitch) / 5) )
		
		if self.UsesFuelConsumption == 1 then
			self.Fuel = self.Fuel - ((self.RealPitch / 210) * self.FuelConsumption)
			
			if self.UpdateFuelDel < CurTime() then
				self.UpdateFuelDel = CurTime() + 2
				self.Seat1:SetNetworkedInt( "SCarFuel", self.Fuel )
			end
		end
		
		if self.PlayOnce == 1 then
			self.StartSound:ChangePitch( self.Pitch + 30 )
		end
		
		if self.UsingSeat1 == true && self.UseHud == 1 then
			self.Seat1:SetNetworkedFloat( "EngineRev" , self.Pitch )
		end	
		
	
		--Gear
		if self.Gear != self.OldGear && self.ShiftTime < CurTime() then
			self.ShiftTime = CurTime() + 0.5
			self.ShiftSpeed = vel + 100	
			
			self.OldGear = self.Gear
			self.Entity:EmitSound("car/changeGear.wav")
			
			if self.UseHud == 1 then
				self.Seat1:SetNetworkedInt( "SCarGear" , self.Gear )
			end
		end
		
		if self.Breaking == true && not(self.User1:KeyDown( IN_BACK )) && self.handBreak == false then
			self.Seat1:SetNetworkedInt( "SCarGear" , self.Gear )
			self.Breaking = false
		end
	
	
		--Forcing the player out from the seat when pressing use
		if 	self.User1:KeyDown( IN_USE ) and self.UseDelay < CurTime()  then
			self.User1:ExitVehicle()
			self.RealSteerForce = 0
			self.UseDelay = CurTime() + 1
			
			if self.User1:GetViewEntity():GetClass() == self.Entity:GetClass() then
				self.User1:SetViewEntity(self.User1)	
			end
		end
		
		//CONTROL
		
		--View	
		
		local change = false
		if self.User1.ScarSpecialMiscKeyInput == 11 && self.SwitchViewDelay < CurTime() then
			change = true
			self.SwitchViewDelay = CurTime() + 0.5
			self.User1.ScarSpecialMiscKeyInput = -1
		end
		
		if change == true && self.User1:GetViewEntity():GetClass() != "gmod_cameraprop" then

			if(self.ThirdPView == 1) then
				self.ThirdPView = 0
				self.User1:SetViewEntity(self.User1)
			else
				self.ThirdPView = 1
				self.User1:SetViewEntity(self.Seat1)
			end
			
			local allow = GetConVarNumber("scar_thirdpersonview")
			
			if allow == 0 then
				self.ThirdPView = 0
				self.User1:SetViewEntity(self.User1)
			end
			
			self.Seat1:SetNetworkedInt( "SCarThirdPersonView", self.ThirdPView )
		end
		
		
		--LIGHTS
		
		--Toggling light
		change = false
		if self.User1.ScarSpecialMiscKeyInput == 10 && self.switchLightDelay < CurTime() then	
			if(self.LightOn == 0) then
				self.LightOn = 1
			else
				self.LightOn = 2
			end
				
			change = true
			self.switchLightDelay = CurTime() + 0.5
			self.User1.ScarSpecialMiscKeyInput = -1
		end
		
		
		if change == true then
		
			if (self.LightOn == 1) then
				
			self.Entity:EmitSound("buttons/button1.wav")				
				
				if ValidEntity(self.FLlightSprite) then
					self.FLlightSprite:Remove()
					self.FLlightSprite = NULL
				end
				
				if ValidEntity(self.FRlightSprite) then
					self.FRlightSprite:Remove()
					self.FRlightSprite = NULL
				end	
				

				if ValidEntity(self.FLlight) then
					self.FLlight:Remove()
					self.FLlight = NULL
				end
				
				if ValidEntity(self.FRlight) then
					self.FRlight:Remove()
					self.FRlight = NULL
				end					
				
				local allow =  GetConVarNumber("scar_usert")
				
				if allow == 1 then
					if (self.FLlight == NULL) then
						self.FLlight = ents.Create( "env_projectedtexture" )
						self.FLlight:SetParent( self.Entity )
						self.FLlight:SetLocalPos( self.FLlightPos )
						self.FLlight:SetLocalAngles( Angle(10,0,0) )
						self.FLlight:SetKeyValue( "enableshadows", 1 )
						self.FLlight:SetKeyValue( "LightWorld", 1 )		
						self.FLlight:SetKeyValue( "farz", 2048 )
						self.FLlight:SetKeyValue( "nearz", 65 )
						self.FLlight:SetKeyValue( "lightfov", 50 )
						self.FLlight:SetKeyValue( "lightcolor", "255 255 255" )
						self.FLlight:Spawn()
						self.FLlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )				
					end
					
					if (self.FRlight == NULL) then			
						self.FRlight = ents.Create( "env_projectedtexture" )
						self.FRlight:SetParent( self.Entity )
						self.FRlight:SetLocalPos( self.FRlightPos )
						self.FRlight:SetLocalAngles( Angle(10,0,0) )
						self.FRlight:SetKeyValue( "enableshadows", 1 )
						self.FRlight:SetKeyValue( "LightWorld", 1 )	
						self.FRlight:SetKeyValue( "farz", 2048 )
						self.FRlight:SetKeyValue( "nearz", 65 )
						self.FRlight:SetKeyValue( "lightfov", 50 )
						self.FRlight:SetKeyValue( "lightcolor", "255 255 255" )
						self.FRlight:Spawn()
						self.FRlight:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )			
					end	
				end
				
				self.FLlightSprite = ents.Create("env_sprite");
				self.FLlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.FLlightPos.x ) + ( self.Entity:GetRight() * self.FLlightPos.y ) + ( self.Entity:GetUp() * self.FLlightPos.z ) )	
				self.FLlightSprite:SetKeyValue( "renderfx", "14" )
				self.FLlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
				self.FLlightSprite:SetKeyValue( "scale","1.0")
				self.FLlightSprite:SetKeyValue( "spawnflags","1")
				self.FLlightSprite:SetKeyValue( "angles","0 0 0")
				self.FLlightSprite:SetKeyValue( "rendermode","9")
				self.FLlightSprite:SetKeyValue( "renderamt","255")
				self.FLlightSprite:SetKeyValue( "rendercolor", "240 240 170" )				
				self.FLlightSprite:Spawn()
				self.FLlightSprite:SetParent( self.Entity )				
				
				
				self.FRlightSprite = ents.Create("env_sprite");
				self.FRlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.FRlightPos.x ) + ( self.Entity:GetRight() * self.FRlightPos.y ) + ( self.Entity:GetUp() * self.FRlightPos.z ) )
				self.FRlightSprite:SetKeyValue( "renderfx", "14" )
				self.FRlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
				self.FRlightSprite:SetKeyValue( "scale","1.0")
				self.FRlightSprite:SetKeyValue( "spawnflags","1")
				self.FRlightSprite:SetKeyValue( "angles","0 0 0")
				self.FRlightSprite:SetKeyValue( "rendermode","9")
				self.FRlightSprite:SetKeyValue( "renderamt","255")
				self.FRlightSprite:SetKeyValue( "rendercolor", "240 240 170" )				
				self.FRlightSprite:Spawn()
				self.FRlightSprite:SetParent( self.Entity )						
				
			elseif self.LightOn == 2 then
			
				self.LightOn = 0
				if ValidEntity(self.FLlight) then
					self.FLlight:Remove()
					self.FLlight = NULL
				end
				
				if ValidEntity(self.FRlight) then
					self.FRlight:Remove()
					self.FRlight = NULL
				end		
				
				if ValidEntity(self.FLlightSprite) then
					self.FLlightSprite:Remove()
					self.FLlightSprite = NULL
				end
				
				if ValidEntity(self.FRlightSprite) then
					self.FRlightSprite:Remove()
					self.FRlightSprite = NULL
				end	
				
				self.FLlightSprite = ents.Create("env_sprite");
				self.FLlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.FLlightPos.x ) + ( self.Entity:GetRight() * self.FLlightPos.y ) + ( self.Entity:GetUp() * self.FLlightPos.z ) )	
				self.FLlightSprite:SetKeyValue( "renderfx", "14" )
				self.FLlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
				self.FLlightSprite:SetKeyValue( "scale","1.0")
				self.FLlightSprite:SetKeyValue( "spawnflags","1")
				self.FLlightSprite:SetKeyValue( "angles","0 0 0")
				self.FLlightSprite:SetKeyValue( "rendermode","9")
				self.FLlightSprite:SetKeyValue( "renderamt","150")
				self.FLlightSprite:SetKeyValue( "rendercolor", "240 240 170" )				
				self.FLlightSprite:Spawn()
				self.FLlightSprite:SetParent( self.Entity )				
				
				self.FRlightSprite = ents.Create("env_sprite");
				self.FRlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.FRlightPos.x ) + ( self.Entity:GetRight() * self.FRlightPos.y ) + ( self.Entity:GetUp() * self.FRlightPos.z ) )
				self.FRlightSprite:SetKeyValue( "renderfx", "14" )
				self.FRlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
				self.FRlightSprite:SetKeyValue( "scale","1.0")
				self.FRlightSprite:SetKeyValue( "spawnflags","1")
				self.FRlightSprite:SetKeyValue( "angles","0 0 0")
				self.FRlightSprite:SetKeyValue( "rendermode","9")
				self.FRlightSprite:SetKeyValue( "renderamt","150")
				self.FRlightSprite:SetKeyValue( "rendercolor", "240 240 170" )				
				self.FRlightSprite:Spawn()
				self.FRlightSprite:SetParent( self.Entity )					

				
			end
		end
		
		
		
		--Hydraulics
		
	
		
		
		if self.HydraulicActive == 1 then

				if self.User1:KeyDown( IN_ATTACK2 ) && self.HydUse == 0 then
				
					self.HydUse = 1
					self.HydDelay = CurTime() + 0.2
					self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))
					self.HydActivateFL = self.HydActivateFL + 1
					self.HydActivateFR = self.HydActivateFR + 1
					self.HydActivateRL = self.HydActivateRL + 1
					self.HydActivateRR = self.HydActivateRR + 1

					if self.HydActivateFL > 1 then
						self.HydActivateFL = 0
					end

					if self.HydActivateFR > 1 then
						self.HydActivateFR = 0
					end
					
					if self.HydActivateRL > 1 then
						self.HydActivateRL = 0
					end

					if self.HydActivateRR > 1 then
						self.HydActivateRR = 0
					end				
				elseif not(self.User1:KeyDown( IN_ATTACK2 )) then
					self.HydUse = 0
				end	
		
		
				if(!ValidEntity(self.WeaponSystem) or (ValidEntity(self.WeaponSystem) && self.WeaponSystem.FireHydraulics == true)) then
				
					--Front
					if self.User1:KeyDown( IN_FORWARD ) && not(self.User1:KeyDown( IN_MOVELEFT )) && not(self.User1:KeyDown( IN_MOVERIGHT )) && self.User1:KeyDown( IN_ATTACK ) then
						
						if self.UseFrontH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))					
							self.HydActivateFL = self.HydActivateFL + 1
							self.HydActivateFR = self.HydActivateFR + 1	

							if self.HydActivateFL > 1 then
								self.HydActivateFL = 0
							end

							if self.HydActivateFR > 1 then
								self.HydActivateFR = 0
							end
						end
						
						self.UseFrontH = 1
					else
					
						if self.UseFrontH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFL = self.HydActivateFL + 1
							self.HydActivateFR = self.HydActivateFR + 1	

							if self.HydActivateFL > 1 then
								self.HydActivateFL = 0
							end

							if self.HydActivateFR > 1 then
								self.HydActivateFR = 0
							end
						end
						self.UseFrontH = 0					
					end
					
					--Back
					if self.User1:KeyDown( IN_BACK ) && not(self.User1:KeyDown( IN_MOVELEFT )) && not(self.User1:KeyDown( IN_MOVERIGHT )) && self.User1:KeyDown( IN_ATTACK ) then

						if self.UseBackH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateRL = self.HydActivateRL + 1
							self.HydActivateRR = self.HydActivateRR + 1

							if self.HydActivateRL > 1 then
								self.HydActivateRL = 0
							end

							if self.HydActivateRR > 1 then
								self.HydActivateRR = 0
							end	
						end
						self.UseBackH = 1					
					else
					
						if self.UseBackH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))					
							self.HydActivateRL = self.HydActivateRL + 1
							self.HydActivateRR = self.HydActivateRR + 1

							if self.HydActivateRL > 1 then
								self.HydActivateRL = 0
							end

							if self.HydActivateRR > 1 then
								self.HydActivateRR = 0
							end	
						end
						self.UseBackH = 0
					end				
				
					--Left
					if self.User1:KeyDown( IN_MOVELEFT ) && not(self.User1:KeyDown( IN_BACK )) && not(self.User1:KeyDown( IN_FORWARD )) && not(self.User1:KeyDown( IN_MOVERIGHT )) && self.User1:KeyDown( IN_ATTACK ) then
						
						if self.UseLeftH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFL = self.HydActivateFL + 1
							self.HydActivateRL = self.HydActivateRL + 1	

							if self.HydActivateFL > 1 then
								self.HydActivateFL = 0
							end

							if self.HydActivateRL > 1 then
								self.HydActivateRL = 0
							end
						end
						self.UseLeftH = 1			
					else
					
						if self.UseLeftH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))					
							self.HydActivateFL = self.HydActivateFL + 1
							self.HydActivateRL = self.HydActivateRL + 1	

							if self.HydActivateFL > 1 then
								self.HydActivateFL = 0
							end

							if self.HydActivateRL > 1 then
								self.HydActivateRL = 0
							end
						end
						self.UseLeftH = 0						
					end			

					--Right
					if self.User1:KeyDown( IN_MOVERIGHT ) && not(self.User1:KeyDown( IN_BACK )) && not(self.User1:KeyDown( IN_FORWARD )) && not(self.User1:KeyDown( IN_MOVELEFT )) && self.User1:KeyDown( IN_ATTACK ) then

						if self.User1ightH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFR = self.HydActivateFR + 1
							self.HydActivateRR = self.HydActivateRR + 1	

							if self.HydActivateFR > 1 then
								self.HydActivateFR = 0
							end

							if self.HydActivateRR > 1 then
								self.HydActivateRR = 0
							end
						end
						self.User1ightH = 1	
					else
					
						if self.User1ightH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFR = self.HydActivateFR + 1
							self.HydActivateRR = self.HydActivateRR + 1	

							if self.HydActivateFR > 1 then
								self.HydActivateFR = 0
							end

							if self.HydActivateRR > 1 then
								self.HydActivateRR = 0
							end
						end	
						self.User1ightH = 0					
					end
					
					
					--Front Left
					if self.User1:KeyDown( IN_MOVELEFT ) && self.User1:KeyDown( IN_FORWARD ) && not(self.User1:KeyDown( IN_BACK )) && not(self.User1:KeyDown( IN_MOVERIGHT )) && self.User1:KeyDown( IN_ATTACK ) then

						if self.UseFrontLeftH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFL = self.HydActivateFL + 1

							if self.HydActivateFL > 1 then
								self.HydActivateFL = 0
							end

						end
						self.UseFrontLeftH = 1	
					else
					
						if self.UseFrontLeftH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFL = self.HydActivateFL + 1

							if self.HydActivateFL > 1 then
								self.HydActivateFL = 0
							end

						end	
						self.UseFrontLeftH = 0					
					end				

					--Front Right
					if self.User1:KeyDown( IN_MOVERIGHT ) && self.User1:KeyDown( IN_FORWARD ) && not(self.User1:KeyDown( IN_BACK )) && not(self.User1:KeyDown( IN_MOVELeft )) && self.User1:KeyDown( IN_ATTACK ) then

						if self.UseFrontRightH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFR = self.HydActivateFR + 1

							if self.HydActivateFR > 1 then
								self.HydActivateFR = 0
							end

						end
						self.UseFrontRightH = 1	
					else
					
						if self.UseFrontRightH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateFR = self.HydActivateFR + 1

							if self.HydActivateFR > 1 then
								self.HydActivateFR = 0
							end

						end	
						self.UseFrontRightH = 0					
					end			

					--Back Left
					if self.User1:KeyDown( IN_MOVELEFT ) && self.User1:KeyDown( IN_BACK ) && not(self.User1:KeyDown( IN_FORWARD )) && not(self.User1:KeyDown( IN_MOVERIGHT )) && self.User1:KeyDown( IN_ATTACK ) then

						if self.User1earLeftH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateRL = self.HydActivateRL + 1

							if self.HydActivateRL > 1 then
								self.HydActivateRL = 0
							end

						end
						self.User1earLeftH = 1	
					else
					
						if self.User1earLeftH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateRL = self.HydActivateRL + 1

							if self.HydActivateRL > 1 then
								self.HydActivateRL = 0
							end

						end	
						self.User1earLeftH = 0					
					end				

					--Back Right
					if self.User1:KeyDown( IN_MOVERIGHT ) && self.User1:KeyDown( IN_BACK ) && not(self.User1:KeyDown( IN_FORWARD )) && not(self.User1:KeyDown( IN_MOVELeft )) && self.User1:KeyDown( IN_ATTACK ) then

						if self.User1earRightH == 0 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateRR = self.HydActivateRR + 1

							if self.HydActivateRR > 1 then
								self.HydActivateRR = 0
							end

						end
						self.User1earRightH = 1	
					else
					
						if self.User1earRightH == 1 then
							self.Entity:EmitSound("car/hydraulics.wav",50,math.random(50,150))						
							self.HydActivateRR = self.HydActivateRR + 1

							if self.HydActivateRR > 1 then
								self.HydActivateRR = 0
							end

						end	
						self.User1earRightH = 0					
					end			
				end
			
			local carVel = self.Entity:GetPhysicsObject():GetVelocity()
	
			--EXTENDING
			if self.HydActivateFL == 1 and self.HydActiveFL == 0 && self.RemovedFL == 0 && self.WfrontLeft:IsValid() && self.WfrontLeft != NULL && self.WfrontLeft != nil then
				self.HydActiveFL = 1
				self.axisFL:Remove()
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))
				
				
				local vel = self.WfrontLeft:GetPhysicsObject():GetVelocity()
				local newPos = self.FLwheelPos + Vector(0,0,((self.HeightFront *-1) + self.HydraulicHeight))
				local oldPos = self.WfrontLeft:GetPos()
				local oldAng = self.WfrontLeft:GetAngles()
				self.WfrontLeft:SetPos(self.Entity:GetPos() + newPos )
				self.WfrontLeft:SetAngles( self.Entity:GetAngles() + Angle(0,180,0)  )
				self.axisFL = constraint.Axis( self.WfrontLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )						
				self.WfrontLeft:SetPos( oldPos )
				self.WfrontLeft:SetAngles( oldAng )	
				self.WfrontLeft:GetPhysicsObject():SetVelocity( vel )	
				
				self.Entity:SetAngles(ang)
				self.Entity:GetPhysicsObject():SetVelocity(carVel)
				
				constraint.NoCollide( self.Entity, self.WfrontLeft.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WfrontLeft, 0, 0 )	
				
			end

			if self.HydActivateFR == 1 and self.HydActiveFR == 0 && self.RemovedFR == 0 && self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil  then
				self.HydActiveFR = 1
				self.axisFR:Remove()				
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))

				local vel = self.WfrontRight:GetPhysicsObject():GetVelocity()				
				local newPos = self.FRwheelPos + Vector(0,0,((self.HeightFront *-1) + self.HydraulicHeight))	
				local oldPos = self.WfrontRight:GetPos()
				local oldAng = self.WfrontRight:GetAngles()	
				self.WfrontRight:SetPos(self.Entity:GetPos() + newPos )
				self.WfrontRight:SetAngles( self.Entity:GetAngles()  )	
				self.axisFR = constraint.Axis( self.WfrontRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )	
				self.WfrontRight:SetPos( oldPos )
				self.WfrontRight:SetAngles( oldAng )
				self.WfrontRight:GetPhysicsObject():SetVelocity( vel )	
				
				self.Entity:SetAngles(ang)
				self.Entity:GetPhysicsObject():SetVelocity(carVel)
				
				constraint.NoCollide( self.Entity, self.WfrontRight.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WfrontRight, 0, 0 )					
			end

			if self.HydActivateRL == 1 and self.HydActiveRL == 0 && self.RemovedRL == 0 && self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil then
				self.HydActiveRL = 1
				self.axisRL:Remove()				
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))			
				
				local vel = self.WrearLeft:GetPhysicsObject():GetVelocity()				
				local newPos = self.RLwheelPos + Vector(0,0,((self.HeightRear *-1) + self.HydraulicHeight ))
				local oldPos = self.WrearLeft:GetPos()
				local oldAng = self.WrearLeft:GetAngles()	
				self.WrearLeft:SetPos(self.Entity:GetPos() + newPos )
				self.WrearLeft:SetAngles( self.Entity:GetAngles() + Angle(0,180,0)   )
				self.axisRL = constraint.Axis( self.WrearLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )
				self.WrearLeft:SetPos(oldPos)
				self.WrearLeft:SetAngles( oldAng )	
				self.WrearLeft:GetPhysicsObject():SetVelocity( vel )
				
				self.Entity:SetAngles(ang)	
				self.Entity:GetPhysicsObject():SetVelocity(carVel)
				
				constraint.NoCollide( self.Entity, self.WrearLeft.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WrearLeft, 0, 0 )						
			end

			if self.HydActivateRR == 1 and self.HydActiveRR == 0 && self.RemovedRR == 0 && self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil  then
				self.HydActiveRR = 1
				self.axisRR:Remove()				
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))
				
				local vel = self.WrearRight:GetPhysicsObject():GetVelocity()				
				local newPos = self.RRwheelPos + Vector(0,0,((self.HeightRear *-1) + self.HydraulicHeight ))
				local oldPos = self.WrearRight:GetPos()
				local oldAng = self.WrearRight:GetAngles()		
				self.WrearRight:SetPos(self.Entity:GetPos() + newPos )
				self.WrearRight:SetAngles( self.Entity:GetAngles() )	
				self.axisRR = constraint.Axis( self.WrearRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )	
				self.WrearRight:SetPos( oldPos )
				self.WrearRight:SetAngles( oldAng )	
				self.WrearRight:GetPhysicsObject():SetVelocity( vel )
				
				self.Entity:SetAngles(ang)	
				self.Entity:GetPhysicsObject():SetVelocity(carVel)

				constraint.NoCollide( self.Entity, self.WrearRight.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WrearRight, 0, 0 )					
			end
			---
			
			--RETRACTING
			if self.HydActivateFL == 0 and self.HydActiveFL == 1 && self.RemovedFL == 0 && self.WfrontLeft:IsValid() && self.WfrontLeft != NULL && self.WfrontLeft != nil then
				self.HydActiveFL = 0
				self.axisFL:Remove()
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))

				local vel = self.WfrontLeft:GetPhysicsObject():GetVelocity()				
				local newPos = self.FLwheelPos + Vector(0,0,(self.HeightFront *-1))
				local oldPos = self.WfrontLeft:GetPos()
				local oldAng = self.WfrontLeft:GetAngles()
				self.WfrontLeft:SetPos(self.Entity:GetPos() + newPos )
				self.WfrontLeft:SetAngles( self.Entity:GetAngles() + Angle(0,180,0) )
				self.axisFL = constraint.Axis( self.WfrontLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )						
				self.WfrontLeft:SetPos( oldPos )
				self.WfrontLeft:SetAngles( oldAng )
				self.WfrontLeft:GetPhysicsObject():SetVelocity( vel )	
				
				self.Entity:SetAngles(ang)	
				self.Entity:GetPhysicsObject():SetVelocity(carVel)

				constraint.NoCollide( self.Entity, self.WfrontLeft.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WfrontLeft, 0, 0 )	
				
			end

			if self.HydActivateFR == 0 and self.HydActiveFR == 1 && self.RemovedFR == 0 && self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil then
				self.HydActiveFR = 0
				self.axisFR:Remove()
							
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))				
				
				local vel = self.WfrontLeft:GetPhysicsObject():GetVelocity()				
				local newPos = self.FRwheelPos + Vector(0,0, (self.HeightFront *-1))	
				local oldPos = self.WfrontRight:GetPos()
				local oldAng = self.WfrontRight:GetAngles()	
				self.WfrontRight:SetPos(self.Entity:GetPos() + newPos )
				self.WfrontRight:SetAngles( self.Entity:GetAngles() )	
				self.axisFR = constraint.Axis( self.WfrontRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )	
				self.WfrontRight:SetPos( oldPos )
				self.WfrontRight:SetAngles( oldAng )
				self.WfrontRight:GetPhysicsObject():SetVelocity( vel )
				
				self.Entity:SetAngles(ang)	
				self.Entity:GetPhysicsObject():SetVelocity(carVel)

				constraint.NoCollide( self.Entity, self.WfrontRight.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WfrontRight, 0, 0 )					
			end

			if self.HydActivateRL == 0 and self.HydActiveRL == 1 && self.RemovedRL == 0 && self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil then
				self.HydActiveRL = 0
				self.axisRL:Remove()			
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))				
				
				local vel = self.WfrontLeft:GetPhysicsObject():GetVelocity()				
				local newPos = self.RLwheelPos + Vector(0,0, (self.HeightRear *-1))
				local oldPos = self.WrearLeft:GetPos()
				local oldAng = self.WrearLeft:GetAngles()	
				self.WrearLeft:SetPos(self.Entity:GetPos() + newPos )
				self.WrearLeft:SetAngles( self.Entity:GetAngles() + Angle(0,180,0)  )
				self.axisRL = constraint.Axis( self.WrearLeft, self.Entity, 0, 0, Vector(0,1,0) , newPos, 0, 0, 0 )
				self.WrearLeft:SetPos(oldPos)
				self.WrearLeft:SetAngles( oldAng )	
				self.WrearLeft:GetPhysicsObject():SetVelocity( vel )	
				
				self.Entity:SetAngles(ang)	
				self.Entity:GetPhysicsObject():SetVelocity(carVel)

				constraint.NoCollide( self.Entity, self.WrearLeft.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WrearLeft, 0, 0 )					
			end

			if self.HydActivateRR == 0 and self.HydActiveRR == 1 && self.RemovedRR == 0 && self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil then
				self.HydActiveRR = 0
				self.axisRR:Remove()
				
				local ang = self.Entity:GetAngles()
				self.Entity:SetAngles(Angle( 0, 0, 0 ))
						
				local vel = self.WfrontLeft:GetPhysicsObject():GetVelocity()				
				local newPos = self.RRwheelPos + Vector(0,0, (self.HeightRear *-1))
				local oldPos = self.WrearRight:GetPos()
				local oldAng = self.WrearRight:GetAngles()		
				self.WrearRight:SetPos(self.Entity:GetPos() + newPos )
				self.WrearRight:SetAngles( self.Entity:GetAngles() )	
				self.axisRR = constraint.Axis( self.WrearRight, self.Entity, 0, 0, Vector(0,-1,0) , newPos, 0, 0, 0 )	
				self.WrearRight:SetPos( oldPos )
				self.WrearRight:SetAngles( oldAng )	
				self.WrearRight:GetPhysicsObject():SetVelocity( vel )	
				
				self.Entity:SetAngles(ang)
				self.Entity:GetPhysicsObject():SetVelocity(carVel)

				constraint.NoCollide( self.Entity, self.WrearRight.Rim, 0, 0 )	
				constraint.NoCollide( self.Entity, self.WrearRight, 0, 0 )					
			end			
		end			
		
		--Won't check it if we are using the hand break
		--if not(self.User1:KeyDown( IN_JUMP )) && not(self.User1:KeyDown( IN_ATTACK )) then
		if not(self.User1:KeyDown( IN_JUMP )) then
			
			local turbo = 1

			--Turbo
			if self.User1:KeyDown( IN_SPEED ) && self.TurboTime < CurTime() && self.TurboCant < CurTime() && self.UsingTurbo == false then
				self.TurboTime = CurTime() + self.TurboDuration
				self.UsingTurbo = true
				self.TurboStopSound:Stop()
				self.TurboStartSound:Stop()
				self.TurboStartSound:Play()
			end			
			
			if self.TurboTime > CurTime() && self.UsingTurbo == true then
				turbo = self.TurboEffect
			end
			
			if self.TurboTime < CurTime() && self.UsingTurbo == true then
				self.TurboCant = CurTime() + self.TurboDelay
				self.UsingTurbo = false
				self.TurboStartSound:Stop()
				self.TurboStopSound:Stop()
				self.TurboStopSound:Play()				
			end
	
			--FORWARD
			
			--Checking if we are using hydraulics
			local usesHydraulics = false
			
			if self.User1:KeyDown( IN_ATTACK ) && self.HydraulicActive == 1 && (!ValidEntity(self.WeaponSystem) or (ValidEntity(self.WeaponSystem) && self.WeaponSystem.FireHydraulics == true)) then
				usesHydraulics = true
			end
			
			if 	self.User1:KeyDown( IN_FORWARD ) && self.handBreak == false && not(self.User1:KeyDown( IN_BACK )) && usesHydraulics == false then
				local rightWheel = NULL
				local leftWheel = NULL

				if self.Gear == 0 && self.RealPitch > 190 && vel < 30 && ( self.RemovedRL == 0 or self.RemovedRR == 0 ) then
					local lim = self.Entity:GetUp():DotProduct(Vector(0,0,1))
					
					if lim > 0 && self.StartBoost < CurTime() then
						self.Entity:EmitSound("car/burnout.wav",70,math.random(100,150))
						self.StartBoost = CurTime() + 2
					end
				end

				if self.TurboTime > CurTime() && self.UsingTurbo == true then
					if self.exhaustPos != NULL then
						local nosAng = self.Entity:GetVelocity():Angle()
						nosAng.y = nosAng.y	+ 180
						local nosPos = (self.Entity:GetPos() + (self.Entity:GetForward() * self.exhaustPos.x) + (self.Entity:GetRight() * self.exhaustPos.y) + (self.Entity:GetUp() * self.exhaustPos.z))			
						local effectdata = EffectData()
						effectdata:SetOrigin( nosPos )
						effectdata:SetAngle( nosAng )
						effectdata:SetScale( 1 )
						util.Effect( "MuzzleEffect", effectdata )
					end
					
					if self.exhaustPos2 != NULL then
						local nosAng = self.Entity:GetVelocity():Angle()
						nosAng.y = nosAng.y	+ 180
						local nosPos = (self.Entity:GetPos() + (self.Entity:GetForward() * self.exhaustPos2.x) + (self.Entity:GetRight() * self.exhaustPos2.y) + (self.Entity:GetUp() * self.exhaustPos2.z))			
						local effectdata = EffectData()
						effectdata:SetOrigin( nosPos )
						effectdata:SetAngle( nosAng )
						effectdata:SetScale( 1 )
						util.Effect( "MuzzleEffect", effectdata )
					end					
				end
				

				
				if self.WrearRight != NULL then
					rightWheel = self.WrearRight:GetPhysicsObject()
				end
				
				if self.WrearLeft != NULL then
					leftWheel = self.WrearLeft:GetPhysicsObject()
				end
				
				local spinForceR = 400
				local spinForceL = -400
				
				if self.WrearRight.IsFlat == 1 then
					spinForceR =  spinForceR + 600
				end
	
				if self.WrearLeft.IsFlat == 1 then
					spinForceL =  spinForceL - 600
				end	
				
				if self.ShiftTime < CurTime() then
					self.ShiftSpeed = 1000000
				end
				
				if vel < self.ShiftSpeed && vel < self.MaxSpeed && (rightWheel != NULL or leftWheel != NULL) then
				
					if self.RemovedRR == 0 && rightWheel != NULL then 
						rightWheel:AddAngleVelocity( Vector(0, spinForceR, 0 ))	
					end
					
					if self.RemovedRL == 0 && leftWheel != NULL then 
						leftWheel:AddAngleVelocity( Vector(0, spinForceL, 0 ))	
					end
					
					if (self.WrearRight.IsColliding == 1 or self.WrearLeft.IsColliding == 1) && (self.RemovedRL == 0 or self.RemovedRR == 0 ) then
					
						local speedBoost = 1
						
						if self.StartBoost > CurTime() then
							speedBoost = 5
						end					
					
						entphys:ApplyForceCenter( self.Entity:GetForward() * self.Acceleration * turbo + self.Entity:GetVelocity() * SPEEDMULTIPLIER * speedBoost)
					end	
					
				end			
			
			--REVERSE
			elseif self.User1:KeyDown( IN_BACK ) && self.handBreak == false && not(self.User1:KeyDown( IN_FORWARD )) && usesHydraulics == false then
				local rightWheel = NULL
				local leftWheel = NULL
				local breakeffect = 1
				local scale = vel / self.ReverseMaxSpeed
				self.Breaking = true
				
				if self.WrearRight != NULL then
					rightWheel = self.WrearRight:GetPhysicsObject()
				end
				
				if self.WrearLeft != NULL then
					leftWheel = self.WrearLeft:GetPhysicsObject()
				end				
				
				local realBreakEff = self.DefaultBreakEfficiency + ( (5 - self.BreakEfficiency) / 100)

				local spinForceR = -400
				local spinForceL = 400
				
				if self.WrearRight.IsFlat == 1 then
					spinForceR =  spinForceR - 600
				end
	
				if self.WrearLeft.IsFlat == 1 then
					spinForceL =  spinForceL + 600
				end	
				

				if self.RemovedRR == 0 && rightWheel != NULL then
					rightWheel:AddAngleVelocity( Vector(0, spinForceR, 0 ) )		
				end
				
				if self.RemovedRL == 0 && leftWheel != NULL then 
					leftWheel:AddAngleVelocity( Vector(0, spinForceL, 0 ) )	
				end
				
				
				if (self.WrearLeft.IsColliding == 0 or self.RemovedRL == 1)  then
					breakeffect = breakeffect - 0.5
				end
					
				if (self.WrearRight.IsColliding == 0 or self.RemovedRR == 1) then
					breakeffect = breakeffect - 0.5
				end	
				
						--
						local mul = -1
						local curVel = self.Entity:GetVelocity():Normalize()
						local front = self.Entity:GetForward()
						front = front * -1
						
						if curVel:DotProduct(front) < 0.90 then
							mul = 1
						end
						--
				
				if self.ReverseMaxSpeed > vel && mul == -1 then
					entphys:ApplyForceCenter( self.Entity:GetForward() * self.ReverseForce * breakeffect * -1)
					
					if self.UseHud == 1 then
						self.Seat1:SetNetworkedInt( "SCarGear" , -1 )
					end
					
					self.Gear = -1
					self.RealGear = -1					
				elseif ((self.WrearLeft.IsColliding == 1 and self.RemovedRL == 0) or (self.WrearRight.IsColliding == 1 and self.RemovedRR == 0)) &&  mul == 1 then
					entphys:SetVelocity( self.Entity:GetVelocity() * realBreakEff )	
					entphys:ApplyForceCenter( self.Entity:GetForward() * self.ReverseForce * breakeffect * -1)
					if self.UseHud == 1 then
						self.Seat1:SetNetworkedInt( "SCarGear" , -2 )
						self.RealGear = - 2
					end
				end	
			end	

			if self.User1:KeyDown( IN_BACK ) && self.User1:KeyDown( IN_FORWARD ) && vel < 100 && self.handBreak == false then
			
				local rightWheel = NULL
				local leftWheel = NULL
			
				self.StartBoost = CurTime() + 1
				
				entphys:SetVelocity( self.Entity:GetVelocity() * 0.5)	
				
				if self.WrearRight != NULL then
					rightWheel = self.WrearRight:GetPhysicsObject()
				end
				
				if self.WrearLeft != NULL then
					leftWheel = self.WrearLeft:GetPhysicsObject()
				end		
			
				if self.RemovedRR == 0 && rightWheel != NULL then 
					rightWheel:AddAngleVelocity( Vector(0, 2000, 0 ))	
				end
				
				if self.RemovedRL == 0 && leftWheel != NULL then 
					leftWheel:AddAngleVelocity( Vector(0, -2000, 0 ))	
				end		
				
				if self.DoesWheelSkid == false && (rightWheel != NULL or leftWheel != NULL) then
				
					self.WheelSkid:Play()
					self.DoesWheelSkid = true
					self.SkidType = 1				
				end
				

					if ValidEntity(self.WrearLeft) && self.WrearLeft.IsColliding == 1 && self.TireSmokeLeft == NULL then
						local ang = self.Entity:GetAngles()	
						ang.p = ang.p + 180						
						self.TireSmokeLeft = ents.Create("env_smoketrail")
						self.TireSmokeLeft:SetPos(self.WrearLeft:GetPos() + Vector(0,0,-10 ))
						self.TireSmokeLeft:SetKeyValue("angles", tostring(ang))						
						self.TireSmokeLeft:SetKeyValue("emittime", "16384")
						self.TireSmokeLeft:SetKeyValue("startcolor", "200 200 200 ")
						self.TireSmokeLeft:SetKeyValue("endcolor", "200 200 200")
						self.TireSmokeLeft:SetKeyValue("opacity", "255")
						self.TireSmokeLeft:SetKeyValue("spawnradius", "0")
						self.TireSmokeLeft:SetKeyValue("lifetime", "1" )
						self.TireSmokeLeft:SetKeyValue("startsize", "10")
						self.TireSmokeLeft:SetKeyValue("endsize", "25")
						self.TireSmokeLeft:SetKeyValue("minspeed", "0")
						self.TireSmokeLeft:SetKeyValue("maxspeed", "0")
						self.TireSmokeLeft:SetKeyValue("mindirectedspeed", "68")
						self.TireSmokeLeft:SetKeyValue("maxdirectedspeed", "84")
						self.TireSmokeLeft:SetKeyValue("spawnrate", "64")
						self.TireSmokeLeft:Spawn()
						self.TireSmokeLeft:SetParent(self.Entity)
						self.TireSmokeLeft:Activate()
					end
					
					if ValidEntity(self.WrearRight) && self.WrearRight.IsColliding == 1 && self.TireSmokeRight == NULL then
						local ang = self.Entity:GetAngles()	
						ang.p = ang.p + 180
						self.TireSmokeRight = ents.Create("env_smoketrail")
						self.TireSmokeRight:SetPos(self.WrearRight:GetPos() + Vector(0,0,-10 ))
						self.TireSmokeRight:SetKeyValue("angles", tostring(ang))	
						self.TireSmokeRight:SetKeyValue("emittime", "16384")
						self.TireSmokeRight:SetKeyValue("startcolor", "200 200 200 ")
						self.TireSmokeRight:SetKeyValue("endcolor", "200 200 200")
						self.TireSmokeRight:SetKeyValue("opacity", "255")
						self.TireSmokeRight:SetKeyValue("spawnradius", "0")
						self.TireSmokeRight:SetKeyValue("lifetime", "1" )
						self.TireSmokeRight:SetKeyValue("startsize", "10")
						self.TireSmokeRight:SetKeyValue("endsize", "25")
						self.TireSmokeRight:SetKeyValue("minspeed", "0")
						self.TireSmokeRight:SetKeyValue("maxspeed", "0")
						self.TireSmokeRight:SetKeyValue("mindirectedspeed", "68")
						self.TireSmokeRight:SetKeyValue("maxdirectedspeed", "84")
						self.TireSmokeRight:SetKeyValue("spawnrate", "64")
						self.TireSmokeRight:Spawn()
						self.TireSmokeRight:SetParent(self.Entity)
						self.TireSmokeRight:Activate()
					end		

				local forceMul = 0
				if self.User1:KeyDown( IN_MOVELEFT ) && not(self.User1:KeyDown( IN_MOVERIGHT )) then					
					forceMul = 1
				elseif self.User1:KeyDown( IN_MOVERIGHT ) && not(self.User1:KeyDown( IN_MOVELEFT )) then
 					forceMul = -1
				end
				
				if forceMul != 0 then
					if forceMul == 1 && ValidEntity(self.WfrontLeft) then					
						self.WfrontLeft:GetPhysicsObject():SetVelocity(self.WfrontLeft:GetPhysicsObject():GetVelocity() * 0.1)
					elseif ValidEntity(self.WfrontRight) then
						self.WfrontRight:GetPhysicsObject():SetVelocity(self.WfrontRight:GetPhysicsObject():GetVelocity() * 0.1)
					end
					
					if self.TireSmokeLeft != NULL then
						if ValidEntity(self.WrearLeft) then
							self.WrearLeft:GetPhysicsObject():ApplyForceCenter( self.Entity:GetRight() * 1500 * forceMul)
						end
					end
					if self.TireSmokeRight != NULL then
						if ValidEntity(self.WrearRight) then
							self.WrearRight:GetPhysicsObject():ApplyForceCenter( self.Entity:GetRight() * 1500 * forceMul )
						end							
					end				
				end
					
			end
			if (self.DoesWheelSkid == true && not(self.User1:KeyDown( IN_BACK ) && self.User1:KeyDown( IN_FORWARD ))) && self.SkidType == 1 then
				self.DoesWheelSkid = false
				self.SkidType = 0
				self.WheelSkid:Stop()
				
				if self.TireSmokeLeft != NULL && self.TireSmokeLeft != nil then
					self.TireSmokeLeft:Remove()
					self.TireSmokeLeft = NULL
				end
				
				if self.TireSmokeRight != NULL && self.TireSmokeRight != nil then
					self.TireSmokeRight:Remove()
					self.TireSmokeRight	= NULL	
				end
				
			end
			
			if self.SkidType > 0 then
				local skidpitch = vel
				if skidpitch > 3000 then skidpitch = 3000 end
				
				skidpitch = skidpitch / 20
				self.WheelSkid:ChangePitch( 70 + skidpitch )
				
				if self.SkidType == 1 then
				self.WheelSkid:ChangePitch( 100 )
				end
			end

		end
		
		--Anti slide code
		if (self.WrearRight.IsColliding == 1 or self.WrearLeft.IsColliding == 1) && (self.RemovedRL == 0 or self.RemovedRR == 0 ) && self.RealGear != -2 && self.handBreak == false then
		
			local dotmul = self.Entity:GetVelocity():Dot(self.Entity:GetRight())
			local antiSlideForce = self.Entity:GetVelocity() * self.Entity:GetRight()

			--Taking the slide force and converts it to forward force
			entphys:ApplyForceCenter( self.Entity:GetRight() * self.AntiSlide * dotmul * -1 ) 
		end			
		
		
		--AutoStraighten
		if self.AutoStraighten > 0 && not(self.User1:KeyDown( IN_BACK )) && self.handBreak == false then
			local mul = 0
		
			if ValidEntity(self.axisRR) && self.WrearRight.IsColliding == 1 then
				mul = mul + 0.25
			end

			if ValidEntity(self.axisRL) && self.WrearLeft.IsColliding == 1 then
				mul = mul + 0.25
			end

			if ValidEntity(self.axisFR) && self.WfrontRight.IsColliding == 1 then
				mul = mul + 0.25
			end
			
			if ValidEntity(self.axisFL) && self.WfrontLeft.IsColliding == 1 then
				mul = mul + 0.25
			end			
			
			local velDir = self.Entity:GetVelocity():Normalize()
			local vel = self.Entity:GetVelocity():Length() / self.MaxSpeed
			
			local destPos = self.Entity:GetPos() + velDir * 500
			local lDist = (self.Entity:GetPos() + self.Entity:GetRight() * -50):Distance(destPos)	
			local rDist = (self.Entity:GetPos() + self.Entity:GetRight() * 50):Distance(destPos)	 
			local force = lDist - rDist
			
			if force < 0 then
				force  = force * -1
			end		

			if lDist > rDist then
				self.Entity:GetPhysicsObject():AddAngleVelocity( Vector(0,0, -0.01) * force * mul * vel * self.AutoStraighten )
			else
				self.Entity:GetPhysicsObject():AddAngleVelocity( Vector(0,0, 0.01) * force * mul * vel * self.AutoStraighten)	
			end				
		end
				
	end
	
	if self.UsingSeat1 && ValidEntity(self.User1) then

		local entphys = self.Entity:GetPhysicsObject()

		--Checking if we are using hydraulics
		
		local usesHydraulics = false
		local force = 0
		
		if self.User1:KeyDown( IN_ATTACK ) && self.HydraulicActive == 1 && (!ValidEntity(self.WeaponSystem) or (ValidEntity(self.WeaponSystem) && self.WeaponSystem.FireHydraulics == true)) then
			usesHydraulics = true
		end		
			
		if (self.RemovedFL == 0 or self.RemovedFR == 0) && usesHydraulics == false then
		
			local autoStr = self.AutoStraighten
			if autoStr >= 0 then autoStr = 1 end
			
			--local forceScale =  1 - (self.Entity:GetPhysicsObject():GetVelocity():Length() / self.MaxSpeed) * 0.8
			local forceScale = 1 - ((self.Entity:GetPhysicsObject():GetVelocity():Length() / self.MaxSpeed) * 0.8) + (0.8 * (autoStr / 50))
			local maxForce = forceScale * self.SteerForce
		
			
			if 	self.User1:KeyDown( IN_MOVELEFT ) then	
			
				if self.RealSteerForce < 0 then
					self.RealSteerForce = math.Approach( self.RealSteerForce, maxForce , self.SteerResponse * 3 )	
				else
					self.RealSteerForce = math.Approach( self.RealSteerForce, maxForce, self.SteerResponse )	
				end		
					
			elseif self.User1:KeyDown( IN_MOVERIGHT ) then
			
				if self.RealSteerForce > 0 then
					self.RealSteerForce = math.Approach( self.RealSteerForce, maxForce * -1 , self.SteerResponse * -3 )	
				else
					self.RealSteerForce = math.Approach( self.RealSteerForce, maxForce * -1 , self.SteerResponse * -1 )	
				end				
			end		
				
			local halfforce = self.RealSteerForce / 2
			force = self.RealSteerForce
				
			if self.WfrontLeft.IsColliding == 0 then
				force = force - halfforce
			end
			
			if self.WfrontRight.IsColliding == 0 then
				force = force - halfforce
			end
	
			if self.handBreak == true then
				force = force * 0.5
			end
			
		end		


		if self.RealSteerForce != 0 then
			local curVel = self.Entity:GetVelocity():Normalize()
			local front = self.Entity:GetForward()
				
			force = force  * curVel:DotProduct(front)
			
			
			if ValidEntity(self.WfrontLeft) or ValidEntity(self.WfrontRight) then
				entphys:AddAngleVelocity( Vector(0, 0, force ))
			end
			
			if !self.User1:KeyDown( IN_MOVELEFT ) && !self.User1:KeyDown( IN_MOVERIGHT ) then
				self.RealSteerForce = math.Approach( self.RealSteerForce, 0 , self.SteerResponse )
			end			
		else
		
			if self.RealSteerForce > 0 then
				self.RealSteerForce = math.Approach( self.RealSteerForce, 0 , self.SteerResponse * -2 )	
			elseif self.RealSteerForce < 0 then
				self.RealSteerForce = math.Approach( self.RealSteerForce, 0, self.SteerResponse * 2 )	
			end			
		end		
		
	end	
	
	--InAirCount
	if (self.RemovedRL == 1 or self.WrearLeft.IsColliding == 0) && (self.WrearRight.IsColliding == 0 or self.RemovedRR == 1) then
		self.InAirCount = self.InAirCount + 1
	else
		self.InAirCount = 0
	end

	
end
-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

	local Damage = 	0
	local attacker = dmg:GetAttacker( )

	if attacker != self.User1 then
		if dmg:IsExplosionDamage() then
			Damage = dmg:GetDamage()
		else
			Damage = (dmg:GetDamage()) / 4
		end

		if self.CanTakeDamage == 1 then
			self.CarHealth = self.CarHealth - Damage
		end
	end

end
-------------------------------------------THINK
function ENT:Think()

	local vel = self.Entity:GetVelocity()
	local front = self.Entity:GetForward()
	local frontVel = self.Entity:GetVelocity()

	frontVel.x = frontVel.x * front.x
	frontVel.y = frontVel.y * front.y
	frontVel.z = frontVel.z * front.z	
	
	vel = vel:Length()
	frontVel = frontVel:Length()
	frontVel = vel - frontVel
	
	
	if self.AutoRepairWheels == true then
		self.AutoRepairWheels = false
		self:ChangeWheel( self.WheelModel , self.physMat)
	end
	
	local forwardAng = self.Entity:GetVelocity():Normalize():DotProduct(self.Entity:GetForward())
	
	--Wheel skid
	if self.DoesWheelSkid == false && frontVel > 100 && self.DamageLevel != 4 && (forwardAng < 0.90) then
		if (self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil && self.WrearLeft.IsColliding == 1 ) or (self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil && self.WrearRight.IsColliding == 1 ) then
			self.DoesWheelSkid = true
			self.WheelSkid:Play()
			local ang = self.Entity:GetAngles()	
			ang.p = ang.p + 180
			self.SkidType = 2
			
			if self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil && self.WrearLeft.IsColliding == 1 then
				self.TireSmokeLeft = ents.Create("env_smoketrail")
				self.TireSmokeLeft:SetPos(self.WrearLeft:GetPos() + Vector(0,0,-10 ))
				self.TireSmokeLeft:SetKeyValue("angles", tostring(ang))					
				self.TireSmokeLeft:SetKeyValue("emittime", "16384")
				self.TireSmokeLeft:SetKeyValue("startcolor", "200 200 200 ")
				self.TireSmokeLeft:SetKeyValue("endcolor", "200 200 200")
				self.TireSmokeLeft:SetKeyValue("opacity", "255")
				self.TireSmokeLeft:SetKeyValue("spawnradius", "0")
				self.TireSmokeLeft:SetKeyValue("lifetime", "1" )
				self.TireSmokeLeft:SetKeyValue("startsize", "10")
				self.TireSmokeLeft:SetKeyValue("endsize", "25")
				self.TireSmokeLeft:SetKeyValue("minspeed", "0")
				self.TireSmokeLeft:SetKeyValue("maxspeed", "0")
				self.TireSmokeLeft:SetKeyValue("mindirectedspeed", "68")
				self.TireSmokeLeft:SetKeyValue("maxdirectedspeed", "84")
				self.TireSmokeLeft:SetKeyValue("spawnrate", "64")
				self.TireSmokeLeft:Spawn()
				self.TireSmokeLeft:SetParent(self.Entity)
				self.TireSmokeLeft:Activate()
			end
			
			if self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil && self.WrearRight.IsColliding == 1 then
				self.TireSmokeRight = ents.Create("env_smoketrail")
				self.TireSmokeRight:SetPos(self.WrearRight:GetPos() + Vector(0,0,-10 ))
				self.TireSmokeRight:SetKeyValue("angles", tostring(ang))				
				self.TireSmokeRight:SetKeyValue("emittime", "16384")
				self.TireSmokeRight:SetKeyValue("startcolor", "200 200 200 ")
				self.TireSmokeRight:SetKeyValue("endcolor", "200 200 200")
				self.TireSmokeRight:SetKeyValue("opacity", "255")
				self.TireSmokeRight:SetKeyValue("spawnradius", "0")
				self.TireSmokeRight:SetKeyValue("lifetime", "1" )
				self.TireSmokeRight:SetKeyValue("startsize", "10")
				self.TireSmokeRight:SetKeyValue("endsize", "25")
				self.TireSmokeRight:SetKeyValue("minspeed", "0")
				self.TireSmokeRight:SetKeyValue("maxspeed", "0")
				self.TireSmokeRight:SetKeyValue("mindirectedspeed", "68")
				self.TireSmokeRight:SetKeyValue("maxdirectedspeed", "84")
				self.TireSmokeRight:SetKeyValue("spawnrate", "64")
				self.TireSmokeRight:Spawn()
				self.TireSmokeRight:SetParent(self.Entity)
				self.TireSmokeRight:Activate()
			end
		end
	elseif  self.DoesWheelSkid == true && frontVel < 100 && self.SkidType == 2 or self.handBreak == true or self.InAirCount >= 10 or (forwardAng > 0.90) then
		self.DoesWheelSkid = false
		self.WheelSkid:Stop()
		self.SkidType = 0
		self.InAirCount = 0
		
		if self.TireSmokeLeft != NULL && self.TireSmokeLeft != nil then
			self.TireSmokeLeft:Remove()
			self.TireSmokeLeft = NULL
		end
		
		if self.TireSmokeRight != NULL && self.TireSmokeRight != nil then
			self.TireSmokeRight:Remove()
			self.TireSmokeRight	= NULL	
		end
	end
	
	
	--It shall forever be awake
    local phys = self.Entity:GetPhysicsObject()
	phys:Wake()
	
	if self.StartOnce == false && self.PlayOnce == 0 && self.UsingSeat1 == true && self.DamageLevel != 4 && self.Fuel > 0 && self.Entity:WaterLevel() <= 1 then
	
		if !ValidEntity(self.WeaponSystem) or ValidEntity(self.WeaponSystem) && self.IgnoreStartSound == false then
			self.StartDel = CurTime() + 1
			self.Entity:EmitSound("car/engineStart.wav",70)
		end
		self.StartOnce = true
		self.IgnoreStartSound = false
	end
	
	--Sounds
	--Starting SCar
	if self.StartOnce == true && self.PlayOnce == 0 && self.StartDel < CurTime() && self.UsingSeat1 == true && self.DamageLevel != 4 && self.Fuel > 0 && self.Entity:WaterLevel() <= 1 then
		self.PlayOnce = 1
		self.StartOnce = false
		 
		self.StartSound:Stop()
		self.StartSound:Play()
		self.OffSound:Stop()
		self.breakInitiated = false
		if self.RLlightSprite == NULL then
			self.RLlightSprite = ents.Create("env_sprite")
			self.RLlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.RLlightPos.x ) + ( self.Entity:GetRight() * self.RLlightPos.y ) + ( self.Entity:GetUp() * self.RLlightPos.z ) )
			self.RLlightSprite:SetKeyValue( "renderfx", "14" )
			self.RLlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
			self.RLlightSprite:SetKeyValue( "scale","1.0")
			self.RLlightSprite:SetKeyValue( "spawnflags","1")
			self.RLlightSprite:SetKeyValue( "angles","0 0 0")
			self.RLlightSprite:SetKeyValue( "rendermode","9")
			self.RLlightSprite:SetKeyValue( "renderamt","150")
			self.RLlightSprite:SetKeyValue( "rendercolor", "255 0 0" )				
			self.RLlightSprite:Spawn()
			self.RLlightSprite:SetParent( self.Entity )
		end

		if self.RRlightSprite == NULL then
			self.RRlightSprite = ents.Create("env_sprite")
			self.RRlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.RRlightPos.x ) + ( self.Entity:GetRight() * self.RRlightPos.y ) + ( self.Entity:GetUp() * self.RRlightPos.z ) )					
			self.RRlightSprite:SetKeyValue( "renderfx", "14" )
			self.RRlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
			self.RRlightSprite:SetKeyValue( "scale","1.0")
			self.RRlightSprite:SetKeyValue( "spawnflags","1")
			self.RRlightSprite:SetKeyValue( "angles","0 0 0")
			self.RRlightSprite:SetKeyValue( "rendermode","9")
			self.RRlightSprite:SetKeyValue( "renderamt","150")
			self.RRlightSprite:SetKeyValue( "rendercolor", "255 0 0" )				
			self.RRlightSprite:Spawn()
			self.RRlightSprite:SetParent( self.Entity )	
		end		
		
		if ValidEntity(self.FLlightSprite) then
			self.FLlightSprite:Remove()
		end
		
		self.FLlightSprite = ents.Create("env_sprite");
		self.FLlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.FLlightPos.x ) + ( self.Entity:GetRight() * self.FLlightPos.y ) + ( self.Entity:GetUp() * self.FLlightPos.z ) )	
		self.FLlightSprite:SetKeyValue( "renderfx", "14" )
		self.FLlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
		self.FLlightSprite:SetKeyValue( "scale","1.0")
		self.FLlightSprite:SetKeyValue( "spawnflags","1")
		self.FLlightSprite:SetKeyValue( "angles","0 0 0")
		self.FLlightSprite:SetKeyValue( "rendermode","9")
		self.FLlightSprite:SetKeyValue( "renderamt","150")
		self.FLlightSprite:SetKeyValue( "rendercolor", "240 240 170" )				
		self.FLlightSprite:Spawn()
		self.FLlightSprite:SetParent( self.Entity )				
		
		if ValidEntity(self.FRlightSprite) then
			self.FRlightSprite:Remove()
		end
		
		self.FRlightSprite = ents.Create("env_sprite");
		self.FRlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.FRlightPos.x ) + ( self.Entity:GetRight() * self.FRlightPos.y ) + ( self.Entity:GetUp() * self.FRlightPos.z ) )
		self.FRlightSprite:SetKeyValue( "renderfx", "14" )
		self.FRlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
		self.FRlightSprite:SetKeyValue( "scale","1.0")
		self.FRlightSprite:SetKeyValue( "spawnflags","1")
		self.FRlightSprite:SetKeyValue( "angles","0 0 0")
		self.FRlightSprite:SetKeyValue( "rendermode","9")
		self.FRlightSprite:SetKeyValue( "renderamt","150")
		self.FRlightSprite:SetKeyValue( "rendercolor", "240 240 170" )				
		self.FRlightSprite:Spawn()
		self.FRlightSprite:SetParent( self.Entity )			
		
		--Creating exhaust smoke
		self.exhaustIsOn = 1

		local ang = self.Entity:GetAngles()		
		ang.p = ang.p + 180
		if self.exhaustPos != NULL then
			self.exhaustEffect = ents.Create("env_smoketrail")
			self.exhaustEffect:SetPos(self.Entity:GetPos() + (self.Entity:GetForward() * self.exhaustPos.x) + (self.Entity:GetRight() * self.exhaustPos.y) + (self.Entity:GetUp() * self.exhaustPos.z))
			self.exhaustEffect:SetKeyValue("angles", tostring(ang))
			self.exhaustEffect:SetKeyValue("emittime", "16384")
			self.exhaustEffect:SetKeyValue("startcolor", "170 170 170 ")
			self.exhaustEffect:SetKeyValue("endcolor", "100 100 100")
			self.exhaustEffect:SetKeyValue("opacity", "255")
			self.exhaustEffect:SetKeyValue("spawnradius", "0")
			self.exhaustEffect:SetKeyValue("lifetime", "0.5" )
			self.exhaustEffect:SetKeyValue("startsize", "3")
			self.exhaustEffect:SetKeyValue("endsize", "7")
			self.exhaustEffect:SetKeyValue("minspeed", "0")
			self.exhaustEffect:SetKeyValue("maxspeed", "0")
			self.exhaustEffect:SetKeyValue("mindirectedspeed", "68")
			self.exhaustEffect:SetKeyValue("maxdirectedspeed", "84")
			self.exhaustEffect:SetKeyValue("spawnrate", "64")
			self.exhaustEffect:SetAngles(ang)
			self.exhaustEffect:Spawn()
			self.exhaustEffect:SetParent(self.Entity)
			self.exhaustEffect:Activate()
		end
		
		if self.exhaustPos2 != NULL then
			self.exhaustEffect2 = ents.Create("env_smoketrail")
			self.exhaustEffect2:SetPos(self.Entity:GetPos() + (self.Entity:GetForward() * self.exhaustPos2.x) + (self.Entity:GetRight() * self.exhaustPos2.y) + (self.Entity:GetUp() * self.exhaustPos2.z))
			self.exhaustEffect2:SetKeyValue("angles", tostring(ang))
			self.exhaustEffect2:SetKeyValue("emittime", "16384")
			self.exhaustEffect2:SetKeyValue("startcolor", "170 170 170 ")
			self.exhaustEffect2:SetKeyValue("endcolor", "100 100 100")
			self.exhaustEffect2:SetKeyValue("opacity", "255")
			self.exhaustEffect2:SetKeyValue("spawnradius", "0")
			self.exhaustEffect2:SetKeyValue("lifetime", "0.5" )
			self.exhaustEffect2:SetKeyValue("startsize", "3")
			self.exhaustEffect2:SetKeyValue("endsize", "7")
			self.exhaustEffect2:SetKeyValue("minspeed", "0")
			self.exhaustEffect2:SetKeyValue("maxspeed", "0")
			self.exhaustEffect2:SetKeyValue("mindirectedspeed", "68")
			self.exhaustEffect2:SetKeyValue("maxdirectedspeed", "84")
			self.exhaustEffect2:SetKeyValue("spawnrate", "64")
			self.exhaustEffect2:SetAngles(ang)
			self.exhaustEffect2:Spawn()
			self.exhaustEffect2:SetParent(self.Entity)
			self.exhaustEffect2:Activate()
		end		
	
	--Shutting down SCar
	elseif 	self.PlayOnce == 1 && (self.UsingSeat1 == false or self.Fuel < 0 or self.Entity:WaterLevel() >= 2) then
		self.PlayOnce = 0
		self.StartDel = CurTime()
		self.StartOnce = false
		self.StartSound:Stop()
		self.OffSound:Stop()	
		self.OffSound:Play()	
		self.exhaustIsOn = 0
		self.UsingTurbo = false
		self.TurboTime = 0
		self.TurboCant = CurTime() + self.TurboDelay		
		self.TurboStartSound:Stop()
		self.TurboStopSound:Stop()		
		self.Pitch = 40
		self.RealPitch = 40
		if self.exhaustEffect != NULL then
			self.exhaustEffect:Remove()
		end

		if self.exhaustEffect2 != NULL then		
			self.exhaustEffect2:Remove()
		end
		
		//Removing lights
		if ValidEntity(self.FLlight) then
			self.FLlight:Remove()
			self.FLlight = NULL
		end

		if ValidEntity(self.FRlight) then
			self.FRlight:Remove()
			self.FRlight = NULL
		end		
		
		if ValidEntity(self.FLlightSprite) then
			self.FLlightSprite:Remove()
			self.FLlightSprite = NULL
		end
	
		if ValidEntity(self.FRlightSprite) then
			self.FRlightSprite:Remove()
			self.FRlightSprite = NULL
		end

		if ValidEntity(self.RLlightSprite) then
			self.RLlightSprite:Remove()
			self.RLlightSprite = NULL
		end
		
		if ValidEntity(self.RRlightSprite) then
			self.RRlightSprite:Remove()
			self.RRlightSprite = NULL
		end
	
	end
		
	if self.StartOnce == true && self.PlayOnce == 0 && (self.UsingSeat1 == false or self.Fuel < 0 or self.Entity:WaterLevel() >= 2) then
		self.StartDel = CurTime()
		self.StartOnce = false	
	end
		
	if self.UsingSeat1 && ValidEntity(self.User1) then	
	
		if ( (self.WfrontLeft.IsColliding == 1 && self.WfrontLeft.IsDestroyed == 0 ) or (self.WfrontRight.IsColliding == 1 && self.WfrontRight.IsDestroyed == 0 ) or (self.WrearLeft.IsColliding == 1 && self.WrearLeft.IsDestroyed == 0 ) or (self.WrearRight.IsColliding == 1 && self.WrearRight.IsDestroyed == 0 ) ) then
			self:AdjustKeepUpRightConstraint()	
		else
			if ValidEntity(self.StabilizerConstaint) then
				self.StabilizerConstaint:Remove()
				self.StabilizerConstaint = NULL
			end
		end		
	
		--Creating red break lights 
		if (self.User1:KeyDown( IN_BACK ) or self.User1:KeyDown( IN_JUMP )) then
		
			if self.breakInitiated == false then
				if ValidEntity(self.RLlightSprite) then
					self.RLlightSprite:Remove()
					self.RLlightSprite = ents.Create("env_sprite")
					self.RLlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.RLlightPos.x ) + ( self.Entity:GetRight() * self.RLlightPos.y ) + ( self.Entity:GetUp() * self.RLlightPos.z ) )
					self.RLlightSprite:SetKeyValue( "renderfx", "14" )
					self.RLlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
					self.RLlightSprite:SetKeyValue( "scale","1.0")
					self.RLlightSprite:SetKeyValue( "spawnflags","1")
					self.RLlightSprite:SetKeyValue( "angles","0 0 0")
					self.RLlightSprite:SetKeyValue( "rendermode","9")
					self.RLlightSprite:SetKeyValue( "renderamt","255")
					self.RLlightSprite:SetKeyValue( "rendercolor", "255 0 0" )				
					self.RLlightSprite:Spawn()
					self.RLlightSprite:SetParent( self.Entity )
				end
				
				if ValidEntity(self.RRlightSprite) then
					self.RRlightSprite:Remove()
					self.RRlightSprite = ents.Create("env_sprite")
					self.RRlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.RRlightPos.x ) + ( self.Entity:GetRight() * self.RRlightPos.y ) + ( self.Entity:GetUp() * self.RRlightPos.z ) )					
					self.RRlightSprite:SetKeyValue( "renderfx", "14" )
					self.RRlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
					self.RRlightSprite:SetKeyValue( "scale","1.0")
					self.RRlightSprite:SetKeyValue( "spawnflags","1")
					self.RRlightSprite:SetKeyValue( "angles","0 0 0")
					self.RRlightSprite:SetKeyValue( "rendermode","9")
					self.RRlightSprite:SetKeyValue( "renderamt","255")
					self.RRlightSprite:SetKeyValue( "rendercolor", "255 0 0" )				
					self.RRlightSprite:Spawn()
					self.RRlightSprite:SetParent( self.Entity )	
				end		
				self.breakInitiated  = true
			end
			
		else
			if self.breakInitiated == true then
				if ValidEntity(self.RLlightSprite) then
					self.RLlightSprite:Remove()
					self.RLlightSprite = ents.Create("env_sprite")
					self.RLlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.RLlightPos.x ) + ( self.Entity:GetRight() * self.RLlightPos.y ) + ( self.Entity:GetUp() * self.RLlightPos.z ) )
					self.RLlightSprite:SetKeyValue( "renderfx", "14" )
					self.RLlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
					self.RLlightSprite:SetKeyValue( "scale","1.0")
					self.RLlightSprite:SetKeyValue( "spawnflags","1")
					self.RLlightSprite:SetKeyValue( "angles","0 0 0")
					self.RLlightSprite:SetKeyValue( "rendermode","9")
					self.RLlightSprite:SetKeyValue( "renderamt","150")
					self.RLlightSprite:SetKeyValue( "rendercolor", "255 0 0" )				
					self.RLlightSprite:Spawn()
					self.RLlightSprite:SetParent( self.Entity )
				end
				
				if ValidEntity(self.RRlightSprite) then
					self.RRlightSprite:Remove()
					self.RRlightSprite = ents.Create("env_sprite")
					self.RRlightSprite:SetPos( self.Entity:GetPos() + (self.Entity:GetForward() * self.RRlightPos.x ) + ( self.Entity:GetRight() * self.RRlightPos.y ) + ( self.Entity:GetUp() * self.RRlightPos.z ) )					
					self.RRlightSprite:SetKeyValue( "renderfx", "14" )
					self.RRlightSprite:SetKeyValue( "model", "sprites/glow1.vmt")
					self.RRlightSprite:SetKeyValue( "scale","1.0")
					self.RRlightSprite:SetKeyValue( "spawnflags","1")
					self.RRlightSprite:SetKeyValue( "angles","0 0 0")
					self.RRlightSprite:SetKeyValue( "rendermode","9")
					self.RRlightSprite:SetKeyValue( "renderamt","150")
					self.RRlightSprite:SetKeyValue( "rendercolor", "255 0 0" )				
					self.RRlightSprite:Spawn()
					self.RRlightSprite:SetParent( self.Entity )	
				end		

				self.breakInitiated = false
			end
		end
	
	
	
		--HandBreak
		if self.User1:KeyDown( IN_JUMP ) && self.handBreak == false then
			self.handBreak = true 
			
			if self.UseHud == 1 then
				self.Seat1:SetNetworkedInt( "SCarGear" , -3 )
			end
			
			if self.RemovedFL == 0 && self.WfrontLeft:IsValid() then
				self.breakFL = constraint.Weld( self.WfrontLeft, self.Entity, 0, 0, 0, false )
			end

			if self.RemovedFR == 0 && self.WfrontRight:IsValid() then			
				self.breakFR = constraint.Weld( self.WfrontRight, self.Entity, 0, 0, 0, false )
			end
			
			if self.RemovedRL == 0 && self.WrearLeft:IsValid() then			
				self.breakRL = constraint.Weld( self.WrearLeft, self.Entity, 0, 0, 0, false )
			end
			
			if self.RemovedRR == 0 && self.WrearRight:IsValid() then		
				self.breakRR = constraint.Weld( self.WrearRight, self.Entity, 0, 0, 0, false )
			end
			
			--Randomizing skid sound
			local rand = math.random(1,3)
			
			if rand == 1 then
				self.Skid = CreateSound(self.Entity,"vehicles/v8/skid_highfriction.wav")
			elseif rand == 2 then
				self.Skid = CreateSound(self.Entity,"vehicles/v8/skid_lowfriction.wav")			
			elseif rand == 3 then
				self.Skid = CreateSound(self.Entity,"vehicles/v8/skid_normalfriction.wav")			
			end
			
			if vel > 300 then
				self.Skid:Stop()
				self.Skid:Play()
			end
					
		elseif not(self.User1:KeyDown( IN_JUMP )) && self.handBreak == true && self.Entity.handBreakDel < CurTime() then
			self.handBreak = false
			
			if self.UseHud == 1 then
				self.Seat1:SetNetworkedInt( "SCarGear" , self.Gear )
			end
			
			if self.RemovedFL == 0 && self.breakFL && self.breakFL != NULL then
				self.breakFL:Remove()
				self.breakFL = NULL
			end
			
			if self.RemovedFR == 0 && self.breakFR && self.breakFR != NULL then
				self.breakFR:Remove()
				self.breakFR = NULL			
			end
			
			if self.RemovedRL == 0 && self.breakRL && self.breakRL != NULL then
				self.breakRL:Remove()
				self.breakRL = NULL			
			end

			if self.RemovedRR == 0 && self.breakRR && self.breakRR != NULL then			
				self.breakRR:Remove()
				self.breakRR = NULL		
			end
			
			
			if self.WfrontLeft.Rim && self.WfrontLeft.Rim:IsValid() then
				constraint.NoCollide( self.Entity, self.WfrontLeft.Rim, 0, 0 )	
			end

			if self.WfrontRight.Rim && self.WfrontRight.Rim:IsValid() then
				constraint.NoCollide( self.Entity, self.WfrontRight.Rim, 0, 0 )	
			end

			if self.WrearLeft.Rim && self.WrearLeft.Rim:IsValid() then
				constraint.NoCollide( self.Entity, self.WrearLeft.Rim, 0, 0 )	
			end

			if self.WrearRight.Rim && self.WrearRight.Rim:IsValid() then
				constraint.NoCollide( self.Entity, self.WrearRight.Rim, 0, 0 )	
			end					
			
			constraint.NoCollide( self.Entity, self.WfrontLeft, 0, 0 )		
			constraint.NoCollide( self.Entity, self.WfrontRight, 0, 0 )		
			constraint.NoCollide( self.Entity, self.WrearLeft , 0, 0 )		
			constraint.NoCollide( self.Entity, self.WrearRight, 0, 0 )
			self.Skid:Stop()			
		end
	
	else
	
	if self.StabilizerConstaint != NULL then
		self.StabilizerConstaint:Remove()
		self.StabilizerConstaint = NULL
	end	
	
	end
	
	if vel < 50 then
		self.Skid:Stop()
	end
	
	self.UsingSeat1 = false
	self.UsingSeat2 = false
	self.UsingSeat3 = false
	self.UsingSeat4 = false
	self.UsingSeat5 = false

	--Which seats are currently being used?
	for k,v in pairs(player.GetAll()) do
		if v:InVehicle( ) then
			local PlyUsedVeh = v:GetVehicle()						
			
			if PlyUsedVeh == self.Seat1 then
				self.UsingSeat1 = true
				self.User1.EnterSCarDel = CurTime() + 1			
			end
			
			if PlyUsedVeh == self.Seat2 then
				self.UsingSeat2 = true
				self.User2.EnterSCarDel = CurTime() + 1			
			end

			if PlyUsedVeh == self.Seat3 then
				self.UsingSeat3 = true
				self.User3.EnterSCarDel = CurTime() + 1				
			end

			if PlyUsedVeh == self.Seat4 then
				self.UsingSeat4 = true	
				self.User4.EnterSCarDel = CurTime() + 1				
			end

			if PlyUsedVeh == self.Seat5 then
				self.UsingSeat5 = true	
				self.User5.EnterSCarDel = CurTime() + 1				
			end						
			
		end
	end	
	
	
	if self.UsingSeat1 == false && ValidEntity(self.User1) then
		self.RealSteerForce = 0
		
		if self.User1:GetViewEntity():GetClass() != "gmod_cameraprop" then
			self.User1:SetViewEntity(self.User1)	
		end
		
		self.User1 = NULL
	end
	
	--Do Someone want to leave the vehicle or change seat?
	--Know this isn't a very beutiful way to check it but i will do it anyway since it seems like all tables become globals

	for k,v in pairs(player.GetAll()) do
		if v:InVehicle( ) then
			local PlyUsedVeh = v:GetVehicle()						
			
			if PlyUsedVeh == self.Seat1 then
				self.UsingSeat1 = true
				self.User1.EnterSCarDel = CurTime() + 1			
			end
			
			if PlyUsedVeh == self.Seat2 then
				self.UsingSeat2 = true
				self.User2.EnterSCarDel = CurTime() + 1			
			end

			if PlyUsedVeh == self.Seat3 then
				self.UsingSeat3 = true
				self.User3.EnterSCarDel = CurTime() + 1				
			end

			if PlyUsedVeh == self.Seat4 then
				self.UsingSeat4 = true	
				self.User4.EnterSCarDel = CurTime() + 1				
			end

			if PlyUsedVeh == self.Seat5 then
				self.UsingSeat5 = true	
				self.User5.EnterSCarDel = CurTime() + 1				
			end						
			
		end
	end	
	
	
	--Do Someone want to leave the vehicle or change seat?
	--Know this isn't a very beutiful way to check it but i will do it anyway since it seems like all tables become globals

	local Ignore = {0,0,0,0,0}
	for i = 1, self.NrOfSeats do	
		local Ply = NULL
		local PlyPrevSeat = i
		local isInSeat = NULL
		
		if i == 1 then 
			Ply = self.User1
			isInSeat = self.UsingSeat1
		end
		
		if i == 2 then 
			Ply = self.User2 
			isInSeat = self.UsingSeat2			
		end	
		
		if i == 3 then 
			Ply = self.User3 
			isInSeat = self.UsingSeat3			
		end
		
		if i == 4 then 
			Ply = self.User4 
			isInSeat = self.UsingSeat4			
		end
		
		if i == 5 then 
			Ply = self.User5 
			isInSeat = self.UsingSeat5			
		end						
		
			if ValidEntity(Ply) and Ignore[i] == 0 then
				if 	Ply:KeyDown( IN_WALK ) && isInSeat then

					local SeatCheck = 0
					local UseThaSeat = i
					local dont = 0
					while SeatCheck < self.NrOfSeats do
						SeatCheck = SeatCheck + 1
						UseThaSeat = UseThaSeat + 1
						if UseThaSeat > self.NrOfSeats then UseThaSeat = 1 end
					
					
						if UseThaSeat == 1 && self.UsingSeat1 == false && dont == 0 then
							Ply:ExitVehicle()
							Ply:EnterVehicle(self.Seat1)
							Ignore[1] = 1
							self.User1 = Ply												
							dont = 1						
						end
					
						if UseThaSeat == 2 && self.UsingSeat2 == false && dont == 0 then
							Ply:ExitVehicle()
							Ply:EnterVehicle(self.Seat2)											
							Ignore[2] = 1												
							self.User2 = Ply												
							dont = 1
						end
					
						if UseThaSeat == 3 && self.UsingSeat3 == false && dont == 0 then
							Ply:ExitVehicle()
							Ply:EnterVehicle(self.Seat3)												
							Ignore[3] = 1												
							self.User3 = Ply													
							dont = 1							
						end									
					
						if UseThaSeat == 4 && self.UsingSeat4 == false && dont == 0 then
							Ply:ExitVehicle()
							Ply:EnterVehicle(self.Seat4)												
							Ignore[4] = 1												
							self.User4 = Ply													
							dont = 1							
						end									

						if UseThaSeat == 5 && self.UsingSeat5 == false && dont == 0 then
							Ply:ExitVehicle()
							Ply:EnterVehicle(self.Seat5)												
							Ignore[5] = 1												
							self.User5 = Ply													
							dont = 1								
						end											
					
						if dont == 1 then
							if PlyPrevSeat == 1 then
								self.UsingSeat1 = false
								Ply:SetViewEntity(Ply)
								self.User1 = NULL
							end
							if PlyPrevSeat == 2 then
								self.UsingSeat2 = false
								self.User2 = NULL													
							end
							if PlyPrevSeat == 3 then
								self.UsingSeat3 = false
								self.User3 = NULL													
							end
							if PlyPrevSeat == 4 then
								self.UsingSeat4 = false
								self.User4 = NULL													
							end
							if PlyPrevSeat == 5 then
								self.UsingSeat5 = false
								self.User5 = NULL													
							end
							
							local viewAng = self.Entity:GetAngles():Forward()
							viewAng.y = viewAng.y + 90
							Ply:SetEyeAngles( viewAng )	
							
						end									
					end
				end
			end
	end
	
	--Deploy handbreak if we leave the vehicle
	if self.UsingSeat1 == false && self.handBreak == false && vel < 50 && self.Entity.handBreakDel < CurTime() && self.DamageLevel != 4 then

		self.handBreak = true 
		
		if self.RemovedFL == 0 then
			self.breakFL = constraint.Weld( self.WfrontLeft, self.Entity, 0, 0, 0, false )
		end

		if self.RemovedFR == 0 then			
			self.breakFR = constraint.Weld( self.WfrontRight, self.Entity, 0, 0, 0, false )
		end
		
		if self.RemovedRL == 0 then			
			self.breakRL = constraint.Weld( self.WrearLeft, self.Entity, 0, 0, 0, false )
		end
		
		if self.RemovedRR == 0 then		
			self.breakRR = constraint.Weld( self.WrearRight, self.Entity, 0, 0, 0, false )
		end
	
	end	
	
	


	--Removing wheels if they are damaged	
	if self.WfrontLeft.IsDestroyed == 1 && self.RemovedFL == 0 then
		self.RemovedFL = 1
		
		if ValidEntity(self.axisFL) then
			self.axisFL:Remove()
		end
		
		if ValidEntity(self.breakFL) then
			self.breakFL:Remove()
		end		
	end

	if self.WfrontRight.IsDestroyed == 1 && self.RemovedFR == 0 then
		self.RemovedFR = 1	

		if ValidEntity(self.axisFR) then
			self.axisFR:Remove()
		end
		
		if ValidEntity(self.breakFR) then
			self.breakFR:Remove()
		end			
	end
	
	if self.WrearLeft.IsDestroyed == 1 && self.RemovedRL == 0 then
		self.RemovedRL = 1		

		if ValidEntity(self.axisRL) then
			self.axisRL:Remove()
		end
		
		if ValidEntity(self.breakRL) then
			self.breakRL:Remove()
		end			
	end

	if self.WrearRight.IsDestroyed == 1 && self.RemovedRR == 0 then
		self.RemovedRR = 1		

		if ValidEntity(self.axisRR) then
			self.axisRR:Remove()
		end
		
		if ValidEntity(self.breakRR) then
			self.breakRR:Remove()
		end			
	end	
	
	
	--Effects	
	if self.CarHealth < self.CarMaxHealth then
		
		if self.CarHealth < 100 && self.DamageLevel == 0 then
			self.DamageLevel = 1

			self.SmokeEffect = ents.Create("env_smokestack")
			self.SmokeEffect:SetPos(self.Entity:GetPos() + (self.Entity:GetForward() * self.effectPos.x) + (self.Entity:GetRight() * self.effectPos.y) + (self.Entity:GetUp() * self.effectPos.z))
			self.SmokeEffect:SetKeyValue("InitialState", "1")
			self.SmokeEffect:SetKeyValue("WindAngle", "0 0 0")
			self.SmokeEffect:SetKeyValue("WindSpeed", "0")
			self.SmokeEffect:SetKeyValue("rendercolor", "" .. tostring(170) .. " " .. tostring(170) .. " " .. tostring(170) .. "")
			self.SmokeEffect:SetKeyValue("renderamt", "" .. tostring(170) .. "")
			self.SmokeEffect:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
			self.SmokeEffect:SetKeyValue("BaseSpread", tostring(10))
			self.SmokeEffect:SetKeyValue("SpreadSpeed", tostring(5))
			self.SmokeEffect:SetKeyValue("Speed", tostring(100))
			self.SmokeEffect:SetKeyValue("StartSize", tostring(50))
			self.SmokeEffect:SetKeyValue("EndSize", tostring(10))
			self.SmokeEffect:SetKeyValue("roll", tostring(10))
			self.SmokeEffect:SetKeyValue("Rate", tostring(10))
			self.SmokeEffect:SetKeyValue("JetLength", tostring(50))
			self.SmokeEffect:SetKeyValue("twist", tostring(5))

			//Spawn smoke
			self.SmokeEffect:Spawn()
			self.SmokeEffect:SetParent(self.Entity)
			self.SmokeEffect:Activate()	
		
		elseif self.CarHealth < 50 && self.DamageLevel == 1 then
			self.DamageLevel = 2
			
			self.SmokeEffect:Remove()
		
			self.SmokeEffect = ents.Create("env_smokestack")
			self.SmokeEffect:SetPos(self.Entity:GetPos() + (self.Entity:GetForward() * self.effectPos.x) + (self.Entity:GetRight() * self.effectPos.y) + (self.Entity:GetUp() * self.effectPos.z))
			self.SmokeEffect:SetKeyValue("InitialState", "1")
			self.SmokeEffect:SetKeyValue("WindAngle", "0 0 0")
			self.SmokeEffect:SetKeyValue("WindSpeed", "0")
			self.SmokeEffect:SetKeyValue("rendercolor", "" .. tostring(10) .. " " .. tostring(10) .. " " .. tostring(10) .. "")
			self.SmokeEffect:SetKeyValue("renderamt", "" .. tostring(170) .. "")
			self.SmokeEffect:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
			self.SmokeEffect:SetKeyValue("BaseSpread", tostring(10))
			self.SmokeEffect:SetKeyValue("SpreadSpeed", tostring(5))
			self.SmokeEffect:SetKeyValue("Speed", tostring(100))
			self.SmokeEffect:SetKeyValue("StartSize", tostring(50))
			self.SmokeEffect:SetKeyValue("EndSize", tostring(10))
			self.SmokeEffect:SetKeyValue("roll", tostring(10))
			self.SmokeEffect:SetKeyValue("Rate", tostring(100))
			self.SmokeEffect:SetKeyValue("JetLength", tostring(50))
			self.SmokeEffect:SetKeyValue("twist", tostring(5))

			//Spawn smoke
			self.SmokeEffect:Spawn()
			self.SmokeEffect:SetParent(self.Entity)
			self.SmokeEffect:Activate()		

		elseif self.CarHealth < 25 && self.DamageLevel == 2 then
			self.DamageLevel = 3
			
			self.SmokeEffect:Remove()
			
			self.FireSound:Stop()
			self.FireSound:Play()
			
			self.FireEffect = ents.Create( "env_fire_trail" )
			self.FireEffect:SetPos(self.Entity:GetPos() + (self.Entity:GetForward() * self.effectPos.x) + (self.Entity:GetRight() * self.effectPos.y) + (self.Entity:GetUp() * self.effectPos.z))
			self.FireEffect:Spawn()
			self.FireEffect:SetParent(self.Entity)
		elseif self.CarHealth <= 0 && self.DamageLevel == 3 then
			self.DamageLevel = 4
		
			local delay = GetConVarNumber( "scar_removedelay" )
		
			if delay != 0 then
				self.AutoRemoveDel = CurTime() + delay
			else
				self.AutoRemoveDel = NULL
			end
		
			local expl = ents.Create("env_explosion")
			expl:SetKeyValue("spawnflags",128)
			expl:SetPos(self.Entity:GetPos())
			expl:Spawn()
			expl:Fire("explode","",0)
		
			local FireExp = ents.Create("env_physexplosion")
			FireExp:SetPos(self.Entity:GetPos())
			FireExp:SetParent(self.Entity)
			FireExp:SetKeyValue("magnitude", 500)
			FireExp:SetKeyValue("radius", 300)
			FireExp:SetKeyValue("spawnflags", "1")
			FireExp:Spawn()
			FireExp:Fire("Explode", "", 0)
			FireExp:Fire("kill", "", 5)
			util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 500, 500)			
			
			self.Entity:SetColor(50,50,50,255)
			self.Entity.IsDestroyed = 1
			
			local health = 0
				
			if self.UsingSeat1 == true  && self.User1 != nil && self.User1 != NULL && self.User1:IsValid() then
				self.User1:ExitVehicle()
				self.User1:Fire("sethealth", ""..health.."", 0)
			end		
			if self.UsingSeat2 == true && self.User2 != nil && self.User2 != NULL && self.User2:IsValid() then
				self.User2:ExitVehicle()			
				self.User2:Fire("sethealth", ""..health.."", 0)
			end		
			if self.UsingSeat3 == true && self.User3 != nil && self.User3 != NULL && self.User3:IsValid() then
				self.User3:ExitVehicle()			
				self.User3:Fire("sethealth", ""..health.."", 0)
			end		
			if self.UsingSeat4 == true  && self.User4 != nil && self.User4 != NULL && self.User4:IsValid() then
				self.User4:ExitVehicle()			
				self.User4:Fire("sethealth", ""..health.."", 0)
			end		
			if self.UsingSeat5 == true && self.User5 != nil && self.User5 != NULL && self.User5:IsValid() then
				self.User5:ExitVehicle()			
				self.User5:Fire("sethealth", ""..health.."", 0)
			end				

			self.Entity:GetPhysicsObject():ApplyForceCenter( self.Entity:GetUp() * 500 )
			
			if  self.RemovedFL == 0 && self.WfrontLeft:IsValid() && self.WfrontLeft != NULL && self.WfrontLeft != nil then
				self.WfrontLeft:SetColor(50,50,50,255)
			end

			if self.RemovedFR == 0 && self.WfrontRight:IsValid() && self.WfrontRight != NULL && self.WfrontRight != nil then
				self.WfrontRight:SetColor(50,50,50,255)
			end
			
			if self.RemovedRL == 0 && self.WrearLeft:IsValid() && self.WrearLeft != NULL && self.WrearLeft != nil then
				self.WrearLeft:SetColor(50,50,50,255)
			end

			if self.RemovedRR == 0 && self.WrearRight:IsValid() && self.WrearRight != NULL && self.WrearRight != nil then
				self.WrearRight:SetColor(50,50,50,255)
			end	
		
		end	
		
		if self.AutoRemoveDel != NULL && self.DamageLevel == 4 && self.AutoRemoveDel < CurTime() then
			self.Entity:Remove()
		end
		
		if self.DamageLevel == 3 && self.TakeHealthDel < CurTime() then
			self.CarHealth = self.CarHealth - 3
			self.TakeHealthDel = CurTime() + 1									
		end
	end
	
	self:SpecialThink()
end
-------------------------------------------ON REMOVE
function ENT:OnRemove()

	self.WheelSkid:Stop()
	self.StartSound:Stop()
	self.OffSound:Stop()	
	self.Skid:Stop()	
	self.TurboStartSound:Stop()
	self.TurboStopSound:Stop()
	self.FireSound:Stop()
	
	if ValidEntity(self.User1) && self.User1:GetViewEntity():GetClass() != "gmod_cameraprop" then
		self.User1:SetViewEntity(self.User1)
	end	
	
	if ValidEntity(self.Seat1) then
		self.Seat1:Remove()
	end

	if ValidEntity(self.Seat2) then	
		self.Seat2:Remove()
	end
	
	if ValidEntity(self.Seat3) then	
		self.Seat3:Remove()
	end
	
	if ValidEntity(self.Seat4) then	
		self.Seat4:Remove()
	end
	
	if ValidEntity(self.Seat5) then	
		self.Seat5:Remove()
	end
	
	self.StabilizerProp:Remove()	
	
	if ValidEntity(self.WfrontLeft) then
		self.WfrontLeft:Remove()
	end

	if ValidEntity(self.WfrontRight) then	
		self.WfrontRight:Remove()	
	end
	
	if ValidEntity(self.WrearLeft) then	
		self.WrearLeft:Remove()
	end
	
	if ValidEntity(self.WrearRight) then	
		self.WrearRight:Remove()
	end
	
	if self.exhaustIsOn == 1 then
	
		if ValidEntity(self.exhaustEffect) then
			self.exhaustEffect:Remove()
		end
		
		if ValidEntity(self.exhaustEffect2) then	
			self.exhaustEffect2:Remove()
		end
	end
	
		
	if ValidEntity(self.TireSmokeLeft) then
		self.TireSmokeLeft:Remove()
	end
	
	if ValidEntity(self.TireSmokeRight) then
		self.TireSmokeRight:Remove()
	end					
	
	if ValidEntity(self.WeaponSystem) then
		self.WeaponSystem:Remove()
	end
	
	self:SpecialRemove()
	
end

function ENT:SetBindings( bindings )
	if ValidEntity(self.WeaponSystem) then
		self.WeaponSystem:SetBindings( bindings )
	end
end

function ENT:AddConnection( ent )

	if not(string.find(ent:GetClass(), "sent_sakarias_car_")) then
	
		ent:AddConnection(self.Entity)
		
		if ent:GetClass() == "sent_sakarias_weaponsystem" && !ValidEntity(self.WeaponSystem) then
			self.WeaponSystem = ent
			
		elseif string.find(ent:GetClass(), "sent_sakarias_weapon_") && ValidEntity(self.WeaponSystem) then
			self.WeaponSystem:AddConnection(ent)
		end
	end
end

function ENT:SwitchRopeVisibility()

	if ValidEntity(self.WeaponSystem) then
		self.WeaponSystem:SwitchRopeVisibility()
	end
end

function ENT:RemoveAllConnections()
	if ValidEntity(self.WeaponSystem) then
		self.WeaponSystem:RemoveVehicleConnection()
	end
end


function ENT:AdjustKeepUpRightConstraint()
	
	local trace = {}
	trace.start = self.Entity:GetPos() + self.Entity:GetUp() * self.SeatPos1.z
	trace.endpos = self.Entity:GetPos() + (self.Entity:GetUp() * -500)
	trace.filter =  { self.Entity, self.StabilizerProp, self.WfrontLeft, self.WfrontRight, self.WrearLeft, self.WrearRight, self.User1}
	local tr = util.TraceLine( trace )	
	
	local newAng = tr.HitNormal:Angle()
	newAng.pitch = newAng.pitch + 90
	
	if self.StabilizerConstaint != NULL then
		self.StabilizerConstaint:Remove()
		self.StabilizerConstaint = NULL
	end
	
	self.StabilizerConstaint = constraint.Keepupright( self.StabilizerProp, newAng , 0, self.Stabilisation)
	
end

function ENT:GetVehicle()
	return self.Entity
end

function ENT:GetDriver()
	return self.User1
end

function ENT:PlayerUsingVehicle()

	if ValidEntity(self.User1) && self.User1:InVehicle() && self.Seat1:GetDriver() == self.User1 then
		return true
	end

	return false
end
