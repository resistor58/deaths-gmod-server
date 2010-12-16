local display_owners = false

concommand.Add( "wire_holograms_display_owners", function()
	display_owners = !display_owners
end )

hook.Add( "HUDPaint", "wire_holograms_showowners", function()
	if !display_owners then return end
	
	for _,ent in pairs( ents.FindByClass( "gmod_wire_hologram" ) ) do
		local id = ent:GetNWInt( "ownerid" )
		
		for _,ply in pairs( player.GetAll() ) do
			if ply:UserID() == id then
				local vec = ent:GetPos():ToScreen()
				
				draw.DrawText( ply:Name() .. "\n" .. ply:SteamID(), "ScoreboardText", vec.x, vec.y, Color(255,0,0,255), 1 )
				break
			end
		end
	end
end )
