// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_fof_base"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_coachgun.mdl"
SWEP.WorldModel			= "models/weapons/w_coachgun.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Coachgun.Single")
SWEP.Primary.Recoil		= 5.5
SWEP.Primary.Damage		= 12
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.04
SWEP.Primary.Delay 		= 0.25

SWEP.Primary.ClipSize		= 2					// Size of a clip
SWEP.Primary.DefaultClip	= 2					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= false
SWEP.Shotgun			= true
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-5.8205, -0.1201, 4.7958)
SWEP.IronSightsAng 		= Vector (0.1289, -0.0233, 0)
SWEP.RunArmOffset 		= Vector (1.1505, 0, 5.7803)
SWEP.RunArmAngle 			= Vector (-19.6556, 3.7158, 0)

SWEP.Penetration			= false
SWEP.Ricochet			= false

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/coachgun/coach_fire1.wav")
    	util.PrecacheSound("weapons/coachgun/coach_fire2.wav")
end