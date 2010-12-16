// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_dod_base"

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_garand.mdl"
SWEP.WorldModel			= "models/weapons/w_garand.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Garand.Shoot")
SWEP.Primary.Reload		= Sound("Weapon_Garand.ClipDing")
SWEP.Primary.Recoil		= 2
SWEP.Primary.Damage		= 57
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Delay 		= 0.15

SWEP.Primary.ClipSize		= 8					// Size of a clip
SWEP.Primary.DefaultClip	= 8					// Default number of bullets in a clip
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

SWEP.IronSightsPos 		= Vector (-6.9472, 0, 5.0735)
SWEP.IronSightsAng 		= Vector (0.0031, 0.0203, 0)
SWEP.RunArmOffset 		= Vector (7.8383, -5.2375, 2.9358)
SWEP.RunArmAngle 			= Vector (-14.7005, 28.5205, 0)

SWEP.AlreadyGive			= false

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/garand_shoot.wav")
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:IsNPC() then return end
	if not IsFirstTimePredicted() then return end

	if (self.Owner:KeyDown(IN_USE)) then
		if (SERVER) then
			if not self.AlreadyGive then
				self.Owner:Give("weapon_mad_dod_garand_rg")
			end

			self.Owner:SelectWeapon("weapon_mad_dod_garand_rg")
		end

		self.AlreadyGive = true

		return
	end

	if (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetNetworkedBool("Holsted")) then return end
	
	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	// When the weapon is already doing an animation, just return end because we don't want to interrupt it
	if (self.ActionDelay > CurTime()) then return end 

	if (self.Weapon:Clip1() <= 0) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		// Need to call the default reload before the real reload animation (don't try to understand my reason)
		self.Weapon:DefaultReload(ACT_VM_RELOAD)

		self:SetIronsights(false)
		self:ReloadAnimation()
	end
end

/*---------------------------------------------------------
   Name: SWEP:ReloadAnimation()
---------------------------------------------------------*/
function SWEP:ReloadAnimation()

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("reload"))
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame. Use this function if you don't 
	   want to copy/past the think function everytime you 
	   create a new weapon with this base...
---------------------------------------------------------*/
function SWEP:SecondThink()
end

/*---------------------------------------------------------
   Name: SWEP:DeployAnimation()
---------------------------------------------------------*/
function SWEP:DeployAnimation()

	if (self.Weapon:Clip1() == 0) then
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("draw_empty"))
	else
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("draw"))
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	if (self.Weapon:Clip1() <= 0) then
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("shoot_empty"))

		self.Weapon:EmitSound(self.Primary.Reload)

		if not IsFirstTimePredicted() or CLIENT then return end

		local effectdata = EffectData()  
		effectdata:SetEntity(self.Weapon)  
		effectdata:SetAttachment(self.Weapon:LookupAttachment("1")) 
		effectdata:SetScale(8)  
		util.Effect("effect_mad_shell", effectdata, true, true)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()
		Animation:SetSequence(Animation:LookupSequence("shoot" .. math.random(1, 3)))
	end
end