local bans
local loadingwindow -- Holds the loading window so we can close it after it's done loading.

local function unbanPress( btn )
	RunConsoleCommand( "ulx", "unban", btn.id )
	btn:GetParent():Remove()
	btn.window:Remove() -- Remove original menu so we can reload it
	timer.Simple( 0.2, ulx.showBanMenu )
end

local function cancelPress( btn )
	btn:GetParent():Remove() -- Remove the pop-up
end

local function removePress( btn )
	local window = vgui.Create( "DFrame" )
	window:SetSize( 350, 300 )
	window:Center()
	window:SetTitle( "Unban " .. btn.id )
	window:SetVisible( true )
	window:MakePopup()
	
	local data = bans[ btn.id ]
	
	local i = 0
	local function addItem( lbl, text )
		local label = vgui.Create( "Label", window )
		label:SetText( lbl )
		label:SetSize( 60, 20 )
		label:SetPos( 10, 30 + i*20 )
		
		local name = vgui.Create( "Label", window )
		name:SetText( text )
		name:SetSize( 270, 20 )
		name:SetPos( 80, 30 + i*20 )		
		
		i = i + 1
	end
	
	local bantime
	if data.time and tonumber( data.time ) and tonumber( data.time ) > 0 then
		bantime = os.date( "%c", data.time )
	else
		bantime = "<Unknown>"
	end
	
	local unbantime
	if data.unban and tonumber( data.unban ) and tonumber( data.unban ) > 0 then
		unbantime = os.date( "%c", data.unban )
	else
		unbantime = "Permanent"
	end	
	
	addItem( "Please note:", "The times listed below are in the SERVER'S local time" )
	addItem( "Name:", (data.name or "<Unknown>") )	
	addItem( "SteamID:", btn.id )
	addItem( "Ban Time:", bantime )
	addItem( "Unban Time:", unbantime )
	addItem( "Banner:", (data.admin or "<Unknown>") )
	
	local bannerlabel = vgui.Create( "Label", window )
	bannerlabel:SetText( "Reason:" )
	bannerlabel:SetSize( 60, 20 )
	bannerlabel:SetPos( 10, 150 )
	
	-- Now we're going to split the reason up into lines
	local i = 0
	local reason = data.reason or "<None given>"
	while reason:len() > 0 do
		local s = reason:sub( 0, 55 )		
		local loc = s:reverse():find( "%s" ) -- Reverse it so we can find the last space.
		if loc and s ~= reason then
			s = string.Trim( s:sub( 1, -loc ) )
		else
			s = reason
		end		
		reason = string.Trim( reason:gsub( "^" .. ULib.makePatternSafe( s ), "" ) )
	
		local banner = vgui.Create( "Label", window )
		banner:SetText( s )
		banner:SetSize( 270, 20 )
		banner:SetPos( 80, 150 + (i*12) )
		i = i + 1
	end
	-- Done splitting
	
	local questionlabel = vgui.Create( "Label", window )
	questionlabel:SetText( "Are you sure you want to unban this user?" )
	questionlabel:SetSize( 250, 20 )
	questionlabel:SetPos( 70, window:GetTall() - 70 )	
	
	local unbanbutton = vgui.Create( "DButton", window )
	unbanbutton:SetText( "Unban" )
	unbanbutton:SetSize( 100, 20 )
	unbanbutton:SetPos( 50, window:GetTall() - 40 )	
	unbanbutton.id = btn.id
	unbanbutton.window = btn:GetParent():GetParent():GetParent():GetParent()
	unbanbutton.DoClick = unbanPress
	
	local cancelbutton = vgui.Create( "DButton", window )
	cancelbutton:SetText( "Cancel" )
	cancelbutton:SetSize( 100, 20 )
	cancelbutton:SetPos( 200, window:GetTall() - 40 )
	cancelbutton.DoClick = cancelPress
end

function ulx.showBanMenuDone()
	if loadingwindow then 
		loadingwindow:Remove()
		loadingwindow = nil
	end
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 640, 480 )
	window:Center()
	window:SetTitle( "ULX Ban Menu" )
	window:SetVisible( true )
	window:MakePopup()
	
	local titlepanel = vgui.Create( "Panel", window )
	titlepanel:SetSize( window:GetWide() - 20, 20 )
	titlepanel:SetPos( 10, 30 )
	
	local  namelabel = vgui.Create( "Label", titlepanel )
	namelabel:SetText( "Name" )
	namelabel:SetSize( 190, 20 )
	namelabel:SetPos( 10, 0 )
	
	local  idlabel = vgui.Create( "Label", titlepanel )
	idlabel:SetText( "SteamID" )
	idlabel:SetSize( 110, 20 )
	idlabel:SetPos( 190, 0 )
	
	local  idlabel = vgui.Create( "Label", titlepanel )
	idlabel:SetText( "Unban" )
	idlabel:SetSize( 120, 20 )
	idlabel:SetPos( 310, 0 )
	
	local  idlabel = vgui.Create( "Label", titlepanel )
	idlabel:SetText( "Banner" )
	idlabel:SetSize( 180, 20 )
	idlabel:SetPos( 440, 0 )
	
	local panellist = vgui.Create( "DPanelList", window )
	panellist:EnableVerticalScrollbar()
	panellist:EnableHorizontal( false )
	panellist:SetSize( window:GetWide() - 10, window:GetTall() - 60 )
	panellist:SetPos( 5, 50 )
	
	-- Sort our bans
	local sortedbans = {}
	for id, data in pairs( bans ) do
		table.insert( sortedbans, { id = id, data = data } )
	end	
	table.sort( sortedbans, function( a, b ) return a.id < b.id end )
	
	if #sortedbans < 1 then
		local panel = vgui.Create( "Panel", panellist )
		panel:SetSize( panellist:GetWide(), 30 )
		panellist:AddItem( panel )
		
		local lbl = vgui.Create( "Label", panel )
		lbl:SetText( "No bans!" )
		lbl:SetSize( 160, 30 )
		lbl:SetPos( 200, 0 )				
	end
	
	for _, v in ipairs( sortedbans ) do
		local id = v.id
		local data = v.data
		
		local panel = vgui.Create( "Panel", panellist )
		panel:SetSize( panellist:GetWide(), 30 )
		panellist:AddItem( panel )
		
		local name = vgui.Create( "Label", panel )
		name:SetText( data.name or "<Unknown>" )
		name:SetSize( 160, 30 )
		name:SetPos( 0, 0 )		

		local steamid = vgui.Create( "Label", panel )
		steamid:SetText( id )
		steamid:SetSize( 110, 30 )
		steamid:SetPos( 180, 0 )	
		
		local unbantime
		if data.unban and tonumber( data.unban ) and tonumber( data.unban ) > 0 then
			unbantime = os.date( "%c", data.unban )
		else
			unbantime = "Permanent"
		end	
		
		local unban = vgui.Create( "Label", panel )
		unban:SetText( unbantime )
		unban:SetSize( 120, 30 )
		unban:SetPos( 300, 0 )
		
		local admin = vgui.Create( "Label", panel )
		admin:SetText( data.admin or "<Unknown>" )
		admin:SetSize( 150, 30 )
		admin:SetPos( 430, 0 )	

		local button = vgui.Create( "DImageButton", panel )
		button:SetDrawBorder( true )
		button:SetDrawBackground( true )
		button:SetImage( "gui/silkicons/check_off" )
		button:SetSize( 16, 16 )
		button:SetPos( 590, 7 )
		button.id = id
		button.DoClick = removePress
	end
end

function ulx.showBanMenu()
	RunConsoleCommand( "ulx_getbans" )
	
	-- Now open a loading window
	local window = vgui.Create( "DFrame" )
	window:SetSize( 200, 40 )
	window:Center()
	window:SetTitle( "" )
	window:SetVisible( true )
	window.btnClose:SetVisible( false )
	
	local  label = vgui.Create( "Label", window )
	label:SetText( "Loading..." )
	label:SetSize( 100, 20 )
	label:SetPos( 80, 10 )
	
	loadingwindow = window
end
usermessage.Hook( "SendBanMenu", ulx.showBanMenu )

function ulx.rcvBansStart( um )
	bans = {}
	sortedbans = {}
end
usermessage.Hook( "ULXBansStart", ulx.rcvBansStart )

function ulx.rcvBan( um )
	local k = um:ReadString()
	local v = ULib.umsgRcv( um )
	bans[ k ] = v
end
usermessage.Hook( "ULXBan", ulx.rcvBan )

-- Have to separate the reason out to make sure the msg isn't too big.
function ulx.rcvBanReason( um )
	local k = um:ReadString()
	local reason = um:ReadString()
	bans[ k ].reason = reason
end
usermessage.Hook( "ULXBanReason", ulx.rcvBanReason )

function ulx.rcvBansEnd( um )
	ulx.showBanMenuDone()
end
usermessage.Hook( "ULXBansEnd", ulx.rcvBansEnd )