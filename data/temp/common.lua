require( "json" )

function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

function data( file )
	return json.decode( readFile( ( "../%s.json" ):format( file ) ) )
end

function loadNames( path )
	local contents = readFile( path )

	local names = { }
	local count = 0

	contents:gsub( "(.-)[\n]", function( name )
		names[ name ] = true

		count = count + 1
	end )
	
	return names, count
end

function itemID( name )
	for id, item in ipairs( Items ) do
		if item.name.hgg == name then
			return id
		end
	end
	
	return nil
end

function skillID( name )
	for id, skill in ipairs( Skills ) do
		if skill.name.hgg == name then
			return id
		end
	end

	return nil
end

function parseItem( line )
	local success, _, name, count = line:find( "^([%a%d%-%+ ]+) (%d+)$" )

	if not success then
		-- don't throw anything since this usually marks
		-- the start of another block

		return
	end

	return itemID( name ), tonumber( count )
end

function parseSkill( line )
	local success, _, name, points = line:find( "^([%a%-/ ]+) ([%+%-]?%d+)$" )

	if not success then
		return
	end

	return skillID( name ), tonumber( points )
end

-- table deep copy
-- be careful!
function table.copy( arr )
	local new = { }

	for key, val in pairs( arr ) do
		new[ key ] = type( val ) == "table" and table.copy( val ) or val
	end

	return new
end

function colorEqual( c1, c2 )
	return c1.red   == c2.red   and
	       c1.green == c2.green and
	       c1.blue  == c2.blue
end
