local function btnPress( btn ) 
	btn:GetParent():GetParent():GetParent():GetParent():Close() -- Fun chain!!
	local dummy, dummy, command, args = string.find( btn.data, "(%a+)%s*(.*)" )	
	ULib.redirect( LocalPlayer(), command, _,  args ) -- So we don't have to use ConCommand() and risk it being blocked.
end

function ulx.showMainMenu()
	local t = {} -- We're going to fill this with what we have access to.
	for label, command in pairs( ulx.mainMenuContents ) do
		if ULib.ucl.query( LocalPlayer(), command ) then
			t[ label ] = command
		end
	end
	
	-- All this junk is so the menu will dynamically size.
	local maxColumns = 5 -- Max columns
	local window = vgui.Create( "DFrame" )
	local num = table.Count( t ) -- How many buttons?
	local actualColumns = math.min( num, maxColumns ) -- Meet max
	
	window:SetWide( actualColumns * 100 + 20 )
		
	local rows = math.ceil( num / maxColumns )
	local visibleRows = math.Clamp( rows, 0, 8 )	
	window:SetTall( visibleRows * 40 + 40 )
	
	window:SetPos( ( ScrW() - window:GetWide() ) / 2, ScrH() - window:GetTall() - 40 ) -- Put this bottom center
	window:SetTitle( "ULX Main Menu" )
	window:SetVisible( true )
	window:MakePopup()
	
	options = {}
	options.columns = actualColumns
	options.visibleRows = visibleRows
	options.buttonWide = 80
	options.buttonTall = 30
	options.vspacing = 10
	options.callback = btnPress
	local panel = ulx.controlListMaker( window, t, options )
	panel:SetPos( 10, 30 )
end