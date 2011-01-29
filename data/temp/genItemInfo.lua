#! /usr/bin/lua

require( "json" )

local DataPath = "items/info.txt"

function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

local Actions =
{
	init = function( line, item )
		local success, _, id, name = line:find( "^(%d+) (.+)$" )

		if not success then
			assert( nil, "bad id/name: " .. line )
		end

		item.id = tonumber( id )
		item.name = { hgg = name }

		return "main"
	end,

	main = function( line, item )
		if line == "edible" then
			item.edible = true

			return "main"
		end

		if line == "supply" then
			item.supply = true

			return "main"
		end

		local success, _, icon, color = line:find( "^(%l+) (%l+)$" )

		if success then
			item.icon = icon
			item.color = color

			return "main"
		end

		local success, _, rarity = line:find( "^R(%d)$" )

		if success then
			item.rarity = tonumber( rarity )

			return "main"
		end

		local success, _, value = line:find( "^(%d+)z$" )

		if success then
			item.value = tonumber( value )

			return "main"
		end

		local success, _, points = line:find( "^(%d+)pts$" )

		if success then
			item.yukumoPoints = tonumber( points )

			return "main"
		end

		assert( nil, "couldn't parse line: " .. line )
	end,
}

function doLine( line, piece, state )
	if not Actions[ state ] then
		print( state )
	end

	return Actions[ state ]( line, piece )
end

local Items = { }

io.input( DataPath )

local state = "init"
local item = { }

for line in io.lines() do
	if line == "" then
		table.insert( Items, item )

		state = "init"
		item = { }
	else
		state = doLine( line, item, state )
	end
end

table.insert( Items, item )

print( "genItemInfo: ok!" )

io.output( "../items.json" )
io.write( json.encode( Items ) )
