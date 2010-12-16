--[[
	Title: Base

	Sets up some things for ulx.
]]

ulx.help = {}
ulx.convarhelp = {}

function ulx.cc_ulx( ply, command, argv, args )
	if string.Trim( args ) == "" then
		ULib.console( ply, "No command entered. If you need help, please type \"ulx help\" in your console." )
	else
		ULib.console( ply, "Invalid command entered. If you need help, please type \"ulx help\" in your console." )
	end
end
ULib.begin_subconcommand( "ulx", ulx.cc_ulx, "ulxListCommands", ULib.ACCESS_ALL )

local currentCategory

--[[
	Function: setCategory

	This is will set the ulx help category. Pass nothing to reset.

	Parameters:

		category - *(Optional)* The category. Leave nil to reset.
		
	Revisions:
	
		v3.20 - Initial
]]
function ulx.setCategory( category )
	if not type( category ) == "string" then category = nil end
	currentCategory = category or "default"
	
	ulx.help[ currentCategory ] = ulx.help[ currentCategory ] or {} -- Create a table for this new category if one doesn't already exist.
	ulx.convarhelp[ currentCategory ] = ulx.convarhelp[ currentCategory ] or {} -- Create a table for this new category if one doesn't already exist.
end
ulx.setCategory() -- Init

--[[
	Function: concommand

	This is what will set up ULX's commands, it makes them under the command "ulx"

	Parameters:

		command - The console command. IE, "kick".
		fn_call - The function to call when the command's called.
		help - *(Optional)* A help string for using the command.
		access - *(Optional, defaults to ACCESS_ALL)* Restricted access.
		say_cmd - *(Optional)* A say command to use.
		hide_say - *(Optional, defaults to false)* If true, say command will be hid.
		autocomplete_type - *(Optional, defaults to ulx.ID_HELP)* The way to handle the autocomplete.
		autocomplete_fn - *(Optional)* The autocomplete as a function name (string).
		nospace - *(Optional, defaults to false)* If true, won't need a space in the say command.
		
	Revisions:
	
		v3.20 - Added nospace parameter
]]
function ulx.concommand( command, fn_call, help, access, say_cmd, hide_say, autocomplete_type, autocomplete_fn, nospace )
	access = access or ULib.ACCESS_ALL
	autocomplete_type = autocomplete_type or ulx.ID_HELP

	if say_cmd and string.Trim( say_cmd ) == "" then say_cmd = nil end

	if say_cmd and type( say_cmd ) == "string" then
		ULib.addSayCommand( say_cmd, fn_call, "ulx " .. command, help, hide_say, nospace )
	end

	if access ~= ULib.ACCESS_NONE then
		table.insert( ulx.help[ currentCategory ], { cmd=command, help=help, say_cmd=say_cmd, autocomplete_type=autocomplete_type, autocomplete_fn=autocomplete_fn } )
	end
	return ULib.add_subconcommand( "ulx", command, fn_call, access )
end

--[[
	Function: convar

	This is what will set up ULX's convars, it makes them under the command "ulx"

	Parameters:

		command - The console command. IE, "sv_kickminge".
		value - The value to start off at.
		help - *(Optional)* A help string for using the command.
		access - *(Optional, defaults to ACCESS_ALL)* Restricted access.
]]
function ulx.convar( command, value, help, access )
	access = access or ULib.ACCESS_ALL
	value = value or ""

	if access ~= ULib.ACCESS_NONE then
		table.insert( ulx.convarhelp[ currentCategory ], { cmd=command, access=access, help=help } )
	end
	return ULib.add_subconvar( "ulx", command, value, access )
end

local function formatCmdHelp( data, tab )	
	local beg
	if tab then 
		beg = "\to "
	else
		beg = " o "
	end
	
	if data.say_cmd then
		return beg .. data.cmd .. " " .. data.help .. " (say:" .. data.say_cmd .. ")"
	else
		return beg .. data.cmd .. " " .. data.help
	end
end

function ulx.cc_help( ply, command, argv, args )
	ULib.console( ply, "ULX Help:" )
	ULib.console( ply, "If a command can take multiple targets, it will usually let you use the keyword <ALL> or * (asterisk)." )
	ULib.console( ply, "These keywords are self explanatory." )
	ULib.console( ply, "All commands must be preceded by \"ulx \", ie \"ulx slap\"" )
	ULib.console( ply, "\nCommand Help:\n" )
	
	for k, data in ipairs( ulx.help.default ) do
		if ULib.ucl.query( ply, "ulx " .. data.cmd, true ) then
			ULib.console( ply, formatCmdHelp( data ) )
		end
	end	
	if #ulx.help.default > 0 then ULib.console( ply, "" ) end
	
	for category, v in pairs( ulx.help ) do
		if category ~= "default" then
			local hasAccess = false
			local str = ""
			for k, data in ipairs( v ) do
				if ULib.ucl.query( ply, "ulx " .. data.cmd, true ) then
					hasAccess = true
					str = str .. formatCmdHelp( data, true ) .. "\n"
				end
			end
			
			if hasAccess then -- Don't show the category if they don't have access to any of the functions.
				ULib.console( ply, "Category: " .. category )
				local lines = ULib.explode( "\n", str )
				for _, line in ipairs( lines ) do
					ULib.console( ply, line )
				end
				--ULib.console( ply, "" ) -- Newline
			end
		end
	end

	ULib.console( ply, "\nCvar Help:\n" )
	
	for k, v in ipairs( ulx.convarhelp.default ) do
		if ULib.ucl.query( ply, "ulx " .. v.cmd, true ) then
			ULib.console( ply, " o " .. v.cmd .. " " .. v.help )
		end
	end	
	if #ulx.convarhelp.default > 0 then ULib.console( ply, "\n" ) end
	
	for category, data in pairs( ulx.convarhelp ) do
		if category ~= "default" then
			local hasAccess = false
			local str = ""
			for k, v in ipairs( data ) do
				if ULib.ucl.query( ply, "ulx " .. v.cmd, true ) then
					hasAccess = true
					str = str .. "\to " .. v.cmd .. " " .. v.help .. "\n"
				end
			end
			
			if hasAccess then -- Don't show the category if they don't have access to any of the functions.
				ULib.console( ply, "Category: " .. category )
				local lines = ULib.explode( "\n", str )
				for _, line in ipairs( lines ) do
					ULib.console( ply, line )
				end
			end
		end
	end	
	ULib.console( ply, "\n-End of help\nULX version: " .. ulx.getVersion() .. "\n" )
end
ulx.concommand( "help", ulx.cc_help, "- Shows this help.", ULib.ACCESS_ALL )

--------------------------------------
--Now for boring initilization stuff--
--------------------------------------

-- Hook ULX done loading
ulx.doneCallbacks = {}
function ulx.OnDoneLoading( fn )
	table.insert( ulx.doneCallbacks, fn )
end

function ulx.DoDoneCallbacks()
	for _, fn in ipairs( ulx.doneCallbacks ) do
		PCallError( fn )
	end
end

-- Setup the maps table
do
	ulx.maps = {}
	local maps = file.Find( "../maps/*.bsp" )

	for _, map in ipairs( maps ) do
		table.insert( ulx.maps, map:sub( 1, -5 ) ) -- Take off the .bsp
	end
	table.sort( ulx.maps ) -- Make sure it's alphabetical
end

local function sendAutocomplete( ply, dummy )
	if not ply.ulx_autocompleteinitial and type( dummy ) == "boolean" then -- Wait for "ulib client init" for first send.
		return
	end
	ply.ulx_autocompleteinitial = true
	
	umsg.Start( "ulx_resetinfo", ply ) -- Tell them to clear out all old data.
	umsg.End()

	for _, data in pairs( ulx.help ) do
		for k, v in ipairs( data ) do
			if ULib.ucl.query( ply, "ulx " .. v.cmd, true ) then
				umsg.Start( "ulx_autocomplete", ply )
					umsg.String( v.cmd )
					ULib.umsgSend( { id=v.autocomplete_type, fn=v.autocomplete_fn, help=v.help } )
				umsg.End()
			end
		end
	end

	for _, data in pairs( ulx.convarhelp ) do
		for k, v in ipairs( data ) do
			if ULib.ucl.query( ply, "ulx " .. v.cmd, true ) then
				umsg.Start( "ulx_autocomplete", ply )
					umsg.String( v.cmd )
					ULib.umsgSend( { id=ulx.ID_HELP, help=v.help } )
				umsg.End()
			end
		end
	end
end
ULib.ucl.addAccessCallback( sendAutocomplete )
hook.Add( "ULibPlayerULibLoaded", "sendAutoComplete", sendAutocomplete )

-- This will load ULX client side
local function playerInit( ply, timed )	
	local _, v, r = ulx.getVersion()
	umsg.Start( "ulx_initplayer", ply )
		umsg.Float( v )
		umsg.Long( r )
	umsg.End()
	
	for menuid, t in pairs( ulx.menuContents ) do
		for _, data in ipairs( t ) do
			umsg.Start( "ulx_addMenuItem", ply )
				umsg.Char( menuid )
				umsg.String( data.label )
				ULib.umsgSend( data.data )
			umsg.End()
		end
	end
end
hook.Add( "ULibPlayerULibLoaded", "ULXInitPlayer", playerInit )
