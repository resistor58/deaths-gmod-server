require("datastream")

local dir = "scarsave/"
local sep = "¤"
local fileContent = ""

function recieveSCarSaveCommand( um )

	local str = um:ReadString()
	local info = string.Explode(sep, str)
	local command = info[1]
	
	if command == "delete" then
		local fileName = info[2]
		
		--Deletes a file on client
		if file.Exists( dir..fileName ) then
			file.Delete( dir..fileName )
		end			
		
	elseif command == "require" then
		local fileName = info[2]
		
		--Sends the save to the server
		if file.Exists( dir..fileName ) then
			local cont = file.Read( dir..fileName )
			datastream.StreamToServer( "SCarSaveSendFile", { cont, fileName } )
		end
	else

		Msg("Recieved unknown command: "..command.."\n")
		
	end

end
usermessage.Hook("SCarSaveCommand", recieveSCarSaveCommand)


function GetSCarSaveFromServer( handler, id, encoded, decoded )
 
	--Saves a txt file on client that comes from server
	decoded[2] = decoded[2]..".txt"
	file.Write(dir..decoded[2], decoded[1])
 
end
datastream.Hook( "SCarSaveSendClientFile", GetSCarSaveFromServer )
