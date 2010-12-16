// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_fof_coltnavy"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_peacemaker.mdl"
SWEP.WorldModel			= "models/weapons/w_peacemaker.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Peacemaker.Single")
SWEP.Primary.Recoil		= 3
SWEP.Primary.Damage		= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay 		= 0.95

SWEP.Primary.ClipSize		= 6					// Size of a clip
SWEP.Primary.DefaultClip	= 6					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "SniperPenetratedRound"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-5.3822, -7.2721, 2.5181)
SWEP.IronSightsAng 		= Vector (1.3918, 0.0129, 0)
SWEP.RunArmOffset 		= Vector (0.1756, 0, 5.4496)
SWEP.RunArmAngle 			= Vector (-16.9408, 2.663, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/peacemaker/peacemaker_single1.wav")
    	util.PrecacheSound("weapons/peacemaker/peacemaker_single2.wav")
    	util.PrecacheSound("weapons/peacemaker/peacemaker_single3.wav")
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (not self.Owner:IsNPC() and self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetDTBool(0)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if (not self:CanPrimaryAttack()) then return end

	self.ActionDelay = (CurTime() + self.Primary.Delay)

	if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
		self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration() + 0.5)
	end

	self.Weapon:EmitSound(self.Primary.Sound)
	self:TakePrimaryAmmo(1)

	if self.Weapon:GetDTBool(3) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay - 0.52)
	else
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end

	self:ShootBulletInformation()

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end