include('shared.lua')

SWEP.PrintName			= "Mad Cows Weapon Base of Fistful of Frags"	// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 1							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/swep.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/swep")
end