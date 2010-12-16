// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_fof_base"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip		= false
SWEP.ViewModel 			= "models/weapons/v_deringer.mdl"
SWEP.WorldModel 			= "models/weapons/w_deringer.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Deringer.Single")
SWEP.Primary.Recoil		= 1
SWEP.Primary.Damage		= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.022
SWEP.Primary.Delay 		= 1.2

SWEP.Primary.ClipSize		= 2					// Size of a clip
SWEP.Primary.DefaultClip	= 2					// Default number of bullets in a clip
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

SWEP.IronSightsPos 		= Vector (-5.8429, 0, 2.2437)
SWEP.IronSightsAng 		= Vector (4.03, 0.0373, 0)
SWEP.RunArmOffset 		= Vector (-0.22, 0, 7.1964)
SWEP.RunArmAngle 			= Vector (-22.7972, 0.5712, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/deringer/deringer_single1.wav")
    	util.PrecacheSound("weapons/deringer/deringer_single2.wav")
    	util.PrecacheSound("weapons/deringer/deringer_single3.wav")
end

/*---------------------------------------------------------
   Name: SWEP:ReloadAnimation()
---------------------------------------------------------*/
function SWEP:ReloadAnimation()

	self.Weapon:DefaultReload(ACT_VM_RELOAD)

	timer.Simple(self.Owner:GetViewModel():SequenceDuration(), function()
		if not IsFirstTimePredicted() then return end

		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)

		self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())

		if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
			self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
		end
	end)
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

	if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
		self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration() + 0.5)
	end

	if (self.Weapon:Clip1() > 0) then
		timer.Simple(self.Owner:GetViewModel():SequenceDuration(), function()
			if not IsFirstTimePredicted() then return end

			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)

			self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
			self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())

			if (IsValid(self.Owner) and self.Owner:GetViewModel()) then
				self:IdleAnimation(self.Owner:GetViewModel():SequenceDuration())
			end
		end)
	end
end