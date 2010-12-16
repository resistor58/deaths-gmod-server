--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

--[[
//Sounds
resource.AddFile( "sound/car/changeGear.wav" )
resource.AddFile( "sound/car/hydraulics.wav" )
resource.AddFile( "sound/car/nosstart.wav" )
resource.AddFile( "sound/car/nosstop.wav" )
resource.AddFile( "sound/car/skid.wav" )
resource.AddFile( "sound/car/burnout.wav" )
resource.AddFile( "sound/carStools/hydraulic.wav" )
resource.AddFile( "sound/carStools/spray.wav" )
resource.AddFile( "sound/carStools/tune.wav" )
resource.AddFile( "sound/carStools/wheel.wav" )
resource.AddFile( "sound/tire/flatTire.wav" )

resource.AddFile( "materials/VGUI/wheel_Banshee.vtf" )
resource.AddFile( "materials/VGUI/wheel_belair.vtf" )
resource.AddFile( "materials/VGUI/wheel_cadillac.vtf" )
resource.AddFile( "materials/VGUI/wheel_camaro.vtf" )
resource.AddFile( "materials/VGUI/wheel_chevy66.vtf" )
resource.AddFile( "materials/VGUI/wheel_fordGT.vtf" )
resource.AddFile( "materials/VGUI/wheel_hummer.vtf" )
resource.AddFile( "materials/VGUI/wheel_impala.vtf" )
resource.AddFile( "materials/VGUI/wheel_impala88.vtf" )
resource.AddFile( "materials/VGUI/wheel_junker.vtf" )
resource.AddFile( "materials/VGUI/wheel_mustang.vtf" )
resource.AddFile( "materials/VGUI/wheel_studebaker.vtf" )
resource.AddFile( "materials/VGUI/wheel_template.vtf" )

resource.AddFile( "materials/VGUI/wheel_Banshee.vmt" )
resource.AddFile( "materials/VGUI/wheel_belair.vmt" )
resource.AddFile( "materials/VGUI/wheel_cadillac.vmt" )
resource.AddFile( "materials/VGUI/wheel_camaro.vmt" )
resource.AddFile( "materials/VGUI/wheel_chevy66.vmt" )
resource.AddFile( "materials/VGUI/wheel_fordGT.vmt" )
resource.AddFile( "materials/VGUI/wheel_hummer.vmt" )
resource.AddFile( "materials/VGUI/wheel_impala.vmt" )
resource.AddFile( "materials/VGUI/wheel_impala88.vmt" )
resource.AddFile( "materials/VGUI/wheel_junker.vmt" )
resource.AddFile( "materials/VGUI/wheel_mustang.vmt" )
resource.AddFile( "materials/VGUI/wheel_studebaker.vmt" )
resource.AddFile( "materials/VGUI/wheel_template.vmt" )

//Hud materials
resource.AddFile( "materials/SCarHUD/gear.vtf" )
resource.AddFile( "materials/SCarHUD/speedPointer.vtf" )
resource.AddFile( "materials/SCarHUD/rev.vtf" )
resource.AddFile( "materials/SCarHUD/speed.vtf" )
resource.AddFile( "materials/SCarHUD/fuelPointer.vtf" )
resource.AddFile( "materials/SCarHUD/gear.vmt" )
resource.AddFile( "materials/SCarHUD/speedPointer.vmt" )
resource.AddFile( "materials/SCarHUD/rev.vmt" )
resource.AddFile( "materials/SCarHUD/speed.vmt" )
resource.AddFile( "materials/SCarHUD/fuelPointer.vmt" )
]]--
ENT.spawnedBy = NULL
ENT.MaxHealth = 50
ENT.WheelHealth = 50

ENT.Rim = NULL
ENT.PunkOnce = 0
ENT.CanTakeDamage = 1
ENT.Owner = NULL
ENT.TireModel = NULL

ENT.DecoyWheel = NULL

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_Sakarias_CarWheel" )
	ent:SetPos( SpawnPos ) 			
 	ent:Spawn()
 	ent:Activate()
	self.spawnedBy = ply
	return ent 
	
end

function ENT:Initialize()

	self.TireModel = self.Entity.TireModel
	
	--self.TireModel = "models/props_vehicles/carparts_wheel01a.mdl"

	self.Entity:SetModel( self.TireModel )
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
	phys:SetMass(15)
	
	--construct.SetPhysProp( self.spawnedBy,  self.Entity, 0, nil, { GravityToggle = 1, Material = "rubber" })
	construct.SetPhysProp( self.spawnedBy,  self.Entity, 0, nil, { GravityToggle = 1, Material = "jeeptire" })
	self.Entity.IsColliding = 0
	self.Entity.IsDestroyed = 0

	self.Entity.Rim = NULL
	self.WheelHealth = self.MaxHealth 
	
	if ValidEntity(self.SCarOwner) then
		self.DecoyWheel = ents.Create( "prop_physics" )
		self.DecoyWheel:SetModel(self.TireModel)	
		self.DecoyWheel:Spawn()	
		self.DecoyWheel:SetParent( self.Entity )
		self.DecoyWheel:SetLocalPos(Vector(0,0,0))
		self.DecoyWheel:SetLocalAngles( self.Entity:GetAngles() )	
		self.DecoyWheel:SetNotSolid( true )
		self.Entity:SetColor(255,255,255,0)
	end

end

function ENT:SetCanTakeDamage( CanTakeDamage )
	self.CanTakeDamage = CanTakeDamage
end

function ENT:SetCarOwner( ply )

	if ValidEntity(ply) then
		self.Owner = ply
		
		self.Entity:SetNetworkedEntity("ASS_Owner", self.Owner)
		self.Entity:SetVar( "ASS_Owner", self.Owner )
		self.Entity:SetVar("ASS_OwnerOverride", true)
		self.Entity.Owner = self.Owner

		--ASS prop protection
		self.Entity:SetNetworkedEntity("ASS_Owner", self.Owner)
		self.Entity:SetVar( "ASS_Owner", self.Owner )
		self.Entity:SetVar("ASS_OwnerOverride", true)
		
		--Falcos prop protection
		self.Owner = ply
		self.Entity.Owner = ply
		self.Entity.OwnerID = ply:SteamID()
		self.OwnerID = ply:SteamID()
		
		--UPS prop protection
		gamemode.Call( "UPSAssignOwnership", ply, self )	
	end
end

-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity
	
	self.Entity.IsColliding = 1	
	
end

function ENT:PhysicsUpdate()
	if ValidEntity(self.SCarOwner) && ValidEntity(self.DecoyWheel) && self.Entity.IsDestroyed == 0 then
		local percent = self.SCarOwner.RealSteerForce / self.SCarOwner.SteerForce
		
		--if (self.SCarOwner.RealSteerForce > 0 && self.SCarOwner.RealSteerForce < (self.SCarOwner.SteerResponse * 2)) or (self.SCarOwner.RealSteerForce < 0 && self.SCarOwner.RealSteerForce > (self.SCarOwner.SteerResponse * -2)) then
			--percent = 0
		--end
		
		local moveAng = 45 * percent
		local ang = self.Entity:GetAngles()
		ang:RotateAroundAxis( self.SCarOwner:GetUp() , moveAng )
		
		self.DecoyWheel:SetAngles( ang )
	end
end

-------------------------------------------DAMAGE
function ENT:OnTakeDamage(dmg)

	
	if self.Entity.IsDestroyed == 0 && self.CanTakeDamage == 1  then
		local attacker = dmg:GetAttacker( )
		
		if attacker != self.EntOwner.User1 then
			local Damage = dmg:GetDamage()
			self.WheelHealth = self.WheelHealth - Damage
		end
	end
end
-------------------------------------------THINK
function ENT:Think()
	self.Entity.IsColliding = 0
	
	if self.WheelHealth <= 0 then
		self.Entity.IsDestroyed = 1	
	end
	
	
	if (self.MaxHealth > self.WheelHealth && self.PunkOnce == 0) then
		self.PunkOnce = 1
		
		self.Entity:SetNotSolid( true )
		
		local ang = self.Entity:GetAngles()
		self.Entity:SetAngles(Angle(0,0,0))
		--Spawning rim
		self.Rim = ents.Create( "sent_Sakarias_CarWheel_punked" )		
		self.Rim:SetPos( self.Entity:GetPos() )
		self.Rim:SetOwner( self.Owner )		
		self.Rim:SetAngles( self.Entity:GetAngles() + Angle(0,90,0))
		self.Rim.OwnerEnt = self.Entity
		self.Rim:Spawn()	
		self.Rim:GetPhysicsObject():SetMass(1)	
		self.Entity.Rim = self.Rim
		constraint.Weld( self.Entity, self.Rim, 0, 0, 0, 1 ) 
		self.Rim:GetPhysicsObject():SetMass(20)	
		self.Rim:SetCarOwner( self.Owner )
		
		self.Entity:SetAngles(ang)	
		
		if ValidEntity(self.DecoyWheel) then
			self.DecoyWheel:SetLocalAngles( Angle(0,0,0) )
		end
		
		if not(self.Entity.IsFlat == 1) then
			self.Entity:EmitSound("tire/flatTire.wav", 60,math.random(50,150))	
			self.Entity.IsFlat = 1			
		end
		
		self.Entity:SetCollisionGroup( GROUP_DEBRIS )			
	end
	
	if self.Rim.IsColliding == 1 then
		self.Entity.IsColliding = 1
	end
	
	
	

end

-------------------------------------------ON REMOVE
function ENT:OnRemove()

	if self.PunkOnce == 1 then
		self.Rim:Remove()
	end
	
end

function ENT:BuildDupeInfo()
	local info = WireLib.BuildDupeInfo(self) or {}
	
	info.TireModel = self.TireModel
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	WireLib.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	
	self.TireModel = info.TireModel
end

function ENT:GiveDamage( damage, attacker )
	if self.Entity.IsDestroyed == 0 && self.CanTakeDamage == 1  then

		if !ValidEntity(self.SCarOwner) or ValidEntity(self.SCarOwner) && ValidEntity(self.SCarOwner.User1) && attacker != self.SCarOwner.User1 or ValidEntity(self.SCarOwner) && self.SCarOwner.User1 == NULL then
			self.WheelHealth = self.WheelHealth - damage
		end
		
	end
end