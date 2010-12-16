include('shared.lua')

	
	local matTargetLight = Material("sprites/glow03")
		matTargetLight:SetMaterialInt("$spriterendermode",9)
		matTargetLight:SetMaterialInt("$illumfactor",8)
		matTargetLight:SetMaterialInt("$nocull",0)

function SWEP:Think()

	if self.Owner:KeyDown(IN_ATTACK) then
		local trace = self.Owner:GetEyeTrace()
		local laserpos = trace.HitPos + trace.HitNormal*32
		render.SetMaterial(matTargetLight)
		render.DrawSprite(laserpos,32,32,Color(255,20,20,230))
	end

end
