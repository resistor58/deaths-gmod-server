SWEP.HoldType = "pistol"
if SERVER then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")

	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = false 
	SWEP.NPCFireRate = 0.75
	SWEP.AutomaticFrameAdvance = true

	SWEP.tblSounds = {}
	SWEP.tblSounds["Primary"] = "weapons/flaregun/fire.wav"
	SWEP.tblSounds["ReloadB"] = "weapons/flaregun/reload.wav"
end

SWEP.Base = "weapon_slv_base"
SWEP.Category		= "Other"

SWEP.Spawnable = SERVER || SLVBase_IsInstalledOnServer
SWEP.AdminSpawnable = SERVER || SLVBase_IsInstalledOnServer

SWEP.EmptySound = false
SWEP.InWater = false

SWEP.ViewModel = "models/weapons/v_flaregun.mdl"
SWEP.WorldModel = "models/weapons/w_flaregun.mdl"

SWEP.Primary.Delay = 2

SWEP.Primary.Recoil = 2.5
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.AmmoSize = 20
SWEP.Primary.AmmoPickup	= 5
SWEP.Primary.SingleClip = false

SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.ReloadDelay = 1

function SWEP:GetAmmoPrimary()
	return 1
end

function SWEP:PrimaryAttack(ShootPos, ShootDir)
	self.Weapon:SetNextSecondaryFire(CurTime() +self.Primary.Delay)
	self.Weapon:SetNextPrimaryFire(CurTime() +self.Primary.Delay)
	
	if !self:CanPrimaryAttack() then self:Reload(); return end
	if SERVER then
		self:PlaySound("Primary")
		local ang = self.Owner:GetAimVector():Angle()
		local pos = self.Owner:GetShootPos() +ang:Forward() *40 +ang:Right() *7 +ang:Up() *-4
		local entFlare = ents.Create("env_flare")
		entFlare:SetKeyValue("spawnflags", "4")
		entFlare:SetKeyValue("scale", "2")
		entFlare:SetKeyValue("classname", "obj_flare")
		entFlare:SetPos(pos)
		entFlare:SetAngles(ang)
		entFlare:Spawn()
		entFlare:Activate()
		entFlare:Fire("launch", "2000", 0)
		entFlare.tmIgnition = CurTime()
		local cspFlare = CreateSound(entFlare, "weapons/flaregun/burn.wav")
		cspFlare:Play()
		entFlare:CallOnRemove("stopBurnSound", function()
			cspFlare:Stop()
		end)
		timer.Simple(30, function()
			if ValidEntity(entFlare) then entFlare:Fire("Die", "", 0); cspFlare:Stop() end
		end)
		self:AddClip1(-1)
	end
	self.bReloadOnNextIdle = true
	self.Owner:MuzzleFlash()
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:NextIdle(self:SequenceDuration())
	self:PlayThirdPersonAnim()
end

function SWEP:SecondaryAttack(ShootPos, ShootDir)
end
