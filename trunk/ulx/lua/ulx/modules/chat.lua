-- This module holds any type of chatting functions
ulx.setCategory( "Chat" )

function ulx.cc_psay( ply, command, argv, args )
	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], true, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	if target == ply then
		ULib.tsay( ply, "Why are you talking to yourself?" )
		return
	end

	local dummy, dummy, str = args:find( "^\"*" .. ULib.makePatternSafe( argv[ 1 ] ) .. "\"*%s+(.*)$" )
	local nick
	if ply:IsValid() then
		nick = ply:Nick()
	else
		nick = "(Console)"
	end

	local message = string.format( "%s to %s: %s", nick, target:Nick(), str )

	ULib.tsay( target, message )
	ULib.tsay( ply, message )

	if util.tobool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( message )
	end
end
ulx.concommand( "psay", ulx.cc_psay, "<user> <text> - Sends a private message to the user.", ULib.ACCESS_ALL, "!p", true, ulx.ID_PLAYER_HELP, _ )

local seeasayAccess = "ulx seeAsay"
ULib.ucl.registerAccess( seeasayAccess, ULib.ACCESS_OPERATOR ) -- Give operators access to see asays echoes by default

function ulx.cc_asay( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	if ply:IsValid() then
		nick = ply:Nick()
	else
		nick = "(Console)"
	end

	local message
	if argv[ 1 ] == "/me" then
		message = string.format ( "(ADMINS) *** %s %s", nick, args:sub( 5 ) )
	else
		message = string.format( "%s to admins: %s", nick, args )
	end

	local players = player.GetAll()
	for _, player in ipairs( players ) do
		if ULib.ucl.query( player, seeasayAccess ) and player ~= ply then
			ULib.tsay( player, message )
		end
	end
	ULib.tsay( ply, message ) -- Make sure they get it too.
	if isDedicatedServer() then	Msg( message .. "\n" ) end

	if util.tobool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( message )
	end
end
ulx.concommand( "asay", ulx.cc_asay, "<text> - Sends a message to currently connected admins.", ULib.ACCESS_ALL, "@", true, ulx.ID_HELP, _, true )

function ulx.cc_tsay( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	ULib.tsay( _, args )

	if util.tobool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( "(tsay) " .. args )
	end
end
ulx.concommand( "tsay", ulx.cc_tsay, "<text> - Sends a message to everyone.", ULib.ACCESS_ADMIN, "@@", true, ulx.ID_HELP, _, true )

function ulx.cc_csay( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	ULib.csay( _, args )

	if util.tobool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( "(csay) " .. args )
	end
end
ulx.concommand( "csay", ulx.cc_csay, "<text> - Sends a message to everyone in the middle of the screen.", ULib.ACCESS_ADMIN, "@@@", true, ulx.ID_HELP, _, true )

local waittime = 60
local lasttimeusage = -waittime
function ulx.cc_thetime( ply, command, argv, args )
	if lasttimeusage + waittime > CurTime() then
		ULib.tsay( ply, "I just told you what time it is! Please wait " .. waittime .. " seconds before using this command again", true )
		return
	end

	lasttimeusage = CurTime()
	if not ply:IsValid() then
		Msg( os.date( "The time is now %I:%M %p.\n" ) )
	end
	ULib.tsay( _, os.date( "The time is now %I:%M %p." ), true )
end
ulx.concommand( "thetime", ulx.cc_thetime, " - Shows you the server time.", ULib.ACCESS_ALL, "!thetime", _, ulx.ID_HELP )

local adverts = {}

local function doAdvert( group, id )
	local info = adverts[ group ][ id ]

	local message = string.gsub( info.message, "%%curmap%%", game.GetMap() )
	message = string.gsub( message, "%%host%%", GetConVarString( "hostname" ) )
	message = string.gsub( message, "%%ulx_version%%", ulx.getVersion() )

	if not info.color then -- tsay
		local lines = ULib.explode( "\n+", message )
		local ft = FrameTime()

		for i, line in ipairs( lines ) do
			timer.Simple( (i-1) * ft * 2, ULib.tsay, _, line ) -- Run one message every other frame (to ensure correct order)
		end
	else
		ULib.csay( _, message, info.color, info.len )
	end

	timer.Simple( FrameTime() * 0.5, function()
		local nextid = math.fmod( id, #adverts[ group ] ) + 1
		timer.Remove( "ULXAdvert" .. type( group ) .. group )
		timer.Create( "ULXAdvert" .. type( group ) .. group, adverts[ group ][ nextid ].rpt, 1, doAdvert, group, nextid )
	end )
end

local gimpSays = {} -- Holds gimp says
local ID_GIMP = 1
local ID_MUTE = 2

function ulx.cc_gimp( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A gimped #T" )
		v.gimp = ID_GIMP
	end
end
ulx.concommand( "gimp", ulx.cc_gimp, "<user(s)> - Gimps a player (can't talk normally).", ULib.ACCESS_ADMIN, "!gimp", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Gimp", "ulx gimp" )

function ulx.cc_mute( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A muted #T" )
		v.gimp = ID_MUTE
	end
end
ulx.concommand( "mute", ulx.cc_mute, "<user(s)> - Mutes a player (can't talk at all).", ULib.ACCESS_ADMIN, "!mute", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Mute", "ulx mute" )

function ulx.cc_ungimp( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A ungimped/unmuted #T" )
		v.gimp = nil
	end
end
ulx.concommand( "ungimp", ulx.cc_ungimp, "<user(s)> - Ungimps a player.", ULib.ACCESS_ADMIN, "!ungimp", _, ulx.ID_PLAYER_HELP )
ulx.concommand( "unmute", ulx.cc_ungimp, "<user(s)> - Unmutes a player.", ULib.ACCESS_ADMIN, "!unmute", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Unmute/gimp", "ulx unmute" )

local function gimpCheck( ply, strText )
	if ply.gimp == ID_MUTE then return "" end
	if ply.gimp == ID_GIMP then
		if #gimpSays < 1 then return nil end
		return gimpSays[ math.random( #gimpSays ) ]
	end
end
hook.Add( "PlayerSay", "ULXGimpCheck", gimpCheck, -15 ) -- Very low priority

function ulx.cc_gag( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A gagged #T")
		umsg.Start( "ulx_gag", v )
			umsg.Bool( true )
		umsg.End()
	end
end
ulx.concommand( "gag", ulx.cc_gag, "<user(s)> - gags user(s) (Disable voice/mic input).", ULib.ACCESS_ADMIN, "!gag", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Gag", "ulx gag" )

function ulx.cc_ungag( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A ungagged #T" )
		umsg.Start( "ulx_gag", v )
			umsg.Bool( false )
		umsg.End()

	end
end
ulx.concommand( "ungag", ulx.cc_ungag, "<user(s)> - Ungags user(s).", ULib.ACCESS_ADMIN, "!ungag", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Ungag", "ulx ungag" )

function ulx.cc_addGimpSay( ply, command, argv, args )
	local say = ULib.stripQuotes( args )
	table.insert( gimpSays, say )
end
ulx.concommand( "addGimpSay", ulx.cc_addGimpSay, "", ULib.ACCESS_NONE ) -- Can only add from configs

function ulx.addAdvert( message, rpt, group, color, len )
	local t

	if group then
		t = adverts[ tostring( group ) ]
		if not t then
			t = {}
			adverts[ tostring( group ) ] = t
		end
	else
		group = table.insert( adverts, {} )
		t = adverts[ group ]
	end

	local id = table.insert( t, { message=message, rpt=rpt, color=color, len=len } )

	if not timer.IsTimer( "ULXAdvert" .. type( group ) .. group ) then
		timer.Create( "ULXAdvert" .. type( group ) .. group, rpt, 1, doAdvert, group, id )
	end
end

function ulx.cc_addAdvert( ply, command, argv, args )
	if #argv < 2 then return end -- Invalid

	local message = argv[ 1 ] or ""
	message = message:gsub( "\\n", "\n" ) -- Make them actual newlines
	local rpt = tonumber( argv[ 2 ] ) or 360
	local group = argv[ 3 ]

	ulx.addAdvert( message, rpt, group )
end
ulx.concommand( "addAdvert", ulx.cc_addAdvert, "", ULib.ACCESS_NONE ) -- Can only add from configs

function ulx.cc_addCsayAdvert( ply, command, argv, args )
	if #argv < 6 then return end -- Invalid

	local message = argv[ 1 ] or ""
	message = message:gsub( "\\n", "\n" ) -- Make them actual newlines
	local r = tonumber( argv[ 2 ] ) or 255
	local g = tonumber( argv[ 3 ] ) or 255
	local b = tonumber( argv[ 4 ] ) or 255
	local rpt = tonumber( argv[ 5 ] ) or 300
	local len = tonumber( argv[ 6 ] ) or 10
	local group = argv[ 7 ]

	ulx.addAdvert( message, rpt, group, Color( r, g, b, 255 ), len )
end
ulx.concommand( "addCsayAdvert", ulx.cc_addCsayAdvert, "", ULib.ACCESS_NONE ) -- Can only add from configs

-- Anti-spam stuff
local function playerSay( ply )
	if not ply.lastChatTime then ply.lastChatTime = 0 end

	local chattime = GetConVarNumber( "ulx_chattime" )
	if chattime <= 0 then return end

	if ply.lastChatTime + chattime > CurTime() then
		return ""
	else
		ply.lastChatTime = CurTime()
		return
	end
end
hook.Add( "PlayerSay", "ulxPlayerSay", playerSay, 19 )
ulx.convar( "chattime", "1.5", "<time> - Players can only chat every x seconds (anti-spam). 0 to disable.", ULib.ACCESS_ADMIN )

local function meCheck( ply, strText, bPublic )
	if ply.gimp then return end -- Don't mess

	if strText:sub( 1, 4 ) == "/me " then
		strText = string.format( "*** %s %s", ply:Nick(), strText:sub( 5 ) )
		if bPublic then
			ULib.tsay( _, strText )
		else
			strText = "(TEAM) " .. strText
			local teamid = ply:Team()
			local players = team.GetPlayers( teamid )
			for _, ply2 in ipairs( players ) do
				ULib.tsay( ply2, strText )
			end
		end

		if isDedicatedServer() then
			Msg( strText .. "\n" ) -- Log to console
		end
		if util.tobool( GetConVarNumber( "ulx_logChat" ) ) then
			ulx.logString( strText )
		end

		return ""
	end
end
hook.Add( "PlayerSay", "ULXMeCheck", meCheck, -18 ) -- Extremely low priority

local function showWelcome( ply )
	local message = GetConVarString( "ulx_welcomemessage" )
	if not message or message == "" then return end

	message = string.gsub( message, "%%curmap%%", game.GetMap() )
	message = string.gsub( message, "%%host%%", GetConVarString( "hostname" ) )
	message = string.gsub( message, "%%ulx_version%%", ulx.getVersion() )

	ply:ChatPrint( message ) -- We're not using tsay because ULib might not be loaded yet. (client side)
end
hook.Add( "PlayerInitialSpawn", "ULXWelcome", showWelcome )
ulx.convar( "welcomemessage", "", "<msg> - This is shown to players on join.", ULib.ACCESS_ADMIN )