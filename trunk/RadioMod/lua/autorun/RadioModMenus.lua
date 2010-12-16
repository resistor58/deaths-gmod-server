---This is a modifyed version of the lua file in WIRE that creates the WIRE tab.
---I don't take any credit for this code
---Thank the guys who developed wire

if ( VERSION < 31 ) then return end --pre gmod 31 = fail
Msg("=== Loading RadioMod Menus ===\n")

if (SERVER) then
	AddCSLuaFile( "RadioModMenus.lua" )
	resource.AddFile( "materials/icons/car_add.vtf" )
	resource.AddFile( "materials/icons/car_add.vmt" )    
	return
 end

local usetab = CreateClientConVar( "cl_radiomod_usetab", "1", true, false )

local function RadioModTab()
	local mmenu = "Main"
	if usetab:GetBool() then
		spawnmenu.AddToolTab( "RadioMod", "RadioMod", "icons/car_add" )
		mmenu = "RadioMod"
	end


end
hook.Add( "AddToolMenuTabs", "RadioModTab", RadioModTab)


//not really needed any more since gmod32, but do it anyway cause 31 required it
local function RadioModCategories()
	if usetab:GetBool() then
		local oldspawnmenuAddToolMenuOption = spawnmenu.AddToolMenuOption
		function spawnmenu.AddToolMenuOption( tab, category, itemname, text, command, controls, cpanelfunction, TheTable )
			if ( tab == "Main" and "RadioMod" == string.lower( string.Left(category, 4) ) ) then tab = "RadioMod" end
			oldspawnmenuAddToolMenuOption( tab, category, itemname, text, command, controls, cpanelfunction, TheTable )
		end
	end
end
hook.Add( "AddToolMenuCategories", "RadioModCategories", RadioModCategories)


 

