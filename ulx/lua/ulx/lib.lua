-- Set exclusive command. Commands can check if an exclusive command is set with getExclusive() 
-- and process no further. Only "big" things like jail, maul, etc should be checking and setting this.
function ulx.setExclusive( ply, action )
	ply.ULXExclusive = action
end

function ulx.getExclusive( target, ply )
	if not target.ULXExclusive then return end
	
	if target == ply then
		return "You are " .. target.ULXExclusive .. "!"
	else
		return target:Nick() .. " is " .. target.ULXExclusive .. "!"
	end
end

function ulx.clearExclusive( ply )
	ply.ULXExclusive = nil
end

--- No die. Don't allow the player to die!
function ulx.setNoDie( ply, bool )
	ply.ulxNoDie = bool
end

local function checkDeath( ply, weapon, killer )
	if ply.ulxNoDie then
		ply:AddDeaths( -1 ) -- Won't show on scoreboard
		if killer == ply then -- Suicide
			ply:AddFrags( 1 ) -- Won't show on scoreboard
		end
		
		local pos = ply:GetPos()
		local ang = ply:EyeAngles()
		timer.Simple( FrameTime() * 0.5, function() -- Run next frame
			if not ply:IsValid() then return end -- Gotta make sure it's still valid since this is a timer
			ULib.getSpawnInfo( ply )
			ULib.spawn( ply, true )
			ply:SetPos( pos )
			ply:SetEyeAngles( ang )
		end )
		return true -- Don't register their death on HUD		
	end
end
hook.Add( "PlayerDeath", "ULXCheckDeath", checkDeath, -10 ) -- Hook it first because we're blocking their death.

function ulx.getVersion() -- This exists on the client as well, so feel free to use it!
	local version
	local r = 0
	
	if file.Exists( "../addons/ulx/lua/ulx/.svn/entries" ) then
		r = tonumber( string.Explode( "\n", file.Read( "../lua/ulx/.svn/entries" ) )[ 4 ] ) -- Get revision from entries file. Hackish I know, but who cares?
		version = string.format( "<SVN> revision %i", r )
	elseif not ulx.release then
		version = string.format( "<SVN> unknown revision" )
	else
		version = string.format( "%.02f", ulx.version )
	end
	
	return version, ulx.version, r
end

ulx.menuContents = {}
function ulx.addToMenu( menuid, label, data )
	ulx.menuContents[ menuid ] = ulx.menuContents[ menuid ] or {}
	table.insert( ulx.menuContents[ menuid ], { label=label, data=data } )
	umsg.Start( "ulx_addMenuItem" )
		umsg.Char( menuid )
		umsg.String( label )
		ULib.umsgSend( data )
	umsg.End()	
end

function ulx.standardizeModel( model ) -- This will convert all model strings to be of the same type, using linux notation and single dashes.
	model = model:lower()
	model = model:gsub( "\\", "/" )
	model = model:gsub( "/+", "/" ) -- Multiple dashes
	return model
end
