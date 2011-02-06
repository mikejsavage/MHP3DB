require( "inc.config" )

require( "inc.json" )
require( "inc.template" )

require( "inc.utils" )


-- seed RNG
math.randomseed( os.time() )



-- GET/POST parsing
local function parse( str )
	local tokens = { }

	str:gsub( "([^&]+)&?", function( token )
		local idx = token:find( "=" )

		if idx ~= nil then
			tokens[ token:sub( 0, idx - 1 ) ] = token:sub( idx + 1 )
		else
			tokens[ token ] = ""
		end
	end )

	return tokens
end

Get = { }

if os.getenv( "QUERY_STRING" ) then
	Get = parse( os.getenv( "QUERY_STRING" ) )
end

Post = { }
local postLength = os.getenv( "CONTENT_LENGTH" )

if postLength and postLength ~= "0" then
	if os.getenv( "CONTENT_TYPE" ):startsWith( "application/x-www-form-urlencoded" ) then
		Post = parse( io.stdin:read( tonumber( postLength ) ) )
	end
end

print( "Content-type: text/html" )
