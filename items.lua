require( "cgi" )

--print( "Content-type: text/html\n" )

-- data

Items = data( "items" )

for _, item in ipairs( Items ) do
	print( T( item.name ) )
end

print( table.getn( Items ) )
