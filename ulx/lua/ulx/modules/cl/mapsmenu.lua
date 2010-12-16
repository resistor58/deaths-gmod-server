local gamemodes = {}

local function rcvGamemode( um )
	local gamemode = um:ReadString()
	table.insert( gamemodes, gamemode )
end
usermessage.Hook( "ulx_gamemode", rcvGamemode )

local function rcvGamemodeClear( um )
	gamemodes = {}
end
usermessage.Hook( "ulx_cleargamemodes", rcvGamemodeClear )

local function btnPress( btn )
	local panel = btn:GetParent():GetParent():GetParent()
	local gamemode = panel.button:GetValue():sub( 11 )
	if gamemode == "<default>" then
		RunConsoleCommand( "ulx", "map", btn:GetValue() )
	else
		RunConsoleCommand( "ulx", "map", btn:GetValue(), gamemode )
	end
	panel:GetParent():Remove()
end

function ulx.showMapsMenu()
	RunConsoleCommand( "ulx_getgamemodes" )
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 640, 480 )
	window:Center()
	window:SetTitle( "ULX Maps Menu" )
	window:SetVisible( true )
	window:MakePopup()
	
	local t = {}
	for _, map in ipairs( ulx.maps ) do
		t[ map ] = true
	end	
	options = {}
	options.columns = 5
	options.visibleRows = 13
	options.buttonWide = 110
	options.buttonTall = 20
	options.vspacing = 10
	options.callback = btnPress
	local panel = ulx.controlListMaker( window, t, options )
	panel:SetPos( 10, 30 )
	
	local button = vgui.Create( "DButton", window )
	button:SetText( "Gamemode: <default>" )
	button:SetSize( 200, 30 )
	button:SetPos( (window:GetWide() - button:GetWide()) / 2, window:GetTall() - 50 )
	button.DoClick = function ( btn )		
		local menu = DermaMenu()
		menu:AddOption( "<default>", function() button:SetText( "Gamemode: <default>" ) end )
		table.sort( gamemodes )
		for _, gamemode in ipairs( gamemodes ) do
			menu:AddOption( gamemode:sub( 1, 1 ):upper() .. gamemode:sub( 2 ), function() button:SetText( "Gamemode: " .. gamemode:sub( 1, 1 ):upper() .. gamemode:sub( 2 ) ) end )
		end
		menu:Open()	
	end
	
	panel.button = button
end

usermessage.Hook( "SendMapsMenu", ulx.showMapsMenu )