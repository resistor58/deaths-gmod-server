if !SLVBase then
	include("autorun/slvbase_sh_init.lua")
	if !SLVBase then return end
end
local addon = "T[-]Rex"
if SLVBase.AddonInitialized(addon) then return end
local addonDat = {tag = "TRex"}
SLVBase.AddDerivedAddon(addon, addonDat)
SLVBase.InitLua("trex_init")

local function AddToList(Category, Name, Class, KeyValues, fOffset, bOnCeiling, bOnFloor)
	list.Set("NPC", Class, {Name = Name, Class = Class, Category = Category, Offset = fOffset, KeyValues = KeyValues, OnCeiling = bOnCeiling, OnFloor = bOnFloor})
end

local Category = "Animals"
AddToList(Category, "T-Rex", "npc_trex")

hook.Add("InitPostEntity", "TREX_PrecacheModels", function()
	local models = {}
	local function AddDir(path)
		for k, v in pairs(file.Find("../" .. path .. "*")) do
			if string.find(v, ".mdl") then
				table.insert(models, path .. v)
			end
		end
	end
	
	local function AddFile(file)
		table.insert(models, file)
	end
	AddFile("models/t-rex.mdl")
	
	for k, v in pairs(models) do
		util.PrecacheModel(v)
	end
	hook.Remove("InitPostEntity", "TREX_PrecacheModels")
end)
