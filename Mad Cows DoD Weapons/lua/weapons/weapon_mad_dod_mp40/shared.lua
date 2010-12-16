// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_dod_thompson"

SWEP.ViewModelFOV			= 52
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_mp40.mdl"
SWEP.WorldModel			= "models/weapons/w_mp40.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_MP40.Shoot")
SWEP.Primary.Recoil		= 0.3
SWEP.Primary.Damage		= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.014
SWEP.Primary.Delay 		= 0.12

SWEP.Primary.ClipSize		= 32					// Size of a clip
SWEP.Primary.DefaultClip	= 32					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Battery"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.DeployDelay			= 1.3

SWEP.ShellEffect			= "effect_mad_shell_pistol"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-4.4198, -2.908, 1.7704)
SWEP.IronSightsAng 		= Vector (0.4878, -0.0735, 0)
SWEP.RunArmOffset 		= Vector (5.3878, 0, 5.117)
SWEP.RunArmAngle 			= Vector (-20.2832, 18.4025, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/mp40_shoot.wav")
end