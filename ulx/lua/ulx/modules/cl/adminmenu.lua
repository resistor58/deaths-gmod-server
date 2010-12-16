local controls
local lastvalues = {}

local function rcvValues( um )
	local cvar = um:ReadString()
	local value = um:ReadShort()
	
	for _, control in ipairs( controls ) do
		if control.data.cvar == cvar then
			if not control.data.button then
				control:SetValue( value )
				lastvalues[ cvar ] = value
			else
				if value == 1 then
					control:SetText( control.data.on )
				else
					control:SetText( control.data.off )
				end				
			end
		end
	end
end
usermessage.Hook( "ulx_menuvalues", rcvValues )

local function doApply()
	for _, control in ipairs( controls ) do
		if not control.data.button then
			local data = control.data
			local value = math.floor( control:GetValue() ) -- Have to floor it because we have precision errors somewhere
			local oldValue = math.floor( lastvalues[ data.cvar ] )
			
			if not data.denyOverflow then
				control:SetMax( math.max( ( 2 * value ), data.max ) )
			end
			
			if value ~= oldValue then
				lastvalues[ data.cvar ] = value
				RunConsoleCommand( "ulx_cvar", data.cvar, value )
			end
		end
	end
end

local function btnPress( control )
	local on
	if control:GetValue() == control.data.off then
		on = "1"
		control:SetText( control.data.on )
	else
		on = "0"
		control:SetText( control.data.off )
	end
	
	RunConsoleCommand( "ulx_cvar", control.data.cvar, on )
end

function ulx.showAdminMenu()
	if not ULib.isSandbox() then
		ULib.csay( LocalPlayer(), "Sorry, this menu is only available in a sandbox gamemode." )
		return
	end

	RunConsoleCommand( "ulx_valueupdate" )
	controls = {}
	
	local window = vgui.Create( "DFrame" )
	window:SetSize( 640, 480 )
	window:Center()
	window:SetTitle( "ULX Admin Menu" )
	window:SetVisible( true )
	window:MakePopup()

	local t = {}
	for _, data in pairs( ulx.adminMenuContents ) do
		if data.button then
			t[ data.off ] = data
		end
	end
	local newcontrols	
	local options = {}
	options.columns = 1
	options.wide = 150
	options.visibleRows = 15
	options.buttonWide = 140
	options.buttonTall = 24
	options.vspacing = 5
	options.callback = btnPress
	local panel1, newcontrols = ulx.controlListMaker( window, t, options )
	panel1:SetPos( 10, 30 )
	table.Add( controls, newcontrols )
	
	t = {}
	for lbl, data in pairs( ulx.adminMenuContents ) do
		if not data.button then
			t[ lbl ] = data
		end
	end	
	newcontrols = nil
	options = {}
	options.columns = 2
	options.wide = 460
	options.visibleRows = 7
	options.buttonWide = 200
	options.buttonTall = 50
	options.vspacing = 5
	options.controlName = "DNumSlider"	
	local panel2, newcontrols = ulx.controlListMaker( window, t, options )
	panel2:SetPos( panel1.X + panel1:GetWide() + 10, 30 )		
	table.Add( controls, newcontrols )
	
	local apply = vgui.Create( "DButton", window )
	apply:SetSize( 100, 40 )
	apply:SetPos( panel2.X + (panel2:GetWide() - apply:GetWide())/2, panel2.Y + panel2:GetTall() + 15 )
	apply:SetText( "Apply" )
	apply.DoClick = doApply
end