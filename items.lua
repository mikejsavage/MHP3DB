require( "cgi" )

--print( "Content-type: text/html\n" )

-- data

Items = data( "items" )



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
		print( T( item.name ) )

		state = "item"
	end
end

if state == "none" then
	for _, item in ipairs( Items ) do
		print( T( item.name ) )
	end

	print( table.getn( Items ) )
end
