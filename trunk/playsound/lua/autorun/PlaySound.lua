local function PlaySound(playerx, command, arguments)

	//Run on all clients when triggered by admins
	if  playerx:IsAdmin() || playerx:IsSuperAdmin() then

		//Don't run if no sound specified
		if arguments[1] == nil then return end

		//Stop sounds if "stop"
		if arguments[1] == "stop" then
			local locateplayers = player.GetAll()
			for i = 1, table.getn(locateplayers) do
			locateplayers[i]:ConCommand("stopsounds")
			end
		return end

		util.PrecacheSound(arguments[1])

		//Play sound
		local locateplayers = player.GetAll()
		for i = 1, table.getn(locateplayers) do
		locateplayers[i]:ConCommand("play " .. arguments[1] .. "")
		end

	end

	//Run locally if triggered by a non-admin user
	if  !playerx:IsAdmin() && !playerx:IsSuperAdmin() then

		//Don't run if no sound specified
		if arguments[1] == nil then return end

		//Stop sounds if "stop"
		if arguments[1] == "stop" then
		playerx:ConCommand("stopsounds")
		return end

		util.PrecacheSound(arguments[1])

		//Play sound
		playerx:ConCommand("play " .. arguments[1] .. "")

	end

end

concommand.Add("playsound", PlaySound)