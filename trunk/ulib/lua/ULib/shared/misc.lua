--[[
	Title: Miscellaneous

	Some utility functions. Unlike the functions in util.lua, this file only holds non-HL2 specific functions.
]]

--[[
	Function: explode

	Split a string by a separator.

	Parameters:

		separator - The separator string.
		str - A string.
		limit - *(Optional)* Max number of elements in the table

	Returns:

		A table of str split by separator, nil and error message otherwise.

	Revisions:

		v2.10 - Initial (dragged over from a GM9 archive though)
]]
function ULib.explode( separator, str, limit )
	local t = {}
	local curpos = 1
	while true do -- We have a break in the loop
		local newpos, endpos = str:find( separator, curpos ) -- find the next separator in the string
		if newpos ~= nil then -- if found then..
			table.insert( t, str:sub( curpos, newpos - 1 ) ) -- Save it in our table.
			curpos = endpos + 1 -- save just after where we found it for searching next time.
		else
			if limit and table.getn( t ) > limit then
				return t -- Reached limit
			end
			table.insert( t, str:sub( curpos ) ) -- Save what's left in our array.
			break
		end
	end

	return t
end


--[[
	Function: stripComments

	Strips comments from a string

	Parameters:

		str - The string to stip comments from
		comment - The comment string. If it's found, whatever comes after it on that line is ignored. ( IE: "//" )
		blockcommentbeg - *(Optional)* The block comment begin string. ( IE: "/*" )
		blockcommentend - *(Optional, must be specified if above parameter is)* The block comment end string. ( IE: "*/" )

	Returns:

		The string with the comments stripped, nil and error otherwise.

	Revisions:

		v2.02 - Fixed block comments in more complicated files.
]]
function ULib.stripComments( str, comment, blockcommentbeg, blockcommentend )
	if blockcommentbeg and string.sub( blockcommentbeg, 1, string.len( comment ) ) == comment then -- If the first of the block comment is the linecomment ( IE: --[[ and -- ).
		string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", function ( match )
			if string.sub( match, 1, string.len( blockcommentbeg ) ) == blockcommentbeg then
				return "" -- No substitution, this is a block comment.
			end
			str = string.gsub( str, ULib.makePatternSafe( match ), "", 1 )
			return ""
		end )

		str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
	else -- Doesn't need special processing.
		str = string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", "" )
		if blockcommentbeg and blockcommentend then
			str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
		end
	end

	return str
end


--[[
	Function: makePatternSafe

	Makes a string safe for pattern usage, like in string.gsub(). Basically replaces all keywords with % and keyword.

	Parameters:

		str - The string to make pattern safe

	Returns:

		The pattern safe string
]]
function ULib.makePatternSafe( str )
         return str:gsub( "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1" )
end


--[[
	Function: stripQuotes

	Trims leading and tailing quotes from a string

	Parameters:

		s - The string to strip

	Returns:

		The stripped string
]]
function ULib.stripQuotes( s )
	return s:gsub( "^%s*[\"]*(.-)[\"]*%s*$", "%1" )
end


--[[
	Function: unescapeBackslash

	Converts '\\' to '\'

	Parameters:

		s - The string to convert

	Returns:

		The converted string
]]
function ULib.unescapeBackslash( s )
	return s:gsub( "\\\\", "\\" )
end


--[[
	Function: splitArgs

	This is similar to string.Explode( " ", str ) except that it will also obey quotation marks.

	Parameters:

		str - The string to split from
		ignore_mistmatch - *(Optional, defaults to false)* If true, won't give a warning on a mismatched quote

	Returns:

		A table containing the individual arguments

	Example:

		:ULib.splitArgs( "This is a \"Cool sentence to\" make \"split up\"" )

		returns...

		{ "This", "is", "a", "Cool sentence to", "make", "split up" }
		
	Known Bugs:
	
		* A quote at the start of a token is assumed to start a quote and vice versa with quote at end of token.
		* Will not correctly pick up '"this "is" an odd thing"', will parse it as a single argument.

	Revisions:

		v2.10 - Can now handle tabs and trims strings before returning.
		v2.30 - Rewrite. Can now properly handle escaped quotes. New param, ignore_mismatch
]]
function ULib.splitArgs( str, ignore_mismatch )
	if not str:find( "%S" ) then return {} end -- Empty table if we have an empty string
	
	str = string.Trim( str )
	local symbols = ULib.explode( "%s", str )
	local args = {}
	local in_quote = false
	
	for i, word in ipairs( symbols ) do
		local sanitized_word = ULib.stripQuotes( word )
		
		if not in_quote then
			table.insert( args, sanitized_word )
		else
			args[ #args ] = string.format( "%s %s", args[ #args ], sanitized_word )
		end
		
		if word:sub( 1, 1 ) == '"' then
			in_quote = true
		end
		
		if word:sub( -1, -1 ) == '"' and word:sub( -2, -2 ) ~= '\\' then
			in_quote = false
		end
	end
	
	if in_quote and not ignore_mismatch then
		Msg( "WARNING: Mismatched quotes in ULib.splitArgs\n" )
	end
	
	return args
end


--[[
	Function: parseKeyValues

	Parses a keyvalue formatted string into a table.

	Parameters:

		str - The string to parse.
		convert - *(Optional, defaults to false)* Setting this to true will convert garry's keyvalues to a better form. This has two effects.
		  First, it will remove the "Out"{} wrapper. Second, it will convert any keys that equate to a number to a number.

	Returns:

		The table, nil and error otherwise. *If you find you're missing information from the table, the file format might be incorrect.*

	Example format:
:test
:{
:	"howdy"   "bbq"
:
:	foo
:	{
:		"bar"   "false"
:	}
:
:}

	Revisions:

		v2.10 - Initial (but tastefully stolen from a GM9 version)
		v2.30 - Rewrite. Much more robust and properly unescapes backslashes now.
]]
function ULib.parseKeyValues( str, convert )
	str = ULib.stripComments( str, "//" )
	local lines = ULib.explode( "\n", str )
	local parent_tables = {} -- Traces our way to root
	local current_table = {}
	local is_insert_last_op = false
	
	for i, line in ipairs( lines ) do
		local tokens = ULib.splitArgs( line )
		for i, token in ipairs( tokens ) do
			tokens[ i ] = ULib.unescapeBackslash( token )
		end
		
		local num_tokens = #tokens
		
		if num_tokens == 1 then
			local token = tokens[ 1 ]
			if token == "{" then
				local new_table = {}
				if is_insert_last_op then
					current_table[ table.remove( current_table ) ] = new_table
				else
					table.insert( current_table, new_table )
				end
				is_insert_last_op = false
				table.insert( parent_tables, current_table )
				current_table = new_table
				
			elseif token == "}" then
				is_insert_last_op = false
				current_table = table.remove( parent_tables )
				if current_table == nil then
					return nil, "Mismatched recursive tables on line " .. i
				end
				
			else
				is_insert_last_op = true
				table.insert( current_table, tokens[ 1 ] )
			end
			
		elseif num_tokens == 2 then
			is_insert_last_op = false
			if convert and tonumber( tokens[ 1 ] ) then
				tokens[ 1 ] = tonumber( tokens[ 1 ] )
			end
			
			current_table[ tokens[ 1 ] ] = tokens[ 2 ]
			
		elseif num_tokens > 2 then
			return nil, "Bad input on line " .. i
		end
	end
	
	if #parent_tables ~= 0 then
		return nil, "Mismatched recursive tables"
	end
	
	if convert and table.Count( current_table ) == 1 and 
		type( current_table.Out ) == "table" then -- If we caught a stupid garry-wrapper
		
		current_table = current_table.Out
	end
	
	return current_table
end


--[[
	Function: makeKeyValues

	Makes a key values string from a table.

	Parameters:

		t - The table to make the keyvalues from. This can only contain tables, numbers, and strings.
		tab - *Only for internal use*, this helps make inline tables look better.
		completed - A list of table values that have already been parsed, this is *only for internal use* to make sure we don't hit an infinite loop.

	Returns:

		The string, nil and error otherwise.

	Notes:

		If you use numbers as keys in the table, just the values will be used.

	Example table format:
:{ test = { howdy = "bbq", foo = { bar = "false" } } }

	Example return format:
:test
:{
:	"howdy"   "bbq"
:
:	foo
:	{
:		"bar"   "false"
:	}
:
:}

	Revisions:

		v2.10 - Initial (but tastefully stolen from a GM9 version)
]]
function ULib.makeKeyValues( t, tab, completed )
	tab = tab or ""
	completed = completed or {}
	if table.HasValue( completed, t ) then return "" end -- We've already done this table.
	table.insert( completed, t )

	local str = ""

	for k, v in pairs( t ) do
		str = str .. tab
		if type( k ) ~= "number" then
			str = string.format( "%s%q\t", str, tostring( k ) )
		end

		if type( v ) == "table" then
			str = string.format( "%s\n%s{\n%s%s}\n", str, tab, ULib.makeKeyValues( v, tab .. "\t", completed ), tab )
		elseif type( v ) == "string" then
			str = string.format( "%s%q\n", str, v )
		else
			str = str .. tostring( v ) .. "\n"
		end
	end

	return str
end


--[[
	Function: toBool

	Converts a string or number to a bool

	Parameters:

		x - The string or number

	Returns:

		The bool

	Revisions:

		v2.10 - Initial
]]
function ULib.toBool( x )
	if tonumber( x ) ~= nil then
		x = math.Round( tonumber( x ) )
		if x == 0 then
			return false
		else
			return true
		end
	end

	x = x:lower()
	if x == "t" or x == "true" or x == "yes" or x == "y" then
		return true
	else
		return false
	end
end


-- This wonderful bit of following code will make sure that no rogue coder can screw us up by changing the value of '_'
_ = nil -- Make sure we're starting out right.
local old__newindex = _G.__newindex
setmetatable( _G, _G )
function _G.__newindex( t, k, v )
	if k == "_" then
		-- If you care enough to fix bad scripts uncomment this following line.
		-- error( "attempt to modify global variable '_'", 2 )
		return
	end

	if old__newindex then
		old__newindex( t, k, v )
	else
		rawset( t, k, v )
	end
end