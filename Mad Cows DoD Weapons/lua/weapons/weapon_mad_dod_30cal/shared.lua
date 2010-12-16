// Variables that are used on both client and server

local RecoilMul = CreateConVar ("mad_recoilmul", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})
local DamageMul = CreateConVar ("mad_damagemul", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE})

SWEP.Base 				= "weapon_mad_dod_base"

SWEP.ViewModelFOV			= 48
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_30cal.mdl"
SWEP.WorldModel			= "models/weapons/w_30cal.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_30cal.Shoot")
SWEP.Primary.Recoil		= 2.5
SWEP.Primary.OldRecoil		= 2.5
SWEP.Primary.Damage		= 35
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.007
SWEP.Primary.Delay 		= 0.125

SWEP.Primary.ClipSize		= 100					// Size of a clip
SWEP.Primary.DefaultClip	= 100					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "StriderMinigun"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.DeployDelay			= 1.5

SWEP.ShellEffect			= "effect_mad_shell_rifle"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-4.4616, 0, 4.1114)
SWEP.IronSightsAng 		= Vector (-0.0927, -0.2986, 8.9069)
SWEP.RunArmOffset 		= Vector (2.696, 0, 5.6778)
SWEP.RunArmAngle 			= Vector (-22.8837, 16.9755, 0)

SWEP.Type				= 0 					// 1 = Automatic/Semi-Automatic mode, 2 = Suppressor mode, 3 = Burst fire mode
SWEP.Mode				= true

SWEP.data 				= {}
SWEP.data.NormalMsg		= ""
SWEP.data.ModeMsg			= ""
SWEP.data.Delay			= 1.25
SWEP.data.Cone			= 1
SWEP.data.Damage			= 1
SWEP.data.Recoil			= 0.1
SWEP.data.Automatic		= false

SWEP.ReloadTime			= 4.5

SWEP.AllowIdleAnimation		= false

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/30cal_shoot.wav")
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:IsNPC() then return end

	local tr = {}
	tr.start = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 25)
	tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 25) - Vector(0, 0, 36)
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)

	if (trace.Hit and (self.Mode) and self.Owner:GetVelocity():Length() < 25) then // Mode

		bMode = !self.Weapon:GetDTBool(3)
		self:SetMode(bMode)

		self.Weapon:SetNextPrimaryFire(CurTime() + self.data.Delay)
		self.Weapon:SetNextSecondaryFire(CurTime() + self.data.Delay)
		self.ActionDelay = (CurTime() + self.data.Delay)

		self:SetIronsights(false)

		self.Weapon:SetNWInt("NextChangeMode", CurTime() + self.data.Delay)

		return
	end

	if (self.Weapon:GetDTBool(3)) or (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetDTBool(0)) then return end
	
	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end

/*---------------------------------------------------------
   Name: SWEP:SetMode()
---------------------------------------------------------*/
function SWEP:SetMode(b)

	if (self.Owner) then
		if (b) then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			local Animation = self.Owner:GetViewModel()

			if self.Weapon:Clip1() < 9 then
				Animation:SetSequence(Animation:LookupSequence("uptodown" .. math.Clamp(self.Weapon:Clip1(), 1, 8)))
			else
				Animation:SetSequence(Animation:LookupSequence("uptodown"))
			end
		else
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			local Animation = self.Owner:GetViewModel()

			if self.Weapon:Clip1() < 9 then
				Animation:SetSequence(Animation:LookupSequence("downtoup" .. math.Clamp(self.Weapon:Clip1(), 1, 8)))
			else
				Animation:SetSequence(Animation:LookupSequence("downtoup"))
			end
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(3, b)
	end
end

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
function SWEP:Reload()

	// When the weapon is already doing an animation, just return end because we don't want to interrupt it
	if (self.ActionDelay > CurTime()) or not (self.Weapon:GetDTBool(3)) then return end 

	self.Weapon:DefaultReload(ACT_VM_RELOAD_DEPLOYED)

	self.Weapon:SetNWInt("NextChangeMode", CurTime() + 4.5)

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and (self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self:SetIronsights(false)
	end
end

/*---------------------------------------------------------
   Name: SWEP:SecondThink()
   Desc: Called every frame. Use this function if you don't 
	   want to copy/past the think function everytime you 
	   create a new weapon with this base...
---------------------------------------------------------*/
function SWEP:SecondThink()

	local tr = {}
	tr.start = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 25)
	tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 25) - Vector(0, 0, 36)
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine(tr)

	if (self.Weapon:GetDTBool(3)) and self.Weapon:GetNWInt("NextChangeMode") < CurTime() then
		if (not trace.Hit or self.Owner:KeyDown(IN_SPEED) or not self.Owner:IsOnGround() or self.Owner:GetVelocity():Length() > 25) then
			self:SetMode(false)
			self.Weapon:SetNextPrimaryFire(CurTime() + 1.25)
			self.Weapon:SetNextSecondaryFire(CurTime() + 1.25)
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:DeployAnimation()
---------------------------------------------------------*/
function SWEP:DeployAnimation()

//	self.Weapon:SetMode(false)
	self.Weapon:SetDTBool(3, false)
	self.Weapon:SetNWInt("NextChangeMode", CurTime())

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("draw"))
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
---------------------------------------------------------*/
function SWEP:Holster()

//	self.Weapon:SetMode(false)
	self.Weapon:SetNetworkedBool("Mode", false)

	return true
end

/*---------------------------------------------------------
   Name: SWEP:ShootAnimation()
---------------------------------------------------------*/
function SWEP:ShootAnimation()

	if (self.Weapon:GetDTBool(3)) then
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()

		if self.Weapon:Clip1() < 9 then
			Animation:SetSequence(Animation:LookupSequence("downshoot" .. math.Clamp(self.Weapon:Clip1(), 1, 8)))
		else
			Animation:SetSequence(Animation:LookupSequence("downshoot"))
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		local Animation = self.Owner:GetViewModel()

		if self.Weapon:Clip1() < 9 then
			Animation:SetSequence(Animation:LookupSequence("upshoot" .. math.Clamp(self.Weapon:Clip1(), 1, 8)))
		else
			Animation:SetSequence(Animation:LookupSequence("upshoot"))
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:ShootBulletInformation()
   Desc: This function add the damage, the recoil, the number of shots and the cone on the bullet.
---------------------------------------------------------*/
function SWEP:ShootBulletInformation()

	local CurrentDamage
	local CurrentRecoil
	local CurrentCone

	if self.Weapon:GetDTBool(3) then
		CurrentDamage = self.Primary.Damage * self.data.Damage * DamageMul:GetFloat()
		CurrentRecoil = self.Primary.Recoil * self.data.Recoil * RecoilMul:GetFloat()
		CurrentCone = self.Primary.Cone * self.data.Cone
	else
		CurrentDamage = self.Primary.Damage * DamageMul:GetFloat()
		CurrentRecoil = self.Primary.Recoil * RecoilMul:GetFloat()
		CurrentCone = self.Primary.Cone
	end

	// Player is aiming
	if (self.Weapon:GetDTBool(1)) then
		self:ShootBullet(CurrentDamage, CurrentRecoil / 4, self.Primary.NumShots, CurrentCone)
		self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (CurrentRecoil / 6), math.Rand(-1,1) * (CurrentRecoil / 6), 0))
	// Player is not aiming
	else
		self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, CurrentCone)
		self.Owner:ViewPunch(Angle(math.Rand(-0.5,-2.5) * (CurrentRecoil / 3), math.Rand(-1,1) * (CurrentRecoil / 3), 0))
	end
end