#! /usr/bin/lua

-- translations

--Translations = translations( "armory" )

-- templates

local armorList = loadTemplate( "armory/armorList" )
local pieceInfo = loadTemplate( "armory/pieceInfo" )

local decorList = loadTemplate( "armory/decorList" )
local decorInfo = loadTemplate( "armory/decorInfo" )

itemCounts  = loadTemplate( "itemCounts" )
itemNameURL = loadTemplate( "itemNameURL" )

grid      = loadTemplate( "grid" )
gridCell  = loadTemplate( "armory/gridCell" )
gridDecor = loadTemplate( "armory/gridDecor" )



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

local function decorFromName( name )
	for _, decor in ipairs( Decorations ) do
		local urlName = urlFromName( decor.name )

		if urlName == name or urlName .. "_" .. decor.slots == name then
			return decor
		end
	end

	return nil
end



local state = "nothing"

if Get.class then
	if Get.class == "jwl" then
		if Get.name then
			local decoration = decorFromName( Get.name )

			if decoration then
				header( T( decoration.name ) )

				print( decorInfo( { decor = decoration } ) )

				state = "decoration"
			end
		end

		if state == "nothing" then
			header( "Decorations" )

			print( decorList() )

			state = "decorations"
		end
	else
		local class = classFromShort( Get.class )

		if class then
			state = "class"

			if Get.name then
				local piece = pieceFromName( class, Get.name )

				if piece then
					header( T( piece.name ) )

					print( pieceInfo( { class = class, piece = piece } ) )

					state = "piece"
				end
			end

			if state == "class" then
				header( T( class.name ) )

				print( armorList( { class = class } ) )
			end
		end
	end
end

if state == "nothing" then
	header( "Armory" )

	print( grid( { classes = Armors, cols = 5 } ) )

	print( gridDecor() )
end

footer()
