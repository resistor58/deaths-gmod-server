--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.PutItOnPlace = 0 
ENT.ToolEnt = NULL
ENT.ToolDelay = CurTime()
ENT.ToolIndex = 0
ENT.IsSpawned = false

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	 
 	local ent = ents.Create( "sent_Sakarias_RepairStation" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
 	 
	return ent 
 	 
end

function ENT:Initialize()

	self.Entity:SetModel("models/props_lab/partsbin01.mdl")
	self.Entity:SetColor(255, 255, 255, 255)
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetSolid(SOLID_VPHYSICS)	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end
	
end

function ENT:Use( activator, caller )	

	//If the ent is still functioning and there is no one in it you will be able to enter it 
	if activator:IsPlayer() && self.ToolEnt == NULL && self.ToolDelay < CurTime() then
		
		self.ToolDelay = CurTime() + 2
		
		local Position = self.Entity:GetPos() + self.Entity:GetForward() * 10
		local EntAng = self.Entity:GetAngles()
		
		self.ToolEnt = ents.Create( "sent_Sakarias_RepairStationTool" )	
		self.ToolEnt:SetPos(Position)
		self.ToolEnt:SetColor(0, 0, 0, 255)		
		self.ToolEnt:SetAngles(Angle(0, 0, 90)+EntAng)
		self.ToolEnt:Spawn()	
		self.ToolIndex = self.ToolEnt:EntIndex()

		self.IsSpawned = true
		constraint.Rope( self.Entity, self.ToolEnt, 0, 0, Vector(0,12,11), Vector(0,-7,0), 0, 200, 0, 3, "cable/cable2")
		
	end
	
end

function ENT:PhysicsCollide( data, phys ) 

	ent = data.HitEntity
	local collEntIndex = ent:EntIndex()
			
	if string.find(ent:GetClass( ), "sent_sakarias_repairstationtool" ) && self.ToolIndex == collEntIndex && self.ToolDelay < CurTime() then
		self.ToolDelay = CurTime() + 1
		self.ToolEnt:Remove()
		self.ToolEnt = NULL
	end
	
	
end

function ENT:Think()

	if self.ToolEnt == nil then
		self.ToolEnt = NULL	
	end

end

--If the gas pump is removed it will also remove the pipefaucet.
function ENT:OnRemove()

	if self.ToolEnt:IsValid() then
		self.ToolEnt:Remove()
	end
end
