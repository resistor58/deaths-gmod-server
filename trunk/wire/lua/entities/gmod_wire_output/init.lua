
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.WireDebugName = "Output"

local keylist = {"0","1","2","3","4","5","6","7","8","9",".","Enter","+","-","*","/"}

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self:SetOn( false )

	self.Inputs = Wire_CreateInputs(self.Entity, { "A" })
end


function ENT:TriggerInput(iname, value)
	if (iname == "A") then
		if ((value > 0) ~= self:IsOn()) then
			self:Switch(not self:IsOn(), self:GetPlayer())
		end
	end
end


function ENT:Switch( on, ply )
	local plyindex 	= self:GetPlayerIndex()
	local key 		= self:GetKey()
	
	if (not key) then return end
	
	if (on) then
		numpad.Activate( ply, _, {key}, plyindex )
	else
		numpad.Deactivate( ply, _, {key}, plyindex )
	end

	self:SetOn(on)
end

function ENT:ShowOutput()
	if (self.key) then
		if (keylist[self.key + 1]) then
			self:SetOverlayText("Numpad Output ("..keylist[self.key + 1]..")")
		end
	end
end

function ENT:SetKey( key )
	self.Key = key
	self:ShowOutput()
end

function ENT:GetKey()
	return self.Key
end

function ENT:SetOn( on )
	self.On = on
end

function ENT:IsOn()
	return self.On
end
