AddCSLuaFile( "autorun/SCarHandler.lua" ) 
AddCSLuaFile( "autorun/client/recieveSCarSave.lua" ) 
AddCSLuaFile( "autorun/client/SCar3RdPerson.lua" ) 
AddCSLuaFile( "autorun/client/SCarConsole.lua" ) 
AddCSLuaFile( "autorun/client/SCarHUD.lua" ) 
AddCSLuaFile( "autorun/client/SCarKillIcons.lua" ) 
AddCSLuaFile( "autorun/client/SCarSetWepKey.lua" ) 	
AddCSLuaFile( "autorun/AddingWheelsToHandler.lua" ) 


local SCarName = {}
local SCarEntName = {}
local SCarSpawnHeight = {}
local SCarViewDist = {}
local SCarViewDistUp = {}
local nrOfScars = 0


function SakariasSCar_AddSCar( NewScarName, NewScarEntName, spawnHeight, ViewDist, ViewDistUp )

	if NewScarName && NewScarEntName then
		local found = false
		for i=1,nrOfScars do 

			if SCarEntName[i] == NewScarEntName then
				found = true
			end
		end	
		
		if found == false then
			nrOfScars = nrOfScars + 1
			SCarEntName[nrOfScars] = NewScarEntName
			SCarName[nrOfScars] = NewScarName
			SCarSpawnHeight[nrOfScars] = spawnHeight
			SCarViewDist[nrOfScars] = ViewDist
			SCarViewDistUp[nrOfScars] = ViewDistUp
		end		
	end
end

function SakariasSCar_GetScarNames()
	return SCarName
end

function SakariasSCar_GetScarEntNames()
	return SCarEntName
end

function SakariasSCar_GetNrOfScars()
	return nrOfScars
end

function SakariasSCar_GetSpawnHeight( SearchScarEntName )

	for i=1,nrOfScars do
		if SCarEntName[i] == SearchScarEntName then
			return SCarSpawnHeight[i]
		end
	end
	
	return 0
end

function SakariasSCar_GetSpawnHeightLowerCase( SearchScarEntName )

	for i=1,nrOfScars do
		if string.lower(SCarEntName[i]) == SearchScarEntName then
			return SCarSpawnHeight[i]
		end
	end
	
	return 0
end

function SakariasSCar_GetViewInfo( SearchScarEntName )

	for i=1,nrOfScars do
		if string.lower(SCarEntName[i]) == SearchScarEntName then
			return SCarViewDist[i], SCarViewDistUp[i]
		end
	end
	
	return 0,0
end