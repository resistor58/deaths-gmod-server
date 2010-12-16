AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.sModel = "models/t-rex.mdl"
ENT.fMeleeDistance	= 100
ENT.possOffset = Vector(0,0,180)

ENT.bPlayDeathSequence = true

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/t-rex/"

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_BIG_FLINCH
}

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIEVIOLENT
}
ENT.DeathActChance = 72

ENT.tblSourceSounds = {}
ENT.tblSourceSounds["Alert"] = "roar[1-4].wav"
ENT.tblSourceSounds["FlareTrance"] = "flare_trance.wav"
ENT.tblSourceSounds["Angry"] = "angry[1-2].wav"
ENT.tblSourceSounds["Death"] = "die.wav"
ENT.tblSourceSounds["Pain"] = "pain1.wav"
ENT.tblSourceSounds["Search"] = "search.wav"
ENT.tblSourceSounds["Squeeze"] = "squeeze.wav"
ENT.tblSourceSounds["Eat"] = "eat.wav"
ENT.tblSourceSounds["Cautious"] = "idle[1-4].wav"
ENT.tblSourceSounds["Foot"] = "step[1-2].wav"

ENT.tblAlertAct = {ACT_IDLE_ANGRY}
ENT.iAlertRandom = 1

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	
	self:SetCollisionBounds(Vector(120, 120, 140), Vector(-120, -120, 0))
	
	self:CapabilitiesAdd(CAP_MOVE_GROUND | CAP_OPEN_DOORS)

	self:SetHealth(GetConVarNumber("sk_trex_health"))
	self:SetSoundLevel(100)
	self.lastSqueeze = 0
	self.nextThrow = 0
	self:SetState(NPC_STATE_ALERT)
	self.flaresIgnore = {}
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	local bFlareValid = ValidEntity(self.entFlare)
	if self.bFlareSchd then
		local dist = bFlareValid && self:OBBDistance(self.entFlare)
		if !bFlareValid || dist >= 200 then
			self.entFlare = nil
			self.bFlareSchd = nil
			self:CancelCurrentSchedule()
		end
	end
	if self.CurrentSchedule && ValidEntity(self.CurrentSchedule.entFace) then
		self:TurnToTarget(self.CurrentSchedule.entFace)
	end
	if !bFlareValid then
		local dist = math.huge
		local distEnemy = ValidEntity(self.entEnemy) && self:OBBDistance(self.entEnemy) -50 || dist
		for _, ent in pairs(ents.FindByClass("obj_flare")) do
			if !table.HasValue(self.flaresIgnore, ent) && ent:GetVelocity():Length() >= 10 && self:EntInViewCone(ent, self.fViewAngle) then
				local distTgt = self:OBBDistance(ent)
				if ValidEntity(ent) && distTgt < dist && (!ValidEntity(entTgt) || distTgt < distEnemy) && ent.tmIgnition && CurTime() -ent.tmIgnition <= 30 then
					self.entFlare = ent
					dist = distTgt
				end
			end
		end
		if ValidEntity(self.entFlare) then
			local name = self:GetScheduleName()
			if name == "Wnd" || name == "Wnd_NG" then
				self:CancelCurrentSchedule()
			end
		end
	end
	local pp_yaw = self:GetPoseParameter("aim_yaw")
	local pp_pitch = self:GetPoseParameter("aim_pitch")
	local yaw = 0
	local pitch = 0
	local entTgt = self.entFlare || self.entEnemy
	if ValidEntity(entTgt) && (!entTgt:IsPlayer() || entTgt:Health() > 0) then
		local mem = self:GetMemory()
		if !entTgt:IsPlayer() || mem[entTgt].ignoreUntilMove then
			local fDist
			local posCenterTgt
			if entTgt != self.entEnemy then fDist = self:OBBDistance(entTgt); posCenterTgt = entTgt:GetPos() +entTgt:OBBCenter()
			else posTgt = mem[entTgt].lastPos || entTgt:GetPos(); posCenterTgt = posTgt end
			local bPos = self:GetCenter()

			local _ang = self:GetAngles()
			local ang = _ang -(posCenterTgt -bPos):Angle()
			yaw = math.Clamp(math.NormalizeAngle(ang.y) *-1, -30, 30)
			
			_ang = self:GetAngles()
			ang = (posCenterTgt -bPos):Angle() -_ang
			pitch = math.Clamp(pp_pitch +math.NormalizeAngle(ang.p), -15, 10)
		end
	end
	
	pp_yaw = math.ApproachAngle(pp_yaw, yaw, 2)
	self:SetPoseParameter("aim_yaw", pp_yaw)
	
	pp_pitch = math.ApproachAngle(pp_pitch, pitch, 2)
	self:SetPoseParameter("aim_pitch", pp_pitch)
	
	if ValidEntity(self.tgtRagdoll) then
		local att = self:GetAttachment(self:LookupAttachment("mouth"))
		local ragdoll = self.tgtRagdoll
		local bone = ragdoll:GetPhysicsObjectNum(ragdoll:LookupBone("Bip01"))
		if ValidEntity(bone) then
			bone:SetPos(att.Pos)
			bone:SetAngle(att.Ang)
		end
		for i = 0,ragdoll:GetPhysicsObjectCount() -1 do
			local bone = ragdoll:GetPhysicsObjectNum(i)
			if ValidEntity(bone) then
				bone:SetVelocity(Vector(0,0,0))
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnPrimaryTargetChanged(ent)
	local mem = self:GetMemory()
	if mem[ent] then
		mem[ent].ignoreUntilMove = true
		mem[ent].lastMovement = CurTime()
		mem[ent].lastPos = ent:GetPos()
		self.iMemCount = self.iMemCount -1
		if self.iMemCount == 0 then
			self:SetState(NPC_STATE_IDLE)
			self:OnAreaCleared()
			self.tblMemBlockedNodeLinks = {}
			self:TaskComplete()
		end
	end
end

function ENT:OnStateChanged(old, new)
	if new == NPC_STATE_LOST then self:PlayActivity(ACT_COWER)
	elseif new == NPC_STATE_IDLE then self:SetState(NPC_STATE_ALERT) end
end

function ENT:OnCondition(iCondition)
	if self.bDead then return end
	local iNPCState = self:GetState()
	if iNPCState == NPC_STATE_DEAD then return end
	if iNPCState != NPC_STATE_COMBAT && (iCondition == COND_SEE_HATE || iCondition == COND_SEE_FEAR) && table.Count(self:GetMemory()) == 0 then --|| #self.tblMemory > 0) then TODO: CHEATING BEHAVIOR?
		if iNPCState != NPC_STATE_LOST then
			self:PlaySound("Alert")
			if !self:IsPossessed() && #self.tblAlertAct > 0 then
				if math.random(1,self.iAlertRandom) < 3 then
					self:PlayActivity(self.tblAlertAct[math.random(1,#self.tblAlertAct)], true)
					self:OnPlayAlert()
				end
			end
		end
		self:SetState(NPC_STATE_COMBAT)
		return
	end
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_MELEE_ATTACK1,false,fcDone)
end

function ENT:_PossSecondaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RELOAD,false,fcDone)
end

function ENT:_PossReload(entPossessor, fcDone)
	self:PlayActivity(ACT_SPECIAL_ATTACK1,false,fcDone)
end

local function CreateRagdoll(ent)
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(ent:GetModel())
	for i = 1, 3 do ragdoll:SetBodygroup(i, ent:GetBodygroup(i)) end
	ragdoll:SetPos(ent:GetPos())
	ragdoll:SetAngles(ent:GetAngles())
	ragdoll:Spawn()
	
	local entVel
	local entPhys = ent:GetPhysicsObject()
	if entPhys:IsValid() then entVel = entPhys:GetVelocity()
	else entVel = ent:GetVelocity() end

	for i=0,ragdoll:GetPhysicsObjectCount() -1 do
		local bone = ragdoll:GetPhysicsObjectNum(i)
		if ValidEntity(bone) then
			local bonepos, boneang = ent:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
			
			bone:SetPos(bonepos)
			bone:SetAngle(boneang)
			
			bone:AddVelocity(entVel)
		end
	end
	ragdoll:SetSkin(ent:GetSkin())
	ragdoll:SetColor(ent:GetColor())
	ragdoll:SetMaterial(ent:GetMaterial())
	if ent:IsOnFire() then ragdoll:Ignite(math.Rand(8, 10), 0) end
	ragdoll:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	return ragdoll
end

function ENT:EventHandle(sEvent)
	if string.find(sEvent,"foot") then
		util.ScreenShake(self:GetPos(), 85, 85, 0.4, 1000)
		self:EmitSound(self.sSoundDir .. "step" .. math.random(1,2) .. ".wav", 150, 100)
		return
	end
	if string.find(sEvent,"mattack") then
		local fDist = self.fMeleeDistance +12
		local dmg
		local viewPunch
		if string.find(sEvent, "bite") then
			dmg = GetConVarNumber("sk_trex_dmg_bite")
			viewPunch = string.find(sEvent, "biteA") && Angle(-30,0,0) || Angle(-15,30,-3)
		elseif string.find(sEvent, "swipe") then
			dmg = GetConVarNumber("sk_trex_dmg_swipe")
			viewPunch = Angle(-4,-36,3)
			self:DoMeleeDamage(fDist,dmg,viewPunch,nil,function(ent)
				ent:SetVelocity(self:GetRight() *-250 +self:GetForward() *10 +Vector(0,0,300))
			end)
			return
		elseif string.find(sEvent, "headbutt") then
			dmg = GetConVarNumber("sk_trex_dmg_headbutt")
			viewPunch = Angle(-48,0,0)
			self:DoMeleeDamage(fDist,dmg,viewPunch,nil,function(ent)
				ent:SetVelocity(self:GetForward() *250 +Vector(0,0,320))
			end)
			for k, v in pairs(ents.FindInSphere(self:GetMeleePos(), 150)) do
				if v:IsPhysicsEntity() && self:Visible(v) then
					local phys = v:GetPhysicsObject()
					if phys:IsMoveable() then
						local posEnt = v:GetPos()
						local angToEnt = self:GetAngleToPos(posEnt).y
						if (angToEnt <= 70 && angToEnt >= 0) || (angToEnt <= 360 && angToEnt >= 290) then
							v:SetPhysicsAttacker(self)
							phys:ApplyForceCenter((self:GetForward() *900000 +self:GetUp() *90000))
							phys:AddAngleVelocity(Angle(0,600,0))
						end
					end
				end
			end
			return
		elseif string.find(sEvent, "stomp") then
			viewPunch = Angle(42,0,0)
			fDist = fDist -30
			dmg = GetConVarNumber("sk_trex_dmg_stomp")
		else
			local posDmg = self:GetMeleePos()
			local posSelf = self:GetPos()
			local posSelfCenter = posSelf +self:OBBCenter()
			for _, ent in pairs(ents.FindInSphere(posDmg,fDist)) do
				if ValidEntity(ent) && self:IsEnemy(ent) && self:Visible(ent) && ent:Health() > 0 && self:CanEat(ent) then
					local posEnemy = ent:GetPos()
					local angToEnemy = self:GetAngleToPos(posEnemy).y
					if (angToEnemy <= 70 && angToEnemy >= 0) || (angToEnemy <= 360 && angToEnemy >= 290) then
						local dmg = GetConVarNumber("sk_trex_dmg_eat")
						local posDmg = ent:NearestPoint(posSelfCenter)
						local dmgInfo = DamageInfo()
						dmgInfo:SetDamage(dmg)
						dmgInfo:SetAttacker(self)
						dmgInfo:SetInflictor(self)
						dmgInfo:SetDamageType(DMG_SLASH)
						dmgInfo:SetDamagePosition(posDmg)
						ent:TakeDamageInfo(dmgInfo)
						if ent:Health() <= 0 then
							local ragdoll = CreateRagdoll(ent)
							self.tgtBloodCol = ent.iBloodType || ent:GetBloodColor()
							self.tgtRagdoll = ragdoll
							
							ragdoll:NoCollide(self)
							self:DeleteOnDeath(ragdoll)
							if !ent:IsPlayer() then ent:Remove()
							else
								local plRagdoll = ent:GetRagdollEntity()
								if ValidEntity(plRagdoll) then plRagdoll:Remove() end
								ent:Spectate(OBS_MODE_CHASE)
								ent:SpectateEntity(ragdoll)
							end
						end
						break
					end
				end
			end
			return
		end
		self:DoMeleeDamage(fDist,dmg,viewPunch)
		return
	end
	if string.find(sEvent, "munch") then
		local ragdoll = self.tgtRagdoll
		if !ValidEntity(ragdoll) then return end
		local i = 0
		local col = self.tgtBloodCol
		local particle
		if col == BLOOD_COLOR_RED then particle = "blood_impact_red_01"
		elseif col == BLOOD_COLOR_YELLOW || col == BLOOD_COLOR_ANTLION || col == BLOOD_COLOR_ANTLION_WORKER then particle = "blood_impact_yellow_01"
		elseif col == BLOOD_COLOR_GREEN || col == BLOOD_COLOR_ZOMBIE then particle = "blood_impact_green_01"
		elseif col == BLOOD_COLOR_BLUE then particle = "blood_impact_blue_01"
		elseif col == BLOOD_COLOR_MECH then particle = "impact_metal" end
		if particle then
			for i = 0,ragdoll:GetPhysicsObjectCount() -1 do
				local bone = ragdoll:GetPhysicsObjectNum(i)
				if ValidEntity(bone) then
					local bonepos, boneang = bone:GetPos(), bone:GetAngles()
					ParticleEffect(particle, bonepos, boneang, self)
				end
			end
		end
		self.tgtRagdoll:Remove()
		self.tgtBloodCol = nil
		self.tgtRagdoll = nil
		local att = self:GetAttachment(self:LookupAttachment("mouth"))
		WorldSound(self.sSoundDir .. "gooification01.wav", att.Pos, 80, 100)
		return
	end
end

function ENT:Interrupt()
	self.bFlareSchd = nil
	if ValidEntity(self.tgtRagdoll) then self.tgtRagdoll:Remove(); self.tgtRagdoll = nil; self.tgtBloodCol = nil end
	if self.actReset then self:SetMovementActivity(self.actReset); self.actReset = nil end
	if self:IsPossessed() then self:_PossScheduleDone() end
	self.bInSchedule = false
end

function ENT:GetCenterBone(ent)
	return ent:LookupBone("Bip01") || ent:LookupBone("ValveBiped.Bip01_Pelvis")
end

function ENT:CanEat(ent)
	if !util.IsValidRagdoll(ent:GetModel()) || !self:GetCenterBone(ent) then return false end
	if ent:IsPlayer() then return true end
	local hull = ent:GetHullType()
	return hull != HULL_LARGE && hull != HULL_LARGE_CENTERED
end

function ENT:UpdateLastEnemyPositions()
	local mem = self:GetMemory()
	for ent, data in pairs(mem) do
		if ValidEntity(ent) then
			local vel = ent:GetVelocity()
			local bVisible = self:Visible(ent) && self:EntInViewCone(ent, self.fViewAngle) && (!ent:IsPlayer() || vel:Length() >= 10)
			if bVisible then
				if ent == self.entEnemy then self.moveEnemyStart = nil end
				local pos = ent:GetPos()
				local posLast = mem[ent].lastPos || pos
				local dist = pos:Distance(posLast)
				if dist > 0.2 then
					if mem[ent].ignoreUntilMove then
						mem[ent].ignoreUntilMove = nil
						self.iMemCount = self.iMemCount +1
						self:SetState(NPC_STATE_COMBAT)
						local name = self:GetScheduleName()
						if name == "Wnd" || name == "Wnd_NG" || name == "Act" .. ACT_IDLE_AIM_AGITATED then
							self:CancelCurrentSchedule()
						end
					elseif self:GetScheduleName() == "Act" .. ACT_COWER then self:CancelCurrentSchedule() end
				end
				mem[ent].lastMovement = dist <= 0.2 && mem[ent].lastMovement || CurTime()
				mem[ent].lost = mem[ent].ignoreUntilMove || false
				mem[ent].lastDir = (vel:Length() > 0 || !mem[ent].lastPos || mem[ent].lastPos:Length() == 0) && vel:GetNormal() || (pos -mem[ent].lastPos):GetNormal()
				mem[ent].lastPos = pos
			end
			mem[ent].visible = bVisible
		end
	end
end

function ENT:UpdateEnemies()
	local num = self.iMemCount
	if self.entEnemy && (!ValidEntity(self.entEnemy) || self.entEnemy:Health() <= 0 || self.entEnemy:GetNoTarget() || (self:GetAIType() == 5 && self.entEnemy:WaterLevel() < 2) || (self.entEnemy:IsPlayer() && (tobool(GetConVarNumber("ai_ignoreplayers")) || self.entEnemy:IsPossessing())) || self.entEnemy.bSelfDestruct) then self:RemoveFromMemory(self.entEnemy) end
	self:UpdateMemory()
	self:GetEnemies()
	local fDistClosest = self.fViewDistance
	local posSelf = self:GetPos()
	local enemyLast = self.entEnemy
	local mem = self:GetMemory()
	if mem[self.entEnemy] && mem[self.entEnemy].ignoreUntilMove then self.entEnemy = nil end
	for ent, data in pairs(mem) do
		if !data.ignoreUntilMove then
			local posEnemy = ent:GetPos()
			local fDist = posSelf:Distance(posEnemy)
			if fDist < fDistClosest then
				self.entEnemy = ent
				fDistClosest = fDist
			end
		end
	end
	if self.entEnemy != enemyLast then self:OnPrimaryTargetChanged(self.entEnemy) end
	
	if self.sSquad && self.tblSquadMembers && self.iMemCount > 0 then
		for _, ent in pairs(self.tblSquadMembers) do
			if !ValidEntity(ent) then self.tblSquadMembers[_] = nil
			else ent:MergeMemory(mem) end
		end
		table.refresh(self.tblSquadMembers)
	end
	if num == 0 && self.iMemCount > 0 then self:OnFoundEnemy(self.iMemCount); return
	elseif num > 0 && self.iMemCount == 0 then self:SetState(NPC_STATE_IDLE); self:OnAreaCleared(); self.tblMemBlockedNodeLinks = {} end
	return mem
end

function ENT:HearEnemy()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.fHearDistance)) do
		if self:IsEnemy(v) then
			local mem = self:GetMemory()
			return (!mem[v] || !mem[v].ignoreUntilMove) && true || false
		end
	end
	return false
end

function ENT:DamageHandle(dmginfo)
	local attacker = dmginfo:GetAttacker()
	local mem = self:GetMemory()
	if mem[attacker] then
		if mem[attacker].lastMovement && CurTime() -mem[attacker].lastMovement >= 3 then
			self:CancelCurrentSchedule()
			self:Flinch(HITBOX_GENERIC)
		end
		local pos = attacker:GetPos()
		local vel = attacker:GetVelocity()
		mem[attacker].lastMovement = CurTime()
		mem[attacker].ignoreUntilMove = nil
		mem[attacker].lost = false
		mem[attacker].lastDir = (vel:Length() > 0 || !mem[attacker].lastPos || mem[attacker].lastPos:Length() == 0) && vel:GetNormal() || (pos -mem[attacker].lastPos):GetNormal()
		mem[attacker].lastPos = pos
		self.iMemCount = self.iMemCount +1
		self:SetState(NPC_STATE_COMBAT)
	end
	if ValidEntity(self.entFlare) then
		table.insert(self.flaresIgnore, self.entFlare)
		self.entFlare = nil
		if self.bFlareSchd then
			self.bFlareSchd = nil
			self:CancelCurrentSchedule()
			self:Flinch(HITBOX_GENERIC)
		end
	end
end

function ENT:OnScheduleSelection()
	if ValidEntity(self.entFlare) then
		if !self.entFlare.tmIgnition || CurTime() -self.entFlare.tmIgnition > 30 then self.entFlare = nil
		else
			if self:OBBDistance(self.entFlare) <= 160 then
				local vel = self.entFlare:GetVelocity():Length()
				if vel <= 40 then
					self:PlayActivity(ACT_IDLE_AIM_AGITATED, nil, function()
						table.insert(self.flaresIgnore, self.entFlare)
						self.entFlare = nil
						self:TaskComplete()
					end)
					self.CurrentSchedule.entFace = self.entFlare
					self.bFlareSchd = true
					for _, ent in pairs(self.flaresIgnore) do if !ValidEntity(ent) then self.flaresIgnore[_] = nil end end
					return true
				end
			end
			self:ChaseTarget(self.entFlare)
			return true
		end
	end
end

function ENT:CanPunt(ent)
	if !ent:IsPhysicsEntity() || !self:Visible(ent) then return false end
	local phys = ent:GetPhysicsObject()
	if !phys:IsMoveable() || phys:GetMass() <= 1000 then return false end
	return true
end

local schdRunToLastPosition = ai_schedule.New("Chase Enemy")
schdRunToLastPosition:EngTask("TASK_GET_PATH_TO_LASTPOSITION")
schdRunToLastPosition:EngTask("TASK_WAIT", 0.2)
function ENT:SelectScheduleHandle(fDist,fDistPredicted,iDisposition)
	if iDisposition == 1 then
		if self:HasCondition(COND_TASK_FAILED) && !self:Visible(self.entEnemy) && CurTime() -self.lastSqueeze >= 8 then self:PlayActivity(ACT_CROUCHIDLE_AGITATED, true); self.lastSqueeze = CurTime(); return end
		local mem = self:GetMemory()
		local bLostEnemy = mem[self.entEnemy].lastMovement && CurTime() -mem[self.entEnemy].lastMovement >= 3
		if !bLostEnemy then
			if (fDist <= self.fMeleeDistance || fDistPredicted <= self.fMeleeDistance) && self:CanSee(self.entEnemy) then
				local health = self.entEnemy:Health()
				local rand = math.random(1,5)
				local act
				if rand <= 2 then
					local dmgMunch = GetConVarNumber("sk_trex_dmg_eat")
					if health -dmgMunch <= 0 && rand == 1 && self:CanEat(self.entEnemy) then
						act = ACT_RELOAD
					elseif fDist <= 60 then
						local dmgStomp = GetConVarNumber("sk_trex_dmg_stomp")
						if health -dmgStomp <= 0 then
							act = ACT_SPECIAL_ATTACK1
						end
					end
				end
				self:PlayActivity(act || ACT_MELEE_ATTACK1, true)
				return
			end
			if self:Visible(self.entEnemy) then
				local bCanThrow = CurTime() >= self.nextThrow
				local entTarget
				if !bCanThrow && !self.bDontThrow then
					for k, ent in pairs(ents.FindInSphere(self:GetMeleePos(),400)) do
						if self:CanPunt(ent) && self:EntInViewCone(ent, 45) then
							bCanThrow = true
							entTarget = ent
						end
					end
				end
				if bCanThrow then
					self.bDontThrow = nil
					if !ValidEntity(entTarget) then
						local mass = 120
						for k, ent in pairs(ents.FindInSphere(self:GetPos(), 1000)) do
							if ent:IsPhysicsEntity() && self:Visible(ent) then
								local phys = ent:GetPhysicsObject()
								if phys:IsMoveable() then
									local _mass = phys:GetMass()
									if _mass > mass && _mass <= 1000 then
										entTarget = ent
										mass =_mass
									end
								end
							end
						end
					end
					if ValidEntity(entTarget) then
						local tblFilter = ents.GetAll()
						for k, v in pairs(tblFilter) do
							if v == entTarget then table.remove(tblFilter, k); break end
						end
						local posEnt = entTarget:GetPos() +entTarget:OBBCenter()
						local pos = util.TraceLine({start = posEnt -(self.entEnemy:GetPos() -posEnt):GetNormal() *(entTarget:BoundingRadius() +10), endpos = posEnt, filter = tblFilter}).HitPos
						pos = pos -(posEnt -pos):GetNormal() *(self:OBBMaxs().y +30)
						if self:NearestPoint(pos):Distance(pos) <= 30 then
							self:PlayActivity(ACT_SPECIAL_ATTACK2, true)
							self.nextThrow = CurTime() +math.Rand(6,10)
							self.chaseObjectStop = nil
							return
						end
						self:SetLastPosition(pos)
						self:StartSchedule(schdRunToLastPosition)
						self.chaseObjectStop = self.chaseObjectStop || CurTime() +5
						if !self:HasCondition(35) && CurTime() < self.chaseObjectStop then return end
						self:ClearCondition(35)
						self.nextThrow = CurTime() +math.Rand(10,18)
						self.bDontThrow = true
						self.chaseObjectStop = nil
					end
				end
			end
		else
			if mem[self.entEnemy] && mem[self.entEnemy].lastPos then
				local pos = mem[self.entEnemy].lastPos
				local dist = self:NearestPoint(pos):Distance(pos)
				local distB = self:OBBDistance(self.entEnemy)
				dist = dist < distB && dist || distB
				if !mem[self.entEnemy].ignoreUntilMove && dist <= 160 then
					mem[self.entEnemy].ignoreUntilMove = true
					self.iMemCount = self.iMemCount -1
					if self.iMemCount == 0 then
						self:PlayActivity(ACT_COWER, nil, function()
							self:SetState(NPC_STATE_IDLE)
							self:OnAreaCleared()
							self.tblMemBlockedNodeLinks = {}
							self:TaskComplete()
						end)
					end
					return
				end
				self:MoveToPos(pos, false, true)
				return
			end
		end
		self:ChaseEnemy()
	elseif iDisposition == 2 then
		self:Hide()
	end
end
