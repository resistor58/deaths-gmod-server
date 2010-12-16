if SERVER then
	include( "ulx/init.lua" )
else
	include( "ulx/cl_init.lua" )
end

--[[
Because I keep forgetting...
This file is the entry point for ULX on both server and client, the server instantly loads the server assests.
The client sends a "loaded" command to the server waits to proceed until it receives confirmation from the server to go ahead. 
The client gets the version and revision from the server and sends a "loaded phase 2" command to the server.
The server waits an extra second and then announces to other ULX functions listening that the client is ready.
]]