--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.RepairDelay = CurTime() + 2

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
--------Spawning the entity and getting some sounds i use.   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 + Vector(0,0,20)
 	 
	local ent = ents.Create( "sent_Sakarias_RepairStationTool" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
	self.spawnedBy = ply
	return ent 
	
end

function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_c17/tools_wrench01a.mdl" )
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
end



-------------------------------------------PHYS COLLIDE
function ENT:PhysicsCollide( data, phys ) 
	ent = data.HitEntity

	local dont = true	
	if not(string.find( ent:GetClass( ), "sent_sakarias_car" )) or string.find( ent:GetClass( ), "sent_sakarias_carwheel" ) or string.find( ent:GetClass( ), "sent_Sakarias_carwheel_punked" ) then
		dont = false
	end
	

	if dont && self.RepairDelay < CurTime() then
		self.RepairDelay = CurTime() + 2
		ent:Repair()
		self.Entity:EmitSound("carStools/tune.wav",100,math.random(80,150))
	end

	
end
-------------------------------------------THINK
function ENT:Think()


end
