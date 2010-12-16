--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.PutItOnPlace = 0 
ENT.PlaceEnt = NULL


------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )
   
 	if ( !tr.Hit ) then return end 
 	 
 	local SpawnPos = tr.HitPos + tr.HitNormal * 10 
 	 
 	local ent = ents.Create( "sent_Sakarias_GasPump" )
	ent:SetPos( SpawnPos ) 
 	ent:Spawn()
 	ent:Activate() 
 	 
	return ent 
 	 
end

function ENT:Initialize()

	self.Entity:SetModel("models/props_wasteland/gaspump001a.mdl")
	self.Entity:SetColor(255, 255, 255, 255)
	self.Entity:SetOwner(self.Owner)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetSolid(SOLID_VPHYSICS)	
    local phys = self.Entity:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end


	local Position = self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45))
	local EntAng = self.Entity:GetAngles()

	self.PlaceEnt = ents.Create( "sent_Sakarias_GasPumpNozzle" )	
	self.PlaceEnt:SetPos(Position)
	self.PlaceEnt:SetColor(0, 0, 0, 255)		
	self.PlaceEnt:SetAngles(Angle(0, 0, 90)+EntAng)
	self.PlaceEnt:Spawn()	

	constraint.Rope( self.Entity, self.PlaceEnt, 0, 0, Vector(0,-18,56), Vector(0,-7,0), 0, 200, 0, 3, "cable/cable2")
	constraint.Weld( self.Entity, self.PlaceEnt, 0, 0, 1000)

	
end
function ENT:PhysicsCollide( data, phys ) 

	ent = data.HitEntity
	
	if string.find(ent:GetClass( ), "sent_sakarias_gaspumpnozzle" ) then
		self.PutItOnPlace = 1
	end
end

function ENT:Think()
	if self.PutItOnPlace == 1 then 
		self.PutItOnPlace = 0

		local Position = self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45))
		local EntAng = self.Entity:GetAngles()		
		local StayThere = ent:GetPhysicsObject()

		self.PlaceEnt:SetPos(Position)
		self.PlaceEnt:SetAngles(Angle(0, 0, 90)+EntAng)
		constraint.Weld( self.Entity, self.PlaceEnt, 0, 0, 1000)
	end
	
	if self.PlaceEnt == nil or not(self.PlaceEnt:IsValid()) then
		self.PutItOnPlace = 1
		
		local Position = self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45))
		local EntAng = self.Entity:GetAngles()
		
		self.PlaceEnt = ents.Create( "sent_Sakarias_GasPumpNozzle" )	
		self.PlaceEnt:SetPos(Position)
		self.PlaceEnt:SetColor(0, 0, 0, 255)		
		self.PlaceEnt:SetAngles(Angle(0, 0, 90)+EntAng)
		self.PlaceEnt:Spawn()	

		constraint.Rope( self.Entity, self.PlaceEnt, 0, 0, Vector(0,-18,56), Vector(0,-7,0), 0, 200, 0, 3, "cable/cable2")
		constraint.Weld( self.Entity, self.PlaceEnt, 0, 0, 1000)	
	end	
	
end

--If the gas pump is removed it will also remove the pipefaucet.
function ENT:OnRemove()
	if self.PlaceEnt:IsValid() then
		self.PlaceEnt:Remove()
	end
end
