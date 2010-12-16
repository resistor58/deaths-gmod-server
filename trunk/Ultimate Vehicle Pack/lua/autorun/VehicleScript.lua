AddCSLuaFile("Client/ClientVehicleScript.lua")
local function SpawnedVehicle(player, vehicle)
local localpos = vehicle:GetPos() local localang = vehicle:GetAngles()
			----Add passenger seats
if vehicle.VehicleTable then
	if vehicle.VehicleTable.AdjustSpawnPos then
	vehicle:SetAngles(localang + vehicle.VehicleTable.AdjustSpawnPos.Ang)
	vehicle:SetPos(localpos + vehicle.VehicleTable.AdjustSpawnPos.Pos)
	end
	
	if vehicle.VehicleTable.Passengers then		
			-----Grab the data for the extra seats, we do want the lovely sitting anim dont we.
			local SeatName = vehicle.VehicleTable.SeatType
			
			local seatdata = list.Get( "Vehicles" )[ SeatName ]
			
			-----Repeat for each seat.
		for a,b in pairs(vehicle.VehicleTable.Passengers) do
			local SeatPos = localpos + ( localang:Forward() * b.Pos.x) + ( localang:Right() * b.Pos.y) + ( localang:Up() * b.Pos.z)
			local Seat = ents.Create( "prop_vehicle_prisoner_pod" )
			Seat:SetModel( seatdata.Model )
			Seat:SetKeyValue( "vehiclescript" , "scripts/vehicles/prisoner_pod.txt" )
			Seat:SetAngles( localang + b.Ang )
			Seat:SetPos( SeatPos )
				Seat:Spawn()
				Seat:Activate()
				Seat:SetParent(vehicle)
				if vehicle.VehicleTable.HideSeats then
					Seat:SetColor(255,255,255,0)
				end
			Seat.VehicleName = "Jeep Seat"
			Seat.VehicleTable = seatdata
			Seat.ClassOverride = "prop_vehicle_prisoner_pod"
			----------- Replace the position with the ent so we can find it later.
			vehicle.VehicleTable.Passengers[a].Ent = Seat
		end
	end
end
end

local NormalExits = { "exit1","exit2","exit3","exit4","exit5","exit6"}
local function GetVehicleExit(player,vehicle)
if vehicle.VehicleTable then
	if vehicle.VehicleTable.Customexits then
		for a,b in pairs(vehicle.VehicleTable.Customexits) do
		----------------Calculate actual postion ------------------
		local localpos = vehicle:GetPos() local localang = vehicle:GetAngles()
		localpos = localpos + ( localang:Forward() * b.x) + ( localang:Right() * b.y) + ( localang:Up() * b.z)
		-----------Trace to see if we can get out there------
		if vehicle:VisibleVec(localpos) then
		player:SetPos(localpos)
		return
		end
		end
	end
	for a,b in pairs(NormalExits) do
		local angpos = vehicle:GetAttachment( vehicle:LookupAttachment( b ) )
		if angpos != nil then
		if 	vehicle:VisibleVec( angpos.Pos ) then
		player:SetPos( angpos.Pos )
		return
		end
		end
	end
end
end

local function DoVehicleExit( player ) 
	local vehicle = player:GetVehicle()
	----i need to make sure the player is deffinately out of the car.
	if player:InVehicle() then
	player:ExitVehicle()
	end
	----by now we should be out of the car, we better check this just to prevent any errors
	if !player:InVehicle() then
		if vehicle.VehicleTable then
		if vehicle:GetParent():IsValid() then
		local parent = vehicle:GetParent()
			if parent:IsVehicle() then
				if parent.VehicleTable.Passengers then
					GetVehicleExit(player,parent)
				end
			end
		elseif vehicle.VehicleTable.Customexits then
			GetVehicleExit(player,vehicle)
		end
		end
	end
end

-------The "PlayerUse" seems to repeat about 3 times, i better stop this.
local lastcheck = CurTime()
function GetInCar( player , vehicle )	
   ------Seat trace, allows you to access seats inside a car.
	if vehicle:IsVehicle() and lastcheck + 0.3 < CurTime() then
		if vehicle.VehicleTable then
		if vehicle.VehicleTable.Passengers then
			-----trace trough the car and see if your looking at a seat----
			local Start = player:GetShootPos() local Forward = player:GetAimVector()
			local trace = {} trace.start = Start trace.endpos = Start + (Forward * 90)
			trace.filter = { player , vehicle } local trace = util.TraceLine( trace ) 
			-----did we hit a seat? if so, can we get in it?
			if trace.Entity:IsValid() and trace.Entity:IsVehicle() then
				if trace.Entity:GetDriver() != nil and player:GetVehicle() != nil then
				player:EnterVehicle( trace.Entity )
				end
			end
		end
		end
	end
lastcheck = CurTime()
return true
end
hook.Add( "PlayerUse", "GetInCar", GetInCar ) 

local function RepositionPlayer( player, vehicle )
					---------Calculate Pos-------------
		local localpos = vehicle:GetPos() local localang = vehicle:GetAngles()
		local definepos = vehicle.VehicleTable.AdjustSitPos
		localpos = localpos + ( localang:Forward() * definepos.x) + ( localang:Right() * definepos.y) + ( localang:Up() * definepos.z)
					----------------------------------------
		player:SetParent()
		player:SetPos(localpos)
		player:SetParent(vehicle)
end



local function EnteredVehicle( player, vehicle, role )
	----Setup / clear VeiwData
	player:SendLua("LocalPlayer().VehicleViewMod = {}" )
	if vehicle.VehicleTable then
	if vehicle.VehicleTable.ModView then
		if vehicle.VehicleTable.ModView.FirstPerson then
		local Vec = vehicle.VehicleTable.ModView.FirstPerson
		player:SendLua("LocalPlayer().VehicleViewMod.FirstPos = Vector("..Vec.x..","..Vec.y..","..Vec.z..")" )
		end
		if vehicle.VehicleTable.ModView.ThirdPerson then
		player:SendLua("LocalPlayer().VehicleViewMod.ThirdOut = ".. vehicle.VehicleTable.ModView.ThirdPerson.Out )
		player:SendLua("LocalPlayer().VehicleViewMod.ThirdUp = ".. vehicle.VehicleTable.ModView.ThirdPerson.Up )
		end	
	end
	if vehicle.VehicleTable.AdjustSitPos then
	--I Had to delay the function, Otherwise it just looses effect
	timer.Simple(0.1, RepositionPlayer, player, vehicle) 
	--RepositionPlayer(player,vehicle)
	end
	end
end 

local function SetVehicleAnimation( player, anim )
	local seq = seq
	if (player:InVehicle()) then
	local vehicle = player:GetVehicle()
	if vehicle.VehicleTable then
		if (vehicle:GetTable().HandleAnimation ) then seq = vehicle:GetTable().HandleAnimation( player )
		else
			local class =player:GetVehicle():GetClass()
			if ( vehicle.VehicleTable.Animation ) then seq = player:LookupSequence( vehicle.VehicleTable.Animation )
			elseif ( class == "prop_vehicle_jeep" ) then seq = player:LookupSequence( "drive_jeep" )
			elseif ( class == "prop_vehicle_airboat" ) then	seq = player:LookupSequence( "drive_airboat" )
			else seq = player:LookupSequence( "drive_pd" )
			end
		end
	player:SetPlaybackRate( 1.0 ) player:ResetSequence( seq ) player:SetCycle( 0 ) return true
	end
	end
end

local function ExitingCar ( player, key )
 if key == IN_USE and player:InVehicle() then
	DoVehicleExit(player)
	---now i need to set the position after i get out of the car... so instead of waiting for this to pass, ill forse it myself
	return false
 end
end

if SERVER then
hook.Add( "KeyPress", "ExitingCar", ExitingCar ) 
end
hook.Add( "SetPlayerAnimation", "VehicleAnimation", SetVehicleAnimation )
hook.Add( "PlayerSpawnedVehicle", "SpawnedVehicle", SpawnedVehicle ); 
hook.Add( "PlayerEnteredVehicle", "EnteredVehicle", EnteredVehicle ); 
