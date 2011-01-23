#! /usr/bin/lua

-- this is obv incomplete...

require( "cgi" )
require( "json" )

local Weapons = json.decode( readFile( "data/weapons.json" ) )

print( "Content-type: text/html\n" )

for _, class in ipairs( Weapons ) do
	print( "<h1>" .. class.name.hgg .. "</h1>" )

	print( "<ul>" )
	for i, weapon in ipairs( class.weapons ) do
		print( "<li>" .. weapon.name.hgg .. "</li>" )
	end
	print( "</ul>" )
end
