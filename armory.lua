require( "cgi" )

print( "Content-type: text/html\n" )

-- data

Armors = data( "armors" )
Items  = data( "items" )
Skills = data( "skills" )

-- translations

--Translations = translations( "armory" )

-- templates

local armorList = loadTemplate( "armory/armorList" )

itemCounts  = loadTemplate( "itemCounts" )
itemNameURL = loadTemplate( "itemNameURL" )

grid     = loadTemplate( "armory/grid" )
gridCell = loadTemplate( "armory/gridCell" )



local function classFromShort( short )
	for _, class in ipairs( Armors ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

local function pieceFromName( class, name )
	for _, piece in ipairs( class.pieces ) do
		-- convert every piece name to a url and not the other
		-- way around because converting to a url is destructive

		if urlFromName( piece.name ) == name then
			return piece
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
			local piece = pieceFromName( Get.name )

			if piece then
				header( T( piece.name ) )

				state = "piece"
			end
		end

		if state == "class" then
			header( T( class.name ) )

			print( armorList( { class = class } ) )
		end
	end
end

if state == "nothing" then
	header( "Armory" )

	print( grid( { weapons = Armors, cols = 5 } ) )
end

footer()
