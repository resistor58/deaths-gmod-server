
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

local isarmed = 0
local caninuke = 1
local canbeeb = 1
--util.PrecacheSound( "common/warning.wav" ) not used anymore

function ENT:Initialize() 
self.Entity:SetModel( "models/props_junk/Popcan01a.mdl" ) 	
self.Entity:PhysicsInit( SOLID_VPHYSICS )     
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   
self.Entity:SetSolid( SOLID_VPHYSICS )               
local phys = self.Entity:GetPhysicsObject()  
if not (WireAddon == nil) then self.Inputs = Wire_CreateInputs(self.Entity, { "Detonate!", "Arm"}) end	
if not (WireAddon == nil) then self.Outputs = Wire_CreateOutputs(self.Entity, { "Armed"}) end
if (phys:IsValid()) then  		
phys:Wake()  	
end 
 
end   

function ENT:TriggerInput(iname, value) --wire inputs
	if (iname == "Detonate!") then
		if value == 1 then
		    if self.isarmed == 1 then
			    self:MakeNuke()
			end
		end
	end
	if (iname == "Arm") then
		if value == 1 then
		    self.isarmed = 1
		end
		if value == 0 then
		    self.isarmed = 0
		end
	end
end

function ENT:SpawnFunction( ply, tr)

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "soda_sent_atomic_bomb" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent

end

function ENT:PhysicsCollide( data, physobj )
    if ( self.isarmed == 1 ) then
	    if data.Speed > 600 and data.DeltaTime > 0.15 then -- if it hits an object at over 600 speed
            self:MakeNuke()
		end
    end
end	

function ENT:OnTakeDamage(dmginfo)
self.Entity:TakePhysicsDamage( dmginfo )
end 

function ENT:Think()
	if ( self.isarmed == 1 ) then
	    self:SetOverlayText( " ARMED " )
	else
	    self:SetOverlayText( " Unarmed " )
	end
	if not (WireAddon == nil) then Wire_TriggerOutput(self.Entity, "Armed", self.isarmed) end
end

--function ENT:Kaboom()
--    if self.isarmed == 1 then
--	    if self.caninuke == 1 then
--		    self:MakeNuke()
--	        self.Entity:Remove()
--		end
--	end
--end	

function ENT:OnRemove()
self.caninuke = 0
end

function ENT:MakeNuke() --Make ze nuke!
local nuke = ents.Create("sent_nuke")
if caninuke == 1 then
nuke:SetPos( self.Entity:GetPos() )
nuke:SetVar("owner",self.Owner)
nuke:Spawn()
nuke:Activate()
Msg("Made a nuke!\n") --debug stuff
self.Entity:Remove()
end
end
function ENT:Use()
    self.isarmed = 1
end	