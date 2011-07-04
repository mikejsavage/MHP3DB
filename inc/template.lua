-- pretty much Zed Shaw's template code from Tir
-- http://tir.mongrel2.org/home
-- http://zedshaw.com
--
-- so i guess this is BSD licensed? i'm not very good at this

--TemplateCache = { }

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
			table.insert( output, loadTemplate( %s )() )
		]] ):format( str )
	end,
}

function compileTemplate( template, name )
	-- append a {} so the last bit of text isn't
	-- chopped by the pattern
	template = template .. "{}"

	local code =
	{
		"local output = { }",

		-- this is so awful
		"local function print( str ) table.insert( output, str ) end",
		"local function printf( form, ... ) table.insert( output, form:format( ... ) ) end",
	}

	for text, block in template:gmatch( "([^{]-)(%b{})" ) do
		if text ~= "" then
			table.insert( code, ( "table.insert( output, [[%s]] )" ):format( text ) )
		end

		local action = Actions[ block:sub( 1, 2 ) ]

		if action then
			table.insert( code, action( block:sub( 3, -3 ) ) )
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
	--[[if TemplateCache[ file ] then
		return TemplateCache[ file ]
	end]]

	local template = compileTemplate( readFile( ( "%s/%s.lua" ):format( TemplatesDir, file ) ), file )

	--[[if not IsLocalHost then
		TemplateCache[ file ] = template
	end]]

	return template
end

function echo( str )
	return ( "table.insert( output, %s )" ):format( str )
end
