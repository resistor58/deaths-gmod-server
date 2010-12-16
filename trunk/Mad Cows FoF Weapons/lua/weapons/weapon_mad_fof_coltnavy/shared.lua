// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_fof_base_shotgun"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_coltnavy.mdl"
SWEP.WorldModel			= "models/weapons/w_coltnavy.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_ColtNavy.Single")
SWEP.Primary.Recoil		= 2
SWEP.Primary.Damage		= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.014
SWEP.Primary.Delay 		= 0.95

SWEP.Primary.ClipSize		= 6					// Size of a clip
SWEP.Primary.DefaultClip	= 6					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "357"

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

SWEP.IronSightsPos 		= Vector (-6.4479, -3.5031, 3.9885)
SWEP.IronSightsAng 		= Vector (-0.131, -0.0117, 0)
SWEP.RunArmOffset 		= Vector (0.1756, 0, 5.4496)
SWEP.RunArmAngle 			= Vector (-16.9408, 2.663, 0)

SWEP.Penetration			= true
SWEP.Ricochet			= true

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 1
SWEP.ShotgunBeginReload		= 1

SWEP.Type				= 1 					// 1 = Automatic/Semi-Automatic mode, 2 = Suppressor mode, 3 = Burst fire mode
SWEP.Mode				= true

SWEP.data 				= {}
SWEP.data.NormalMsg		= "Switched to normal mode."
SWEP.data.ModeMsg			= "Switched to fast mode."
SWEP.data.Delay			= 0.25
SWEP.data.Cone			= 1.25
SWEP.data.Damage			= 1
SWEP.data.Recoil			= 1.5
SWEP.data.Automatic		= true

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/coltnavy/navy_fire1.wav")
    	util.PrecacheSound("weapons/coltnavy/navy_fire2.wav")
    	util.PrecacheSound("weapons/coltnavy/navy_fire3.wav")
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
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay - 0.55)
	else
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end

	self:ShootBulletInformation()

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	if self.Weapon:GetDTBool(3) then
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end