local cbox

local function btnPress( btn )
	if not cbox:GetSelected() or not cbox:GetSelected().ply:IsValid() then return end -- No one has been selected.
	
	local dummy, dummy, command, args = string.find( btn.data, "(%a+)%s*(.*)" )
	if not args:find( "#T" ) then args = args .. " #T" end -- If they didn't specify where to stick the player, add it to end.
	args = args:gsub( "#T", "\"" .. cbox:GetSelected().ply:Nick() .. "\"", 1 )
	ULib.redirect( LocalPlayer(), command, _,  args ) -- So we don't have to use ConCommand() and risk it being blocked.
end

function ulx.showClientMenu()
	selectedply = nil
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 640, 480 )
	window:Center()
	window:SetTitle( "ULX Client Menu" )
	window:SetVisible( true )
	window:MakePopup()
	
	local ctrl = vgui.Create( "DComboBox", window )
	ctrl:SetSize( 210, 440 )	
	ctrl:SetPos( 10, 30 )
	cbox = ctrl
	
	local players = player.GetAll()
	local t = {}
	for _, ply in ipairs( players ) do
		local item = ctrl:AddItem( ply:Nick() )
		item.ply = ply
	end	
	
	t = {}
	for k, v in pairs( ulx.clientMenuContents ) do
		local dummy, dummy, command, args = string.find( v, "(%a+)%s*(.*)" )
		if command == "ulx" then
			dummy, dummy, command2, args = string.find( args, "(%a+)%s*(.*)" )
			command = command .. " " .. command2
		end
		if ULib.ucl.query( LocalPlayer(), command ) then
			t[ k ] = v
		end
	end	
	options = {}
	options.columns = 4
	options.wide = 400
	options.visibleRows = 11
	options.buttonWide = 80
	options.buttonTall = 30
	options.vspacing = 10
	options.callback = btnPress
	local panel2 = ulx.controlListMaker( window, t, options )
	panel2:SetPos( 230, 30 )	
end
usermessage.Hook( "SendClientMenu", ulx.showClientMenu )