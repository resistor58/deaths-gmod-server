
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

include('shared.lua')

--handle overlay text client side instead (TAD2020)
function ENT:Think()
	self.BaseClass.Think(self)

    local ang = self.Entity:GetAngles()
	if (ang.p < 0 && !self:GetOut180()) then ang.p = ang.p + 360 end
	if (ang.y < 0 && !self:GetOut180()) then ang.y = ang.y + 360 end
	if (ang.r < 0 && !self:GetOut180()) then ang.r = ang.r + 360
	elseif (ang.r > 180 && self:GetOut180()) then ang.r = ang.r - 360 end
	self:ShowOutput(ang.p, ang.y, ang.r)

	self.Entity:NextThink(CurTime()+0.04)
	return true
end

function ENT:ShowOutput(p, y, r)
	--self.Entity:SetNetworkedString( "GModOverlayText", "Angles = " .. math.Round(p*1000)/1000 .. "," .. math.Round(y*1000)/1000 .. "," .. math.Round(r*1000)/1000 )
	self.Entity:SetNetworkedBeamString( "GModOverlayText", "Angles = " .. math.Round(p*1000)/1000 .. "," .. math.Round(y*1000)/1000 .. "," .. math.Round(r*1000)/1000 )
	//self.BaseClass.BaseClass.SetOverlayText(self, "Angles = " .. math.Round(p*1000)/1000 .. "," .. math.Round(y*1000)/1000 .. "," .. math.Round(r*1000)/1000 )
	--self:SetOverlayText(self, "Angles = " .. math.Round(p*1000)/1000 .. "," .. math.Round(y*1000)/1000 .. "," .. math.Round(r*1000)/1000 )
	--self.Txt = "Angles = " .. math.Round(p*1000)/1000 .. "," .. math.Round(y*1000)/1000 .. "," .. math.Round(r*1000)/1000
end
