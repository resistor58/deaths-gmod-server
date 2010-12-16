AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


local GoBoom = function(ent,owner)

	local nuke = ents.Create("sent_nuke")
	nuke:SetPos( ent:GetPos() )
	nuke:SetOwner(owner)
	nuke:Spawn()
	nuke:Activate()
	
	ent:Remove()
	
end


function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_c4_planted.mdl" )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )	
	self.Entity:SetSolid( SOLID_VPHYSICS )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.Owner = self.Entity:GetOwner()

	timer.Simple(self.DetTime,GoBoom,self.Entity,self.Owner)


end



function ENT:PhysicsCollide( data, physobj )


end


function ENT:OnTakeDamage( dmginfo )

	self.Entity:TakePhysicsDamage( dmginfo )
	
end


function ENT:Use( activator, caller )

end


function ENT:Think()

end

function ENT:OnRemove()

end




