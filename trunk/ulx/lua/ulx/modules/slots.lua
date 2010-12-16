-- This file handles reserved slots
ulx.setCategory( "Reserved Slots" )

ulx.convar( "rslotsMode", "0", " - Sets the slots mode. See server.ini for more information.", ULib.ACCESS_ADMIN )
ulx.convar( "rslots", "2", " - Sets the number of reserved slots, only applicable for modes 1 and 2.", ULib.ACCESS_ADMIN )
ulx.convar( "rslotsVisible", "1", " - Sets whether slots are visible. See server.ini for more information.", ULib.ACCESS_ADMIN )

local access = "ulx reservedslots" -- Access string needed for reserved slots
ULib.ucl.registerAccess( access, ULib.ACCESS_ADMIN ) -- Give admins access to reserved slots by default

function calcSlots( disconnect )
	local mode = GetConVarNumber( "ulx_rslotsMode" )
	if mode == 3 then return 1 end -- Only one slot on this mode

	local slots = GetConVarNumber( "ulx_rslots" )
	if mode == 2 then return slots end

	if mode == 1 then
		local admins = 0 -- Keep track of how many people with access we have

		local players = player.GetAll()
		for _, player in ipairs( players ) do
			if player:IsConnected() and player:query( access ) then
				admins = admins + 1
			end
		end

		if disconnect then admins = admins - 1 end -- Otherwise we're counting the disconnecting admin
		if admins < 0 then admins = 0 end -- Just to be safe!

		local rslots = slots - admins
		if rslots < 0 then rslots = 0 end -- If we have more admins right now then slots for them, we don't want to return a negative number.
		return rslots
	end

	return 0 -- We're actually having an error if we get here, but let's handle it gracefully
end

local function updateSlots( ply, disconnect )
	local visible = util.tobool( GetConVarString( "ulx_rslotsVisible" ) )
	if not visible then -- Make sure our visible slots is up to date
		local slots = calcSlots( disconnect )
		local max = MaxPlayers()
		game.ConsoleCommand( "sv_visiblemaxplayers " .. max - slots .. "\n" )
	end
end
hook.Add( "PlayerDisconnected", "ulxSlotsDisconnect", function( ply ) updateSlots( ply, ply:query( access ) ) end )
ulx.OnDoneLoading( updateSlots )

local function playerAccess( ply )
	local mode = GetConVarNumber( "ulx_rslotsMode" )
	if mode == 0 then return end -- Off!

	local visible = util.tobool( GetConVarString( "ulx_rslotsVisible" ) )
	local slots = calcSlots()
	local cur = #player.GetAll()
	local max = MaxPlayers()

	if ply:query( access ) then -- If they have access, handle this differently
		if not visible then -- Make sure our visible slots is up to date
			updateSlots()
		end

		if mode == 3 and cur + slots > max then -- We've got some kicking to do!
			local shortestply
			local shortesttime = 0

			local players = player.GetAll()
			for _, player in ipairs( players ) do
				if not ULib.ucl.query( player, access ) and not ULib.ucl.query( player, ULib.ACCESS_IMMUNITY ) then
					if player.Created > shortesttime then
						shortesttime = player.Created
						shortestply = player
					end
				end
			end

			if not shortestply then -- We've got a server filled to the brim with admins? Odd but okay
				return
			end

			ULib.kick( shortestply, "[ULX] Freeing slot. Sorry, you had the shortest connection time." )
		end

		return
	end

	if cur + slots > max then
		timer.Simple( FrameTime() * 0.5, ULib.kick, ply, "[ULX] Reserved slot, sorry!" ) -- Wait a frame so all access hooks can be called properly.
	end
end
ULib.ucl.addAccessCallback( playerAccess )