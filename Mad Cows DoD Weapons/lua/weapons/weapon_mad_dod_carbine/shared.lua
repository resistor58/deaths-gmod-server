// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_dod_base"

SWEP.ViewModelFOV			= 45
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_m1carbine.mdl"
SWEP.WorldModel			= "models/weapons/w_m1carb.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Carbine.Shoot")
SWEP.Primary.Recoil		= 1.5
SWEP.Primary.Damage		= 37
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0015
SWEP.Primary.Delay 		= 0.1

SWEP.Primary.ClipSize		= 15					// Size of a clip
SWEP.Primary.DefaultClip	= 15					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "StriderMinigun"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.DeployDelay			= 1

SWEP.ShellEffect			= "effect_mad_shell_rifle"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-6.8457, -16.4019, 3.3008)
SWEP.IronSightsAng 		= Vector (0.0073, 0.023, 0)
SWEP.RunArmOffset 		= Vector (4.7546, 0, 3.4244)
SWEP.RunArmAngle 			= Vector (-10.7548, 15.175, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/m1carbine_shoot.wav")
end