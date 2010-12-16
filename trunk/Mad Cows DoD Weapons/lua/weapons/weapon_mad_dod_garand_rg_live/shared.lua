// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_dod_base"

SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_garand_rglive.mdl"
SWEP.WorldModel			= "models/weapons/w_garand_rg_grenade.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Recoil		= 5
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 1.5

SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= true
SWEP.Rifle				= false
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.Throw 				= CurTime()
SWEP.Primed 			= 0

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if (self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetNetworkedBool("Holsted", false)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if self.Throw > CurTime() or self.Primed != 0 or self.Weapon:GetNetworkedBool("Holsted") then return end

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("throw"))
	self.Owner:GetViewModel():SetPlaybackRate(1)

	self.Primed = 1
	self.PrimaryThrow = true
	self.Throw = CurTime() + 0.35
end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack()
   Desc: +attack2 has been pressed.
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
end

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()

	self:SecondThink()

	if (self.Owner:KeyDown(IN_SPEED) and self.Primed == 0) or self.Weapon:GetNetworkedBool("Holsted") then
		if self.Rifle or self.Sniper or self.Shotgun then
			if (SERVER) then
				self:SetWeaponHoldType("passive")
			end
		elseif self.Pistol then
			if (SERVER) then
				self:SetWeaponHoldType("normal")
			end
		end
	else
		if (SERVER) then
			self:SetWeaponHoldType(self.HoldType)
		end
	end

	if (self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) and self.PrimaryThrow) then
		if self.Throw < CurTime() then
			self.Primed = 2
			self.Throw = CurTime() + 1

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			timer.Simple(0.15, function()	self:ThrowGrenade() self.Owner:ViewPunch(Vector(math.Rand(1, 2), math.Rand(0, 0), math.Rand(0, 0))) end)
		end
	end
end

/*---------------------------------------------------------
   Name: SWEP:Holster()
   Desc: Weapon wants to holster.
	   Return true to allow the weapon to holster.
---------------------------------------------------------*/
function SWEP:Holster()

	self.Primed = 0
	self.Throw = CurTime()

	self.Weapon:Remove()

	return true
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	local Animation = self.Owner:GetViewModel()
	Animation:SetSequence(Animation:LookupSequence("draw"))
	self.Owner:GetViewModel():SetPlaybackRate(1)

	self.Weapon:SetNextPrimaryFire(CurTime() + self.DeployDelay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.DeployDelay)
	self.ActionDelay 	= (CurTime() + self.DeployDelay)
	self.Throw = CurTime() + self.DeployDelay
	self.Primed = 0

	return true
end

/*---------------------------------------------------------
   Name: SWEP:ThrowGrenade()
---------------------------------------------------------*/
function SWEP:ThrowGrenade()

	if (self.Primed != 2 or CLIENT) then return end

	local grenade = ents.Create("ent_mad_dod_us_launcher")

	local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetRight() * 7
		pos = pos + self.Owner:GetForward() * -6
		pos = pos + self.Owner:GetUp() * 1

	grenade:SetPos(pos)

	grenade:SetAngles(self.Owner:GetAngles())
	grenade.Owner = self.Owner
	grenade:SetNWBool("Live", true)
	grenade:Spawn()

	local phys = grenade:GetPhysicsObject()

	if self.Owner:KeyDown(IN_FORWARD) then
		self.Force = 3200
	elseif self.Owner:KeyDown(IN_BACK) then
		self.Force = 2100
	else
		self.Force = 2500
	end

	phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force * 1.2 + Vector(0, 0, 400))

	phys:AddAngleVelocity(Vector(0, 500, 0))

	self.Primed = 0
	self.Weapon:Remove()
	self.Owner:ConCommand("lastinv")
end