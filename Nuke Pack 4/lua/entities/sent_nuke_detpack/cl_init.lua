
include('shared.lua')

local sndBeeb = Sound("weapons/c4/c4_beep1.wav")
local sndStop = Sound("ambient/_period.wav")

local matBeebLight = Material("sprites/glow03")
	matBeebLight:SetMaterialInt("$spriterendermode",9)
	matBeebLight:SetMaterialInt("$illumfactor",8)
	matBeebLight:SetMaterialInt("$nocull",0)


local Beep = function(ent)

	ent:EmitSound(sndBeeb)
	
	local EntTable = ent:GetTable()
	EntTable.SpriteDrawTime = CurTime() + 0.3
	EntTable.SpriteAlpha = 255

end	

local InitTimers = function(EntTable)

EntTable.DetTime = EntTable.Entity:GetNWInt("DetTime")
EntTable.strTimerName = "beeper "..EntTable.Entity:__tostring()

local mod3 = math.fmod(EntTable.DetTime,3)
local NewTime = (EntTable.DetTime - mod3)/3

local time1
local time2
local time3

	if NewTime > mod3 then
		time1 = NewTime + 2*mod3
		time2 = NewTime
		time3 = NewTime - mod3
	else
		time1 = NewTime + mod3
		time2 = NewTime
		time3 = NewTime
	end

timer.Create(EntTable.strTimerName, 1, 0, Beep, EntTable.Entity)
timer.Simple(time1, timer.Adjust, EntTable.strTimerName, 0.5, 0, Beep, EntTable.Entity)
timer.Simple((time1 + time2), timer.Adjust, EntTable.strTimerName, 0.25, 0, Beep, EntTable.Entity)


end
	
function ENT:Initialize()

self.SpriteDrawTime = 0
self.SpriteAlpha = 255

timer.Simple(0.1,InitTimers,self)

	
end

function ENT:Draw()

	self.Entity:DrawModel()

	if self.SpriteDrawTime > CurTime() then
		render.SetMaterial(matBeebLight)
		render.DrawSprite(self.Entity:LocalToWorld(Vector(3,6,7)),32,32,Color(255,20,20,self.SpriteAlpha))
		self.SpriteAlpha = self.SpriteAlpha - 768*FrameTime()
	end

end

function ENT:OnRemove()

	if timer.IsTimer( self.strTimerName ) then
	timer.Remove( self.strTimerName )
	end

end




