local HTML = {}

function HTML:StatusChanged( text )
end

function HTML:ProgressChanged( progress )
end

function HTML:FinishedURL( url )
end

function HTML:OpeningURL( url, target )
end

vgui.Register( "ULXMotd", HTML, "HTML" )



function ulx.showMotdMenu()	
	local window = vgui.Create( "DFrame" )
	if ScrW() > 640 then -- Make it larger if we can.
		window:SetSize( ScrW()*0.9, ScrH()*0.9 )
	else
		window:SetSize( 640, 480 )
	end
	window:Center()
	window:SetTitle( "ULX MOTD" )
	window:SetVisible( true )
	window:MakePopup()

	local html = vgui.Create( "ULXMotd", window )
	
	local button = vgui.Create( "DButton", window )
	button:SetText( "Close" )
	button.DoClick = function() window:Close() end
	button:SetSize( 100, 40 )
	button:SetPos( (window:GetWide() - button:GetWide()) / 2, window:GetTall() - button:GetTall() - 10 )	
	
	html:SetSize( window:GetWide() - 20, window:GetTall() - button:GetTall() - 50 )
	html:SetPos( 10, 30 )
	html:SetHTML( file.Read( "ulx/motd.txt" ) )
end
usermessage.Hook( "SendMotdMenu", ulx.showMotdMenu )

function ulx.rcvMotdStart( um )
	ulx.motdContent = ""
end
usermessage.Hook( "ULXMotdStart", ulx.rcvMotdStart )

function ulx.rcvMotdEnd( um )
	file.Write( "ulx/motd.txt", ulx.motdContent )
	ulx.motdContent = nil
end
usermessage.Hook( "ULXMotdEnd", ulx.rcvMotdEnd )

function ulx.rcvMotdText( um )
	ulx.motdContent = ulx.motdContent .. um:ReadString()
end
usermessage.Hook( "ULXMotdText", ulx.rcvMotdText )