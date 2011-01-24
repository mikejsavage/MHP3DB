#! /usr/bin/lua

require( "cgi" )

local Weapons = data( "weapons" )
local Items   = data( "items" )

print( "Content-type: text/html\n" )

print( header() )

local meleeTree = loadTemplate( "meleeTree" )

for _, class in ipairs( Weapons ) do
	print( "<h1>" .. icon( "equipment/" .. class.short ) .. " " .. class.name.hgg .. "</h1>" )

	print( meleeTree( { class = class } ) )
end

print( footer() )
