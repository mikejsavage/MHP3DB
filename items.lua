require( "cgi" )

--print( "Content-type: text/html\n" )

-- data

Items = data( "items" )

-- templates

local itemInfo = loadTemplate( "items/itemInfo" )

itemName    = loadTemplate( "itemName" )
itemNameURL = loadTemplate( "itemNameURL" )



local function itemFromName( name )
	for _, item in ipairs( Items ) do
		if urlFromName( item.name ) == name then
			return item
		end
	end

	return nil
end

local state = "none"

if Get.name then
	local item = itemFromName( Get.name )

	if item then
		header( T( item.name ) )

		print( itemInfo( { item = item } ) )

		state = "item"
	end
end

if state == "none" then
	header( "Items" )

	for _, item in ipairs( Items ) do
		print( itemNameURL( { item = item } ) .. "<br>" )
	end

	print( table.getn( Items ) )
end

footer()
