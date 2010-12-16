AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.WireDebugName = "GPS"

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	self.storedpositions = {};
	self.arrayindex = 0;
	
	self.Inputs = Wire_CreateInputs(self.Entity, { "Store/Save Pos", "Next", "Remove Save Position"})
	self.Outputs = WireLib.CreateSpecialOutputs( self.Entity, { "X", "Y", "Z", "Vector", "Recall X", "Recall Y", "Recall Z", "Recall Vector", "Current Memory"}, { "NORMAL", "NORMAL", "NORMAL", "VECTOR", "NORMAL", "NORMAL", "NORMAL", "VECTOR", "NORMAL"})
end

function ENT:Setup()
	self.Value = 0
	self.PrevOutput = nil

	//self:ShowOutput(0, 0, 0)
	Wire_TriggerOutput(self.Entity, "X", 0)
	Wire_TriggerOutput(self.Entity, "Y", 0)
	Wire_TriggerOutput(self.Entity, "Z", 0)
	Wire_TriggerOutput(self.Entity, "Vector", Vector(0,0,0))
	Wire_TriggerOutput(self.Entity, "Recall X", 0)
	Wire_TriggerOutput(self.Entity, "Recall Y", 0)
	Wire_TriggerOutput(self.Entity, "Recall Z", 0)
	Wire_TriggerOutput(self.Entity, "Recall Vector", Vector(0,0,0))
	Wire_TriggerOutput(self.Entity, "Current Memory", 0)
end

function ENT:Think()
	self.BaseClass.Think(self)

	local pos = self.Entity:GetPos()
	if (COLOSSAL_SANDBOX) then pos = pos * 6.25 end

	Wire_TriggerOutput(self.Entity, "X", pos.x)
	Wire_TriggerOutput(self.Entity, "Y", pos.y)
	Wire_TriggerOutput(self.Entity, "Z", pos.z)
	Wire_TriggerOutput(self.Entity, "Vector", pos)
	Wire_TriggerOutput(self.Entity, "Current Memory", self.arrayindex)
	if self.arrayindex > 0 then
		Wire_TriggerOutput(self.Entity, "Recall X", self.storedpositions[self.arrayindex].x)
		Wire_TriggerOutput(self.Entity, "Recall Y", self.storedpositions[self.arrayindex].y)
		Wire_TriggerOutput(self.Entity, "Recall Z", self.storedpositions[self.arrayindex].z)
		Wire_TriggerOutput(self.Entity, "Recall Vector", self.storedpositions[self.arrayindex])
	else
		Wire_TriggerOutput(self.Entity, "Recall X", 0)
		Wire_TriggerOutput(self.Entity, "Recall Y", 0)
		Wire_TriggerOutput(self.Entity, "Recall Z", 0)
		Wire_TriggerOutput(self.Entity, "Recall Vector", Vector(0,0,0))
	end
	
	self.Entity:NextThink(CurTime()+0.04)
	return true
end

function ENT:TriggerInput(iname, value)
	if (iname == "Store/Save Pos") then
		if (value ~= 0) then
			local curpos = self.Entity:GetPos()
			table.insert(self.storedpositions, curpos)
			self.arrayindex = self.arrayindex+1
		end
	elseif (iname == "Next") then
		if (value ~= 0) then
			if # self.storedpositions > 0 then
				if not (self.arrayindex >= # self.storedpositions) then
					self.arrayindex = self.arrayindex+1;
				else
					self.arrayindex = 1; --loop back
				end
			end
		end
	elseif (iname == "Remove Save Position") then
		if (value ~= 0) then
			if self.arrayindex ~= 0 then
				table.remove(self.storedpositions, self.arrayindex)
			end
			if (self.arrayindex == 1) and (# self.storedpositions == 0) then
				self.arrayindex = 0
			end
			if (self.arrayindex == (# self.storedpositions+1)) then
				self.arrayindex = self.arrayindex-1
			end
		end
	end
end
