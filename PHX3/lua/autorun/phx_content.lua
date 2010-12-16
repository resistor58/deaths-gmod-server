--[Phoenix Storms SVN - Content by Lua
--[This file takes care of all PHX content.
--[Created by 1/4 Life.

include("phx/phx_materials.lua")
include("phx/phx_models.lua")
include("phx/phx_sounds.lua")
include("phx/phx_vehicles.lua")

//Server Tags (Special thanks to TheLinxV3)
local servertags = GetConVarString("sv_tags")

if servertags == nil then
	RunConsoleCommand("sv_tags", "phxsvn")
elseif not string.find(servertags, "phxsvn") then
	RunConsoleCommand("sv_tags", servertags .. ",phxsvn")
end
