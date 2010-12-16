completeList = {}

local function rcvAutocomplete( um )
	local key = um:ReadString()
	local value = ULib.umsgRcv( um )
	completeList[ key ] = value
end
usermessage.Hook( "ulx_autocomplete", rcvAutocomplete )

function ulxListCommands( command, args )
	local targs = string.Trim( args )
	local argv = ULib.splitArgs( targs, true )

	if #argv == 0 then -- List all ULX commands
		local commandList = {}
		for command, _ in pairs( completeList ) do
			table.insert( commandList, "ulx " .. command )
		end
		return commandList

	elseif #argv == 1 and (targs:len() == 0 or args:sub( -1 ) ~= " ") then -- List specific commands, take entire arg up to the space
		local commandList = {}
		for command, _ in pairs( completeList ) do
			if command:sub( 1, targs:len() ) == targs then
				table.insert( commandList, "ulx " .. command )
			end
		end
		return commandList

	else -- Else specific autocomplete per command
		local command2 = argv[ 1 ]
		local newArgs = " " .. targs:gsub( "^%S+%s*(.*)$", "%1" )
		local info = completeList[ command2 ]

		if not info then return end -- Invalid command or they don't have access to it

		local fn -- Track a custom function
		if info.fn then
			local loc = string.Explode( ".", info.fn )
			fn = _G
			for _, v in ipairs( loc ) do
				fn = fn[ v ]
			end
		end

		if info.id == ulx.ID_ORIGINAL then
			if fn then
				return fn( command .. " " .. command2, newArgs )
			end
		elseif info.id == ulx.ID_HELP then
			return { "ulx " .. command2 .. " " .. info.help }
		elseif info.id == ulx.ID_PLAYER_HELP then
			local targs = string.Trim( newArgs )

			if #argv < 3 and (targs:len() == 0 or args:sub( -1 ) ~= " ") then -- Take entire arg up to the space
				local ret = {}
				local players = ULib.getUsers( targs, true )
				
				if not players then -- Not valid, grab them all.
					players = player.GetAll()
				end
				for _, player in ipairs( players ) do
					table.insert( ret, string.format( "ulx %s \"%s\"", command2, player:Nick() ) )
				end

				return ret
			else
				return { "ulx " .. command2 .. " " .. info.help }
			end
		end
		return
	end
end

ulx.maps = {}
local function rcvMap( um )
	local map = um:ReadString()
	table.insert( ulx.maps, map )
end
usermessage.Hook( "ulx_map", rcvMap )

function mapComplete( command, args )
	local targs = string.Trim( args )
	local mapList = {}
	if targs:len() > 0 then
		for _, map in ipairs( ulx.maps ) do
			if map:sub( 1, targs:len() ) == targs then
				table.insert( mapList, command .. " " .. map )
			end
		end
	else
		for _, map in ipairs( ulx.maps ) do
			table.insert( mapList, command .. " " .. map )
		end
	end

	return mapList
end

local function rcvReset( um ) -- New access, reset our junk.
	completeList = {}
	ulx.maps = {}
end
usermessage.Hook( "ulx_resetinfo", rcvReset )

function ulx.blindUser( bool, amt )
	if bool then
		local function blind()
			draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 255, 255, 255, amt ) )
		end
		hook.Add( "HUDPaint", "ulx_blind", blind )
	else
		hook.Remove( "HUDPaint", "ulx_blind" )
	end
end

local function rcvBlind( um )
	local bool = um:ReadBool()
	local amt = um:ReadShort()
	ulx.blindUser( bool, amt )
end
usermessage.Hook( "ulx_blind", rcvBlind )

function ulx.gagUser( bool )
	if bool then
		local function gagForce( ply, bind )
			if string.find( bind, "+voicerecord" ) then
				return true
			end
		end
		hook.Add( "PlayerBindPress", "ULXGagForce", gagForce )
		local function gagCheck()
			RunConsoleCommand( "-voicerecord" )
		end
		timer.Create( "GagLocalPlayer", 0.1, 0, gagCheck )
		RunConsoleCommand( "-voicerecord" )
	else
		hook.Remove( "PlayerBindPress", "ULXGagForce" )
		timer.Destroy( "GagLocalPlayer")
	end
end

local function rcvGag( um )
	local bool = um:ReadBool()
	ulx.gagUser( bool )
end
usermessage.Hook( "ulx_gag", rcvGag )

local curVote

local function optionsDraw()
	if not curVote then return end
	
	local title = curVote.title
	local options = curVote.options
	local endtime = curVote.endtime
	
	if CurTime() > endtime then return end -- Expired
	
	surface.SetFont( "DefaultBold" )	
	local w, h = surface.GetTextSize( title )
	w = math.max( 200, w )
	local totalh = h * 12 + 20
	draw.RoundedBox( 5, 10, ScrH()*0.4 - 10, w + 20, totalh, Color( 111, 124, 138, 200 ) )	

	optiontxt = ""
	for i=1, 10 do
		if options[ i ] and options[ i ] ~= "" then
			optiontxt = optiontxt .. math.modf( i, 10 ) .. ". " .. options[ i ]
		end
		optiontxt = optiontxt .. "\n"
	end
	draw.DrawText( title .. "\n\n" .. optiontxt, "DefaultBold", 20, ScrH()*0.4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
end

local function rcvVote( um )
	local title = um:ReadString()
	local timeout = um:ReadShort()
	local options = ULib.umsgRcv( um )

	local function callback( id )
		if id == 0 then id = 10 end

		if not options[ id ] then
			return -- Returning nil will keep our hook
		end

		RunConsoleCommand( "ulx_vote", id )
		curVote = nil
		return true -- Let it know we're done here
	end
	LocalPlayer():AddPlayerOption( title, timeout, callback, optionsDraw )

	curVote = { title=title, options=options, endtime=CurTime()+timeout }
end
usermessage.Hook( "ulx_vote", rcvVote )

function ulx.getVersion() -- This exists on the server as well, so feel free to use it!	
	if ulx.revision > 0 then -- SVN version?
		version = string.format( "<SVN> revision %i", ulx.revision )
	elseif not ulx.release then
		version = string.format( "<SVN> unknown revision" )
	else
		version = string.format( "%.02f", ulx.version )
	end
	
	return version, ulx.version, ulx.revision
	
end

-- This function will create a matrix of controls inside a DPanelList for us. I found I was doing basically the same thing across all the ULX menus so I made this utility.
-- You can see the options you need below, pretty self-explanitory. The list table is format is key being the label for the control and the value will be put in control.data
--   so that the data can be retrieved in a callback.
-- You'll want to make sure you have an extra 10px to spare in the spacing, since it will push all elements closer when it needs a scrollbar.
function ulx.controlListMaker( parent, list, options )
	local columns = options.columns or 4
	local visibleRows = options.visibleRows or 4
	
	local wide = options.wide or parent:GetWide() - 20
	
	local controlName = options.controlName or "DButton"	
	
	local buttonWide = options.buttonWide or 80
	local buttonTall = options.buttonTall or 30
	
	local vspacing = options.vspacing or 10
	
	local alphabetize = options.alphabetize
	if alphabetize == nil then alphabetize = true end
		
	local panel = vgui.Create( "DPanelList", parent )
	panel:EnableVerticalScrollbar()
	panel:EnableHorizontal( false )
	panel:SetSize( wide, ( buttonTall + vspacing ) * visibleRows )

	local menulabels = {}
	for k, _ in pairs( list ) do
		table.insert( menulabels, k )
	end
	
	if alphabetize then
		table.sort( menulabels )
	end
	
	local controls = {}
	
	local t = ULib.matrixTable( menulabels, columns )
	local empty = #t <= 0
	
	local innerpanel = vgui.Create( "DPanel", panel )
	
	if not empty then
		local tall = math.max( (buttonTall + vspacing) * #t[ 1 ] - vspacing, panel:GetTall() )
		innerpanel:SetSize( panel:GetWide(), tall ) -- Make it as tall as we need
	
		-- Now let's figure out how wide the panel really is. If there's a scrollbar it takes off 10px
		local panelWide = innerpanel:GetWide()
		if #menulabels > columns * visibleRows then
			panelWide = panelWide - 10
		end
		local buttonFullWide = panelWide / columns -- How wide a button can be if there's no spacing at all.
	
		for i=1, #t[ 1 ] do
			for n=1, columns do
				if t[ n ][ i ] then
					local data = list[ t[ n ][ i ] ] -- The data provided for us on this control
					local control = vgui.Create( controlName, innerpanel )
					control:SetText( t[ n ][ i ] )
				
					control:SetPos( (n - 1) * buttonFullWide + (buttonFullWide - buttonWide)/2, (i - 1)*(buttonTall + vspacing) + vspacing/2 )
					control:SetSize( buttonWide, buttonTall )
				
					if controlName == "DButton" then
						control.DoClick = options.callback
					elseif controlName == "DNumSlider" then
						--control:SetPos( (n - 1)*buttonFullWide + (buttonFullWide - buttonWide)/2, (i - 1)*(buttonTall + vspacing) + 15 )
						--control:SetSize( buttonWide - 30, buttonTall ) -- Keep the second number at 100
						control:SetMin( data.min or 0 ) -- Minimum number of the slider
						control:SetMax( data.max ) -- Maximum number of the slider
						control:SetValue( data.value or 0 )
						control:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
						if options.callback then control.Wang.OnValueChanged = options.callback end
					else
						control:SetActionFunction( options.callback )
					end
					control.data = data
					table.insert( controls, control )
				end
			end
		end
	else -- if empty
		innerpanel:SetSize( panel:GetWide(), panel:GetTall() )
	end
	
	panel:AddItem( innerpanel )
	panel:PerformLayout()
	return panel, controls
end

-- We can't stick this in our main menu module in the event they remove/replace the module.
ulx.mainMenuContents = {}
ulx.clientMenuContents = {}
ulx.adminMenuContents = {}

function ulx.addToMenu( menuid, label, data )
	if menuid == ulx.ID_MMAIN then
		ulx.mainMenuContents[ label ] = data
	elseif menuid == ulx.ID_MCLIENT then
		ulx.clientMenuContents[ label ] = data
	elseif menuid == ulx.ID_MADMIN then
		ulx.adminMenuContents[ label ] = data
	end
end

local function rcvMenuItem( um )
	local menuid = um:ReadChar()
	local label = um:ReadString()
	local data = ULib.umsgRcv( um )
	ulx.addToMenu( menuid, label, data )
end
usermessage.Hook( "ulx_addMenuItem", rcvMenuItem )
