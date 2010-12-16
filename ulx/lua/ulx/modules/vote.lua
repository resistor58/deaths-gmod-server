ulx.setCategory( "Voting" )

---------------
--Public vote--
---------------
ulx.convar( "voteEcho", "0", _, ULib.ACCESS_NONE ) -- Echo votes?

-- First, our helper function to make voting so much easier!
local voteInProgress
function ulx.doVote( title, options, callback, timeout, filter, noecho, ... )
	timeout = timeout or 20
	if voteInProgress then
		Msg( "Error! ULX tried to start a vote when another vote was in progress!\n" )
		return
	end

	if not options[ 1 ] or not options[ 2 ] then
		Msg( "Error! ULX tried to start a vote without at least two options!\n" )
		return
	end

	local voters = 0
	local rp = RecipientFilter()
	if not filter then
		rp:AddAllPlayers()
		voters = #player.GetAll()
	else
		for _, ply in ipairs( filter ) do
			rp:AddPlayer( ply )
			voters = voters + 1
		end
	end

	umsg.Start( "ulx_vote", rp )
		umsg.String( title )
		umsg.Short( timeout )
		ULib.umsgSend( options )
	umsg.End()

	voteInProgress = { callback=callback, options=options, title=title, results={}, voters=voters, votes=0, noecho=noecho, args={...} }

	timer.Create( "ULXVoteTimeout", timeout, 1, ulx.voteDone )
end

function ulx.voteCallback( ply, command, argv )
	if not voteInProgress then
		ULib.tsay( ply, "There is not a vote in progress" )
		return
	end

	if not argv[ 1 ] or not tonumber( argv[ 1 ] ) or not voteInProgress.options[ tonumber( argv[ 1 ] ) ] then
		ULib.tsay( ply, "Invalid or out of range vote." )
		return
	end

	if ply.ulxVoted then
		ULib.tsay( ply, "You have already voted!" )
		return
	end

	local echo = util.tobool( GetConVarNumber( "ulx_voteEcho" ) )
	local id = tonumber( argv[ 1 ] )
	voteInProgress.results[ id ] = voteInProgress.results[ id ] or 0
	voteInProgress.results[ id ] = voteInProgress.results[ id ] + 1

	voteInProgress.votes = voteInProgress.votes + 1

	ply.ulxVoted = true -- Tag them as having voted

	local str = ply:Nick() .. " voted for: " .. voteInProgress.options[ id ]
	if echo and not voteInProgress.noecho then
		ULib.tsay( _, str )
	end
	ulx.logString( str )
	if isDedicatedServer() then Msg( str .. "\n" ) end

	if voteInProgress.votes >= voteInProgress.voters then
		timer.Destroy( "ULXVoteTimeout" )
		ulx.voteDone()
	end
end
concommand.Add( "ulx_vote", ulx.voteCallback )

function ulx.voteDone()
	local players = player.GetAll()
	for _, ply in ipairs( players ) do -- Clear voting tags
		ply.ulxVoted = nil
	end

	local vip = voteInProgress
	voteInProgress = nil
	PCallError( vip.callback, vip, unpack( vip.args ) )
end
-- End our helper functions





local function voteDone( t )
	local results = t.results
	local winner
	local winnernum = 0
	for id, numvotes in pairs( results ) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	local str
	if not winner then
		str = "Vote results: No option won because no one voted!"
	else
		str = "Vote results: Option '" .. t.options[ winner ] .. "' won. (" .. winnernum .. "/" .. t.voters .. ")"
	end
	ULib.tsay( _, str )
	ulx.logString( str )
	Msg( str .. "\n" )
end

function ulx.cc_vote( ply, command, argv, args )
	if #argv < 3 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end
	
	if voteInProgress then
		ULib.tsay( ply, "There is already a vote in progress. Please wait for the current one to end.", true )
		return
	end	

	local title = argv[ 1 ]
	table.remove( argv, 1 )
	ulx.doVote( title, argv, voteDone )
	ulx.logServAct( ply, "#A started a vote." )
end
ulx.concommand( "vote", ulx.cc_vote, "<title> <option1> <option2> [<option3>] .. - Starts a public vote.", ULib.ACCESS_ADMIN, "!vote", _, ulx.ID_HELP )



local function voteMapDone2( t, changeTo, ply )
	local shouldChange = false

	if t.results[ 1 ] and t.results[ 1 ] > 0 then
		ulx.logServAct( ply, "#A approved the votemap" )
		shouldChange = true
	else
		ulx.logServAct( ply, "#A denied the votemap" )
	end

	if shouldChange then
		ULib.consoleCommand( "changelevel " .. changeTo .. "\n" )
	end
end

local function voteMapDone( t, argv, ply )
	local results = t.results
	local winner
	local winnernum = 0
	for id, numvotes in pairs( results ) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	local ratioNeeded = GetConVarNumber( "ulx_votemap2Successratio" )
	local minVotes = GetConVarNumber( "ulx_votemap2Minvotes" )
	local str
	local changeTo
	if (#argv < 2 and winner ~= 1) or not winner or winnernum < minVotes or winnernum / t.voters < ratioNeeded then
		str = "Vote results: Vote was unsuccessful."
	else
		str = "Vote results: Option '" .. t.options[ winner ] .. "' won, changemap pending admin approval. (" .. winnernum .. "/" .. t.voters .. ")"

		-- Figure out the map to change to.
		if #argv > 1 then
			changeTo = t.options[ winner ]
		else
			changeTo = argv[ 1 ]
		end

		ulx.doVote( "Accept result and changemap to " .. changeTo .. "?", { "Yes", "No" }, voteMapDone2, _, { ply }, true, changeTo, ply )
	end
	ULib.tsay( _, str )
	ulx.logString( str )
	if isDedicatedServer() then Msg( str .. "\n" ) end
end

function ulx.cc_votemap2( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end
	
	if voteInProgress then
		ULib.tsay( ply, "There is already a vote in progress. Please wait for the current one to end.", true )
		return
	end		

	local maplist = "" -- We'll use this in the log
	for id, map in ipairs( argv ) do
		if string.sub( map, -4 ) == ".bsp" then
			map = string.sub( map, 1, -5 ) -- Take off the .bsp
			argv[ id ] = map
		end
		maplist = maplist .. map .. ", "

		if not file.Exists( "../maps/" .. map .. ".bsp" ) then
			ULib.tsay( ply, "Map " .. map .. " does not exist. Aborting command.", true )
			return
		end
	end

	if #argv > 1 then
		ulx.doVote( "Change map to..", argv, voteMapDone, _, _, _, argv, ply )
	else
		ulx.doVote( "Change map to " .. argv[ 1 ] .. "?", { "Yes", "No" }, voteMapDone, _, _, _, argv, ply )
	end
	ulx.logServAct( ply, "#A started a votemap." )
end
ulx.concommand( "votemap2", ulx.cc_votemap2, "<map1> [<map2>] [<map3>] .. - Starts a public map vote.", ULib.ACCESS_ADMIN, "!votemap2", _, ulx.ID_HELP )
ulx.convar( "votemap2Successratio", "0.5", _, ULib.ACCESS_NONE ) -- The ratio needed for a votemap2 to succeed
ulx.convar( "votemap2Minvotes", "3", _, ULib.ACCESS_NONE ) -- Minimum votes needed for votemap2



local function voteKickDone2( t, target, time, ply )
	local shouldKick = false

	if t.results[ 1 ] and t.results[ 1 ] > 0 then
		ulx.logUserAct( ply, target, "#A approved the votekick against #T" )
		shouldKick = true
	else
		ulx.logUserAct( ply, target, "#A denied the votekick against #T" )
	end

	if shouldKick then
		ULib.kick( target, "Vote kick successful." )
	end
end

local function voteKickDone( t, target, time, ply )
	local results = t.results
	local winner
	local winnernum = 0
	for id, numvotes in pairs( results ) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	local ratioNeeded = GetConVarNumber( "ulx_votekickSuccessratio" )
	local minVotes = GetConVarNumber( "ulx_votekickMinvotes" )
	local str
	if winner ~= 1 or winnernum < minVotes or winnernum / t.voters < ratioNeeded then
		str = "Vote results: User will not be kicked. (" .. (results[ 1 ] or "0") .. "/" .. t.voters .. ")"
	else
		str = "Vote results: User will now be kicked, pending admin approval. (" .. winnernum .. "/" .. t.voters .. ")"
		ulx.doVote( "Accept result and kick " .. target:Nick() .. "?", { "Yes", "No" }, voteKickDone2, _, { ply }, true, target, time, ply )
	end

	ULib.tsay( _, str )
	ulx.logString( str )
	if isDedicatedServer() then Msg( str .. "\n" ) end
end

function ulx.cc_votekick( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	if voteInProgress then
		ULib.tsay( ply, "There is already a vote in progress. Please wait for the current one to end.", true )
		return
	end		
	
	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	ulx.doVote( "Kick " .. target:Nick() .. "?", { "Yes", "No" }, voteKickDone, _, _, _, target, time, ply )
	ulx.logUserAct( ply, target, "#A started a votekick against #T." )
end
ulx.concommand( "votekick", ulx.cc_votekick, "<user> - Starts a public kick vote.", ULib.ACCESS_ADMIN, "!votekick", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Votekick", "ulx votekick" )
ulx.convar( "votekickSuccessratio", "0.6", _, ULib.ACCESS_NONE ) -- The ratio needed for a votekick to succeed
ulx.convar( "votekickMinvotes", "2", _, ULib.ACCESS_NONE ) -- Minimum votes needed for votekick



local function voteBanDone2( t, target, time, ply )
	local shouldBan = false

	if t.results[ 1 ] and t.results[ 1 ] > 0 then
		ulx.logUserAct( ply, target, "#A approved the voteban against #T (" .. time .. " minutes)" )
		shouldBan = true
	else
		ulx.logUserAct( ply, target, "#A denied the voteban against #T" )
	end

	if shouldBan then
		ULib.ban( target, time )
		ULib.kick( target, "Vote ban successful." )
	end
end

local function voteBanDone( t, target, time, ply )
	local results = t.results
	local winner
	local winnernum = 0
	for id, numvotes in pairs( results ) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end

	local ratioNeeded = GetConVarNumber( "ulx_votebanSuccessratio" )
	local minVotes = GetConVarNumber( "ulx_votebanMinvotes" )
	local str
	if winner ~= 1 or winnernum < minVotes or winnernum / t.voters < ratioNeeded then
		str = "Vote results: User will not be banned. (" .. (results[ 1 ] or "0") .. "/" .. t.voters .. ")"
	else
		str = "Vote results: User will now be banned for " .. time .. " minutes, pending admin approval. (" .. winnernum .. "/" .. t.voters .. ")"
		ulx.doVote( "Accept result and ban " .. target:Nick() .. "?", { "Yes", "No" }, voteBanDone2, _, { ply }, true, target, time, ply )
	end

	ULib.tsay( _, str )
	ulx.logString( str )
	Msg( str .. "\n" )
end

function ulx.cc_voteban( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end
	
	if voteInProgress then
		ULib.tsay( ply, "There is already a vote in progress. Please wait for the current one to end.", true )
		return
	end		

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	local time = 1440
	if argv[ 2 ] then
		time = tonumber( argv[ 2 ] )

		if not time then
			ULib.tsay( ply, "Invalid number for time!", true )
			return
		end
	end

	ulx.doVote( "Ban " .. target:Nick() .. " for " .. time .. " minutes?", { "Yes", "No" }, voteBanDone, _, _, _, target, time, ply )
	ulx.logUserAct( ply, target, "#A started a voteban of " .. time .. " minutes against #T." )
end
ulx.concommand( "voteban", ulx.cc_voteban, "<user> [<time>] - Starts a ban vote for x mins. Defaults to a day.", ULib.ACCESS_ADMIN, "!voteban", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Voteban", "ulx voteban" )
ulx.convar( "votebanSuccessratio", "0.7", _, ULib.ACCESS_NONE ) -- The ratio needed for a voteban to succeed
ulx.convar( "votebanMinvotes", "3", _, ULib.ACCESS_NONE ) -- Minimum votes needed for voteban
