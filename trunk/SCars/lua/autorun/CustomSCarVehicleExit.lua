--Copyright (c) 2010 Sakarias Johansson
AddCSLuaFile( "autorun/SCarConsoleCommands.lua" ) 
//I know this code is crap!
function CustomSCarVehicleExits(ply, vehicle)

	if vehicle.SCarSeatNum && ply.UseSeatWeapon != 1 then
	local Num = vehicle.SCarSeatNum
	local LoopNum = 0
	local Dont = 0
	local nrOfSeats = vehicle.OwnerEnt:GetNetworkedInt( "SCarNumberOfSeats" )
	
		if Num == 1 then 
				while LoopNum < 5 do
				
					LoopNum = LoopNum + 1
					
					if LoopNum == 1 and Dont == 0 && vehicle.OwnerEnt.SeatOne && nrOfSeats >= 1 then

						local trace = {}
						trace.start = vehicle:GetPos()
						trace.endpos = trace.start + ( (vehicle:GetRight() * -100) )
						trace.filter = { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end		
					end
						
					if LoopNum == 2 and Dont == 0 && vehicle.OwnerEnt.SeatTwo && nrOfSeats >= 2 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatTwo:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatTwo:GetRight() * 100))
						trace.filter = { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatTwo:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end							
					end

					if LoopNum == 3 and Dont == 0 && vehicle.OwnerEnt.SeatThree && nrOfSeats >= 3 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatThree:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatThree:GetForward() * -200))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatThree:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end									
					end					
					
					if LoopNum == 4 and Dont == 0 && vehicle.OwnerEnt.SeatFour && nrOfSeats >= 4 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFour:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFour:GetRight() * -100))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFour:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end		
					end
	
					if LoopNum == 5 and Dont == 0 && vehicle.OwnerEnt.SeatFive && nrOfSeats >= 5 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFive:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFive:GetRight() * 100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFive:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end		
					end
				end
			
--------------	
		elseif Num == 2 then 
				while LoopNum < 5 do
				
					LoopNum = LoopNum + 1
					
					if LoopNum == 1 and Dont == 0 && vehicle.OwnerEnt.SeatTwo && nrOfSeats >= 2 then

						local trace = {}
						trace.start = vehicle:GetPos()
						trace.endpos = trace.start + ( (vehicle:GetRight() * 100))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end										
					end

					if LoopNum == 2 and Dont == 0 && vehicle.OwnerEnt.SeatThree && nrOfSeats >= 3 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatThree:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatThree:GetForward() * -200) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatThree:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end											
					end					
					
					if LoopNum == 3 and Dont == 0 && vehicle.OwnerEnt.SeatFour && nrOfSeats >= 4 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFour:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFour:GetRight() * -100))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFour:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end		
					end
	
					if LoopNum == 4 and Dont == 0 && vehicle.OwnerEnt.SeatFive && nrOfSeats >= 5 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFive:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFive:GetRight() * 100))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFive:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end								
					end
					
					if LoopNum == 5 and Dont == 0 && vehicle.OwnerEnt.SeatOne && nrOfSeats >= 1 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatOne:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatOne:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatOne:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end										
					end
					
				end
			
--------------
		elseif Num == 3 then 
				while LoopNum < 5 do
				
					LoopNum = LoopNum + 1
					
					if LoopNum == 1 and Dont == 0 && vehicle.OwnerEnt.SeatThree && nrOfSeats >= 3 then

						local trace = {}
						trace.start = vehicle:GetPos()
						trace.endpos = trace.start + ( (vehicle:GetForward() * -200))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end												
					end				
					
					if LoopNum == 2 and Dont == 0 && vehicle.OwnerEnt.SeatFour && nrOfSeats >= 4 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFour:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFour:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFour:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end										
					end
	
					if LoopNum == 3 and Dont == 0 && vehicle.OwnerEnt.SeatFive && nrOfSeats >= 5 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFive:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFive:GetRight() * 100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFive:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end											
					end
					
					if LoopNum == 4 and Dont == 0 && vehicle.OwnerEnt.SeatOne && nrOfSeats >= 1 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatOne:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatOne:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatOne:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end											
					end
					
					if LoopNum == 5 and Dont == 0 && vehicle.OwnerEnt.SeatTwo && nrOfSeats >= 2 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatTwo:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatTwo:GetRight() * 100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatTwo:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end									
					end
					
				end
		
----------		
		elseif Num == 4 then 
				while LoopNum < 5 do
				
					LoopNum = LoopNum + 1
					
					if LoopNum == 1 and Dont == 0 && vehicle.OwnerEnt.SeatFour && nrOfSeats >= 4 then

						local trace = {}
						trace.start = vehicle:GetPos()
						trace.endpos = trace.start +  ( (vehicle:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end											
					end
			
					if LoopNum == 2 and Dont == 0 && vehicle.OwnerEnt.SeatFive && nrOfSeats >= 5 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFive:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFive:GetRight() * 100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFive:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end										
					end
					
					if LoopNum == 3 and Dont == 0 && vehicle.OwnerEnt.SeatOne && nrOfSeats >= 1 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatOne:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatOne:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatOne:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end										
					end
					
					if LoopNum == 4 and Dont == 0 && vehicle.OwnerEnt.SeatTwo && nrOfSeats >= 2 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatTwo:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatTwo:GetRight() * 100))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatTwo:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end												
					end

					if LoopNum == 5 and Dont == 0 && vehicle.OwnerEnt.SeatThree && nrOfSeats >= 3 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatThree:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatThree:GetForward() * -200) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatThree:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end											
					end						
				end
		
--------------	
		elseif Num == 5 then 
				while LoopNum < 5 do
				
					LoopNum = LoopNum + 1
					
					if LoopNum == 1 and Dont == 0 && vehicle.OwnerEnt.SeatFive && nrOfSeats >= 5 then

						local trace = {}
						trace.start = vehicle:GetPos()
						trace.endpos = trace.start +  ( (vehicle:GetRight() * 100))
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end										
					end

					if LoopNum == 2 and Dont == 0 && vehicle.OwnerEnt.SeatOne && nrOfSeats >= 1 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatOne:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatOne:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatOne:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end			
					end
					
					if LoopNum == 3 and Dont == 0 && vehicle.OwnerEnt.SeatTwo && nrOfSeats >= 2 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatTwo:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatTwo:GetRight() * 100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatTwo:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end											
					end

					if LoopNum == 4 and Dont == 0 && vehicle.OwnerEnt.SeatThree && nrOfSeats >= 3 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatThree:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatThree:GetForward() * -200) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatThree:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0								
								ply:SetEyeAngles( viewAng )
							end		
					end					
					
					if LoopNum == 5 and Dont == 0 && vehicle.OwnerEnt.SeatFour && nrOfSeats >= 4 then
						local trace = {}
						trace.start = vehicle.OwnerEnt.SeatFour:GetPos()
						trace.endpos = trace.start + ( (vehicle.OwnerEnt.SeatFour:GetRight() * -100) )
						trace.filter =  { vehicle.OwnerEnt.SeatOne, vehicle.OwnerEnt.SeatTwo, vehicle.OwnerEnt, vehicle.OwnerEnt.Stabilizer, vehicle.OwnerEnt.RRwheel, vehicle.OwnerEnt.RLwheel, vehicle.OwnerEnt.SeatThree, vehicle.OwnerEnt.SeatFour, vehicle.OwnerEnt.SeatFive}
						local tr = util.TraceLine( trace )
							if not(tr.Hit) then
								ply:SetPos(trace.endpos)
								Dont = 1

								local viewAng = vehicle.OwnerEnt.SeatFour:GetAngles()
								viewAng.y = viewAng.y + 90
								viewAng.r = 0
								ply:SetEyeAngles( viewAng )
							end									
					end
				end
		end	
--------------	
	end
end
hook.Add("PlayerLeaveVehicle", "CustomSCarVehicleExits", CustomSCarVehicleExits)

