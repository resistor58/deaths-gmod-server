include('shared.lua')

SWEP.PrintName			= "7.62MM MAUSER K98K SNIPER"			// The real ammo type of this rifle is 7.92MM	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_dod_k98_scoped.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_dod_k98_scoped")
end