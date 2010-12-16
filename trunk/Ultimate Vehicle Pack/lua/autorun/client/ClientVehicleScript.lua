function DoVehicleVeiw( player, origin, angles, fov )
if player:InVehicle() and player.VehicleViewMod then
local VeiwMod = player.VehicleViewMod
 if gmod_vehicle_viewmode:GetInt() == 1 then
	if VeiwMod.ThirdOut and VeiwMod.ThirdUp then
		local view = {}
		view.angles = angles
		view.origin = origin - ( angles:Forward() * VeiwMod.ThirdOut ) + ( angles:Up() * VeiwMod.ThirdUp )
	return view
	end
 else
	if VeiwMod.FirstPos then
	local Pos = VeiwMod.FirstPos
    	local view = {}
		view.angles = angles
		view.origin = origin + ( angles:Forward() * Pos.x ) + ( angles:Right() * Pos.y ) + ( angles:Up() * Pos.z )
	return view
	end
 end
end
end
hook.Add("CalcView", "DoVehicleVeiw", DoVehicleVeiw) 