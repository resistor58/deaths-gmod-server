// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_fof_base"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip		= false
SWEP.ViewModel 			= "models/weapons/v_sharps.mdl"
SWEP.WorldModel 			= "models/weapons/w_sharps.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Sharps.Single")
SWEP.Primary.Recoil		= 9
SWEP.Primary.Damage		= 88
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0005
SWEP.Primary.Delay 		= 1

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "SniperPenetratedRound"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-2.9599, -3.5714, 1.6584)
SWEP.IronSightsAng 		= Vector (0.27, 0.027, 0)
SWEP.RunArmOffset 		= Vector (2.3805, 0, 3.1152)
SWEP.RunArmAngle 			= Vector (-18.851, 13.9111, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/sharps/sharps_rifle_fire1.wav")
    	util.PrecacheSound("weapons/sharps/sharps_rifle_fire2.wav")
end