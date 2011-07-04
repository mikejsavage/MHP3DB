-- returns the contents of the file at path
function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

-- i've forgotten exactly what this does
function translations( translations )
	return dofile( ( "%s/%s.lua" ):format( TranslationsDir, translations ) )
end

-- reads json data from file
-- returns table, json string
function data( file )
	local contents = readFile( ( "data/%s.json" ):format( file ) )

	return dofile( ( "data/%s.lua" ):format( file ) ), contents
end

-- returns true if self starts with needle
function string.startsWith( self, needle )
	return self:sub( 1, needle:len() ) == needle
end

-- returns random element from array
function table.random( arr )
	return arr[ math.random( table.getn( arr ) ) ]
end

-- round to nearest whole number
function math.round( num )
	return math.floor( num + 0.5 )
end

-- inserts thousand separators into num
function commas( num )
	local out = ""

	while num >= 1000 do
		out = ( ",%03d%s" ):format( num % 1000, out )

		num = math.floor( num / 1000 )
	end

	return ( "%s%s" ):format( num, out )
end

-- strips bad chars from a string for use in URLs
function string.urlEscape( self )
	return self:gsub( "['\"%[%]]", "" ):gsub( " ", "_" )
end

-- ensures consistency with URLs and makes things easier
function urlFromName( name )
	return name[ DefaultLanguage ]:urlEscape()
end

-- returns a rewrite safe url
function U( url )
	return ( "/%s%s" ):format( BaseUrl, url )
end

-- returns a url with last modified timestamp appended
-- allows cacheing of commonly modified files
-- url returned is also rewrite safe
function C( url )
	assert( LastModified[ url ], url .. " isn't in modified.json!" )

	return ( "%s/%d" ):format( U( url ), LastModified[ url ] )
end

-- returns a rewrite safe url to a cacheable json include
function D( file )
	return C( ( "data/js/%s.js" ):format( file ) )
end

-- returns html for including files from js/
-- eg js( "a", "b" ) will return <script... src="asdf/a.js">...<script... src="asdf/b.js">...
function js( ... )
	local out = ""

	for _, file in ipairs( arg ) do
		out = ( [[%s<script type="text/javascript" src="%s"></script>]] ):format( out, C( ( "js/%s.js" ):format( file ) ) )
	end

	return out
end

-- returns html for including json data from data/js/
function jsd( ... )
	local out = ""

	for _, file in ipairs( arg ) do
		out = ( [[%s<script type="text/javascript" src="%s"></script>]] ):format( out, D( file ) )
	end

	return out
end

-- returns translated string from translation object
-- based on Language, defaults to DefaultLanguage
function T( translation )
	if translation[ Language ] then
		return translation[ Language ]
	end

	return translation[ DefaultLanguage ]
end

-- classFromShort functions
-- all return the class object where class.short == short
-- or nil if nothing matched

function weaponClassFromShort( short )
	for _, class in ipairs( Weapons ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

function gunClassFromShort( short )
	for _, class in ipairs( Guns ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

function armorClassFromShort( short )
	for _, class in ipairs( Armors ) do
		if class.short == short then
			return class
		end
	end

	return nil
end

-- templates and helper functions
-- TODO: perhaps the templates module should be
--       rewritten so this is done automatically
--       for every template? should be possible
--       with varargs

headerTemplate = loadTemplate( "header" )
function header( title )
	print( headerTemplate( { title = title } ) )
end

footerTemplate = loadTemplate( "footer" )
function footer()
	print( footerTemplate() )
end

iconTemplate = loadTemplate( "icon" )
function icon( icon, color )
	if color then
		if type( color ) == "number" then
			color = "rare" .. color
		end
	end

	return iconTemplate( { icon = icon, color = color } )
end

deferTemplate = loadTemplate( "defer" )
function defer( ... )
	local deferred = { }

	for _, script in ipairs( arg ) do
		table.insert( deferred, D( script ) )
	end

	return deferTemplate( { deferred = deferred } )
end
