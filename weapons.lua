#! /usr/bin/lua

require( "cgi" )

print( "Content-type: text/html\n" )

-- data

Weapons = data( "weapons" )
Items   = data( "items" )

-- translations

Translations = translations( "weapons" )

-- templates

local meleeTree = loadTemplate( "weapons/meleeTree" )
local meleeInfo = loadTemplate( "weapons/meleeInfo" )

weaponNameURL = loadTemplate( "weapons/weaponNameURL" )
weaponName    = loadTemplate( "weapons/weaponName" )

itemCounts = loadTemplate( "itemCounts" )
itemName   = loadTemplate( "itemName" )



local function classFromShort( short )
	for _, class in ipairs( Weapons ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

local function weaponFromName( class, name )
	for _, weapon in ipairs( class.weapons ) do
		-- convert every weapon name to a url and not the other
		-- way around because converting to a url is destructive

		if weapon.name[ DefaultLanguage ]:urlEscape() == name then
			return weapon
		end
	end

	return nil
end

local state = "nothing"

if Get.class then
	local class = classFromShort( Get.class )

	if class then
		state = "class"

		if Get.name then
			local weapon = weaponFromName( class, Get.name )

			if weapon then
				header( { title = T( weapon.name ) } )

				print( meleeInfo( { weapon = weapon, class = class } ) )

				state = "weapon"
			end
		end

		if state == "class" then
			header( { title = T( class.name ) } )

			print( meleeTree( { class = class } ) )
		end
	end
end

if state == "nothing" then
	header( { title = "Weapons" } )

	print( "<h1>Real weapons</h1>" )

	print( "<table class='grid'>" )

	local COLS = 3
	local col = 0

	for _, class in ipairs( Weapons ) do
		if col == 0 then
			print( "<tr>" )
		end

		print( "<td>" ..
			"<a href='" .. U( "weapons/" .. class.short ) .. "'>" ..
			"<div>" .. icon( "equipment/" .. class.short ) .. T( class.name ) .. "</div>" ..
			"</a>" ..
			"</td>" )

		col = col + 1
		if col == COLS then
			print( "</tr>" )

			col = 0
		end
	end

	print( "</table>" )

	print( "<h1>Sissy weapons</h1>" )
end

footer()
