--Thanks Overv! You are awesome.
--Overv helped me with everything in this menu.
--All credits to Overv.

AddCSLuaFile( "S_SCarConsole.lua" )

concommand.Add( "sakarias_changelimit", function( ply, com, args )
	if ply:IsAdmin() then
		if ( string.match( args[1], "scar_[a-zA-z]+" ) and tonumber( args[2] ) ) then
			RunConsoleCommand( args[1], args[2] )	
		end
	end	
end)

concommand.Add( "sakarias_updateallvehicles", function( ply, com, args )

	if ply:IsAdmin() then	
		for k, v in pairs( ents.GetAll() ) do
			if string.find( v:GetClass( ), "sent_sakarias_car*" ) && not(string.find( v:GetClass( ), "sent_sakarias_carwheel" ) or string.find( v:GetClass( ), "sent_Sakarias_carwheel_punked" ) or v.IsDestroyed == 1) then
				v:UpdateAllCharacteristics()	
			end 
		end
	end
end)