-- Load our configs
local starttime = 0

local function init()	
	-- Load our banned users
	if file.Exists( "../cfg/banned_user.cfg" ) then
		ULib.execFile( "../cfg/banned_user.cfg" )
	end
	
	for category, data in pairs( ulx.help ) do
		table.sort( data, function (a,b) -- Sort our help
			return (a.cmd < b.cmd)
		end )
	end
	
	for category, data in pairs( ulx.convarhelp ) do
		table.sort( data, function (a,b) -- Sort our help
			return (a.cmd < b.cmd)
		end )
	end
	
	starttime = RealTime()
end
hook.Add( "Initialize", "ULXInitialize", init )

-- We're setting up our own mini-timer here to run the configs because ded server timers don't start until a player joins.
local function doCfg()
	if starttime > 0 and RealTime() - starttime < 5 then return end -- Not enough time yet.
	
	if not file.Exists( "../cfg/server.ini" ) then
		Msg( "[ULX] ERROR: The server.ini file is missing!\n" )
	else
		ULib.execFile( "../cfg/server.ini" )
	end
	
	-- Per gamemode config
	if file.Exists( "../cfg/gamemodes/" .. GAMEMODE.Name:lower() .. ".ini" ) then
		ULib.execFile( "../cfg/gamemodes/" .. GAMEMODE.Name:lower() .. ".ini" )
	end
	
	-- Per map config
	if file.Exists( "../cfg/maps/" .. game.GetMap() .. ".ini" ) then
		ULib.execFile( "../cfg/maps/" .. game.GetMap() .. ".ini" )
	end	
	
	timer.Simple( FrameTime() * 0.5, ulx.DoDoneCallbacks ) -- We're done loading! Wait a tick so the configs load.
	
	if isDedicatedServer() then
		hook.Remove( "Think", "ULXDoCfg" )
	else
		hook.Remove( "ULibPlayerULibLoaded", "ULXDoCfg" )
	end
end
if isDedicatedServer() then
	hook.Add( "Think", "ULXDoCfg", doCfg )
else
	hook.Add( "ULibPlayerULibDoneLoading", "ULXDoCfg", doCfg, 20 )
end