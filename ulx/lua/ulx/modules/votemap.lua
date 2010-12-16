ulx.setCategory( "Voting" )

------------------
--Public votemap--
------------------
ulx.votemaps = {}
local specifiedMaps = {}

local function init()
	local mode = GetConVarNumber( "ulx_votemapMapmode" ) or 1
	if mode == 1 then -- Add all but specified
		local maps = file.Find( "../maps/*.bsp" )
		for _, map in ipairs( maps ) do
			map = map:sub( 1, -5 ) -- Take off .bsp
			if not specifiedMaps[ map ] then
				table.insert( ulx.votemaps, map )
			end
		end
	else
		for map, _ in pairs( specifiedMaps ) do
			if file.Exists( "../maps/" .. map .. ".bsp" ) then
				table.insert( ulx.votemaps, map )
			end
		end
	end

	-- Now, let's sort!
	table.sort( ulx.votemaps )
end
ulx.OnDoneLoading( init ) -- Time for configs

local userMapvote = {} -- Indexed by player.
local mapvotes = {} -- Indexed by map.
local timedVeto = nil

ulx.convar( "votemapEnabled", "1", _, ULib.ACCESS_NONE ) -- Enable/Disable the entire votemap command
ulx.convar( "votemapMintime", "10", _, ULib.ACCESS_NONE ) -- Time after map change before votes count.
ulx.convar( "votemapWaittime", "5", _, ULib.ACCESS_NONE ) -- Time before a user must wait before they can change their vote.
ulx.convar( "votemapSuccessratio", "0.5", _, ULib.ACCESS_NONE ) -- Ratio of (votes for map)/(total players) needed to change map. (Rounds up)
ulx.convar( "votemapMinvotes", "3", _, ULib.ACCESS_NONE ) -- Number of minimum votes needed to change map (Prevents llamas). This supercedes the above convar on small servers.
ulx.convar( "votemapVetotime", "30", _, ULib.ACCESS_NONE ) -- Time in seconds an admin has after a successful votemap to veto the vote. Set to 0 to disable.
ulx.convar( "votemapMapmode", "1", _, ULib.ACCESS_NONE ) -- 1 = Use all maps but what's specified below, 2 = Use only the maps specified below.

function ulx.cc_votemapVeto( ply, command, argv, args )
	if not timedVeto then
		ULib.tsay( ply, "There's nothing to veto!", true )
		return
	end

	timer.Destroy( "ULXVotemap" )
	timedVeto = false
	ULib.tsay( _, "Votemap changelevel halted.", true )
	ulx.logServAct( ply, "#A vetoed the votemap" )
end
ulx.concommand( "veto", ulx.cc_votemapVeto, "- This lets you halt a votemap changelevel.", ULib.ACCESS_ADMIN, "!veto", _, ulx.ID_HELP )

function ulx.cc_votemapAddmap( ply, command, argv, args )
	local map = argv[ 1 ]
	if string.sub( map, -4 ) == ".bsp" then
		map = string.sub( map, 1, -5 ) -- Take off the .bsp
	end

	specifiedMaps[ map ] = true
end
ulx.concommand( "votemapAddmap", ulx.cc_votemapAddmap, "", ULib.ACCESS_NONE )

function ulx.cc_votemap( ply, command, argv, args )
	if not util.tobool( GetConVarNumber( "ulx_votemapEnabled" ) ) then
		ULib.tsay( ply, "The votemap command has been disabled by a server admin.", true )
		return
	end

	if not ply:IsValid() then
		Msg( "You can't use votemap from the dedicated server console.\n" )
		return
	end

	if timedVeto then
		ULib.tsay( ply, "You cannot vote right now, another map has already won and is pending approval.", true )
		return
	end

	if #argv < 1 then
		ULib.console( ply, "Use \"votemap <id>\" to vote for a map. Map list:" )
		for id, map in ipairs( ulx.votemaps ) do
			ULib.console( ply, "  " .. id .. " -\t" .. map )
		end
		return
	end

	local mintime = tonumber( GetConVarString( "ulx_votemapMintime" ) ) or 10
	if CurTime() < mintime * 60 then -- Minutes -> seconds
		ULib.tsay( ply, "Sorry, you must wait " .. mintime .. " minutes after a map change before you can vote for another map.", true )
		ULib.tsay( ply, "That means you must wait " .. string.FormattedTime( mintime*60 - CurTime(), "%02i:%02i" ) .. " more minutes.", true )
		return
	end

	if userMapvote[ ply ] then
		local waittime = tonumber( GetConVarString( "ulx_votemapWaittime" ) ) or 5
		if CurTime() - userMapvote[ ply ].time < waittime * 60 then -- Minutes -> seconds
			ULib.tsay( ply, "Sorry, you must wait " .. waittime .. " minutes before changing your vote.", true )
			ULib.tsay( ply, "That means you must wait " .. string.FormattedTime( waittime*60 - (CurTime() - userMapvote[ ply ].time), "%02i:%02i" ) .. " more minutes.", true )
			return
		end
	end


	local mapid
	if tonumber( argv[ 1 ] ) then
		mapid = tonumber( argv[ 1 ] )
		if not ulx.votemaps[ mapid ] then
			ULib.tsay( ply, "Invalid map id!", true )
			return
		end
	else
		local map = argv[ 1 ]
		if string.sub( map, -4 ) == ".bsp" then
			map = string.sub( map, 1, -5 ) -- Take off the .bsp
		end

		mapid = ULib.findInTable( ulx.votemaps, map )
		if not mapid then
			ULib.tsay( ply, "Invalid map!", true )
			return
		end
	end

	if userMapvote[ ply ] then -- Take away from their previous vote
		mapvotes[ userMapvote[ ply ].mapid ] = mapvotes[ userMapvote[ ply ].mapid ] - 1
	end

	userMapvote[ ply ] = { mapid=mapid, time=CurTime() }
	mapvotes[ mapid ] = mapvotes[ mapid ] or 0
	mapvotes[ mapid ] = mapvotes[ mapid ] + 1

	local minvotes = tonumber( GetConVarString( "ulx_votemapMinvotes" ) ) or 0
	local successratio = tonumber( GetConVarString( "ulx_votemapSuccessratio" ) ) or 0.5

	local votes_needed = math.ceil( math.max( minvotes, successratio * #player.GetAll() ) ) -- Round up whatever the largest is.

	ULib.tsay( _, string.format( "%s voted for %s (%i/%i). Say \"!votemap %i\" to vote for this map too.", ply:Nick(), ulx.votemaps[ mapid ], mapvotes[ mapid ], votes_needed, mapid ), true )
	ulx.logString( string.format( "%s voted for %s (%i/%i)", ply:Nick(), ulx.votemaps[ mapid ], mapvotes[ mapid ], votes_needed ) )

	if mapvotes[ mapid ] >= votes_needed then
		local vetotime = tonumber( GetConVarString( "ulx_votemapVetotime" ) ) or 30

		local admins = {}
		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() then
				if ULib.ucl.query( player, "ulx veto" ) then
					table.insert( admins, player )
				end
			end
		end

		if #admins <= 0 or vetotime < 1 then
			ULib.tsay( _, "Vote for map " .. ulx.votemaps[ mapid ] .. " successful! Changing levels now.", true )
			ulx.logString( "Votemap for " .. ulx.votemaps[ mapid ] .. " won." )
			game.ConsoleCommand( "changelevel " .. ulx.votemaps[ mapid ] .. "\n" )
		else
			ULib.tsay( _, "Vote for map " .. ulx.votemaps[ mapid ] .. " successful! Now pending admin approval. (" .. vetotime .. " seconds)", true )
			for _, player in ipairs( admins ) do
				ULib.tsay( player, "To veto this vote, just say \"!veto\"", true )
			end
			ulx.logString( "Votemap for " .. ulx.votemaps[ mapid ] .. " won. Pending admin veto." )
			timedVeto = true
			timer.Create( "ULXVotemap", vetotime, 1, game.ConsoleCommand, "changelevel " .. ulx.votemaps[ mapid ] .. "\n" )
		end
	end
end
ulx.concommand( "votemap", ulx.cc_votemap, "[<map name or id>] - Vote for a map. No args lists available maps.", ULib.ACCESS_ALL, "!votemap", _, ulx.ID_HELP )

function ulx.votemap_disconnect( ply ) -- We use this to clear out old people's votes
	if userMapvote[ ply ] then -- Take away from their previous vote
		mapvotes[ userMapvote[ ply ].mapid ] = mapvotes[ userMapvote[ ply ].mapid ] - 1
		userMapvote[ ply ] = nil
	end
end
hook.Add( "PlayerDisconnected", "ULXVoteDisconnect", ulx.votemap_disconnect )
