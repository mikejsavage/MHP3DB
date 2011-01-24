function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

function data( file )
	return json.decode( readFile( ( "data/%s.json" ):format( file ) ) )
end

function U( url )
	return ( "/%s%s" ):format( BaseUrl, url )
end

-- templates

header = loadTemplate( "header" )
footer = loadTemplate( "footer" )

iconTemplate = loadTemplate( "icon" )
icon = function( icon )
	return iconTemplate( { icon = icon } )
end
