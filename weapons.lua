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

sharpness = loadTemplate( "weapons/sharpness" )

itemCounts  = loadTemplate( "itemCounts" )
itemNameURL = loadTemplate( "itemNameURL" )

grid     = loadTemplate( "grid" )
gridCell = loadTemplate( "weapons/gridCell" )



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

		if urlFromName( weapon.name ) == name then
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
				header( T( weapon.name ) )

				print( meleeInfo( { weapon = weapon, class = class } ) )

				state = "weapon"
			end
		end

		if state == "class" then
			header( T( class.name ) )

			print( meleeTree( { class = class } ) )
		end
	end
end

if state == "nothing" then
	header( "Weapons" )

	print( "<h1>Real weapons</h1>" )

	print( grid( { classes = Weapons, cols = 3 } ) )

	print( "<h1>Sissy weapons</h1>" ) -- :)

	-- guns
end

footer()
