ulx.convar( "logEcho", "2", "", ULib.ACCESS_NONE )
ulx.convar( "logFile", "1", "", ULib.ACCESS_NONE )
ulx.convar( "logEvents", "1", "", ULib.ACCESS_NONE )
ulx.convar( "logChat", "1", "", ULib.ACCESS_NONE )
ulx.convar( "logSpawns", "1", "", ULib.ACCESS_NONE )
ulx.convar( "logSpawnsEcho", "1", "", ULib.ACCESS_NONE )
ulx.convar( "logDir", "ulx_logs", "", ULib.ACCESS_NONE )

local hiddenechoAccess = "ulx hiddenecho"
ULib.ucl.registerAccess( hiddenechoAccess, ULib.ACCESS_SUPERADMIN ) -- Give superadmins access to see hidden echoes by default

local spawnechoAccess = "ulx spawnecho"
ULib.ucl.registerAccess( spawnechoAccess, ULib.ACCESS_ADMIN ) -- Give admins access to see spawn echoes by default

local curDay -- This will hold the day we think it is right now.

-- Utility stuff for our logs...
ulx.log_file = nil
local function init()
	curDay = os.date( "%d" )
	if util.tobool( GetConVarNumber( "ulx_logFile" ) ) then
		ulx.log_file = os.date( GetConVarString( "ulx_logDir" ) .. "/" .. "%m-%d-%y" .. ".txt" )
		if not file.Exists( ulx.log_file ) then
			file.Write( ulx.log_file, "" )
		else
			ulx.logWriteln( "\n\n" ) -- Make some space
		end
		ulx.logString( "New map: " .. game.GetMap() )
	end
end
ulx.OnDoneLoading( init ) -- So we load the settings first

local function next_log()
	if util.tobool( GetConVarNumber( "ulx_logFile" ) ) then
		local new_log = os.date( GetConVarString( "ulx_logDir" ) .. "/" .. "%m-%d-%y" .. ".txt" )
		if new_log == ulx.log_file then -- Make sure the date has changed.
			return
		end
		local old_log = ulx.log_file
		ulx.logWriteln( "<Logging continued in \"" .. new_log .. "\">" )
		ulx.log_file = new_log
		file.Write( ulx.log_file, "" )
		ulx.logWriteln( "<Logging continued from \"" .. old_log .. "\">" )
	end
	curDay = os.date( "%d" )
end

function ulx.logUserAct( ply, target, action, hide_echo )
	local nick
	if ply:IsValid() then
		if not ply:IsConnected() or not target:IsConnected() then return end
		nick = ply:Nick()
	else
		nick = "(Console)"
	end

	action = action:gsub( "#T", target:Nick(), 1 ) -- Everything needs this replacement
	local level = GetConVarNumber( "ulx_logEcho" )

	if not hide_echo and level > 0 then
		local echo
		if level == 1 then
			echo = action:gsub( "#A", "(ADMIN)", 1 )
		elseif level == 2 then
			echo = action:gsub( "#A", "(ADMIN) " .. nick, 1 )
		end
		ULib.tsay( _, echo, true )
	elseif level > 0 then
		local echo = action:gsub( "#A", "(SILENT)(ADMIN) " .. nick, 1 )
		ULib.tsay( ply, echo, true ) -- Whether or not the originating player has access, they're getting the echo.
		
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if ULib.ucl.query( player, hiddenechoAccess ) and player ~= ply then
				ULib.tsay( player, echo, true )
			end
		end
	end
	
	if isDedicatedServer() then
		Msg( action:gsub( "#A", "(ADMIN) " .. nick, 1 ) .. "\n" )
	end

	if util.tobool( GetConVarNumber( "ulx_logFile" ) ) then
		ulx.logString( action:gsub( "#A", "(ADMIN) " .. nick, 1 ) )
	end
end

function ulx.logServAct( ply, action, hide_echo )
	local nick
	if ply:IsValid() then
		if not ply:IsConnected() then return end
		nick = ply:Nick()
	else
		nick = "(Console)"
	end
	
	local level = GetConVarNumber( "ulx_logEcho" )
	
	if not hide_echo and level > 0 then
		local echo
		if level == 1 then
			echo = action:gsub( "#A", "(ADMIN)", 1 )
		elseif level == 2 then
			echo = action:gsub( "#A", "(ADMIN) " .. nick, 1 )
		end
		ULib.tsay( _, echo, true )
	elseif level > 0 then
		local echo = action:gsub( "#A", "(SILENT)(ADMIN) " .. nick, 1 )
		ULib.tsay( ply, echo, true ) -- Whether or not the originating player has access, they're getting the echo.
		
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if ULib.ucl.query( player, hiddenechoAccess ) and player ~= ply then
				ULib.tsay( player, echo, true )
			end
		end
	end
	
	if isDedicatedServer() then
		Msg( action:gsub( "#A", "(ADMIN) " .. nick, 1 ) .. "\n" )
	end

	if util.tobool( GetConVarNumber( "ulx_logFile" ) ) then
		ulx.logString( action:gsub( "#A", "(ADMIN) " .. nick, 1 ) )
	end
end

function ulx.logString( str )
	if not ulx.log_file then return end

	local date = os.date( "*t" )
	if curDay ~= date.day then
		next_log()
	end

	ulx.logWriteln( string.format( "[%02i:%02i:%02i]", date.hour, date.min, date.sec ) .. str )
end

function ulx.logWriteln( str )
	if not ulx.log_file then return end
	
	if util.tobool( GetConVarNumber( "ulx_logFile" ) ) and ulx.log_file then
		file.Write( ulx.log_file, file.Read( ulx.log_file ) .. str .. "\n" )
	end
end

local function playerSay( ply, text, public )
	if util.tobool( GetConVarNumber( "ulx_logChat" ) ) then
		if not public then
			ulx.logString( string.format( "(TEAM) %s: %s", ply:Nick(), text ) )
		else
			ulx.logString( string.format( "%s: %s", ply:Nick(), text ) )
		end
	end
	return nil
end
hook.Add( "PlayerSay", "ULXLogSay", playerSay, 20 )

local function playerConnect( name, address, steamid )
	if util.tobool( GetConVarNumber( "ulx_logEvents" ) ) then
		ulx.logString( string.format( "Client \"%s\" connected (%s).", name, address ) )
	end
end
hook.Add( "PlayerConnect", "ULXLogConnect", playerConnect, -20 )

local function playerInitialSpawn( ply )
	if util.tobool( GetConVarNumber( "ulx_logEvents" ) ) then
		ulx.logString( string.format( "Client \"%s\" spawned in server (%s)<%s>.", ply:Nick(), ply:IPAddress(), ply:SteamID() ) )
	end
end
hook.Add( "PlayerInitialSpawn", "ULXLogInitialSpawn", playerInitialSpawn, -20 )

local function playerDisconnect( ply )
	if util.tobool( GetConVarNumber( "ulx_logEvents" ) ) then
		ulx.logString( string.format( "Dropped \"%s\" from server", ply:Nick() ) )
	end
end
hook.Add( "PlayerDisconnected", "ULXLogDisconnect", playerDisconnect, -20 )

local function playerDeath( victim, weapon, killer )
	if util.tobool( GetConVarNumber( "ulx_logEvents" ) ) then
		if not killer:IsPlayer() then
			ulx.logString( string.format( "%s was killed by %s", victim:Nick(), killer:GetClass() ) )
		else
			if victim ~= killer then
				ulx.logString( string.format( "%s killed %s using %s", killer:Nick(), victim:Nick(), weapon:GetClass() ) )
			else
				ulx.logString( string.format( "%s suicided!", victim:Nick() ) )
			end
		end
	end
end
hook.Add( "PlayerDeath", "ULXLogDeath", playerDeath, -20 )

-- Check name changes
local function nameCheck( ply, oldnick, newnick )
	if util.tobool( GetConVarNumber( "ulx_logEvents" ) ) then
		ulx.logString( string.format( "%s<%s> changed their name to %s", oldnick, ply:SteamID(), newnick ) )
	end
end
hook.Add( "ULibPlayerNameChanged", "ULXNameChange", nameCheck )

local function shutDown()
	if util.tobool( GetConVarNumber( "ulx_logEvents" ) ) then
		ulx.logString( "Server is shutting down/changing levels." )
	end
end
hook.Add( "ShutDown", "ULXLogShutDown", shutDown, -20 )

function ulx.logSpawn( txt )
	if isDedicatedServer() then
		Msg( txt .. "\n" )
	end


	if util.tobool( GetConVarNumber( "ulx_logSpawns" ) ) then
		ulx.logString( txt )
	end

	if GetConVarNumber( "ulx_logSpawnsEcho" ) == 1 then
		local players = player.GetAll()
		for _, ply in ipairs( players ) do
			if ULib.ucl.query( ply, spawnechoAccess ) then
				ULib.console( ply, txt )
			end
		end

	elseif GetConVarNumber( "ulx_logSpawnsEcho" ) == 2 then -- All players
		ULib.console( _, txt )
	end
end

local function propSpawn( ply, model, ent )
	ulx.logSpawn( string.format( "%s<%s> spawned model %s", ply:Nick(), ply:SteamID(), ulx.standardizeModel( model ) ) )
end
hook.Add( "PlayerSpawnedProp", "ULXLogPropSpawn", propSpawn, 20 )

local function ragdollSpawn( ply, model, ent )
	ulx.logSpawn( string.format( "%s<%s> spawned ragdoll %s", ply:Nick(), ply:SteamID(), ulx.standardizeModel( model ) ) )
end
hook.Add( "PlayerSpawnedRagdoll", "ULXLogRagdollSpawn", ragdollSpawn, 20 )

local function effectSpawn( ply, model, ent )
	ulx.logSpawn( string.format( "%s<%s> spawned effect %s", ply:Nick(), ply:SteamID(), ulx.standardizeModel( model ) ) )
end
hook.Add( "PlayerSpawnedEffect", "ULXLogEffectSpawn", effectSpawn, 20 )

local function vehicleSpawn( ply, ent )
	ulx.logSpawn( string.format( "%s<%s> spawned vehicle %s", ply:Nick(), ply:SteamID(), ulx.standardizeModel( ent:GetModel() ) ) )
end
hook.Add( "PlayerSpawnedVehicle", "ULXLogVehicleSpawn", vehicleSpawn, 20 )

local function sentSpawn( ply, ent )
	ulx.logSpawn( string.format( "%s<%s> spawned sent %s", ply:Nick(), ply:SteamID(), ent:GetClass() ) )
end
hook.Add( "PlayerSpawnedSENT", "ULXLogSentSpawn", sentSpawn, 20 )

-- Thanks Kyzer!
local function NPCSpawn( ply, ent )
	ulx.logSpawn( string.format( "%s<%s> spawned NPC %s", ply:Nick(), ply:SteamID(), ent:GetClass() ) )
end
hook.Add( "PlayerSpawnedNPC", "ULXLogNPCSpawn",NPCSpawn )
