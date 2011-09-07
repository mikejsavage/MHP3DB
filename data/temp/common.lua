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

local function isArray( table )
	-- arrays have to be sequential
	local expectedIdx = 1

	for key, _ in pairs( table ) do
		if key ~= expectedIdx then
			return false
		end

		expectedIdx = expectedIdx + 1
	end

	return true
end

local function serializeObjectToFile( file, obj )
	local t = type( obj )

	if t == "number" or t == "boolean" then
		file:write( tostring( obj ) )

		return
	end

	if t == "string" then
		file:write( ( "%q" ):format( obj ) )

		return
	end

	if t == "table" then
		file:write( "{" )

		if isArray( obj ) then
			for _, v in ipairs( obj ) do
				serializeObjectToFile( file, v )

				file:write( "," )
			end
		else
			for k, v in pairs( obj ) do
				file:write( "[" )
				file:write( ( "%q" ):format( k ) )
				file:write( "]" )
				file:write( "=" )

				serializeObjectToFile( file, v )

				file:write( "," )
			end
		end

		file:write( "}" )

		return
	end

	error( "I don't know how to serialize type " .. t )
end

function serializeToFile( file, obj )
	file:write( "return " )

	serializeObjectToFile( file, obj )
end
