include('shared.lua')

language.Add("weapon_flaregun", "Flare Gun")

SWEP.PrintName = "Flare Gun"
SWEP.Slot = 5
SWEP.SlotPos = 4
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.WepSelectIcon = surface.GetTextureID("HUD/weapons/weapon_flaregun") 
SWEP.BounceWeaponIcon = false 
