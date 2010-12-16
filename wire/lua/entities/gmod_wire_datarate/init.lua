AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.WireDebugName = "DataTransfer"
ENT.OverlayDelay = 0

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	self.Outputs = Wire_CreateOutputs(self.Entity, {"Output","HiSpeed_DataRate","Wire_DataRate"})
	self.Inputs = Wire_CreateInputs(self.Entity,{"Input","Smooth", "Interval"})

	self.Memory = nil
	self.Smooth = 0.5
	self.Interval = 0.25

	self.WDataRate = 0
	self.WDataBytes = 0
	self.HDataRate = 0
	self.HDataBytes = 0

	self:SetOverlayText("Data transferrer\nHi-Speed data rate: 0 bps\nWire data rate: 0 bps")
end

function ENT:Think()
	self.BaseClass.Think(self)

	self.WDataRate = (self.WDataRate*(2-self.Smooth) + self.WDataBytes * (1/self.Interval) * (self.Smooth)) / 2
	self.WDataBytes = 0

	self.HDataRate = (self.HDataRate*(2-self.Smooth) + self.HDataBytes * (1/self.Interval) * (self.Smooth)) / 2
	self.HDataBytes = 0

	Wire_TriggerOutput(self.Entity, "HiSpeed_DataRate", self.HDataRate)
	Wire_TriggerOutput(self.Entity, "Wire_DataRate", self.WDataRate)

	self:SetOverlayText("Data transferrer\nHi-Speed data rate: "..math.floor(self.HDataRate).." bps\nWire data rate: "..math.floor(self.WDataRate).." bps")
	self.Entity:NextThink(CurTime()+self.Interval)

	return true
end

function ENT:ReadCell( Address )
	if (self.Memory) then
		if (self.Memory.LatchStore && self.Memory.LatchStore[math.floor(Address)]) then
			self.HDataBytes = self.HDataBytes + 1
			return self.Memory.LatchStore[math.floor(Address)]
		elseif (self.Memory.ReadCell) then
			self.HDataBytes = self.HDataBytes + 1
			local val = self.Memory:ReadCell(Address)
			if (val) then return val
			else return 0 end
		end
	end
	return nil
end

function ENT:WriteCell( Address, value )
	if (self.Memory) then
		if (self.Memory.LatchStore && self.Memory.LatchStore[math.floor(Address)]) then
			self.Memory.LatchStore[math.floor(Address)] = value
			self.HDataBytes = self.HDataBytes + 1
			return true
		elseif (self.Memory.WriteCell) then
			local res = self.Memory:WriteCell(Address, value)
			self.HDataBytes = self.HDataBytes + 1
			return res
		end
	end
	return false
end

function ENT:TriggerInput(iname, value)
	if (iname == "Input") then
		self.Memory = self.Inputs.Input.Src
		self.WDataBytes = self.WDataBytes + 1
		Wire_TriggerOutput(self.Entity, "Output", value)
	elseif (iname == "Smooth") then
		self.Smooth = 2*(1-math.Clamp(value,0,1))
	elseif (iname == "Interval") then
		self.Interval = math.Clamp(value,0.1,2)	
	end
end
