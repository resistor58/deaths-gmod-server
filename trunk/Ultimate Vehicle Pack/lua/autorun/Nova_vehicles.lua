local V = { 	
				Name = "Airboat Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Airboat passenger Seat",
				Model = "models/nova/airboat_seat.mdl",
				Animation = "sit",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = { Out = 30 , Up = 20 } },
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "airboat_seat", V )
resource.AddFile( "models/nova/airboat_seat.mdl" )

local V = { 	
				Name = "Bus Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Solid_Granite",
				Information = "Schoolbus passenger Seat",
				Model = "models/busseat.mdl",
				Animation = "sit",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,0,-90) },
				ModView = { ThirdPerson = { Out = 30 , Up = 20 } },
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "bus_seat", V )
resource.AddFile( "models/busseat.mdl" )

local V = { 	
				Name = "Jeep Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Classic Jeep passenger Seat",
				Model = "models/nova/jeep_seat.mdl",
				Animation = "sit",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "jeep_seat", V )
resource.AddFile( "models/nova/jeep_seat.mdl" )

local V = { 	
				Name = "Wood Chair", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Good Ol' Wooden chair",
				Model = "models/nova/chair_wood01.mdl",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				Animation = "sit",
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "wood_chair", V )
resource.AddFile( "models/nova/chair_wood01.mdl" )

local V = { 	
				Name = "Wooden Barstool", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "LSK",
				Information = "Good Ol' Wooden barstool, you alcoholic you.",
				Model = "models/nova/chair_wood01.mdl",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				Animation = "sit",
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "wooden_barstool", V )
resource.AddFile( "models/nova/barstool01.mdl" )

local V = { 	
				Name = "Office Chair big", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Big and Comfortable office chair",
				Model = "models/nova/chair_office02.mdl",
				Animation = "sit",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "office_chair_big", V )
resource.AddFile( "models/nova/chair_office02.mdl" )
local V = { 	
				Name = "Office Chair small", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Just a Basic office chair",
				Model = "models/nova/chair_office01.mdl",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				Animation = "sit",
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "office_chair_small", V )
resource.AddFile( "models/nova/chair_office01.mdl" )
local V = { 	
				Name = "Metal Chair", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Cheap metal chair",
				Model = "models/nova/chair_plastic01.mdl",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				Animation = "sit", --this is how you define a now animation
				KeyValues = { vehiclescript	=	"scripts/vehicles/prisoner_pod.txt" }
			}
list.Set( "Vehicles", "plastic_chair", V )
resource.AddFile( "models/nova/chair_plastic01.mdl" )

if 	util.IsValidModel( "models/vehicle.mdl" ) then		
local V = { 
				Name = "Jalopy Seat", 
				Class = "prop_vehicle_prisoner_pod",
				Category = "Seats.Nova",
				Author = "Nova[X]",
				Information = "Jalopy passenger Seat",
				Model = "models/nova/jalopy_seat.mdl",
				AdjustSpawnPos = { Pos = Vector(0,0,0) , Ang = Angle(0,-90,0) },
				ModView = { ThirdPerson = {Out = 30 , Up = 20} },
				Animation = "sit",
				KeyValues = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt"}
			}
list.Set( "Vehicles", "jalopy_seat", V )
resource.AddFile( "models/nova/jalopy_seat.mdl" )
end

local V = { 	
				Name = "Jeep(VU)", 
				Class = "prop_vehicle_jeep_old",
				Category = "Half-Life 2",
				Author = "Nova[X]",
				Information = "The regular old jeep, with an extra seat",
				Model = "models/buggy.mdl",
				Passengers  = { passenger1 = { Pos = Vector(16,37,19), Ang = Angle(0,0,0) } }, -------Set Up passenger seats!
				SeatType = "jeep_seat", ----if were not hideing the seat you probably wnat to choose a seat.
				HideSeats = false, -----Hide the passenger seats?
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test.txt"
							}
			}
list.Set( "Vehicles", "Jeep(VU)", V )

----Just so those poor people who dont own EP2 dont have a cry
if 	util.IsValidModel( "models/vehicle.mdl" ) then		
local V = { 	
				Name = "Jalopy(VU)", 
				Class = "prop_vehicle_jeep",
				Category = "Half-Life 2",
				Author = "Nova[X]",
				Information = "Jalopy, With a working passenger seat!",
				Model = "models/vehicle.mdl",
				AdjustSitPos = Vector(-18,36,22),
				Cassengers  = { passenger1 = { Pos = Vector(22,24,22), Ang = Angle(0,0,0) } }, -------Set Up passenger seats!
				Customexits = { Vector(-90,36,22), Vector(82,36,22), Vector(22,24,90) ,Vector(2,100,30) },
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				HideSeats = true, -----Hide the passenger seats?
				KeyValues = {vehiclescript	=	"scripts/vehicles/jalopy.txt"}
			}
list.Set( "Vehicles", "Jalopy(VU)", V )
end
