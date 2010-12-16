ulx.setCategory( "Menus" )

if file.Exists( "../lua/ulx/modules/cl/mainmenu.lua" ) then
	function ulx.cc_menu( ply, command, argv, args )
		if not ply:IsValid() then
			Msg( "You can't use menus from the dedicated server console.\n" )
			return
		end
		ULib.sendLuaFunction( ply, "ulx.showMainMenu" )
	end
	ulx.concommand( "menu", ulx.cc_menu, " - Shows you the main menu.", ULib.ACCESS_ALL, "!menu", _, ulx.ID_HELP )

	if file.Exists( "../lua/ulx/modules/cl/adminmenu.lua" ) then ulx.addToMenu( ulx.ID_MMAIN, "Admin", "ulx adminmenu" ) end
	if file.Exists( "../lua/ulx/modules/cl/clientmenu.lua" ) then ulx.addToMenu( ulx.ID_MMAIN, "Client", "ulx clientmenu" ) end
	if file.Exists( "../lua/ulx/modules/cl/mapsmenu.lua" ) then ulx.addToMenu( ulx.ID_MMAIN, "Maps", "ulx mapsmenu" ) end
	if file.Exists( "../lua/ulx/modules/cl/motdmenu.lua" ) then ulx.addToMenu( ulx.ID_MMAIN, "MOTD", "ulx motd" ) end
	if file.Exists( "../lua/ulx/modules/cl/banmenu.lua" ) then ulx.addToMenu( ulx.ID_MMAIN, "Bans", "ulx banmenu" ) end
end



if file.Exists( "../lua/ulx/modules/cl/adminmenu.lua" ) then
	function ulx.cc_adminmenu( ply, command, argv, args )
		if not ply:IsValid() then
			Msg( "You can't use menus from the dedicated server console.\n" )
			return
		end

		ULib.sendLuaFunction( ply, "ulx.showAdminMenu" )
	end
	ulx.concommand( "adminmenu", ulx.cc_adminmenu, " - Shows you the admin menu.", ULib.ACCESS_ADMIN, "!adminmenu", _, ulx.ID_HELP )

	local function valueUpdate( ply )
		if not ULib.ucl.query( ply, "ulx adminmenu" ) then -- No reason for them to get this.
			return
		end

		for _, data in pairs( ulx.menuContents[ ulx.ID_MADMIN ] ) do
			umsg.Start( "ulx_menuvalues", ply )
				umsg.String( data.data.cvar )
				umsg.Short( GetConVarNumber( data.data.cvar ) )
			umsg.End()
		end
	end
	ULib.concommand( "ulx_valueupdate", valueUpdate )

	local function cvar( ply, command, argv, args )
		if not ULib.ucl.query( ply, "ulx adminmenu" ) then
			ULib.tsay( ply, "You do not have access to this command", true )
			return
		end

		-- Make sure they're changing something we've registered. No hax for admins. :)
		local found = false
		for _, data in pairs( ulx.menuContents[ ulx.ID_MADMIN ] ) do
			if data.data.cvar == argv[ 1 ] then
				found = true
				break
			end
		end
		if not found then return end

		ulx.logServAct( ply, "#A changed cvar: " .. args )

		ULib.consoleCommand( args .. "\n" )
	end
	ULib.concommand( "ulx_cvar", cvar )

	ulx.addToMenu( ulx.ID_MADMIN, "Max Props:", { max=256, cvar="sbox_maxprops" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Ragdolls:", { max=32, cvar="sbox_maxragdolls" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max NPCs:", { max=32, cvar="sbox_maxnpcs" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Balloons:", { max=64, cvar="sbox_maxballoons" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Wheels:", { max=64, cvar="sbox_maxwheels" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Lamps:", { max=32, cvar="sbox_maxlamps" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Buttons:", { max=64, cvar="sbox_maxbuttons" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Dynamite:", { max=32, cvar="sbox_maxdynamite" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Effects:", { max=128, cvar="sbox_maxeffects" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Emitters:", { max=32, cvar="sbox_maxemitters" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Hoverballs:", { max=64, cvar="sbox_maxhoverballs" } )
--Garry removed in 3/30/08 update	ulx.addToMenu( ulx.ID_MADMIN, "Max SENTs:", { max=128, cvar="sbox_maxsents" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Spawners:", { max=32, cvar="sbox_maxspawners" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Thrusters:", { max=64, cvar="sbox_maxthrusters" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Turrets:", { max=32, cvar="sbox_maxturrets" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Max Vehicles:", { max=32, cvar="sbox_maxvehicles" } )

	ulx.addToMenu( ulx.ID_MADMIN, "Limited Physgun", { button=true, cvar="physgun_limited", off="Enable Limited Physgun", on="Disable Limited Physgun" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Godmode", { button=true, cvar="sbox_godmode", off="Enable Global Godmode", on="Disable Global Godmode" } )
	ulx.addToMenu( ulx.ID_MADMIN, "PvP", { button=true, cvar="sbox_plpldamage", off="Disable PvP Damage", on="Enable PvP Damage" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Noclip", { button=true, cvar="sbox_noclip", off="Enable Noclip", on="Disable Noclip" } )
	ulx.addToMenu( ulx.ID_MADMIN, "Alltalk", { button=true, cvar="sv_alltalk", off="Enable Alltalk", on="Disable Alltalk" } )
end



if file.Exists( "../lua/ulx/modules/cl/clientmenu.lua" ) then
	function ulx.cc_clientmenu( ply, command, argv, args )
		if not ply:IsValid() then
			Msg( "You can't use menus from the dedicated server console.\n" )
			return
		end
		ULib.sendLuaFunction( ply, "ulx.showClientMenu" )
	end
	ulx.concommand( "clientmenu", ulx.cc_clientmenu, " - Shows you the client menu.", ULib.ACCESS_ADMIN, "!clientmenu", _, ulx.ID_HELP )
end



if file.Exists( "../lua/ulx/modules/cl/mapsmenu.lua" ) then
	function ulx.cc_mapsmenu( ply, command, argv, args )
		if not ply:IsValid() then
			Msg( "You can't use menus from the dedicated server console.\n" )
			return
		end

		if not ULib.ucl.query( ply, "ulx map" ) then
			ULib.tsay( ply, "You do not have access to this menu", true )
			return
		end

		umsg.Start( "SendMapsMenu", ply )
		umsg.End()
	end
	ulx.concommand( "mapsmenu", ulx.cc_mapsmenu, " - Shows you the maps menu.", ULib.ACCESS_ADMIN, "!mapsmenu", _, ulx.ID_HELP )

	local function getGamemodes( ply )
		if not ULib.ucl.query( ply, "ulx mapsmenu" ) then -- No reason for them to get this.
			return
		end

		umsg.Start( "ulx_cleargamemodes", ply )
		umsg.End()

		local dirs = file.FindDir( "../gamemodes/*" )
		for _, dir in ipairs( dirs ) do
			if file.Exists( "../gamemodes/" .. dir .. "/info.txt" ) and not util.tobool( util.KeyValuesToTable( file.Read( "../gamemodes/" .. dir .. "/info.txt" ) ).hide ) then
				umsg.Start( "ulx_gamemode", ply )
					umsg.String( dir )
				umsg.End()
			end
		end

	end
	ULib.concommand( "ulx_getgamemodes", getGamemodes )
end



if file.Exists( "../lua/ulx/modules/cl/motdmenu.lua" ) then
	CreateConVar( "motdfile", "ulx_motd.txt" )
	function ulx.cc_motd( ply, command, argv, args )
		if not ply:IsValid() then
			Msg( "You can't see the motd from the console.\n" )
			return
		end

		if not file.Exists( "../" .. GetConVarString( "motdfile" ) ) then return end -- Invalid
		umsg.Start( "SendMotdMenu", ply )
		umsg.End()
	end
	ulx.concommand( "motd", ulx.cc_motd, " - Shows you the message of the day.", ULib.ACCESS_ALL, "!motd", _, ulx.ID_HELP )

	local function showMotd( ply )
		if not util.tobool( GetConVarString( "ulx_showMotd" ) ) then return end
		if not ply:IsValid() then return end -- They left, doh!

		if not file.Exists( "../" .. GetConVarString( "motdfile" ) ) then return end -- Invalid
		local f = file.Read( "../" .. GetConVarString( "motdfile" ) )

		umsg.Start( "ULXMotdStart", ply )
		umsg.End()

		while f:len() > 0 do
			umsg.Start( "ULXMotdText", ply )
				umsg.String( f:sub( 1, 240 ) )
			umsg.End()
			f = f:sub( 241 )
		end

		umsg.Start( "ULXMotdEnd", ply )
		umsg.End()

		umsg.Start( "SendMotdMenu", ply )
		umsg.End()
	end
	hook.Add( "ULibPlayerULibLoaded", "showMotd", showMotd )
	ulx.convar( "showMotd", "1", " - Shows the motd to clients on startup.", ULib.ACCESS_ADMIN )
end

if file.Exists( "../lua/ulx/modules/cl/banmenu.lua" ) then
	function ulx.cc_banmenu( ply, command, argv, args )
		if not ply:IsValid() then
			Msg( "You can't use menus from the dedicated server console.\n" )
			return
		end

		if not ULib.ucl.query( ply, "ulx banmenu" ) then
			ULib.tsay( ply, "You do not have access to this menu", true )
			return
		end

		umsg.Start( "SendBanMenu", ply )
		umsg.End()
	end
	ulx.concommand( "banmenu", ulx.cc_banmenu, " - Shows you the ban menu.", ULib.ACCESS_ADMIN, "!banmenu", _, ulx.ID_HELP )

	local function getBans( ply )
		if not ULib.ucl.query( ply, "ulx banmenu" ) then -- No reason for them to get this.
			return
		end

		ULib.refreshBans()

		umsg.Start( "ULXBansStart", ply )
		umsg.End()

		for id, t in pairs( ULib.bans ) do
			local reason = t.reason
			t.reason = nil
			umsg.Start( "ULXBan", ply )
				umsg.String( id )
				ULib.umsgSend( t )
			umsg.End()

			if reason then
				umsg.Start( "ULXBanReason", ply )
					umsg.String( id )
					umsg.String( reason:sub( 1, 240 ) ) -- Make sure it's not too long.
				umsg.End()
			end
			t.reason = reason
		end

		umsg.Start( "ULXBansEnd", ply )
		umsg.End()
	end
	ULib.concommand( "ulx_getbans", getBans )
end
