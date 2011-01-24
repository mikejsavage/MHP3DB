#! /usr/bin/lua

require( "cgi" )

Weapons = data( "weapons" )
Items   = data( "items" )

print( "Content-type: text/html\n" )

local meleeTree = loadTemplate( "meleeTree" )
local meleeInfo = loadTemplate( "meleeInfo" )

local function classFromShort( short )
	for _, class in ipairs( Weapons ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

if Get.class then
	local class = classFromShort( Get.class )

	if class then
		if Get.id then
			local weapon = class.weapons[ tonumber( Get.id ) ]

			print( header( { title = T( weapon.name ) } ) )

			print( meleeInfo( { weapon = weapon, class = class } ) )
		else
			print( header( { title = T( class.name ) } ) )

			print( meleeTree( { class = class } ) )
		end
	end
else
	print( header( { title = "Weapons" } ) )

	for _, class in ipairs( Weapons ) do
		print( T( class.name ) )
	end
end

print( footer() )
