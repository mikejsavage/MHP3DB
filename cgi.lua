function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

local function parse( str )
	local tokens = { }

	str:gsub( "([^&]+)&?",
	function( token )
		local idx = token:find( "=" )

		if idx ~= nil then
			tokens[ token:sub( 0, idx - 1 ) ] = token:sub( idx + 1 )
		else
			tokens[ token ] = ""
		end
	end
	)

	return tokens
end

Get = { }

if os.getenv( "QUERY_STRING" ) then
	Get = parse( os.getenv( "QUERY_STRING" ) )
end

Post = { }
local postLength = os.getenv( "CONTENT_LENGTH" )

if postLength then
	if os.getenv( "CONTENT_TYPE" ) == "application/x-www-form-urlencoded" then
		Post = parse( io.read( tonumber( postLength ) ) )
	end
end
