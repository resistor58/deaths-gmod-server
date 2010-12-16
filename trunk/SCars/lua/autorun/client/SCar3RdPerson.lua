--Copyright (c) 2010 Sakarias Johansson

local posOffset = Vector(0,0,20)

hook.Add("CalcView", "SCar CalcView", function(ply, position, angles, fov)

	if !ply:Alive() then return end
	if(ply:GetActiveWeapon() == NULL or ply:GetActiveWeapon() == "Camera") then return end
	if GetViewEntity():GetClass() == "gmod_cameraprop" then return end
	

	local veh = LocalPlayer():GetVehicle()
	local isScarSeat = 0
	local ThirdPersonView = 0
	
	if ValidEntity(veh) then
		isScarSeat = veh:GetNetworkedInt( "SCarSeat" )
	end
	
	if isScarSeat == 1 then
		ThirdPersonView = veh:GetNetworkedInt( "SCarThirdPersonView" )
	end
	
	if veh != nil && isScarSeat != nil && isScarSeat == 1 && ThirdPersonView == 1 then

		local SCar = veh:GetNetworkedEntity("SCarEnt")
		local ang = ply:GetAimVector():Angle()
		local pos = SCar:GetPos()
		local cameraCorrection = veh:GetNetworkedInt( "SCarCameraCorrection" )
		local speed = SCar:GetVelocity()
		local vel = SCar:GetVelocity():Length()	
		local smoothing = vel

		
		if vel > 5000 then
			vel = 5000
		end

		if smoothing > 200 then
			smoothing = 200
		end

		smoothing = smoothing - 50
		if smoothing > 0 then
			smoothing = smoothing / 200
		else
			smoothing = 0
		end		
		
		--Overrided
		cameraCorrection = 1
		
		if cameraCorrection == 1 then
		
			--Movement
			speed = speed * -1
			local movediff = posOffset - speed
			posOffset.x = math.Approach(posOffset.x, (speed.x / 20), (movediff.x / 100))
			posOffset.y = math.Approach(posOffset.y, (speed.y / 20), (movediff.y / 100))
			posOffset.z = math.Approach(posOffset.z, (speed.z / 20), (movediff.z / 100))	
			
			pos = pos + posOffset * smoothing
			
			vel = (vel / 5000) * 90
			fov = 75 + vel	
			

			--Direction
			local direction = SCar:GetVelocity():Normalize()	
			local newDirection = ply:GetAimVector()		
			direction.y = direction.y * -1
			
			newDirection = newDirection + ((direction - newDirection) / 5) * smoothing
			
			angles = newDirection:Angle()

		end		

		local carDist = 200
		local up = 30
		
		local carDist, up = SakariasSCar_GetViewInfo( SCar:GetClass() )
		
		if !carDist then carDist = 0 end
		if !up then up = 0 end	
		
		pos = pos + (ang:Forward() * (carDist * -1)) + SCar:GetUp() * up			

		local Trace = {}
		Trace.start = SCar:GetPos() + SCar:GetUp() * up
		Trace.endpos = pos
		Trace.mask = MASK_NPCWORLDSTATIC
		local tr = util.TraceLine(Trace)		

		pos = tr.HitPos + tr.HitNormal

	
		return GAMEMODE:CalcView(ply, pos, angles, fov)
		
	elseif veh != nil && isScarSeat != nil && isScarSeat == 1 && ThirdPersonView == 0 then 	
		local SCar = veh:GetNetworkedEntity("SCarEnt")
		local vel = SCar:GetVelocity():Length()	
		local smoothing = vel

		
		if vel > 5000 then
			vel = 5000
		end

		if smoothing > 200 then
			smoothing = 200
		end

		smoothing = smoothing - 50
		if smoothing > 0 then
			smoothing = smoothing / 200
		else
			smoothing = 0
		end

		local direction = SCar:GetVelocity():Normalize()	
		local newDirection = ply:GetAimVector()		
		direction.y = direction.y * -1
		
		newDirection = newDirection + ((direction - newDirection) / 5) * smoothing
		
		angles = newDirection:Angle()		
		
		return GAMEMODE:CalcView(ply, position, angles, fov)
	end


end)