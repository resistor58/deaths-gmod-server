include('shared.lua')

SWEP.PrintName			= ".50 SMITH CARBINE"				// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_fof_carbine.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_fof_carbine")
end