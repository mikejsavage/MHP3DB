-- translations

--Translations = translations( "armory" )

-- templates

itemCounts  = loadTemplate( "itemCounts" )
itemNameURL = loadTemplate( "itemNameURL" )



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
		local urlName = urlFromName( decor.name ) .. "_" .. decor.slots

		if urlName == name then
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
				local decorInfo = loadTemplate( "armory/decorInfo" )

				header( T( decoration.name ) )

				print( decorInfo( { decor = decoration } ) )

				state = "decoration"
			end
		end

		if state == "nothing" then
			local decorList = loadTemplate( "armory/decorList" )

			header( "Decorations" )

			print( decorList() )

			state = "decorations"
		end
	else
		local class = armorClassFromShort( Get.class )

		if class then
			state = "class"

			if Get.name then
				local piece = pieceFromName( class, Get.name )

				if piece then
					local pieceInfo = loadTemplate( "armory/pieceInfo" )

					header( T( piece.name ) )

					print( pieceInfo( { class = class, piece = piece } ) )

					state = "piece"
				end
			end

			if state == "class" then
				local armorList = loadTemplate( "armory/armorList" )

				header( T( class.name ) )

				print( armorList( { class = class } ) )
			end
		end
	end
end

if state == "nothing" then
	grid      = loadTemplate( "equipGrid" )
	gridCell  = loadTemplate( "equipGridCell" )
	gridDecor = loadTemplate( "armory/gridDecor" )

	header( "Armory" )

	print( grid( { classes = Armors, class = "armor", page = "armory", cols = 5 } ) )

	print( gridDecor() )
end

footer()
