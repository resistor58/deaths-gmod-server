--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile( "SCarHUD.lua" )

resource.AddFile( "materials/SCarHUD/gear.vtf" )
resource.AddFile( "materials/SCarHUD/speedPointer.vtf" )
resource.AddFile( "materials/SCarHUD/rev.vtf" )
resource.AddFile( "materials/SCarHUD/speed.vtf" )
resource.AddFile( "materials/SCarHUD/fuelPointer.vtf" )

resource.AddFile( "materials/SCarHUD/gear.vmt" )
resource.AddFile( "materials/SCarHUD/speedPointer.vmt" )
resource.AddFile( "materials/SCarHUD/rev.vmt" )
resource.AddFile( "materials/SCarHUD/speed.vmt" )
resource.AddFile( "materials/SCarHUD/fuelPointer.vmt" )

	// Get Texture ID's
	local SpeedTex = surface.GetTextureID("SCarHUD/speed")
	local SpeedPointerTex = surface.GetTextureID("SCarHUD/speedPointer")
	local RevTex = surface.GetTextureID("SCarHUD/rev") 
	local GearTex = surface.GetTextureID("SCarHUD/gear") 
	local FuelTex = surface.GetTextureID("SCarHUD/fuelPointer") 
	
	// Screen Info
	local Width = ScrW()
	local Height = ScrH()
	local size = Height * 0.03333333
	
	surface.CreateFont( "Agency FB", size, 200, 0, 0, "gear")
	local wasInVehicle = false
	local isScarSeat = 0
	local useHud = 0
	
function DrawHud() 
	
	if !LocalPlayer():Alive() then return end
	if(LocalPlayer():GetActiveWeapon() == NULL or LocalPlayer():GetActiveWeapon() == "Camera") then return end		
	if GetViewEntity():GetClass() == "gmod_cameraprop" then return end
	
	local veh = LocalPlayer():GetVehicle()
	local ply = LocalPlayer()	
	

	
	if wasInVehicle == false && ply:InVehicle() then
		wasInVehicle = true
		isScarSeat = veh:GetNetworkedInt( "SCarSeat" )
		useHud = veh:GetNetworkedInt( "SCarUseHud" )
	elseif not(ply:InVehicle()) then
		wasInVehicle = false
	end
	
	
	if ply:InVehicle() && isScarSeat == 1 && useHud == 1 then
	
		--Whecking if the user have a widescreen res or not.
		local Width = ScrW()
		local Height = ScrH()
		local isWideScreen = true
		
		if (Width / Height) <= (4 / 3) then
			isWideScreen = false
		end	
	
		local Width = ScrW()
		local Height = ScrH()
	
		local vel = veh:GetVelocity():Length()
		local mph = vel / 23.5
		local kmh = mph * 1.609
		local rev = veh:GetNetworkedFloat( "EngineRev" )
		local CurGear = veh:GetNetworkedInt( "SCarGear" )
		local showGear = NULL
		local fuel = veh:GetNetworkedInt( "SCarFuel" )
		
		
		CurGear = CurGear + 1
		
		if CurGear == 0 then
			showGear = "R"
		elseif CurGear == -1 then
			showGear = "B"		
		elseif CurGear == -2 then
			showGear = "H"		
		else
			showGear = tostring(CurGear)
		end
		
		mph = math.Round( mph )
		kmh = math.Round( kmh )
		
		if mph > 170 then
			mph = 170
		end
		
		if kmh > 274 then
			kmh = 274
		end

		--Km/h
		local rotation = vel * -0.075		
		local xPos = 0
		local yPos = 0
		local xSize = 0
		local ySize = 0
		
		//Speed
		if isWideScreen then
			xPos = Width * 0.8214285714
			yPos = Height * 0.7142857143
			xSize = Width * 0.1785714286
			ySize = Height * 0.2857142857
		else
			xPos = Width * 0.8214285714
			yPos = Height * 0.7823142857
			xSize = Width * 0.1785714286
			ySize = Height * 0.2176870749	
		end	
		
		surface.SetTexture( SpeedTex )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( xPos, yPos, xSize, ySize )	

		--speed arrow
		if isWideScreen then
			xPos = Width * 0.9107142857
			yPos = Height * 0.8571428571
			xSize = Width * 0.1785714286
			ySize = Height * 0.2857142857
		else
			xPos = Width * 0.9107142857
			--yPos = Height * 0.925170068
			yPos = Height * 0.8911564626
			xSize = Width * 0.1785714286
			ySize = Height * 0.2176870749		
		end		
		
	
		
		
		surface.SetTexture( SpeedPointerTex )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( xPos, yPos, xSize, ySize, rotation )

		--Fuel arrow
		if isWideScreen then
			xPos = Width * 0.9107142857
			yPos = Height * 0.939047619
			xSize = Width * 0.0595238095
			ySize = Height * 0.0952380952
		else
			xPos = Width * 0.9107142857
			--yPos = Height * 0.9616190476			
			yPos = Height * 0.9503854875
			xSize = Width * 0.0595238095
			ySize = Height * 0.0725714286	
		end
		
		rotation = fuel * -0.006
		surface.SetTexture( FuelTex )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRectRotated( xPos , yPos, xSize, ySize, rotation )
		
	
		if isWideScreen then	
			xPos = Width * 0.7023809524
			yPos = Height * 0.8095238095
			xSize = Width * 0.119047619
			ySize = Height * 0.1904761905
		else
			xPos = Width * 0.7023809524
			yPos = Height * 0.8548752835
			xSize = Width * 0.119047619
			ySize = Height * 0.1451247165		
		end

			
		rotation = (rev - 40) * -1.3
		//Rev
		surface.SetTexture( RevTex )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( xPos, yPos, xSize, ySize )

		--Rev arrow		
		if isWideScreen then		
			xPos = Width * 0.7619047619
			yPos = Height * 0.9047619048
			xSize = Width * 0.119047619
			ySize = Height * 0.1904761905
		else
			xPos = Width * 0.7619047619
			--yPos = Height * 0.9501133787
			yPos = Height * 0.9274376418
			xSize = Width * 0.119047619
			ySize = Height * 0.1451247165	
		end

		
		rotation = (rev - 40) * -1.3		
		surface.SetTexture( SpeedPointerTex )
		surface.SetDrawColor( 255, 255, 255, 255 )	
		surface.DrawTexturedRectRotated( xPos, yPos, xSize, ySize, rotation )
		
		//Gear	
		if isWideScreen then				
			xPos = Width * 0.8107142857
			yPos = Height * 0.933333333
			xSize = Width * 0.0380952381
			ySize = Height * 0.060952381
		else
			xPos = Width * 0.8107142857
			yPos = Height * 0.947845805
			xSize = Width * 0.0380952381
			ySize = Height * 0.0464399093		
		end
			
		surface.SetTexture( GearTex )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( xPos, yPos, xSize, ySize )

		if isWideScreen then				
			xPos = Width * 0.8297619048
			yPos = Height * 0.9619047619		
		else
			xPos = Width * 0.8297619048
			yPos = Height * 0.9619047619		
		end
		
		draw.SimpleText( showGear, "gear", xPos, yPos, Color( 255, 255, 255, 200 ), 1, 1 )
	end
end

hook.Add( "HUDPaint", "DrawSCarHUD", DrawHud )


--Hide the default HUD if we are using the mech
function Hide( Element ) 

	local ply = LocalPlayer()

	if ValidEntity(ply) && ply:InVehicle() && isScarSeat == 1 && useHud == 1 then
		if ( Element == "CHudHealth" ) or ( Element == "CHudBattery" ) then   
		   return false
		end
		   
		if ( Element == "CHudAmmo" ) and ShowAmmo or ( Element == "CHudSecondaryAmmo" ) and ShowAmmo then
		   return false
		end
	end
end
hook.Add("HUDShouldDraw", "HideCrapScarHud", Hide) 
