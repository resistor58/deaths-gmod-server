--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.spawnedBy = NULL
ENT.Owner = NULL
------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_Sakarias_CarWheel_punked" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	self.spawnedBy = ply
	return ent 
	
end

function ENT:Initialize()

	local TIREMODEL = "models/props_c17/pulleywheels_small01.mdl"
	
	self.Entity:SetModel( TIREMODEL )
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetColor(255,255,255,0)
	self.Entity:GetPhysicsObject():SetMass(1)
	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	construct.SetPhysProp( self.spawnedBy,  self.Entity, 0, nil, { GravityToggle = 1, Material = "rubber" })
	self.Entity.IsColliding = 0
end

function ENT:SetCarOwner( ply )

	self.Owner = ply
	self.Entity:SetNetworkedEntity("ASS_Owner", self.Owner)
	self.Entity:SetVar( "ASS_Owner", self.Owner )
	self.Entity:SetVar("ASS_OwnerOverride", true)
	self.Entity.Owner = self.Owner

end


-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 

	self.Entity.IsColliding = 1	
	
end

-------------------------------------------THINK
function ENT:Think()
	self.Entity.IsColliding = 0	
end

function ENT:OnTakeDamage(dmg)

	if ValidEntity(self.OwnerEnt) then
		local Damage = dmg:GetDamage()
		local attacker = dmg:GetAttacker( )
		self.OwnerEnt:GiveDamage(Damage, attacker)
	end
	
end
