// Variables that are used on both client and server

SWEP.Base 				= "weapon_mad_dod_base"

SWEP.ViewModelFOV      		= 50
SWEP.ViewModel			= "models/weapons/v_k98_rg.mdl"
SWEP.WorldModel			= "models/weapons/w_k98_rg.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound 		= Sound("Weapon_Grenade.Shoot")
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.075
SWEP.Primary.Delay 		= 0.5

SWEP.Primary.ClipSize		= 1					// Size of a clip
SWEP.Primary.DefaultClip	= 1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize		= -1					// Size of a clip
SWEP.Secondary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Secondary.Automatic	= false				// Automatic/Semi Auto
SWEP.Secondary.Ammo		= "none"

SWEP.ShellEffect			= "none"				// "effect_mad_shell_pistol" or "effect_mad_shell_rifle" or "effect_mad_shell_shotgun"
SWEP.ShellDelay			= 0

SWEP.Pistol				= false
SWEP.Rifle				= true
SWEP.Shotgun			= false
SWEP.Sniper				= false

SWEP.IronSightsPos 		= Vector (-4.5248, -5.0179, 5.0219)
SWEP.IronSightsAng 		= Vector (-4.9138, -0.4858, -1.3093)
SWEP.RunArmOffset 		= Vector (5.6468, 0, 3.7276)
SWEP.RunArmAngle 			= Vector (-13.4491, 16.4064, 0)

/*---------------------------------------------------------
   Name: SWEP:Precache()
   Desc: Use this function to precache stuff.
---------------------------------------------------------*/
function SWEP:Precache()

    	util.PrecacheSound("weapons/grenade_shoot.wav")
end

/*---------------------------------------------------------
   Name: SWEP:Grenade()
---------------------------------------------------------*/
SWEP.Force = 7500

function SWEP:Grenade()

	if (CLIENT) then return end

	local grenade = ents.Create ("ent_mad_dod_ger_launcher")
		grenade:SetOwner(self.Owner)

		if not (self.Weapon:GetNetworkedBool("Ironsights")) then
			local pos = self.Owner:GetShootPos()
				pos = pos + self.Owner:GetForward() * 5
				pos = pos + self.Owner:GetRight() * 9
				pos = pos + self.Owner:GetUp() * -8
			grenade:SetPos(pos)
			grenade:SetAngles(self.Owner:GetAngles() + Vector(70, 10, 0))
			grenade:Spawn()
			grenade:Activate()

			local phys = grenade:GetPhysicsObject()
			phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force + Vector(0, 0, 1000))
		else
			grenade:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector()))
			grenade:SetAngles(self.Owner:GetAngles() + Vector(90, 0, 0))
			grenade:Spawn()
			grenade:Activate()

			local phys = grenade:GetPhysicsObject()
			phys:ApplyForceCenter(self.Owner:GetAimVector() * self.Force + Vector(0, 0, 200))
		end
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
---------------------------------------------------------*/
function SWEP:Deploy()

	if (self.Weapon:Clip1() <= 0) and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:SetClip1(1)
		self.Owner:RemoveAmmo(1, self.Weapon:GetPrimaryAmmoType()) 
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 2)
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self:SetIronsights(false)
	return true
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack()
   Desc: +attack1 has been pressed.
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Holst/Deploy your fucking weapon
	if (self.Owner:KeyDown(IN_USE)) then
		bHolsted = !self.Weapon:GetNetworkedBool("Holsted", false)
		self:SetHolsted(bHolsted)

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)

		self:SetIronsights(false)

		return
	end

	if (not self:CanPrimaryAttack()) then return end

	self.ActionDelay = (CurTime() + self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK) 		// View model animation
	self.Owner:SetAnimation(PLAYER_ATTACK1)				// 3rd Person Animation

	self.Weapon:EmitSound(self.Primary.Sound)

	self:TakePrimaryAmmo(1)

	self:Grenade()

	self.Owner:ViewPunch(Vector(math.Rand(-5, -15), math.Rand(0, 0), math.Rand(0, 0)))	

	if ((SinglePlayer() and SERVER) or CLIENT) then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end

	local WeaponModel = self.Weapon:GetOwner():GetActiveWeapon():GetClass()

	if (self.Weapon:Clip1() < 1) then
		timer.Simple(self.Primary.Delay + 0.1, function() 
			if self.Owner and self.Owner:Alive() and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == WeaponModel then
				self:Reload() 
			end
		end)
	end
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
			self.Owner:SelectWeapon("weapon_mad_dod_k98")
		end

		return
	end

	if (!self.IronSightsPos) or (self.Owner:KeyDown(IN_SPEED) or self.Weapon:GetNetworkedBool("Holsted")) then return end
	
	// Not pressing Use + Right click? Ironsights
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.2)
end