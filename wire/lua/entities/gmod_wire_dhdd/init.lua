AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.WireDebugName = "Dupeable HDD"

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self.Outputs = WireLib.CreateOutputs( self, { "Memory [ARRAY]", "Size" } )
	self.Inputs = WireLib.CreateInputs( self, { "Data [ARRAY]", "Clear" } )

	self.Memory = {}

	self:SetOverlayText("DHDD")
end

-- Read cell
function ENT:ReadCell( Address )
	local data = self.Memory[Address or 1] or 0
	return (type(data) == "number") and data or 0
end

-- Write cell
function ENT:WriteCell( Address, value )
	self.Memory[Address] = value
	self:ShowOutputs()
	return true
end

function ENT:ShowOutputs()
	WireLib.TriggerOutput( self, "Memory", self.Memory )
	local n = #self.Memory
	WireLib.TriggerOutput( self, "Size", n )
	self:SetOverlayText("DHDD\nSize: " .. n )
end

function ENT:TriggerInput( name, value )
	if (name == "Data") then
		if (!value) then return end
		self.Memory = value
		self:ShowOutputs()
	elseif (name == "Clear") then
		self.Memory = {}
		self.MemSize = 0
		self:ShowOutputs()
	end
end

function ENT:BuildDupeInfo()
	local info = self.BaseClass.BuildDupeInfo( self ) or {}
	
	info.DHDD = {}
	local n = 0
	info.DHDD.Memory = {}
	for k,v in pairs( self.Memory ) do -- Only save the first 512^2 values
		n = n + 1
		if (n > 512*512) then break end
		info.DHDD.Memory[k] = v
	end
	
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	if (!ply:CheckLimit("wire_dhdds")) then 
		ent:Remove()
		return
	end
	ply:AddCount( "wire_dhdds", ent )
	
	if (info.DHDD) then
		ent.Memory = (info.DHDD.Memory or {})
		self:ShowOutputs()
	end
	
	ent:SetPlayer( ply )
	self.BaseClass.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
end