ulx.setCategory( "Teleport" )

-- Utility function for bring goto and send
local function playerSend( from, to, force )
	if not to:IsInWorld() and not force then return false end -- No way we can do this one

	local yawForward = to:EyeAngles().yaw
	local directions = { -- Directions to try
		math.NormalizeAngle( yawForward - 180 ), -- Behind first
		math.NormalizeAngle( yawForward + 90 ), -- Right
		math.NormalizeAngle( yawForward - 90 ), -- Left
		yawForward,
	}

	local t = {}
	t.start = to:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
	t.filter = { to, from }

	local i = 1
	t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
	local tr = util.TraceEntity( t, from )
    while tr.Hit do -- While it's hitting something, check other angles
    	i = i + 1
    	if i > #directions then  -- No place found
			if force then
				return to:GetPos() + Angle( 0, directions[ 1 ], 0 ):Forward() * 47
			else
				return false
			end
		end

		t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47

		tr = util.TraceEntity( t, from )
    end

	return tr.HitPos
end

function ulx.cc_bring( ply, command, argv, args )
	if not ply:IsValid() then
		Msg( "You can't use this from a dedicated console!\n" )
		return
	end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	if target == ply then
		ULib.tsay( ply, "You can't bring yourself!", true )
		return
	end

	if ulx.getExclusive( ply, ply ) then
		ULib.tsay( ply, ulx.getExclusive( ply, ply ), true )
		return
	end

	if ulx.getExclusive( target, ply ) then
		ULib.tsay( ply, ulx.getExclusive( target, ply ), true )
		return
	end

	if not target:Alive() then
		ULib.tsay( ply, target:Nick() .. " is dead!", true )
		return
	end

	if not ply:Alive() then
		ULib.tsay( ply, "You are dead!", true )
		return
	end

	if ply:InVehicle() then
		ULib.tsay( ply, "Please leave the vehicle first!", true )
		return
	end

	local newpos = playerSend( target, ply, target:GetMoveType() == MOVETYPE_NOCLIP )
	if not newpos then
		ULib.tsay( ply, "Can't find a place to put them!", true )
		return
	end

	if target:InVehicle() then
		target:ExitVehicle()
	end

	local newang = (ply:GetPos() - newpos):Angle()

	target:SetPos( newpos )
	target:SetEyeAngles( newang )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!

	ulx.logUserAct( ply, target, "#A brought #T to him/her" )
end
ulx.concommand( "bring", ulx.cc_bring, "<user> - Brings a user to you.", ULib.ACCESS_ADMIN, "!bring", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Bring", "ulx bring" )

function ulx.cc_goto( ply, command, argv, args )
	if not ply:IsValid() then
		Msg( "You can't use this from a dedicated console!\n" )
		return
	end

	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target, err = ULib.getUser( argv[ 1 ], true, ply ) -- Ignore immunity
	if not target then
		ULib.tsay( ply, err, true )
		return
	end

	if target == ply then
		ULib.tsay( ply, "You can't goto yourself!", true )
		return
	end

	if ulx.getExclusive( ply, ply ) then
		ULib.tsay( ply, ulx.getExlusive( ply, ply ), true )
		return
	end

	if not target:Alive() then
		ULib.tsay( ply, target:Nick() .. " is dead!", true )
		return
	end

	if not ply:Alive() then
		ULib.tsay( ply, "You are dead!", true )
		return
	end

	if target:InVehicle() and ply:GetMoveType() ~= MOVETYPE_NOCLIP then
		ULib.tsay( ply, "Target is in a vehicle! Noclip and use this command to force a goto.", true )
		return
	end

	local newpos = playerSend( ply, target, ply:GetMoveType() == MOVETYPE_NOCLIP )
	if not newpos then
		ULib.tsay( ply, "Can't find a place to put you! Noclip and use this command to force a goto.", true )
		return
	end

	if ply:InVehicle() then
		ply:ExitVehicle()
	end

	local newang = (target:GetPos() - newpos):Angle()

	ply:SetPos( newpos )
	ply:SetEyeAngles( newang )
	ply:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!

	ulx.logUserAct( ply, target, "#A teleported to #T" )
end
ulx.concommand( "goto", ulx.cc_goto, "<user> - Goto a user.", ULib.ACCESS_ADMIN, "!goto", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Goto", "ulx goto" )

function ulx.cc_send( ply, command, argv, args )
	if #argv < 2 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local target_from, err = ULib.getUser( argv[ 1 ], _, ply )
	if not target_from then
		ULib.tsay( ply, err, true )
		return
	end

	local target_to, err = ULib.getUser( argv[ 2 ], _, ply )
	if not target_to then
		ULib.tsay( ply, err, true )
		return
	end

	if target_from == ply or target_to == ply then
		ULib.tsay( ply, "You can't use send on yourself. Please use goto, bring, or tp.", true )
		return
	end

	if target_from == target_to then
		ULib.tsay( ply, "You listed the same target twice! Please two different targets.", true )
		return
	end

	if ulx.getExclusive( target_from, ply ) then
		ULib.tsay( ply, ulx.getExclusive( target_from, ply ), true )
		return
	end

	if ulx.getExclusive( target_to, ply ) then
		ULib.tsay( ply, ulx.getExclusive( target_to, ply ), true )
		return
	end

	local nick = target_from:Nick() -- Going to use this for our error (if we have one)

	if not target_from:Alive() or not target_to:Alive() then
		if not target_to:Alive() then
			nick = target_to:Nick()
		end
		ULib.tsay( ply, nick .. " is dead!", true )
		return
	end

	if target_to:InVehicle() and target_from:GetMoveType() == MOVETYPE_NOCLIP then
		ULib.tsay( ply, "Target is in a vehicle!", true )
		return
	end

	local newpos = playerSend( target_from, target_to, target_from:GetMoveType() == MOVETYPE_NOCLIP )
	if not newpos then
		ULib.tsay( ply, "Can't find a place to put them!", true )
		return
	end

	if target_from:InVehicle() then
		target_from:ExitVehicle()
	end

	local newang = (target_from:GetPos() - newpos):Angle()

	target_from:SetPos( newpos )
	target_from:SetEyeAngles( newang )
	target_from:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!

	ulx.logUserAct( ply, target_from, "#A transported #T to ".. target_to:Nick() )
end
ulx.concommand( "send", ulx.cc_send, "<user1> <user2>- Sends user1 to user2.", ULib.ACCESS_ADMIN, "!send", _, ulx.ID_PLAYER_HELP )

function ulx.cc_teleport( ply, command, argv, args )
	local target
	if #argv < 1 then
		if not ply:IsValid() then
			Msg( "You are the console, you can't teleport if you can't see the world!\n" )
			return
		end
		target = ply
	else
		local err
		target, err = ULib.getUser( argv[ 1 ], _, ply )
		if not target then
			ULib.tsay( ply, err, true )
			return
		end
	end

	if ulx.getExclusive( target, ply ) then
		ULib.tsay( ply, ulx.getExclusive( target, ply ), true )
		return
	end

	if not target:Alive() then
		ULib.tsay( ply, target:Nick() .. " is dead!", true )
		return
	end

	local t = {}
	t.start = ply:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
	t.endpos = ply:GetPos() + ply:EyeAngles():Forward() * 16384
	t.filter = target
	if target ~= ply then
		t.filter = { target, ply }
	end
	local tr = util.TraceEntity( t, target )

	local pos = tr.HitPos

	if target == ply and pos:Distance( ply:GetPos() ) < 64 then -- Laughable distance
		return
	end

	if target:InVehicle() then
		target:ExitVehicle()
	end

	target:SetPos( pos )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!

	if target ~= ply then
		ulx.logUserAct( ply, target, string.format( "#A teleported #T to world position (%.02f, %.02f, %.02f)", pos.x, pos.y, pos.z ) )
	end
end
ulx.concommand( "teleport", ulx.cc_teleport, "[<user>] - Teleports you, or player you specify, to where you're looking.", ULib.ACCESS_ADMIN, "!tp", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Teleport", "ulx teleport" )