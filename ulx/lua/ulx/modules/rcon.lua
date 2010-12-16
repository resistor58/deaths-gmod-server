-- This module holds any type of remote execution functions (IE, 'dangerous')
ulx.setCategory( "Rcon" )

function ulx.cc_rcon( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	ulx.logServAct( ply, "#A ran rcon command: " .. args, true )

	ULib.consoleCommand( args .. "\n" )
end
ulx.concommand( "rcon", ulx.cc_rcon, "<command> - Send the specified command to the server console.", ULib.ACCESS_SUPERADMIN, "!rcon", true, ulx.ID_HELP )

function ulx.cc_luaRun( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	ULib.consoleCommand( "lua_run " .. args .. "\n" )
	ulx.logServAct( ply, "#A ran lua_run: " .. args, true )
end
ulx.concommand( "luarun", ulx.cc_luaRun, "<command> - Feeds the server a lua command.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_HELP )

function ulx.cc_exec( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end
		if string.sub( argv[ 1 ], -4 ) ~= ".cfg" then argv[ 1 ] = argv[ 1 ] .. ".cfg" end
        if file.Exists( "../cfg/" .. argv[ 1 ] ) then
		ULib.execFile( "../cfg/" .. argv[ 1 ] )
		ulx.logServAct( ply, "#A executed " .. argv[ 1 ], true )
        else
        	ULib.tsay( ply, "That config does not exist!", true )
        end
end
ulx.concommand( "exec", ulx.cc_exec, "<file> - Executes a file.", ULib.ACCESS_ADMIN, _, _, ulx.ID_HELP )

function ulx.cc_cexec( ply, command, argv, args )
	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		local dummy, dummy, cmd = args:find( "^\"*" .. ULib.makePatternSafe( argv[ 1 ] ) .. "\"*%s+(.*)$" )
		v:ConCommand( cmd )
		ulx.logUserAct( ply, v, "#A ran \"" .. cmd .. "\" on #T", true )
	end
end
ulx.concommand( "cexec", ulx.cc_cexec, "<user(s)> <command> - Runs a command on the user's console.", ULib.ACCESS_SUPERADMIN, "!cexec", true, ulx.ID_PLAYER_HELP )

function ulx.cc_ent( ply, command, argv, args )
	if not ply:IsValid() then
		Msg( "Can't create entities from dedicated server console.\n" )
		return
	end
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local class = argv[ 1 ]
	table.remove( argv, 1 ) -- We already have the first now
	newEnt = ents.Create( class )

	local trace = ply:GetEyeTrace()
	local vector = trace.HitPos
	vector.z = vector.z + 20

	newEnt:SetPos( vector ) -- Note that the position can be overridden by the users's flags

	for i, v in ipairs( argv ) do -- Loop through them
		local key = string.sub( v, 1, string.find( v, ":" ) - 1 )
		local value = string.sub( v, string.find( v, ":" ) + 1 )
		newEnt:SetKeyValue( key, value )
	end

	newEnt:Spawn()
	newEnt:Activate()

	ulx.logServAct( ply, "#A created ent \"" .. args .. "\"" )
end
ulx.concommand( "ent", ulx.cc_ent, "<classname> <flag>:<value> .. - spawn an ent, separate flag and value with ':'.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_HELP )