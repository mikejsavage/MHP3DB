require( "inc.config" )

require( "inc.json" )
require( "inc.template" )

require( "inc.utils" )

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


math.randomseed( os.time() )


Weapons,     WeaponsJSON     = data( "weapons" )
Guns,        GunsJSON        = data( "guns" )
Armors,      ArmorsJSON      = data( "armors" )
Decorations, DecorationsJSON = data( "decorations" )
Items,       ItemsJSON       = data( "items" )
Skills,      SkillsJSON      = data( "skills" )


function FCGI_Accept()
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

	IsLocalHost = os.getenv( "SERVER_NAME" ) == "localhost"
	CurrentUrl = os.getenv( "REQUEST_URI" ):sub( BaseUrl:len() + 2 )


	dofile( os.getenv( "SCRIPT_FILENAME" ) )
end
