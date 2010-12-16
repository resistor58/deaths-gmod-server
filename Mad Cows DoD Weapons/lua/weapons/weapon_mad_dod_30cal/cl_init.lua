include('shared.lua')

SWEP.PrintName			= "7.62MM BROWNING M1919A4"			// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_dod_30cal.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_dod_30cal")
end

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

	offset = hand.Ang:Right() * 2 + hand.Ang:Forward() * -2 + hand.Ang:Up() * 2
	
	hand.Ang:RotateAroundAxis(hand.Ang:Right(), 0)
	hand.Ang:RotateAroundAxis(hand.Ang:Forward(), 0)
	hand.Ang:RotateAroundAxis(hand.Ang:Up(), 0)
	
	self:SetRenderOrigin(hand.Pos + offset)
	self:SetRenderAngles(hand.Ang)
	
	self:DrawModel()
end