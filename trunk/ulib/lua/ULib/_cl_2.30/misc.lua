


function ULib.explode( separator, str, limit )
	local t = {}
	local curpos = 1
	while true do 
		local newpos, endpos = str:find( separator, curpos ) 
		if newpos ~= nil then 
			table.insert( t, str:sub( curpos, newpos - 1 ) ) 
			curpos = endpos + 1 
		else
			if limit and table.getn( t ) > limit then
				return t 
			end
			table.insert( t, str:sub( curpos ) ) 
			break
		end
	end

	return t
end



function ULib.stripComments( str, comment, blockcommentbeg, blockcommentend )
	if blockcommentbeg and string.sub( blockcommentbeg, 1, string.len( comment ) ) == comment then 
		string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", function ( match )
			if string.sub( match, 1, string.len( blockcommentbeg ) ) == blockcommentbeg then
				return "" 
			end
			str = string.gsub( str, ULib.makePatternSafe( match ), "", 1 )
			return ""
		end )

		str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
	else 
		str = string.gsub( str, ULib.makePatternSafe( comment ) .. "[%S \t]*", "" )
		if blockcommentbeg and blockcommentend then
			str = string.gsub( str, ULib.makePatternSafe( blockcommentbeg ) .. ".-" .. ULib.makePatternSafe( blockcommentend ), "" )
		end
	end

	return str
end



function ULib.makePatternSafe( str )
         return str:gsub( "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1" )
end



function ULib.stripQuotes( s )
	return s:gsub( "^%s*[\"]*(.-)[\"]*%s*$", "%1" )
end



function ULib.unescapeBackslash( s )
	return s:gsub( "\\\\", "\\" )
end



function ULib.splitArgs( str, ignore_mismatch )
	if not str:find( "%S" ) then return {} end 
	
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



function ULib.parseKeyValues( str, convert )
	str = ULib.stripComments( str, "//" )
	local lines = ULib.explode( "\n", str )
	local parent_tables = {} 
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
		type( current_table.Out ) == "table" then 
		
		current_table = current_table.Out
	end
	
	return current_table
end



function ULib.makeKeyValues( t, tab, completed )
	tab = tab or ""
	completed = completed or {}
	if table.HasValue( completed, t ) then return "" end 
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



_ = nil 
local old__newindex = _G.__newindex
setmetatable( _G, _G )
function _G.__newindex( t, k, v )
	if k == "_" then
		
		
		return
	end

	if old__newindex then
		old__newindex( t, k, v )
	else
		rawset( t, k, v )
	end
end