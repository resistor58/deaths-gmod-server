

concommand.Add( "SetSCarPlayerWepKey", function( ply, com, args )

	local key = args[1]
	local setKey = -1
	--ply.ScarSpecialKeyInput = args[1]
	
	
	--I just hate doing this but i haven't found any String to int func :[
	
	if key == "0.00" then
		setKey = 0
	elseif key == "1.00" then
		setKey = 1
	elseif key == "2.00" then
		setKey = 2
	elseif key == "3.00" then
		setKey = 3
	elseif key == "4.00" then
		setKey = 4
	elseif key == "5.00" then
		setKey = 5
	elseif key == "6.00" then
		setKey = 6
	elseif key == "7.00" then
		setKey = 7
	elseif key == "8.00" then
		setKey = 8
	elseif key == "9.00" then
		setKey = 9
	elseif key == "10.00" then
		setKey = 10		
	elseif key == "11.00" then	
		setKey = 11		
	end
	
	if setKey >= 10 then
		ply.ScarSpecialMiscKeyInput = setKey
	else
		ply.ScarSpecialKeyInput = setKey
	end

end)