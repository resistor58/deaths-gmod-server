--[[
	Title: Fun

	Some fun things for admins
]]
ulx.setCategory( "Fun" )

function ulx.cc_slap( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end
	
	local dmg = tonumber( argv[ 2 ] ) or 0
	dmg = math.floor( dmg )
	
	if dmg < 0 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end	

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A slapped #T with " .. dmg .. " damage" )
		ULib.slap( v, dmg )
	end
end
ulx.concommand( "slap", ulx.cc_slap, "<user(s)> [<damage>] - Slaps target(s) with given damage.", ULib.ACCESS_ADMIN, "!slap", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Slap", "ulx slap" )

function ulx.cc_whip( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	local times = tonumber( argv[ 2 ] ) or 10
	local damage = tonumber( argv[ 3 ] ) or 1
	damage = math.floor( damage )
	
	if damage < 0 or times < 0 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end		

	if times > 100 then
		ULib.tsay( ply, "You cannot whip them more than 100 times!", true )
		return
	end

	for _, v in ipairs( targets ) do
		if v.whipped then
			ULib.tsay( ply, v:Nick() .. " is already being whipped by " .. v.whippedby, true )
		else
			ulx.logUserAct( ply, v, string.format( "#A is whipping #T %i times with %i damage.", times, damage ) )
			local dtime = 0
			v.whipped = true
			v.whippedby = ply:Nick()
			v.whipcount = 0
			v.whipamt = times

			timer.Create( "ulxWhip" .. v:EntIndex(), 0.5, 0, function() -- Repeat forever, we have an unhooker inside.
				if not v:IsValid() then return end  -- Gotta make sure they're still there since this is a timer.
				if v.whipcount == v.whipamt or not v:Alive() then
					v.whipped = nil
					v.whippedby = nil
					v.whipcount = nil
					v.whipamt = nil
					timer.Remove( "ulxWhip" .. v:EntIndex() )
				else
					ULib.slap( v, damage )
					v.whipcount = v.whipcount + 1
				end
			end )
		end
	end
end
ulx.concommand( "whip", ulx.cc_whip, "<user(s)> [<times>] [<damage>] - Slaps target(s) x times with dmg each slap.", ULib.ACCESS_ADMIN, "!whip", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Whip", "ulx whip" )

function ulx.cc_slay( ply, command, argv, args )
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
		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		else
			ulx.logUserAct( ply, v, "#A slayed #T" )
			v:Kill()
		end
	end
end
ulx.concommand( "slay", ulx.cc_slay, "<user(s)> - slays the specified users.", ULib.ACCESS_ADMIN, "!slay", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Slay", "ulx slay" )

function ulx.cc_sslay( ply, command, argv, args )
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
		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		else
			ulx.logUserAct( ply, v, "#A sslayed #T" )

			if v:InVehicle() then
				v:ExitVehicle()
			end

			v:KillSilent()
		end
	end
end
ulx.concommand( "sslay", ulx.cc_sslay, "<user(s)> - silently slays the specified users.", ULib.ACCESS_ADMIN, "!sslay", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Sslay", "ulx sslay" )

function ulx.cc_ignite( ply, command, argv, args )
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
		ulx.logUserAct( ply, v, "#A ignited #T" )
		v:Ignite( 300, 100 ) -- 5 mins as max time, allow to spread
	end
end
ulx.concommand( "ignite", ulx.cc_ignite, "<user(s)> - ignites the specified users.", ULib.ACCESS_ADMIN, "!ignite", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Ignite", "ulx ignite" )

local function checkFireDeath( ply )
	if ply:IsOnFire() then ply:Extinguish() end
end
hook.Add( "PlayerDeath", "ULXCheckFireDeath", checkFireDeath )

-- Though I believe this function has been needed for a while, thanks to B!GA for the reminder.
function ulx.cc_unignite( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local find
	if argv[ 1 ]:lower() == "<everything>" then
		local flame_ents = ents.FindByClass( 'entityflame' )

		for _,v in ipairs( flame_ents ) do
			if v:IsValid() then
				v:Remove()
			end
		end
		ulx.logServAct( ply, "#A extinguished everything" )
		find = "<all>"
	else
		find = argv[ 1 ]
	end

	local targets, err = ULib.getUsers( find, _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	for _, v in ipairs( targets ) do
		if v:IsOnFire{} then
			ulx.logUserAct( ply, v, "#A extinguished #T" )
			v:Extinguish()
		end
	end
end
ulx.concommand( "unignite", ulx.cc_unignite, "<user(s)>, or <everything> - Extinguishes individual player(s) or everything", ULib.ACCESS_ADMIN, "!unignite", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Unignite", "ulx unignite" )
ulx.addToMenu( ulx.ID_MCLIENT, "Unignite All", "ulx unignite <everything>" )

function ulx.cc_playsound( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	if not file.Exists( "../sound/" .. argv[ 1 ] ) then
		ULib.tsay( ply, "That sound doesn't exist on the server!", true )
		return
	end

	ulx.logServAct( ply, "#A played sound " .. argv[ 1 ] )

	umsg.Start( "ulib_sound" )
		umsg.String( Sound( argv[ 1 ] ) )
	umsg.End()
end
ulx.concommand( "playsound", ulx.cc_playsound, "<sound> - Plays a sound, relative to 'sound' dir.", ULib.ACCESS_ADMIN )

function ulx.cc_freeze( ply, command, argv, args )
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
		ulx.logUserAct( ply, v, "#A froze #T" )

		if v:InVehicle() then
			local vehicle = v:GetParent()
			v:ExitVehicle()
		end

		v:Lock()
		v:DisallowSpawning( true )
		ulx.setNoDie( v, true )
	end
end
ulx.concommand( "freeze", ulx.cc_freeze, "<user(s)> - freezes the specified users.", ULib.ACCESS_ADMIN, "!freeze", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Freeze", "ulx freeze" )

function ulx.cc_unfreeze( ply, command, argv, args )
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
		ulx.logUserAct( ply, v, "#A unfroze #T" )
		v:UnLock()
		v:DisallowSpawning( false )
		ulx.setNoDie( v, false )
	end
end
ulx.concommand( "unfreeze", ulx.cc_unfreeze, "<user(s)> - unfreezes the specified users.", ULib.ACCESS_ADMIN, "!unfreeze", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Unfreeze", "ulx unfreeze" )

function ulx.cc_god( ply, command, argv, args )
	local targets
	if #argv < 1 then
		if not ply:IsValid() then
			Msg( "You are the console, you are already god.\n" )
			return
		end
		targets = { ply }
	else
		local err
		targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
		if not targets then
			ULib.tsay( ply, err, true )
			return
		end
	end

	for _, v in ipairs( targets ) do
		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		else
			ulx.logUserAct( ply, v, "#A granted god mode to #T" )
			v:GodEnable()
			v.ULXHasGod = true
		end
	end
end
ulx.concommand( "god", ulx.cc_god, "<user(s)> - Makes player(s) invincible. If no user is specified, gods yourself.", ULib.ACCESS_ADMIN, "!god", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "God", "ulx god" )

function ulx.cc_ungod( ply, command, argv, args )
	local targets
	if #argv < 1 then
		if not ply:IsValid() then
			Msg( "Your position of god is irrevocable; if you don't like it, leave the matrix.\n" )
			return
		end
		targets = { ply }
	else
		local err
		targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
		if not targets then
			ULib.tsay( ply, err, true )
			return
		end
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A revoked god mode from #T" )
		v:GodDisable()
		v.ULXHasGod = nil
	end
end
ulx.concommand( "ungod", ulx.cc_ungod, "<user(s)> - Revokes player'(s) godmode. If no-one is specified, ungods you.", ULib.ACCESS_ADMIN, "!ungod", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Ungod", "ulx ungod" )

function ulx.cc_noclip( ply, command, argv, args )
	local targets
	if #argv < 1 then
		if not ply:IsValid() then
			Msg( "You have no physical body to noclip.\n" )
			return
		end
		targets = { ply }
	else
		local err
		targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
		if not targets then
			ULib.tsay( ply, err, true )
			return
		end
	end

	for _, v in ipairs( targets ) do
		if v.NoNoclip then
			ULib.tsay( ply, v:Nick() .. " can't be noclipped right now.", true )
		else
			if v:GetMoveType() == MOVETYPE_WALK then
				v:SetMoveType( MOVETYPE_NOCLIP )
			elseif v:GetMoveType() == MOVETYPE_NOCLIP then
				v:SetMoveType( MOVETYPE_WALK )
			end -- Ignore if they're an observer
		end
	end
end
ulx.concommand( "noclip", ulx.cc_noclip, "<user(s)> - Toggles noclip for player(s). If no arg, noclips you.", ULib.ACCESS_ADMIN, "!noclip", _, ulx.ID_PLAYER_HELP )

function ulx.cc_hp( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	local hp = tonumber( argv[ 2 ] )
	if not hp then
		ULib.tsay( ply, "\"" .. argv[ 2 ] .. "\" is an invalid amount!", true )
		return
	end

	if hp >= 100000 then
		ULib.tsay( ply, "Sorry, you cannot set players' health to 100,000 or more.", true )
		return
	end
	
	if hp < 1 then
		ULib.tsay( ply, "Sorry, you cannot set players' health to less than 1.", true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A set #T's hp to " .. hp )
		v:SetHealth( hp )
	end
end
ulx.concommand( "hp", ulx.cc_hp, "<user(s)> - sets the hp for the specified users.", ULib.ACCESS_ADMIN, "!hp", _, ulx.ID_PLAYER_HELP )

function ulx.cc_armor( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	local armor = tonumber( argv[ 2 ] )
	if not armor then
		ULib.tsay( ply, "\"" .. argv[ 2 ] .. "\" is an invalid amount!", true )
		return
	end

	if armor >= 100000 then
		ULib.tsay( ply, "Sorry, you cannot set players' armor to 100,000 or more.", true )
		return
	end
	
	if armor < 0 then
		ULib.tsay( ply, "Sorry, you cannot set players' armor to less than 0.", true )
		return
	end	

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A set #T's armor to " .. armor )
		v:SetArmor( armor )
	end
end
ulx.concommand( "armor", ulx.cc_armor, "<user(s)> - sets the armor for the specified users.", ULib.ACCESS_ADMIN, "!armor", _, ulx.ID_PLAYER_HELP )

function ulx.cc_cloak( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	local amt = tonumber( argv[ 2 ] ) or 255
	
	amt = 255 - amt
	if amt < 0 or amt > 255 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end	

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A cloaked #T by amount " .. 255 - amt )
		ULib.invisible( v, true, amt )
	end
end
ulx.concommand( "cloak", ulx.cc_cloak, "<user(s)> [<amt 0-255>] - Cloaks user(s) by amount.", ULib.ACCESS_ADMIN, "!cloak", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Cloak", "ulx cloak" )

function ulx.cc_uncloak( ply, command, argv, args )
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
		ulx.logUserAct( ply, v, "#A uncloaked #T" )
		ULib.invisible( v, false )
	end
end
ulx.concommand( "uncloak", ulx.cc_uncloak, "<user(s)> - Uncloaks user(s).", ULib.ACCESS_ADMIN, "!uncloak", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Uncloak", "ulx uncloak" )

function ulx.cc_blind( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	local amt = tonumber( argv[ 2 ] ) or 255
	if amt < 0 or amt > 255 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A blinded #T by amount " .. amt )
		umsg.Start( "ulx_blind", v )
			umsg.Bool( true )
			umsg.Short( amt )
		umsg.End()

		v.HadCamera = v:HasWeapon( "gmod_camera" )
		v:StripWeapon( "gmod_camera" )
	end
end
ulx.concommand( "blind", ulx.cc_blind, "<user(s)> [<amt 0-255>] - Blinds user(s) by amount.", ULib.ACCESS_ADMIN, "!blind", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Blind", "ulx blind" )

function ulx.cc_unblind( ply, command, argv, args )
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
		ulx.logUserAct( ply, v, "#A unblinded #T" )
		umsg.Start( "ulx_blind", v )
			umsg.Bool( false )
			umsg.Short( 0 )
		umsg.End()

		if v.HadCamera then
			v:Give( "gmod_camera" )
		end
		v.HadCamera = nil
	end
end
ulx.concommand( "unblind", ulx.cc_unblind, "<user(s)> - Unblinds user(s).", ULib.ACCESS_ADMIN, "!unblind", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Unblind", "ulx unblind" )

function ulx.cc_jail( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS, true )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err, true )
		return
	end

	local time = tonumber( argv[ 2 ] ) or 0
	
	if time < 0 then
		ULib.tsay( ply, "Invalid number!", true )
		return
	end	

	local mdl1 = Model( "models/props_c17/fence01b.mdl" )
	local mdl2 = Model( "models/props_c17/fence02b.mdl" )
	local jail = {
		{ pos = Vector( 35, 0, 60 ), ang = Angle( 0, 0, 0 ), mdl=mdl2 },
		{ pos = Vector( -35, 0, 60 ), ang = Angle( 0, 0, 0 ), mdl=mdl2 },
		{ pos = Vector( 0, 35, 60 ), ang = Angle( 0, 90, 0 ), mdl=mdl2 },
		{ pos = Vector( 0, -35, 60 ), ang = Angle( 0, 90, 0 ), mdl=mdl2 },
		{ pos = Vector( 0, 0, 110 ), ang = Angle( 90, 0, 0 ), mdl=mdl1 },
		{ pos = Vector( 0, 0, -5 ), ang = Angle( 90, 0, 0 ), mdl=mdl1 },
	}

	for _, v in ipairs( targets ) do

		if v.jail then -- They're already jailed
			v.jail.unjail()
		end

		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		else
			if time > 0 then
				ulx.logUserAct( ply, v, "#A jailed #T for " .. time .. " seconds" )
			else
				ulx.logUserAct( ply, v, "#A jailed #T" )
			end
			if v:InVehicle() then
				local vehicle = v:GetParent()
				v:ExitVehicle()
				vehicle:Remove()
			end

			if v:GetMoveType() == MOVETYPE_NOCLIP then -- Take them out of noclip
				v:SetMoveType( MOVETYPE_WALK )
			end

			local pos = v:GetPos()

			local walls = {}
			for _, info in ipairs( jail ) do
				local ent = ents.Create( "prop_physics" )
				ent:SetModel( info.mdl )
				ent:SetPos( pos + info.pos )
				ent:SetAngles( info.ang )
				ent:Spawn()
				ent:GetPhysicsObject():EnableMotion( false )
				ent.jailWall = true
				table.insert( walls, ent )
			end

			local function unjail()
				for _, ent in ipairs( walls ) do
					if ent:IsValid() then
						ent:Remove()
					end
				end
				if not v:IsValid() then return end -- Make sure they're still connected

				v:DisallowNoclip( false )
				v:DisallowSpawning( false )
				v:DisallowVehicles( false )

				ulx.clearExclusive( v )

				v.jail = nil
			end
			if time > 0 then
				timer.Simple( time, unjail )
			end

			for _, ent in ipairs( walls ) do
				ent:DisallowDeleting( true )
				ent:DisallowMoving( true )
			end
			v:DisallowNoclip( true )
			v:DisallowSpawning( true )
			v:DisallowVehicles( true )
			v.jail = { pos=pos, unjail=unjail }
			ulx.setExclusive( v, "in jail" )
		end
	end
end
ulx.concommand( "jail", ulx.cc_jail, "<user(s)> [<time>] - Jails user(s) for x seconds (forever if not specified).", ULib.ACCESS_ADMIN, "!jail", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Jail", "ulx jail" )

function ulx.cc_unjail( ply, command, argv, args )
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
		if v.jail then
			ulx.logUserAct( ply, v, "#A unjailed #T" )
			v.jail.unjail()
			v.jail = nil
		end
	end
end
ulx.concommand( "unjail", ulx.cc_unjail, "<user(s)> - Unjails user(s).", ULib.ACCESS_ADMIN, "!unjail", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Unjail", "ulx unjail" )

local function jailSpawnCheck( ply )
	if ply.jail then
		ply:SetPos( ply.jail.pos )
	end
end
hook.Add( "PlayerSpawn", "ULXJailSpawnCheck", jailSpawnCheck )

local function jailDisconnectedCheck( ply )
	if ply.jail then
		ply.jail.unjail()
	end
end
hook.Add( "PlayerDisconnected", "ULXJailDisconnectedCheck", jailDisconnectedCheck )

local function jailDamageCheck( ent )
	if ent.jailWall then
		return false
	end
end
hook.Add( "EntityTakeDamage", "ULXJailDamagedCheck", jailDamageCheck, -20 )

local function doGhost( ply )
	if not ply.ghost then return end
	local dTime = FrameTime()
	local speed = 500
	local upspeed = 200

	if ply:KeyDown( IN_FORWARD ) then
		ply:SetPos( ply:GetPos() + ply:GetForward() * (speed*dTime) )
	elseif ply:KeyDown( IN_BACK ) then
		ply:SetPos( ply:GetPos() + ply:GetForward() * (speed*dTime*-1) )
	end

	if ply:KeyDown( IN_MOVERIGHT ) then
		ply:SetPos( ply:GetPos() + ply:GetRight() * (speed*dTime) )
	elseif ply:KeyDown( IN_MOVELEFT ) then
		ply:SetPos( ply:GetPos() + ply:GetRight() * (speed*dTime*-1) )
	end

	if ply:KeyDown( IN_JUMP ) then
		ply:SetPos( ply:GetPos() + ply:GetUp() * (upspeed*dTime) )
	elseif ply:KeyDown( IN_DUCK ) then
		ply:SetPos( ply:GetPos() + ply:GetUp() * (upspeed*dTime*-1) )
	end
end

function ulx.cc_ghost( ply, command, argv, args )
	local targets
	if #argv < 1 then
		if not ply:IsValid() then
			Msg( "You have no physical body to ghost.\n" )
			return
		end
		targets = { ply }
	else
		local err
		targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
		if not targets then
			ULib.tsay( ply, err, true )
			return
		end
	end

	for _, v in ipairs( targets ) do
		if v:InVehicle() then
			v:ExitVehicle()
		end

		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		else
			v:SetMoveType( MOVETYPE_NONE )
			v:SetNotSolid( true )
			v:GodEnable()
			ULib.invisible( v, true )
			v.ghost = true
			ulx.setExclusive( v, "ghosted" )

			-- This is a self-removing think for ghosts. When there's no more ghosts, it dies.
			local function ghostThink()
				local remove = true
				local players = player.GetAll()
				for _, player in ipairs( players ) do
					if player.ghost then
						doGhost( player )
						remove = false
					end
				end
				if remove then
					hook.Remove( "Think", "ULXGhostThink" )
				end
			end
			hook.Add( "Think", "ULXGhostThink", ghostThink )

			ulx.logUserAct( ply, v, "#A ghosted #T", true )
		end
	end
end
ulx.concommand( "ghost", ulx.cc_ghost, " - Ghosts you.", ULib.ACCESS_ADMIN, "!ghost", true, ulx.ID_HELP )

function ulx.cc_unghost( ply, command, argv, args )
	local targets
	if #argv < 1 then
		if not ply:IsValid() then
			Msg( "You have no physical body to unghost.\n" )
			return
		end
		targets = { ply }
	else
		local err
		targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
		if not targets then
			ULib.tsay( ply, err, true )
			return
		end
	end

	for _, v in ipairs( targets ) do
		if v:InVehicle() then
			v:ExitVehicle()
		end

		v:SetMoveType( MOVETYPE_WALK )
		v:SetNotSolid( false )
		v:GodDisable()
		ULib.invisible( v, false )
		v.ghost = nil
		ulx.clearExclusive( v )

		ulx.logUserAct( ply, v, "#A unghosted #T", true )
	end
end
ulx.concommand( "unghost", ulx.cc_unghost, " - Unghosts you.", ULib.ACCESS_ADMIN, "!unghost", true, ulx.ID_HELP )

function ulx.cc_ragdoll( ply, command, argv, args )
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
		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		else
			ulx.logUserAct( ply, v, "#A ragdolled #T" )

			if v:InVehicle() then
				local vehicle = v:GetParent()
				v:ExitVehicle()
			end

			ULib.getSpawnInfo( v ) -- Collect information so we can respawn them in the same state.

			local ragdoll = ents.Create( "prop_ragdoll" )
			ragdoll.ragdolledPly = v
			
			ragdoll:SetPos( v:GetPos() )
			local velocity = v:GetVelocity()
			ragdoll:SetAngles( v:GetAngles() )
			ragdoll:SetModel( v:GetModel() )
			ragdoll:Spawn()
			ragdoll:Activate()
			v:SetParent( ragdoll ) -- So their player ent will match up (position-wise) with where their ragdoll is.
			-- Set velocity for each peice of the ragdoll
			for i=1, 14 do
				ragdoll:GetPhysicsObjectNum( i ):SetVelocity( velocity )
			end

			v:Spectate( OBS_MODE_CHASE )
			v:SpectateEntity( ragdoll )
			v:StripWeapons() -- Otherwise they can still use the weapons.

			ragdoll:DisallowDeleting( true )
			v:DisallowSpawning( true )

			v.ragdoll = ragdoll
			ulx.setExclusive( v, "ragdolled" )
		end
	end
end
ulx.concommand( "ragdoll", ulx.cc_ragdoll, "<user(s)> - ragdolls the specified users.", ULib.ACCESS_ADMIN, "!ragdoll", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Ragdoll", "ulx ragdoll" )

function ulx.cc_unragdoll( ply, command, argv, args )
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
		if v.ragdoll then -- Only if they're ragdolled...
			ulx.logUserAct( ply, v, "#A unragdolled #T" )
			
			v:DisallowSpawning( false )
			v:SetParent()
			
			local ragdoll = v.ragdoll
			v.ragdoll = nil -- Gotta do this before spawn or our hook catches it
			
			if not ragdoll:IsValid() then -- Something must have removed it, just spawn
				ULib.spawn( v, true )
			
			else
				local pos = ragdoll:GetPos()
				pos.z = pos.z + 10 -- So they don't end up in the ground
				
				ULib.spawn( v, true )
				v:SetPos( pos )
				v:SetVelocity( ragdoll:GetVelocity() )
				local yaw = ragdoll:GetAngles().yaw
				v:SetAngles( Angle( 0, yaw, 0 ) )
				ragdoll:Remove()
			end
			
			ulx.clearExclusive( v )
		end
	end
end
ulx.concommand( "unragdoll", ulx.cc_unragdoll, "<user(s)> - unragdolls the specified users.", ULib.ACCESS_ADMIN, "!unragdoll", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Unragdoll", "ulx unragdoll" )

local function ragdollSpawnCheck( ply )
	if ply.ragdoll then
		timer.Simple( 0.01, function() -- Doesn't like us using it instantly
			if not ply:IsValid() then return end -- Make sure they're still here
			ply:Spectate( OBS_MODE_CHASE )
			ply:SpectateEntity( ply.ragdoll )
			ply:StripWeapons() -- Otherwise they can still use the weapons.
		end )
	end
end
hook.Add( "PlayerSpawn", "ULXRagdollSpawnCheck", ragdollSpawnCheck )

local function ragdollDisconnectedCheck( ply )
	if ply.ragdoll then
		ply.ragdoll:Remove()
	end
end
hook.Add( "PlayerDisconnected", "ULXRagdollDisconnectedCheck", ragdollDisconnectedCheck )

local zombieDeath -- We need these registered up here because functions reference each other.
local checkMaulDeath

local function newZombie( pos, ang, ply, b )
		local ent = ents.Create( "npc_fastzombie" )
		ent:SetPos( pos )
		ent:SetAngles( ang )
		ent:Spawn()
		ent:Activate()
		ent:AddRelationship("player D_NU 98") -- Don't attack other players
		ent:AddEntityRelationship( ply, D_HT, 99 ) -- Hate target

		ent:DisallowDeleting( true )
		ent:DisallowMoving( true )

		if not b then
			ent:CallOnRemove( "NoDie", zombieDeath, ply )
		end

		return ent
end

-- Utility function
zombieDeath = function( ent, ply )
	if ply.maul_npcs then -- Recreate!
		local pos = ent:GetPos()
		local ang = ent:GetAngles()
		timer.Simple( FrameTime() * 0.5, function() -- Create it next frame because 1. Old NPC won't be in way and 2. We won't overflow the server while shutting down with someone being mauled
			if not ply:IsValid() then return end -- Player left

			local ent2 = newZombie( pos, ang, ply )
			table.insert( ply.maul_npcs, ent2 ) -- Don't worry about removing the old one, doesn't matter.

			-- Make sure we didn't make a headcrab!
			local ents = ents.FindByClass( "npc_headcrab_fast" )
			for _, ent in ipairs( ents ) do
				dist = ent:GetPos():Distance( pos )
				if dist < 128 then -- Assume it's from the zombies
					ent:Remove()
				end
			end
		end )
	end
end

-- Another utility for maul
local function maulMoreDamage()
	local players = player.GetAll()
	for _, ply in ipairs( players ) do
		if ply.maul_npcs and ply:Alive() then
			if CurTime() > ply.maulStart + 20 then
				local damage = ply.maulStartHP / 20 -- Damage per second
				damage = damage * FrameTime() -- Damage this frame
				damage = math.ceil( damage )
				local newhp = ply:Health() - damage
				if newhp < 1 then newhp = 1 end
				ply:SetHealth( newhp ) -- We don't use takedamage because the player slides across the ground.
				if CurTime() > ply.maulStart + 40 then
					ply:Kill() -- Worst case senario.
					checkMaulDeath( ply ) -- Just in case the death hook is broken
				end
			end
			ply.maul_lasthp = ply:Health()
		end
	end
end

function ulx.cc_maul( ply, command, argv, args )
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
		if ulx.getExclusive( v, ply ) then
			ULib.tsay( ply, ulx.getExclusive( v, ply ), true )
		elseif not v:Alive() then
			ULib.tsay( ply, v:Nick() .. " is dead!", true )
		else
			local pos = {}
			local testent = newZombie( Vector( 0, 0, 0 ), Angle( 0, 0, 0 ), v, true ) -- Test ent for traces

			local yawForward = v:EyeAngles().yaw
			local directions = { -- Directions to try
				math.NormalizeAngle( yawForward - 180 ), -- Behind first
				math.NormalizeAngle( yawForward + 90 ), -- Right
				math.NormalizeAngle( yawForward - 90 ), -- Left
				yawForward,
			}

			local t = {}
			t.start = v:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
			t.filter = { v, testent }

			for i=1, #directions do -- Check all directions
				t.endpos = v:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
				local tr = util.TraceEntity( t, testent )

				if not tr.Hit then
					table.insert( pos, v:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 )
				end
			end

			testent:Remove() -- Don't forget to remove our friend now!

			if #pos > 0 then
				v.maul_npcs = {}
				for _, newpos in ipairs( pos ) do
					local newang = (v:GetPos() - newpos):Angle()

					local ent = newZombie( newpos, newang, v )
					table.insert( v.maul_npcs, ent )
				end

				v:SetMoveType( MOVETYPE_WALK )
				v:DisallowNoclip( true )
				v:DisallowSpawning( true )
				v:DisallowVehicles( true )
				v:GodDisable()
				v:SetArmor( 0 ) -- Armor takes waaaay too long for them to take down
				v.maulOrigWalk = v.WalkSpeed
				v.maulOrigSprint = v.SprintSpeed
				GAMEMODE:SetPlayerSpeed( v, 1, 1 ) -- Somehow 0 == crazy fast

				v.maulStart = CurTime()
				v.maulStartHP = v:Health()
				hook.Add( "Think", "MaulMoreDamageThink", maulMoreDamage )

				ulx.setExclusive( v, "being mauled" )

				ulx.logUserAct( ply, v, "#A mauled #T" )
			else
				ULib.tsay( ply, "Can't find a place to put the npcs for " .. v:Nick(), true )
			end
		end
	end
end
ulx.concommand( "maul", ulx.cc_maul, "<user(s)> - Mauls targets with a npcs.", ULib.ACCESS_ADMIN, "!maul", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Maul", "ulx maul" )

checkMaulDeath = function( ply, weapon, killer )
	if ply.maul_npcs then
		if killer == ply and CurTime() < ply.maulStart + 40 then -- Suicide
			ply:AddFrags( 1 ) -- Won't show on scoreboard
			local pos = ply:GetPos()
			local ang = ply:EyeAngles()
			timer.Simple( FrameTime() * 0.5, function()
				if not ply:IsValid() then return end -- They left

				ply:Spawn()
				ply:SetPos( pos )
				ply:SetEyeAngles( ang )
				ply:SetArmor( 0 )
				ply:SetHealth( ply.maul_lasthp )
				timer.Simple( 0.1, function()
					if not ply:IsValid() then return end -- They left
					ply:SetCollisionGroup( COLLISION_GROUP_WORLD )
					GAMEMODE:SetPlayerSpeed( ply, 1, 1 )
				end )
			end )
			return true -- Don't register their death on HUD
		end

		local npcs = ply.maul_npcs
		ply.maul_npcs = nil -- We have to do it this way to signal that we're done mauling
		for _, ent in ipairs( npcs ) do
			if ent:IsValid() then
				ent:Remove()
			end
		end
		ply.maul_npcs = nil
		ulx.clearExclusive( ply )
		ply.maulStart = nil
		ply.maul_lasthp = nil

		ply:DisallowNoclip( false )
		ply:DisallowSpawning( false )
		ply:DisallowVehicles( false )
		GAMEMODE:SetPlayerSpeed( ply, ply.maulOrigWalk, ply.maulOrigSprint )
		ply.maulOrigWalk = nil
		ply.maulOrigSprint = nil

		ulx.clearExclusive( ply )

		-- Now let's check if there's still players being mauled
		local players = player.GetAll()
		for _, ply in ipairs( players ) do
			if ply.maul_npcs then
				return
			end
		end

		-- No more? Remove hook.
		hook.Remove( "Think", "MaulMoreDamageThink" )
	end
end
hook.Add( "PlayerDeath", "ULXCheckMaulDeath", checkMaulDeath, -15 ) -- Hook it first because we're changing speed. Want others to override us.

-- Code technically taken from Kyzer (http://forums.ulyssesmod.net/index.php/topic,1143.0.html). But heck, it's really only one line of code.
function ulx.cc_stripweapons( ply, command, argv, args )
	if #argv < 1 then
		ULib.tsay( ply, ulx.LOW_ARGS )
		return
	end

	local targets, err = ULib.getUsers( argv[ 1 ], _, true, ply ) -- Enable keywords
	if not targets then
		ULib.tsay( ply, err )
		return
	end

	for _, v in ipairs( targets ) do
		ulx.logUserAct( ply, v, "#A stripped #T's weapons" )
		v:StripWeapons()
	end
end
ulx.concommand( "strip", ulx.cc_stripweapons, "<user(s)> - Strips user(s)'s weapons.", ULib.ACCESS_ADMIN, "!strip", _, ulx.ID_PLAYER_HELP )
ulx.addToMenu( ulx.ID_MCLIENT, "Strip", "ulx strip" )