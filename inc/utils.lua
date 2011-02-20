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
	local contents = readFile( ( "data/%s.json" ):format( file ) )

	return json.decode( contents ), contents
end

function string.startsWith( self, needle )
	return self:sub( 1, needle:len() ) == needle
end

function table.copy( arr )
	local new = { }

	for key, val in pairs( arr ) do
		new[ key ] = type( val ) == "table" and table.copy( val ) or val
	end

	return new
end

function math.round( num )
	return math.floor( num + 0.5 )
end

-- function commANNIHILATE( num )
function commas( num )
	local out = ""

	while num > 1000 do
		out = ( ",%03d%s" ):format( num % 1000, out )

		num = math.floor( num / 1000 )
	end

	return ( "%s%s" ):format( num, out )
end

-- name/url conversion

function string.urlEscape( self )
	return self:gsub( "['\"]", "" ):gsub( " ", "_" )
end

function urlFromName( name )
	return name[ DefaultLanguage ]:urlEscape()
end

-- returns a HTML element of type elem, with class class and contents contents
-- TODO: this function is garbage get rid of it
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
	print( headerTemplate( { title = title } ) )
end

footerTemplate = loadTemplate( "footer" )
footer = function()
	print( footerTemplate() )
end

iconTemplate = loadTemplate( "icon" )
icon = function( icon, color )
	if color then
		if type( color ) == "number" then
			color = "rare" .. color
		end
	else
		color = "rare1"
	end

	return iconTemplate( { icon = icon, color = color } )
end
