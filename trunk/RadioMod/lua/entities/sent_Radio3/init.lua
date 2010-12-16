
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

--Clients shouldn't download the custom radio sounds.
--
--[[
resource.AddFile( "sound/radio_mod_sounds/radio/custom/1.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/2.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/3.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/4.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/5.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/6.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/7.mp3" )
resource.AddFile( "sound/radio_mod_sounds/radio/custom/8.mp3" )
--]]

resource.AddFile( "materials/vgui/entities/sent_Radio3.vtf" )
resource.AddFile( "materials/vgui/entities/sent_Radio3.vmt" )
resource.AddFile( "materials/models/radio_electro.vtf" )
resource.AddFile( "materials/models/radio_electro.vmt" )
include('shared.lua')

--Radio music
ENT.RadioSong1 = NULL
ENT.RadioSong2 = NULL
ENT.RadioSong3 = NULL
ENT.RadioSong4 = NULL
ENT.RadioSong5 = NULL
ENT.RadioSong6 = NULL
ENT.RadioSong7 = NULL
ENT.RadioSong8 = NULL


ENT.SongNr = 0
ENT.NxtDelay = CurTime()

------------------------------------VARIABLES END
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( self.ClassName )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
end
--------------
function ENT:Initialize( )
	self:SetModel( "models/props_lab/citizenradio.mdl" )
	self:SetMaterial( "models/radio_electro" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then phys:Wake() end

	self.Engine = NULL

self.RadioSong1 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/1.mp3")
self.RadioSong2 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/2.mp3")
self.RadioSong3 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/3.mp3")
self.RadioSong4 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/4.mp3")
self.RadioSong5 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/5.mp3")
self.RadioSong6 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/6.mp3")
self.RadioSong7 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/7.mp3")
self.RadioSong8 = CreateSound(self.Entity,"Radio_Mod_Sounds/Radio/custom/8.mp3")

end
--------------
function ENT:Use()
	if self.NxtDelay < CurTime() then
	self.NxtDelay = CurTime()+0.5
	self.SongNr = self.SongNr + 1
		self.Entity:EmitSound("buttons/lightswitch2.wav", 100, 100)

			if self.SongNr >8 then
			self.SongNr = 0
			self.Entity:EmitSound("buttons/button18.wav", 100, 100)
			end



	end
end
-------------------
function ENT:Think()

if self.Entity:WaterLevel() > 0 then

		local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos())
		effectdata:SetStart(Vector(0,0,2)) 
		util.Effect( "PropellerBubbles", effectdata )
end

if self.SongNr == 0 then			
	self.RadioSong1:Stop()
	self.RadioSong2:Stop()
	self.RadioSong3:Stop()
	self.RadioSong4:Stop()
	self.RadioSong5:Stop()
	self.RadioSong6:Stop()
	self.RadioSong7:Stop()
	self.RadioSong8:Stop()
		
end

if self.SongNr == 1 then
	self.RadioSong1:Play()
end

if self.SongNr == 2 then
	self.RadioSong1:Stop()
	self.RadioSong2:Play()
end

if self.SongNr == 3 then
	self.RadioSong2:Stop()
	self.RadioSong3:Play()
end

if self.SongNr == 4 then
	self.RadioSong3:Stop()
	self.RadioSong4:Play()
end

if self.SongNr == 5 then
	self.RadioSong4:Stop()
	self.RadioSong5:Play()
end

if self.SongNr == 6 then
	self.RadioSong5:Stop()
	self.RadioSong6:Play()
end

if self.SongNr == 7 then
	self.RadioSong6:Stop()
	self.RadioSong7:Play()
end

if self.SongNr == 8 then
	self.RadioSong7:Stop()
	self.RadioSong8:Play()
end


end
-------------------
function ENT:OnRemove()
	self.RadioSong1:Stop()
	self.RadioSong2:Stop()
	self.RadioSong3:Stop()
	self.RadioSong4:Stop()
	self.RadioSong5:Stop()
	self.RadioSong6:Stop()
	self.RadioSong7:Stop()
	self.RadioSong8:Stop()

end
