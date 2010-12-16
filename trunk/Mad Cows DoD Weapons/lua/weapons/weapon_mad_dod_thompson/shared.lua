// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_dod_base"

SWEP.ViewModelFOV			= 52
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_thompson.mdl"
SWEP.WorldModel			= "models/weapons/w_thompson.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Thompson.Shoot")
SWEP.Primary.Recoil		= 0.4
SWEP.Primary.Damage		= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.019
SWEP.Primary.Delay 		= 0.086

SWEP.Primary.ClipSize		= 30					// Size of a clip
SWEP.Primary.DefaultClip	= 30					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "SniperPenetratedRound"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.DeployDelay			= 1

SWEP.ShellEffect			= "effect_mad_shell_pistol"	// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-4.5259, -4.2141, 1.7646)
SWEP.IronSightsAng 		= Vector (0.6244, 0.0186, 0)
SWEP.RunArmOffset 		= Vector (4.3673, 0, 3.4242)
SWEP.RunArmAngle 			= Vector (-19.132, 21.3581, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/thompson_shoot.wav")
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetNetworkedBool("Holsted")) then return end
	if self.Owner:IsNPC() then return end

	if (self.Owner:KeyDown(IN_USE)) then // Custom mode
		if (SERVER) then
			self:SetWeaponHoldType("fist")
		end

		local tr = {}
		tr.start = self.Owner:GetShootPos()
		tr.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 50)
		tr.filter = self.Owner
		tr.mask = MASK_SHOT
		local trace = util.TraceLine(tr)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.85)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.85)
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		if (trace.Hit) then
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 25
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound("Weapon_Punch.HitPlayer")
		end

		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)

		return
	end

	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end