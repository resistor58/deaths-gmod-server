local Category = "PhoeniX-Storms"

local function HandlePHXSeatAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_SIT ) 
end

local function HandlePHXVehicleAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_DRIVE_JEEP ) 
end

local function HandlePHXCoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

//PhoeniX-Storms Vehicles

local V = { 	
				Name = "Car Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Sitting Animation",
				Model = "models/props_phx/carseat2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXSeatAnimation,
							}
}
list.Set( "Vehicles", "phx_seat", V )

local V = { 	
				Name = "Car Seat 2", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Driving Animation",
				Model = "models/props_phx/carseat3.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXVehicleAnimation,
							}
}
list.Set( "Vehicles", "phx_seat2", V )

local V = { 	
				Name = "Car Seat 3", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "PHX Airboat Seat Rollercoaster Animation",
				Model = "models/props_phx/carseat2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXCoasterAnimation,
							}
}
list.Set( "Vehicles", "phx_seat3", V )

local V = { 	
				Name = "FSD Overrun", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "PhoeniX-Storms",
				Information = "FSD Overrun Monorail",
				Model = "models/props_phx/trains/fsd-overrun2.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXVehicleAnimation,
							}
}
list.Set( "Vehicles", "phx_train", V )

//XQM Model Pack Vehicles

local V = { 	
				Name = "Modern Chair", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "x-quake",
				Information = "Modern Seat",
				Model = "models/XQM/modernchair.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							},
				Members = {
								HandleAnimation = HandlePHXSeatAnimation,
							}
}
list.Set( "Vehicles", "xqm_modernchair", V )

local V = { 	
				Name = "Pod Remake", 
				Class = "prop_vehicle_prisoner_pod",
				Category = Category,

				Author = "x-quake",
				Information = "Pod Remake",
				Model = "models/XQM/PodRemake.mdl",
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								limitview		=	"0"
							}
}
list.Set( "Vehicles", "xqm_podremake", V )