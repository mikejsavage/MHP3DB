-- translations

Translations = translations( "weapons" )

-- templates

weaponNameURL = loadTemplate( "weapons/weaponNameURL" )
weaponName    = loadTemplate( "weapons/weaponName" )

itemCounts  = loadTemplate( "itemCounts" )
itemNameURL = loadTemplate( "itemNameURL" )



local SharpMults = { 0.5, 0.75, 1, 1.05, 1.2, 1.32 }

local function sharpMult( weapon )
	if not weapon.sharpness then
		return 1
	end

	return SharpMults[ table.getn( weapon.sharpness ) ]
end

function getTATP( weapon )
	return math.round( weapon.attack * ( 1 + 0.0025 * weapon.affinity ) * sharpMult( weapon ) )
end

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
				local info = loadTemplate( "weapons/info" )

				header( T( weapon.name ) )

				print( info( { class = class, weapon = weapon } ) )

				state = "weapon"
			end
		end

		if state == "class" then
			header( T( class.name ) )

			local weaponTree = loadTemplate( "weapons/tree" )

			print( weaponTree( { class = class } ) )
		end
	else
		class = gunClassFromShort( Get.class )

		if class then
			state = "class"

			if Get.name then
				local weapon = weaponFromName( class, Get.name )

				if weapon then
					local info = loadTemplate( "weapons/info" )

					header( T( weapon.name ) )

					print( info( { class = class, weapon = weapon } ) )

					state = "weapon"
				end
			end

			if state == "class" then
				local weaponTree = loadTemplate( "weapons/tree" )

				header( T( class.name ) )

				print( weaponTree( { class = class } ) )
			end
		end
	end
end

if state == "nothing" then
	grid     = loadTemplate( "equipGrid" )
	gridCell = loadTemplate( "equipGridCell" )

	header( "Weapons" )


	print( "<h1>Real weapons</h1>" )

	print( grid( { classes = Weapons, class = "weapons", page = "weapons", cols = 3 } ) )


	print( "<h1>Sissy weapons</h1>" ) -- :)

	print( grid( { classes = Guns, class = "weapons", page = "weapons", cols = 3 } ) )
end

footer()
