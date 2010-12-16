include('shared.lua')

SWEP.PrintName			= "9MM WALTHER P38"				// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 1							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_dod_p38.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_dod_p38")
end