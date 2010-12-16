ulx.setCategory( "User Management" )

local readhelpaccess = "ulx hasreadhelp"
local function checkReadHelp( ply )
	if ULib.ucl.query( ply, readhelpaccess ) then -- Nothing to do here
		return true
	end

	ULib.tsay( ply, "These commands are complicated! You must first read the help. Use \"ulx usermanagementhelp\" in console to see it." )
	return false
end

function ulx.cc_usermanagementhelp( ply, command, argv, args )
	if ply:IsValid() then
		local info = ULib.ucl.authed[ ply ]
		if not info or info.type == ULib.DEFAULT_GRANT_ACCESS.type then
			ULib.tsay( ply, "Sorry, " .. ply:Nick() .. ", this is an advanced help function for admins to use." )
			return
		end
	end

	if ply:IsValid() then
		umsg.Start( "ULXUserManagementHelp", ply )
		umsg.End()
	else
		ulx.showUserHelp()
	end

	if ply:IsValid() and not ULib.ucl.query( ply, readhelpaccess ) then
		local info = ULib.ucl.authed[ ply ]
		info.allow = info.allow or {}
		table.insert( info.allow, readhelpaccess )
		ULib.ucl.addUser( info.account, info.type, info.id, info.groups, {allow=info.allow, deny=info.deny}, info.pass, info.pass_req, true )
		ULib.tsay( ply, "Your access has been changed to reflect that you have read this help. You can now use the user management commands.", true )
	end
end
ulx.concommand( "usermanagementhelp", ulx.cc_usermanagementhelp, " - See the user management help.", ULib.ACCESS_ALL, _, _, ulx.ID_HELP )

function ulx.cc_adduser( ply, command, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	if target:IsUserGroup( ULib.ACCESS_SUPERADMIN ) and ply:IsValid() and not ply:IsListenServerHost() then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of a superadmin!", true )
		return
	end

	local group = argv[ 2 ]:lower()
	local immunity = util.tobool( argv[ 3 ] )
	if ULib.ucl.groups[ group ] == nil or group == "user" then -- "not ULib.ucl.groups[ group ]" isn't working for some reason. Lua language construct error? Strange!
		ULib.tsay( ply, "Invalid group!", true )
		return
	end

	local groups = { group }
	local allows = {}
	if immunity then table.insert( allows, ULib.ACCESS_IMMUNITY ) end

	local info = ULib.ucl.authed[ target ]
	if not info or info.type == ULib.DEFAULT_GRANT_ACCESS.type then -- If they don't have an account, make a new one. Otherwise recycle old information.
		ULib.ucl.addUser( target:Nick():lower(), "steamid", target:SteamID(), groups, {allow=allows, deny={}} , _, _, true )
	else
		ULib.ucl.addUser( info.account, info.type, info.id, groups, {allow=allows, deny={}} , _, _, true )
	end

	if immunity then
		ulx.logUserAct( ply, target, "#A added user #T to group \"" .. group .. "\" with immunity" )
	else
		ulx.logUserAct( ply, target, "#A added user #T to group \"" .. group .. "\"" )
	end
end
ulx.concommand( "adduser", ulx.cc_adduser, "<user> <group> [<immunity>] - Add a user to specified group with optional immunity.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_PLAYER_HELP )

function ulx.cc_adduserid( ply, command, argv, args )
--Thianks to Mr.President for the adduserid idea and function code. Used with permission.
	if not checkReadHelp( ply ) then return end

	if #argv < 3 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local pname = argv[ 1 ]

	local group = argv[ 2 ]
	
	local sid = argv[ 3 ]:upper()

	if not string.find( sid, "STEAM_%d:%d:%d+" ) then
		ULib.tsay( ply, "Invalid steamid." )
		return
	end

	local immunity = util.tobool( argv[ 4 ] )

	if ULib.ucl.groups[ group ] == nil or group == "user" then -- "not ULib.ucl.groups[ group ]" isn't working for some reason. Lua language construct error? Strange!
		ULib.tsay( ply, "Invalid group!", true )
		return
	end

	local groups = { group }
	local allows = {}
	if immunity then table.insert( allows, ULib.ACCESS_IMMUNITY ) end

	ULib.ucl.addUser( pname, "steamid", sid, groups, {allow=allows, deny={}} , _, _, true )


	if immunity then
		ulx.logServAct( ply, "#A added userid " .. sid .. " (" .. pname ..") to group \"" .. group .. "\" with immunity" )
	else
		ulx.logServAct( ply,"#A added userid " .. sid .. " (" .. pname ..") to group \"" .. group .. "\"" )
	end

end
ulx.concommand( "adduserid", ulx.cc_adduserid, "<name> <group> <SteamID> [<immunity>] - Add a user by SteamID to specified group with optional immunity.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_PLAYER_HELP )

function ulx.cc_removeuser( ply, command, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	if target:IsUserGroup( ULib.ACCESS_SUPERADMIN ) and ply:IsValid() and not ply:IsListenServerHost() then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of a superadmin!", true )
		return
	end

	local info = ULib.ucl.authed[ target ]
	if not info or info.type == ULib.DEFAULT_GRANT_ACCESS.type then -- If they don't have an account, fail.
		ULib.tsay( ply, "User has no access!", true )
		return
	end

	ULib.ucl.removeUser( info.account, true )
	ulx.logUserAct( ply, target, "#A removed all of #T's access rights" )
end
ulx.concommand( "removeuser", ulx.cc_removeuser, "<user> - Permanently removes a user's access.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_PLAYER_HELP )

function ulx.cc_userallow( ply, command, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	local info = ULib.ucl.authed[ target ]
	if not info or info.type == ULib.DEFAULT_GRANT_ACCESS.type then
		ULib.tsay( ply, "Please add this user to a group first!" )
		return
	end

	if target:IsUserGroup( ULib.ACCESS_SUPERADMIN ) and ply:IsValid() and not ply:IsListenServerHost() then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of a superadmin!", true )
		return
	end

	local allow = info.allow or {}
	local deny = info.deny or {}
	local command = argv[ 2 ]

	if not ULib.ucl.query( ply, command ) then
		ULib.tsay( ply, "You must first have access to this command in order to give it to others (or you can't give yourself access to commands)!", true )
		return
	end

	local revoke = util.tobool( argv[ 3 ] )
	local i = ULib.findInTable( info.allow, command )

	if revoke then
		if i then
			table.remove( info.allow, i )
			ULib.ucl.addUser( info.account, info.type, info.id, info.groups, {allow=info.allow, deny=info.deny}, info.pass, info.pass_req, true )
			ulx.logServAct( ply, "#A revoked user \"" .. target:Nick() .. "\"'s access to \"" .. command .. "\"" )
		else
			ULib.tsay( ply, "User \"" .. target:Nick() .. "\" doesn't have access to \"" .. command .. "\"", true )
			return
		end
	else
		if i then
			ULib.tsay( ply, "User \"" .. target:Nick() .. "\" already has access to \"" .. command .. "\"", true )
			return
		else
			table.insert( info.allow, command )
			local j = ULib.findInTable( info.deny, command )
			if j then
				table.remove( info.deny, j )
			end
			ULib.ucl.addUser( info.account, info.type, info.id, info.groups, {allow=info.allow, deny=info.deny}, info.pass, info.pass_req, true )
			ulx.logServAct( ply, "#A granted user \"" .. target:Nick() .. "\" access to \"" .. command .. "\"" )
		end
	end
end
ulx.concommand( "userallow", ulx.cc_userallow, "<user> <command> [<revoke>] - Specifically allows the user access to command.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_PLAYER_HELP )

function ulx.cc_userdeny( ply, command, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	local info = ULib.ucl.authed[ target ]
	if not info or info.type == ULib.DEFAULT_GRANT_ACCESS.type then
		ULib.tsay( ply, "Please add this user to a group first!" )
		return
	end

	if target:IsUserGroup( ULib.ACCESS_SUPERADMIN ) and ply:IsValid() and not ply:IsListenServerHost() then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of a superadmin!", true )
		return
	end

	local allow = info.allow or {}
	local deny = info.deny or {}
	local command = argv[ 2 ]

	if not ULib.ucl.query( ply, command ) then
		ULib.tsay( ply, "You must first have access to this command in order to deny it from others!", true )
		return
	end

	local revoke = util.tobool( argv[ 3 ] )
	local i = ULib.findInTable( info.deny, command )

	if revoke then
		if i then
			table.remove( info.deny, i )
			ULib.ucl.addUser( info.account, info.type, info.id, info.groups, {allow=info.allow, deny=info.deny}, info.pass, info.pass_req, true )
			ulx.logServAct( ply, "#A removed user \"" .. target:Nick() .. "\"'s denial of access to \"" .. command .. "\"" )
		else
			ULib.tsay( ply, "User \"" .. target:Nick() .. "\" isn't denied access to \"" .. command .. "\"", true )
			return
		end
	else
		if i then
			ULib.tsay( ply, "User \"" .. target:Nick() .. "\" is already denied access to \"" .. command .. "\"", true )
			return
		else
			table.insert( info.deny, command )
			local j = ULib.findInTable( info.allow, command )
			if j then
				table.remove( info.allow, j )
			end
			ULib.ucl.addUser( info.account, info.type, info.id, info.groups, {allow=info.allow, deny=info.deny}, info.pass, info.pass_req, true )
			ulx.logServAct( ply, "#A denied user \"" .. target:Nick() .. "\" access to \"" .. command .. "\"" )
		end
	end
end
ulx.concommand( "userdeny", ulx.cc_userdeny, "<user> <command> [<revoke>] - Specifically denies the user access to command.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_PLAYER_HELP )

function ulx.cc_addgroup( ply, cmd, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local group = argv[ 1 ]:lower()

	if group == ULib.ACCESS_SUPERADMIN then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of the superadmin group!", true )
		return
	end

	if ULib.ucl.groups[ group ] ~= nil then
		ULib.tsay( ply, "This group already exists!" )
		return
	end

	ULib.ucl.addGroup( group, _, true, { argv[ 2 ] } )
	ulx.logServAct( ply, "#A created group \"" .. argv[ 1 ] .."\"" )
end
ulx.concommand( "addgroup", ulx.cc_addgroup, "<group> [<inherit>] - Create a new group with optional inheritance.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_HELP )

function ulx.cc_removegroup( ply, cmd, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local group = argv[ 1 ]:lower()

	if group == ULib.ACCESS_SUPERADMIN then
		ULib.tsay( ply, "Sorry, for security reasons, you can't remove the superadmin group!", true )
		return
	end

	if ULib.ucl.groups[ group ] == nil then
		ULib.tsay( ply, "This group doesn't exist!" )
		return
	end

	ULib.ucl.removeGroup( group, true )
	ulx.logServAct( ply, "#A removed group \"" .. argv[ 1 ] .."\"" )
end
ulx.concommand( "removegroup", ulx.cc_removegroup, "<group> - Remove a group. USE WITH CAUTION.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_HELP )

function ulx.cc_groupallow( ply, cmd, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local group = argv[ 1 ]:lower()
	local access = argv[ 2 ]:lower()
	local info = ULib.ucl.groups[ group ]

	if not info or group == "user" then
		ULib.tsay( ply, "Invalid group.", true )
		return
	end

	if not ULib.ucl.query( ply, command ) then
		ULib.tsay( ply, "You must first have access to this command in order to give it to others (or you can't give yourself access to commands)!", true )
		return
	end

	if group == ULib.ACCESS_SUPERADMIN then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of the superadmin group!", true )
		return
	end

	local revoke = util.tobool( argv[ 3 ] )
	local i = ULib.findInTable( info.allow, access )

	if revoke then
		if i then
			table.remove( info.allow, i )
			ULib.ucl.addGroup( argv[ 1 ], { allow = info.allow, deny = info.deny }, true, info.inherit_from )
			ulx.logServAct( ply, "#A revoked group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\"'s access to \"" .. access .. "\"" )
		else
			ULib.tsay( ply, "Group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\" doesn't have access to \"" .. access .. "\"", true )
			return
		end
	else
		if i then
			ULib.tsay( ply, "Group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\" already has access to \"" .. access .. "\"", true )
			return
		else
			table.insert( info.allow, access )
			local j = ULib.findInTable( info.deny, access )
			if j then
				table.remove( info.deny, j )
			end
			ULib.ucl.addGroup( argv[ 1 ], { allow = info.allow, deny = info.deny }, true, info.inherit_from )
			ulx.logServAct( ply, "#A granted group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\" access to \"" .. access .. "\"" )
		end
	end

	-- We'll only get here if there's an actual change. Let's reprobe all users in this group.
	local players = player.GetAll()
	for _, ply in ipairs( players ) do
		if table.HasValue( ply:GetGroups( true ), group ) then
			ULib.ucl.probe( ply, false, true )
		end
	end
end
ulx.concommand( "groupallow",  ulx.cc_groupallow, "<group> <access> [<revoke>] - Allow group access to string access.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_HELP )

function ulx.cc_groupdeny( ply, cmd, argv, args )
	if not checkReadHelp( ply ) then return end

	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local group = argv[ 1 ]:lower()
	local access = argv[ 2 ]:lower()
	local info = ULib.ucl.groups[ group ]

	if not info or argv[ 1 ] == "user" then
		ULib.tsay( ply, "Invalid group.", true )
		return
	end

	if not ULib.ucl.query( ply, access ) then
		ULib.tsay( ply, "You must first have access to this command in order to deny it from others!", true )
		return
	end

	if group == ULib.ACCESS_SUPERADMIN then
		ULib.tsay( ply, "Sorry, for security reasons, you can't change the access of the superadmin group!", true )
		return
	end

	local revoke = util.tobool( argv[ 3 ] )
	local i = ULib.findInTable( info.deny, access )

	if revoke then
		if i then
			table.remove( info.deny, i )
			ULib.ucl.addGroup( argv[ 1 ], { allow = info.allow, deny = info.deny }, true, info.inherit_from )
			ulx.logServAct( ply, "#A removed group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\"'s denial of access to \"" .. access .. "\"" )
		else
			ULib.tsay( ply, "Group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\" isn't denied access to \"" .. access .. "\"", true )
			return
		end
	else
		if i then
			ULib.tsay( ply, "Group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\" is already denied access to \"" .. access .. "\"", true )
			return
		else
			table.insert( info.deny, access )
			local j = ULib.findInTable( info.allow, access )
			if j then
				table.remove( info.allow, j )
			end
			ULib.ucl.addGroup( argv[ 1 ], { allow = info.allow, deny = info.deny }, true, info.inherit_from )
			ulx.logServAct( ply, "#A denied group \"" .. group:sub( 1, 1 ):upper() .. group:sub( 2 ) .. "\" access to \"" .. access .. "\"" )
		end
	end

	-- We'll only get here if there's an actual change. Let's reprobe all users in this group.
	local players = player.GetAll()
	for _, ply in ipairs( players ) do
		if table.HasValue( ply:GetGroups( true ), group ) then
			ULib.ucl.probe( ply, false, true )
		end
	end
end
ulx.concommand( "groupdeny",  ulx.cc_groupdeny, "<group> <access> [<revoke>] - Deny a group access to string access.", ULib.ACCESS_SUPERADMIN, _, _, ulx.ID_HELP )