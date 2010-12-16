ulx.setCategory( "Utilities" )

function ulx.cc_who( ply, command, argv, args )
	ULib.console( ply, "ID Name                            Immune Groups" )

	local players = player.GetAll()
	for _, player in ipairs( players ) do
		local id = tostring( player:EntIndex() )
		local nick = player:Nick()
		local text = string.format( "%i%s %s%s ", id, string.rep( " ", 2 - id:len() ), nick, string.rep( " ", 31 - nick:len() ) )

		if ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) then
			text = text .. "Yes    "
		else
			text = text .. "No     "
		end

		for k, v in pairs( ULib.ucl.authed[ player ].groups ) do
			if v ~= ULib.ACCESS_ALL then
				text = text .. v:sub( 1, 1 ):upper() .. v:sub( 2 ) .. ", "
			end
		end

		text = text:sub( 1, -3 ) -- Take off trailing ', '

		ULib.console( ply, text )
	end
end
ulx.concommand( "who", ulx.cc_who, "- Shows all connected players ids and access.", ULib.ACCESS_ALL )

function ulx.cc_map( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local map = argv[ 1 ]
	if string.sub( map, -4 ) == ".bsp" then
		map = string.sub( map, 1, -5 ) -- Take off the .bsp
	end

	if not file.Exists( "../maps/" .. map .. ".bsp" ) then
		ULib.tsay( ply, "That map does not exist!", true )
		return
	end

	if argv[ 2 ] and (not file.IsDir( "../gamemodes/" .. argv[ 2 ] ) or not file.Exists( "../gamemodes/" .. argv[ 2 ] .. "/info.txt" ) or util.tobool( util.KeyValuesToTable( file.Read( "../gamemodes/" .. argv[ 2 ] .. "/info.txt" ) ).hide ) ) then
		ULib.tsay( ply, "That gamemode does not exist!", true )
		return
	end

	if not argv[ 2 ] then
		game.ConsoleCommand( "changelevel " .. map .. "\n" )
		ulx.logServAct( ply, "#A changed map to " .. map )
	else
		game.ConsoleCommand( "changegamemode " .. map .. " " .. argv[ 2 ] .. "\n" )
		ulx.logServAct( ply, "#A changed map to " .. map .. ", gamemode to " .. argv[ 2 ] )
	end
end
ulx.concommand( "map", ulx.cc_map, "<map> [<gamemode>] - Changes the map and gamemode (if specified).", ULib.ACCESS_ADMIN, "!map", _, ulx.ID_ORIGINAL, "mapComplete" )

local function sendMapAutocomplete( ply, dummy )
	-- TODO: It seemed that we had a good reason for the code below that's commented out. Make sure everything still works.
	--[[if not ply.ulx_mapautocompleteinitial then -- We're going to be called twice on a player init. Ignore the first one, as it's too soon.
		ply.ulx_mapautocompleteinitial = true
		return
	end]]

	if ULib.ucl.query( ply, "ulx map" ) then -- Only send if they have access to this.
		for _, map in ipairs( ulx.maps ) do
			umsg.Start( "ulx_map", ply )
				umsg.String( map )
			umsg.End()
		end
	end
end
--ULib.ucl.addAccessCallback( sendMapAutocomplete )
hook.Add( "ULibPlayerULibLoaded", "sendMapAutoComplete", sendMapAutocomplete )

function ulx.cc_kick( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	local reason = string.gsub( args, "%s*" .. argv[ 1 ] .. "%s*", "" )

	if reason then
		ulx.logUserAct( ply, target, "#A kicked #T (" .. reason .. ")" )
	else
		ulx.logUserAct( ply, target, "#A kicked #T" )
	end

	ULib.kick( target, argv[ 2 ] )
end
ulx.concommand( "kick", ulx.cc_kick, "<user> [<reason>] - Kicks a user with the given reason.", ULib.ACCESS_ADMIN, "!kick", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Kick", "ulx kick" )

function ulx.cc_ban( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	local bantime = tonumber( argv[ 2 ] )
	if not bantime or bantime < 0 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end
	
	local dummy, dummy, reason = args:find( "^\"*" .. ULib.makePatternSafe( argv[ 1 ] ) .. "\"*%s+" .. ULib.makePatternSafe( argv[ 2 ] or "" ) .. "%s+(.*)$" )
	reason = reason or "" -- Make sure it has a value	

	local time = "for " .. bantime .. " minute(s)"
	if bantime == 0 then time = "permanently" end
	if reason ~= "" then reason = "(" .. reason .. ")" end
	ulx.logUserAct( ply, target, "#A banned #T " .. time .. " " .. reason )

	ULib.kickban( target, bantime, reason, ply )
end
ulx.concommand( "ban", ulx.cc_ban, "<user> [<time>] [<reason>] - Bans a user for x minutes, use 0 for permaban.", ULib.ACCESS_ADMIN, "!ban", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Ban (perma)", "ulx ban #T 0" )
ulx.addToMenu( ulx.ID_MCLIENT, "Ban (5 mins)", "ulx ban #T 5" )
ulx.addToMenu( ulx.ID_MCLIENT, "Ban (60 mins)", "ulx ban #T 60" )

function ulx.cc_banid( ply, cmd, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	if not string.find( argv[ 1 ], "STEAM_%d:%d:%d+" ) then
		ULib.tsay( ply, "Invalid steamid." )
		return
	end

	local bantime = tonumber( argv[ 2 ] )
	if not bantime or bantime < 0 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end	

	local dummy, dummy, reason = args:find( "^\"*" .. ULib.makePatternSafe( argv[ 1 ] ) .. "\"*%s+" .. ULib.makePatternSafe( argv[ 2 ] or "" ) .. "%s+(.*)$" )
	reason = reason or "" -- Make sure it has a value

	local time = "for " .. bantime .. " minute(s)"
	if bantime == 0 then time = "permanently" end
	if reason ~= "" then
		ulx.logServAct( ply, string.format( "#A banned id %s %s (%s)", argv[ 1 ], time, reason ) )
	else
		ulx.logServAct( ply, string.format( "#A banned id %s %s", argv[ 1 ], time ) )
	end
	ULib.addBan( argv[ 1 ], bantime, reason, nil, ply )

	if file.Exists( "../cfg/banned_user.cfg" ) then
		ULib.execFile( "../cfg/banned_user.cfg" )
	end
	game.ConsoleCommand( string.format( "banid %d %s kick;writeid\n", bantime, argv[ 1 ] ) )
end
ulx.concommand( "banid", ulx.cc_banid, "<steamid> [<time>] [<reason>] - Add a steamid to the bans, use 0 for perma.", ULib.ACCESS_ADMIN, "!banid", _, ulx.ID_HELP )

function ulx.cc_unban( ply, cmd, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	if not string.find( argv[ 1 ], "STEAM_%d:%d:%d+" ) then
		ULib.tsay( ply, "Invalid steamid.", true )
		return
	end

	ULib.unban( argv[ 1 ] )

	ulx.logServAct( ply, "#A unbanned steamid " .. argv[ 1 ] )
end
ulx.concommand( "unban", ulx.cc_unban, "<steamid> - Remove the specified steamid from the banlist.", ULib.ACCESS_ADMIN, "!unban", _, ulx.ID_HELP )

function ulx.cc_spectate( ply, command, argv, args )
	if not ply:IsValid() then
		Msg( "You can't spectate from dedicated server console.\n" )
		return
	end
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end
	
	if ulx.getExclusive( ply, ply ) then
		ULib.tsay( ply, ulx.getExclusive( ply, ply ), true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	if target == ply then
		ULib.tsay( ply, "You can't spectate yourself!", true )
		return
	end

	ULib.getSpawnInfo( ply )

	local pos = ply:GetPos()
	local ang = ply:GetAngles()
	local function unspectate( player, key )
		if ply ~= player then return end -- Not the person we want		
		if key ~= IN_FORWARD and key ~= IN_BACK and key ~= IN_MOVELEFT and key ~= IN_MOVERIGHT then return end -- Not a key we're interested in

		ULib.spawn( player, true ) -- Get out of spectate.
		if player.ULXHasGod then player:GodEnable() end -- Restore if player had ulx god.
		player:SetPos( pos )
		player:SetAngles( ang )
		ulx.logUserAct( player, target, "#A stopped spectating #T", true )
		hook.Remove( "KeyPress", "ulx_unspectate_" .. ply:EntIndex() )
		hook.Remove( "PlayerDisconnected", "ulx_unspectatedisconnect_" .. ply:EntIndex() )
		ulx.clearExclusive( ply )
	end
	hook.Add( "KeyPress", "ulx_unspectate_" .. ply:EntIndex(), unspectate )
	
	local function disconnect( player ) -- We want to watch for spectator or target disconnect
		if player == target or player == ply then -- Target or spectator disconnecting
			if player == target then -- Restore them
				ULib.spawn( ply, true ) -- Get out of spectate.
				if ply.ULXHasGod then ply:GodEnable() end -- Restore if player had ulx god.
				ply:SetPos( pos )
				ply:SetAngles( ang )				
			end
			ulx.logUserAct( ply, target, "#A stopped spectating #T", true )
			hook.Remove( "KeyPress", "ulx_unspectate_" .. ply:EntIndex() )
			hook.Remove( "PlayerDisconnected", "ulx_unspectatedisconnect_" .. ply:EntIndex() )
			ulx.clearExclusive( ply )			
		end
	end
	hook.Add( "PlayerDisconnected", "ulx_unspectatedisconnect_" .. ply:EntIndex(), disconnect )

	ulx.logUserAct( ply, target, "#A began spectating #T", true )
	ply:Spectate( OBS_MODE_IN_EYE )
	ply:SpectateEntity( target )
	ply:StripWeapons() -- Otherwise they can use weapons while spectating

	ULib.tsay( ply, "To get out of spectate, move forward.", true )
	ulx.setExclusive( ply, "spectating" )
end
ulx.concommand( "spectate", ulx.cc_spectate, "<user> - Spectates specified user.", ULib.ACCESS_ADMIN, "!spectate", true, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Spectate", "ulx spectate" )

function ulx.cc_addForcedDownload( ply, command, argv, args )
	if #argv < 1 then return end -- Invalid

	if string.sub( argv[ 1 ], -1 ) == "/" then
		argv[ 1 ] = string.sub( argv[ 1 ], 0, -2 )
	end

	local files = {}

	if file.IsDir( "../" .. argv[ 1 ] ) then
		local t = file.Find( "../" .. argv[ 1 ] .. "/*" )
		for _, v in pairs( t ) do
			if not file.IsDir( "../" .. argv[ 1 ] .. "/" .. v ) then
				table.insert( files, argv[ 1 ] .. "/" .. v )
			elseif #argv == 2 and util.tobool( argv[ 2 ] ) then
				ulx.cc_addForcedDownload( ply, command, { argv[ 1 ] .. "/" .. v, 1 } )
			end
		end
	elseif not file.Exists( "../" .. argv[ 1 ] ) then
		Msg( "ULX Config Error: Tried to add a nonexistant file to forced downloads '" .. argv[ 1 ] .. "'\n" )
		return
	else
		files = { argv[ 1 ] }
	end

	for _, v in pairs( files ) do
		resource.AddFile( v )
	end
end
ulx.concommand( "addForcedDownload", ulx.cc_addForcedDownload, "", ULib.ACCESS_NONE ) -- Can only add from configs

-- We use this for our debuginfo function. I know it may have other uses, but you'd probably want to improve it anyways so meh. Adapted from PrintTable()
local function dumpTable( t, indent, done )
	done = done or {}
	indent = indent or 0
	local str = ""

	for k, v in pairs( t ) do
		str = str .. string.rep( "\t", indent )

		if type( v ) == "table" and not done[ v ] then
			done[ v ] = true
			str = str .. tostring( k ) .. ":" .. "\n"
			str = str .. dumpTable( v, indent + 1, done )

		else
			str = str .. tostring( k ) .. "\t=\t" .. tostring( v ) .. "\n"
		end
	end

	return str
end

function ulx.cc_debuginfo( ply, command, argv, args )
	local str = string.format( "ULX version: %s\nULib version: %.2f\n", ulx.getVersion(), ULib.VERSION )
	str = str .. string.format( "Gamemode: %s\nMap: %s\n", GAMEMODE.Name, game.GetMap() )
	str = str .. "Dedicated server: " .. tostring( isDedicatedServer() ) .. "\n\n"

	local players = player.GetAll()
	str = str .. string.format( "Currently connected players:\nNick%s steamid%s id lsh created\n", str.rep( " ", 27 ), str.rep( " ", 11 ) )
	for _, ply in ipairs( players ) do
		local id = string.format( "%i", ply:EntIndex() )
		local created = string.format( "%i", ply.Created )
		local steamid = ply:SteamID()

		local plyline = ply:Nick() .. str.rep( " ", 32 - ply:Nick():len() ) -- Name
		plyline = plyline .. steamid .. str.rep( " ", 19 - steamid:len() ) -- Steamid
		plyline = plyline .. id .. str.rep( " ", 3 - id:len() ) -- id
		if ply:IsListenServerHost() then
			plyline = plyline .. "y   "
		else
			plyline = plyline .. "n   "
		end
		plyline = plyline .. created -- Seconds from server start the player connected

		str = str .. plyline .. "\n"
	end

	local gmoddefault = util.KeyValuesToTable( file.Read( "../settings/users.txt" ) )
	str = str .. "\n\nULib.ucl.users (#=" .. table.Count( ULib.ucl.users ) .. "):\n" .. dumpTable( ULib.ucl.users, 1 ) .. "\n\n"
	str = str .. "ULib.ucl.groups (#=" .. table.Count( ULib.ucl.groups ) .. "):\n" .. dumpTable( ULib.ucl.groups, 1 ) .. "\n\n"
	str = str .. "ULib.ucl.authed (#=" .. table.Count( ULib.ucl.authed ) .. "):\n" .. dumpTable( ULib.ucl.authed, 1 ) .. "\n\n"
	str = str .. "Garrysmod default file (#=" .. table.Count( gmoddefault ) .. "):\n" .. dumpTable( gmoddefault, 1 ) .. "\n\n"

	str = str .. "Active addons on this server:\n"
	local possibleaddons = file.FindDir( "../addons/*" )
	for _, addon in ipairs( possibleaddons ) do
		if file.Exists( "../addons/" .. addon .. "/info.txt" ) then
			local t = util.KeyValuesToTable( file.Read( "../addons/" .. addon .. "/info.txt" ) )
			if tonumber( t.version ) then t.version = string.format( "%g", t.version ) end -- Removes innaccuracy in floating point numbers
			str = str .. string.format( "%s%s by %s, version %s (%s)\n", addon, str.rep( " ", 24 - addon:len() ), t.author_name, t.version, t.up_date )
		end
	end

	file.Write( "ulx/debugdump.txt", str )
	Msg( "Debug information written to garrysmod/data/ulx/debugdump.txt on server.\n" )
end
ulx.concommand( "debuginfo", ulx.cc_debuginfo, " - Get some helpful debug information", ULib.ACCESS_NONE ) -- Only want this to be run from server console.

--------------------
--     Hooks      --
--------------------
local function playerPickup( ply, ent )
	if ent:GetClass() == "player" and ULib.isSandbox() and ULib.ucl.query( ply, "ulx physgunplayer" ) and not ent.NoNoclip and (not ULib.ucl.query( ent, ULib.ACCESS_IMMUNITY ) or ULib.ucl.query( ply, "overcomeimmunity" )) then
		ent:SetMoveType( MOVETYPE_NONE ) -- So they don't bounce
		return true
	end
end
hook.Add( "PhysgunPickup", "ulxPlayerPickup", playerPickup, -5 ) -- Allow admins to move players. Call before the prop protection hook.
ULib.ucl.registerAccess( "ulx physgunplayer", ULib.ACCESS_ADMIN )

local function playerDrop( ply, ent )
	if ent:GetClass() == "player" then
		ent:SetMoveType( MOVETYPE_WALK )
	end
end
hook.Add( "PhysgunDrop", "ulxPlayerDrop", playerDrop )
