include('shared.lua')

SWEP.PrintName			= "GRENADE"						// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 99 							// Can't choose it if you don't have a M1 Garand
SWEP.SlotPos			= 1							// Position in the slot

// Don't need an icon because we'll never see it

/*---------------------------------------------------------
   Name: SWEP:DrawWorldModel()
   Desc: Draws the world model (not the viewmodel).
---------------------------------------------------------*/
function SWEP:DrawWorldModel()

	local hand, offset, rotate
	
	if not ValidEntity(self.Owner) then
		self:DrawModel()
		return
	end
	
	hand = self.Owner:GetAttachment(self.Owner:LookupAttachment("anim_attachment_rh"))

	offset = hand.Ang:Right() * -0.25 + hand.Ang:Forward() * -0.25 + hand.Ang:Up() * 1
	
	hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
	hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 90)
	hand.Ang:RotateAroundAxis(hand.Ang:Up(), -90)
	
	self:SetRenderOrigin(hand.Pos + offset)
	self:SetRenderAngles(hand.Ang)
	
	self:DrawModel()
end