require("datastream")

local dir = "scarsave/"
local sep = "¤"

function GetSCarSaveFromClient( sender, handler, id, encoded, decoded )

	--Server saves a file from client
	file.Write(dir..decoded[2], decoded[1])
  
end
datastream.Hook( "SCarSaveSendFile", GetSCarSaveFromClient )