function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

function translations( translations )
	return dofile( ( "%s/%s.lua" ):format( TranslationsDir, translations ) )
end

function data( file )
	return json.decode( readFile( ( "data/%s.json" ):format( file ) ) )
end

function rareColor( rarity )
	return RareColors[ rarity ]
end

function string.startsWith( self, needle )
	return self:sub( 1, needle:len() ) == needle
end

-- name/url conversion

function string.urlEscape( self )
	return self:gsub( "'", "" ):gsub( " ", "_" )
end

function urlFromName( name )
	return name[ DefaultLanguage ]:urlEscape()
end

-- returns a HTML element of type elem, with class class and contents contents
function E( elem, class, contents )
	local classStr
	local contentStr

	if class then
		classStr = ( " class=\"%s\"" ):format( class )
	else
		classStr = ""
	end

	if contents then
		contentStr = ( ">%s</%s" ):format( contents, elem )
	else
		contentStr = ""
	end

	return ( "<%s%s%s>" ):format( elem, classStr, contentStr )
end

-- returns a rewrite safe url
function U( url )
	return ( "/%s%s" ):format( BaseUrl, url )
end

-- returns translation
function T( translation )
	if translation[ Language ] then
		return translation[ Language ]
	end

	return translation.hgg
end

-- templates

headerTemplate = loadTemplate( "header" )
header = function( title )
	print( headerTemplate( title ) )
end

footerTemplate = loadTemplate( "footer" )
footer = function()
	print( footerTemplate() )
end

iconTemplate = loadTemplate( "icon" )
icon = function( icon )
	return iconTemplate( { icon = icon } )
end