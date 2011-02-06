-- pretty much Zed Shaw's template code from Tir
-- http://tir.mongrel2.org/home
-- http://zedshaw.com

local Actions =
{
	[ "{%" ] = function( block )
		return block
	end,

	[ "{{" ] = function( str )
		return ( "table.insert( output, %s )" ):format( str )
	end,

	[ "{<" ] = function( str )
		return ( "table.insert( output, escapeHTML( %s ) )" ):format( str )
	end,

	[ "{(" ] = function( str )
		return ( [[
			if not cached[ %s ] then
				cached[ %s ] = loadTemplate( %s )
			end

			table.insert( output, cached[ %s ]() )
		]] ):format( str, str, str, str )
	end,
}

function compileTemplate( template, name )
	-- append a {} so the last bit of text isn't
	-- chopped by the pattern
	template = template .. "{}"

	local code = { "local output = { }", "local cached = { }" }

	for text, block in template:gmatch( "([^{]-)(%b{})" ) do
		if text ~= "" then
			table.insert( code, ( "table.insert( output, [[%s]] )" ):format( text ) )
		end

		local action = Actions[ block:sub( 1, 2 ) ]

		if action then
			table.insert( code, action( block:sub( 3, -3 ):gsub( "%f[%a]print%(", "table.insert%( output," ) ) )
		elseif block ~= "{}" then
			table.insert( code, ( "table.insert( output, [[<h3>Bad block: %s</h3>]] )" ):format( block ) )
		end
	end

	table.insert( code, "return table.concat( output )" )

	code = table.concat( code, '\n' )

	local func = assert( loadstring( code, name ) )

	return function( context )
		if context then
			-- copy globals to context
			setmetatable( context, { __index = _G } )

			-- set func's env to context
			setfenv( func, context )
		end

		return func()
	end
end

function loadTemplate( file )
	return compileTemplate( readFile( ( "%s/%s.lua" ):format( TemplatesDir, file ) ), file )
end

function echo( str )
	return ( "table.insert( output, %s )" ):format( str )
end
