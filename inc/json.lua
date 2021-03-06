module( "json", package.seeall )

-- DECODING

string.at = function( self, idx )
	return self:sub( idx, idx )
end

string.startsWithFrom = function( self, str, from )
	from = from or 1

	return self:sub( from, str:len() + from - 1 ) == str
end

string.unescape = function( self )
	return self:gsub( "\\n", "\n" ):gsub( "\\\"", "\"" )
end

string.skip = function( self, pos )
	local mPos, mEnd = self:find( "^[ \t\r\n]+", pos )

	if mEnd ~= nil then
		return mEnd + 1
	end

	return pos
end

local function skip( str, pos )
	local mPos, mEnd = str:find( "^[ \t\r\n]+", pos )

	if mEnd ~= nil then
		return mEnd + 1
	end

	return pos
end

local function decodeString( str, pos )
	local start = pos

	local len = str:len()
	local last = "\""

	while pos <= len do
		local curr = str:at( pos )

		if curr == "\"" and last ~= "\\" then
			return str:sub( start, pos - 1 ):unescape(), pos + 1
		end

		last = curr
		pos = pos + 1
	end

	error( "unclosed string" )
end

local function decodeObject( str, pos )
	local object = { }
	local first = true

	local len = str:len()

	while pos <= len do
		pos = skip( str, pos )

		if first then
			if str:at( pos ) == "}" then
				return object, pos + 1
			end

			first = false
		end

		if str:at( pos ) ~= "\"" then
			error( "key should be a string" )
		end

		local key
		key, pos = decodeString( str, pos + 1 )

		pos = skip( str, pos )

		if str:at( pos ) ~= ":" then
			error( "should be a : after key" )
		end

		pos = skip( str, pos + 1 )

		object[ key ], pos = decodeValue( str, pos )

		pos = skip( str, pos )

		if str:at( pos ) == "}" then
			return object, pos + 1
		end

		if str:at( pos ) ~= "," then
			error( "should be a , or } after value" )
		end

		pos = pos + 1
	end

	error( "unclosed }" )
end

local function decodeArray( str, pos )
	local array = { }
	local idx = 1

	local len = str:len()

	while pos <= len do
		pos = skip( str, pos )

		if idx == 1 and str:at( pos ) == "]" then
			return array, pos + 1
		end

		array[ idx ], pos = decodeValue( str, pos )

		pos = skip( str, pos )

		if str:at( pos ) == "]" then
			return array, pos + 1
		end

		if str:at( pos ) ~= "," then
			error( "should be a , or ] after value" )
		end

		idx = idx + 1
		pos = pos + 1
	end

	error( "unclosed ]" )
end

local function decodeNumber( str, pos )
	local partInt = str:match( "^-?%d*", pos )

	if not partInt then
		error( "NaN" )
	end

	local number = partInt

	pos = pos + partInt:len()

	local partDec = str:match( "^%.%d+", pos )

	if partDec then
		number = number .. partDec

		pos = pos + partDec:len()
	end

	local partExp = str:match( "^[eE][-+]?%d+", pos )

	if partExp then
		number = number .. partExp

		pos = pos + partExp:len()
	end
	
	return tonumber( number ), pos
end

function null()
	return null
end

-- why does this need to be global...
function decodeValue( str, pos )
	pos = skip( str, pos )

	local next = str:at( pos )

	if next == "{" then
		return decodeObject( str, pos + 1 )
	elseif next == "[" then
		return decodeArray( str, pos + 1 )
	elseif next == "\"" then
		return decodeString( str, pos + 1 )
	elseif str:startsWithFrom( "true", pos ) then
		return true, pos + ( "true" ):len()
	elseif str:startsWithFrom( "false", pos ) then
		return false, pos + ( "false" ):len()
	elseif str:startsWithFrom( "null", pos ) then
		return null, pos + ( "null" ):len()
	else
		return decodeNumber( str, pos )
	end
end

function decode( str )
	local status, obj = pcall( decodeValue, str, 1 )

	if status then
		return obj
	end

	-- obj is actually an error code
	return nil, obj
end

-- ENCODING

local function isArray( table )
	-- arrays have to be sequential
	local expectedIdx = 1

	for key, _ in pairs( table ) do
		if type( key ) ~= "number" or key ~= expectedIdx then
			return false
		end

		expectedIdx = expectedIdx + 1
	end

	return true
end

function encode( object )
	if object == null then
		return "null"
	end

	local t = type( object )

	if t == "string" then
		return ( "\"%s\"" ):format( object:gsub( "\"", "\\\"" ) )
	end

	if t == "number" or t == "boolean" then
		return tostring( object )
	end

	if t == "table" then
		if isArray( object ) then
			local str = "["
			local len = table.getn( object )

			if len == 0 then
				return ( "%s]" ):format( str )
			end

			-- is it actually faster unrolling like this?...

			for i = 1, len - 1 do
				str = ( "%s%s," ):format( str, json.encode( object[ i ] ) )
			end

			return ( "%s%s]" ):format( str, json.encode( object[ len ] ) )
		end

		local str = "{"

		-- ...if it is then this should be unrolled too

		for key, val in pairs( object ) do
			str = ( "%s\"%s\":%s," ):format( str, key, json.encode( val ) )
		end

		-- strip trailing comma
		return ( "%s}" ):format( str:sub( 1, -2 ) )
	end
end
