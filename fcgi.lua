require( "inc.config" )

require( "inc.json" )
require( "inc.template" )

require( "inc.utils" )

local function parseQuery( str )
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


Monsters,    MonstersJSON    = data( "monsters" )
Weapons,     WeaponsJSON     = data( "weapons" )
Guns,        GunsJSON        = data( "guns" )
Armors,      ArmorsJSON      = data( "armors" )
Decorations, DecorationsJSON = data( "decorations" )
Items,       ItemsJSON       = data( "items" )
Skills,      SkillsJSON      = data( "skills" )
Shots,       ShotsJSON       = data( "shots" )

Tips         = data( "tips" )
Posts        = data( "posts" )
LastModified = data( "modified" )


function FCGI_Accept( postString )
	print( "Content-Type: text/html; charset=utf-8\r\n\r\n" )


	Get = { }

	local queryString = os.getenv( "QUERY_STRING" )

	if queryString then
		Get = parseQuery( queryString )
	end

	Post = postString and parseQuery( postString ) or { }


	IsLocalHost = os.getenv( "SERVER_NAME" ) == "localhost"
	CurrentUrl = os.getenv( "REQUEST_URI" ):sub( BaseUrl:len() + 2 )


	-- the server should always be passing us a legit request
	-- so don't bother checking
	dofile( os.getenv( "SCRIPT_FILENAME" ) )
end
