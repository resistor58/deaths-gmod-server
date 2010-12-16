ulx.setCategory( "Toolmodes" )

local gdeny = {}

function ulx.cc_tooldeny( ply, command, argv, args )
	if not ULib.isSandbox() then
		ULib.tsay( ply, "Sorry, this is only available in a sandbox gamemode.", true )
		return
	end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	ulx.logServAct( ply, "#A denied the server access to the toolmode \"" .. argv[ 1 ] .. "\"" )
	gdeny[ argv[ 1 ] ] = true
end
ulx.concommand( "tooldeny", ulx.cc_tooldeny, "<toolmode> - Globally denies the use of the specified toolmode. (IE: \"remover\")", ULib.ACCESS_ADMIN, _, _, ulx.ID_HELP )

function ulx.cc_toolallow( ply, command, argv, args )
	if not ULib.isSandbox() then
		ULib.tsay( ply, "Sorry, this is only available in a sandbox gamemode.", true )
		return
	end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	ulx.logServAct( ply, "#A granted the server access to the toolmode \"" .. argv[ 1 ] .. "\"" )
	gdeny[ argv[ 1 ] ] = nil
end
ulx.concommand( "toolallow", ulx.cc_toolallow, "<toolmode> - Globally allows the use of the specified toolmode. (IE: \"remover\")", ULib.ACCESS_ADMIN, _, _, ulx.ID_HELP )

function ulx.cc_tooldenyuser( ply, command, argv, args )
	if not ULib.isSandbox() then
		ULib.tsay( ply, "Sorry, this is only available in a sandbox gamemode.", true )
		return
	end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	ulx.logUserAct( ply, target, "#A denied #T access to the toolmode \"" .. argv[ 2 ] .. "\"" )
	target.deny = target.deny or {}
	target.deny[ argv[ 2 ] ] = true
end
ulx.concommand( "tooldenyuser", ulx.cc_tooldenyuser, "[<user>] <toolmode> - Denies a player the use of the specified toolmode.", ULib.ACCESS_ADMIN, _, _, ulx.ID_PLAYER_HELP )

function ulx.cc_toolallowuser( ply, command, argv, args )
	if not ULib.isSandbox() then
		ULib.tsay( ply, "Sorry, this is only available in a sandbox gamemode.", true )
		return
	end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	ulx.logUserAct( ply, target, "#A granted #T access to the toolmode \"" .. argv[ 2 ] .. "\"" )
	local t = target:GetTable()
	t.deny = t.deny or {}
	t.deny[ argv[ 2 ] ] = nil
end
ulx.concommand( "toolallowuser", ulx.cc_toolallowuser, "[<user>] <toolmode> - Allows a player the use of the specified toolmode.", ULib.ACCESS_ADMIN, _, _, ulx.ID_PLAYER_HELP )

local access = "ulx tooldenyoverride" -- Access string needed
ULib.ucl.registerAccess( access, ULib.ACCESS_ADMIN ) -- Give admins access by default
local function tool( ply, tr, toolmode )
	if (gdeny[ toolmode ] and not ULib.ucl.query( ply, access )) or (ply.deny and ply.deny[ toolmode ]) then
		ULib.tsay( ply, "This toolmode has been disabled." )
		return false
	end
end
hook.Add( "CanTool", "ULXToolCheck2", tool )