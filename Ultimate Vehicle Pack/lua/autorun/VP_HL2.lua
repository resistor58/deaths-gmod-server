//HL2 and CSS vehicles.

local Category = "Half-Life 2"


local V = { 	
				// Required information
				Name = "Piranesi APC", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "Piranesi APC",
				Model = "models/pirapc/pirapc.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/pirapc.txt"
							}
			}

list.Set( "Vehicles", "piranesi_apc", V )

local V = { 	
				// Required information
				Name = "Tides Truck", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "Kuno86",
				Information = "Tides Truck",
				Model = "models/tideslkw.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/tideslkw.txt"
							}
			}

list.Set( "Vehicles", "tideslkw", V )

local V = { 	
				// Required information
				Name = "Combine APC", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "Combine APC",
				Model = "models/combapc/combapc.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/combineapc.txt"
							}
			}

list.Set( "Vehicles", "combine_apc", V )

local V = { 	
				// Required information
				Name = "Human APC", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "Human APC",
				Model = "models/apc/apc.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/apc.txt"
							}
			}

list.Set( "Vehicles", "human_apc", V )

local V = { 	
				// Required information
				Name = "Turbo Jalopy", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "VALVe",
				Information = "The Episode 2 Jalopy",
				Model = "models/vehicle.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/turbo_jalopy.txt"
							}
			}

list.Set( "Vehicles", "Jalopy", V )

local V = { 	
				// Required information
				Name = "Old Truck", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "Kuno86",
				Information = "Old truck",
				Model = "models/hl2truck.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/hl2truck.txt"
							}
			}

list.Set( "Vehicles", "hl2truck", V )

local V = { 	
				// Required information
				Name = "Hover Bike", 
				Class = "prop_vehicle_airboat",
				Category = Category,

				// Optional information
				Author = "lasermaniac, blackops",
				Information = "Hover Bike",
				Model = "models/hoverbike.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/hoverbike_script.txt"
							}
			}

list.Set( "Vehicles", "Hover Bike", V )

local V = { 	
				// Required information
				Name = "Wheel-less Buggy", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "NeoDement",
				Information = "A wheel-less buggy.",
				Model = "models/wheellessbuggy.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test.txt"
							}
			}

list.Set( "Vehicles", "wheelless_buggy", V )

local V = { 	
				// Required information
				Name = "Wartburg", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "Kuno86",
				Information = "Wartburg, an HL:2 car converted to be drivable.",
				Model = "models/wartburg.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,9) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/wartburg.txt"
							}
			}

list.Set( "Vehicles", "wartburg", V )

local V = { 	
				// Required information
				Name = "Trabbi", 
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "Kuno86",
				Information = "Trabbi, an HL:2 car converted to be drivable.",
				Model = "models/trabbi.mdl",
				SeatType = "jeep_seat",
				ModView = { FirstPerson = Vector(0,0,12) },
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/trabbi.txt"
							}
			}

list.Set( "Vehicles", "trabbi", V )

local V = { 	
				Name = "Big Airboat",
				Class = "prop_vehicle_airboat",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/airboatbig.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/airboat_big.txt"
							}
			}

list.Set( "Vehicles", "big_airboat", V )

local V = { 	
				Name = "Small airboat",
				Class = "prop_vehicle_airboat",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/airboatsmall.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/airboat_rc.txt"
							}
			}

list.Set( "Vehicles", "small_airboat", V )

local V = { 	
				Name = "Jeep Rally",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyrally.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_rally.txt"
							}
			}

list.Set( "Vehicles", "jeep_rally", V )

local V = { 	
				Name = "Jeep Confused",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyconfused.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_confused.txt"
							}
			}

list.Set( "Vehicles", "jeep_confused", V )

local V = { 	
				Name = "Jeep Box Grren",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggybox2.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeepbox.txt"
							}
			}

list.Set( "Vehicles", "jeep_box_green", V )

local V = { 	
				Name = "Jeep Box Normal",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggybox.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeepbox.txt"
							}
			}

list.Set( "Vehicles", "jeep_box_normal", V )

local V = { 	
				Name = "Jeep Go-Cart Green",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyconcrete4.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_concrete2.txt"
							}
			}

list.Set( "Vehicles", "jeep_gokart_green", V )

local V = { 	
				Name = "Jeep Go-Cart No-Roof",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyconcrete3.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_concrete2.txt"
							}
			}

list.Set( "Vehicles", "jeep_gokart_noroof", V )

local V = { 	
				Name = "Jeep Go-Kart Mixed",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyconcrete2.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_concrete.txt"
							}
			}

list.Set( "Vehicles", "jeep_gokart_mixed", V )

local V = { 	
				Name = "Jeep Go-Kart",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyconcrete.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_concrete.txt"
							}
			}

list.Set( "Vehicles", "jeep_gokart", V )

local V = { 	
				Name = "Jeep Crazy",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggycrazy.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_crazy.txt"
							}
			}

list.Set( "Vehicles", "jeep_crazy", V )

local V = { 	
				Name = "Jeep Speedo",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyfast.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_speddo.txt"
							}
			}

list.Set( "Vehicles", "jeep_speedo", V )

local V = { 	
				Name = "Jeep Huge",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggyhuge.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_huge.txt"
							}
			}

list.Set( "Vehicles", "jeep_huge", V )

local V = { 	
				Name = "Jeep Big",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggybig.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_big.txt"
							}
			}

list.Set( "Vehicles", "jeep_big", V )

local V = { 	
				Name = "Jeep Medium",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggymedium.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test_rc.txt"
							}
			}

list.Set( "Vehicles", "jeep_medium", V )

local V = { 	
				Name = "Jeep Two",
				Class = "prop_vehicle_jeep",
				Category = Category,
				Author = "N/A",
				Information = "",
				Model = "models/buggytwo.mdl",
				
				KeyValues = {
								vehiclescript	=	"scripts/vehicles/jeep_test.txt"
							}
			}

list.Set( "Vehicles", "jeep_two", V )