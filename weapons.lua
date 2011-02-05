#! /usr/bin/lua

require( "cgi" )

print( "Content-type: text/html\n" )

-- data

Weapons = data( "weapons" )
Guns    = data( "guns" )
Items   = data( "items" )

-- translations

Translations = translations( "weapons" )

-- templates

local MeleeTrees =
{
	hh = "weapons/hhTree",
	gl = "weapons/glTree",
	sa = "weapons/saTree",
	default = "weapons/meleeTree",
}

weaponNameURL = loadTemplate( "weapons/weaponNameURL" )
weaponName    = loadTemplate( "weapons/weaponName" )


itemCounts  = loadTemplate( "itemCounts" )
itemNameURL = loadTemplate( "itemNameURL" )



local function classFromShort( short )
	for _, class in ipairs( Weapons ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

local function gunClassFromShort( short )
	for _, class in ipairs( Guns ) do
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
		sharpness = loadTemplate( "weapons/sharpness" )

		state = "class"

		if Get.name then
			local weapon = weaponFromName( class, Get.name )

			if weapon then
				local meleeInfo = loadTemplate( "weapons/meleeInfo" )

				header( T( weapon.name ) )

				print( meleeInfo( { weapon = weapon, class = class } ) )

				state = "weapon"
			end
		end

		if state == "class" then
			header( T( class.name ) )

			local meleeTree = loadTemplate( MeleeTrees[ class.short ] or MeleeTrees.default )

			print( meleeTree( { class = class } ) )
		end
	else
		class = gunClassFromShort( Get.class )

		if class then
			state = "class"

			if Get.name then
				local weapon = weaponFromName( class, Get.name )

				if weapon then
					local gunInfo = loadTemplate( "weapons/gunInfo" )

					header( T( weapon.name ) )

					print( gunInfo( { weapon = weapon, class = class } ) )

					state = "weapon"
				end
			end

			if state == "class" then
				local gunTree = loadTemplate( "weapons/gunTree" )

				header( T( class.name ) )

				print( gunTree( { class = class } ) )
			end
		end
	end
end

if state == "nothing" then
	grid     = loadTemplate( "grid" )
	gridCell = loadTemplate( "weapons/gridCell" )

	header( "Weapons" )


	print( "<h1>Real weapons</h1>" )

	print( grid( { classes = Weapons, cols = 3 } ) )


	print( "<h1>Sissy weapons</h1>" ) -- :)

	print( grid( { classes = Guns, cols = 3 } ) )
end

footer()
