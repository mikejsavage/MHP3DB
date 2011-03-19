#! /usr/bin/lua

require( "common" )

local DataPath = "items/info.txt"

local Actions =
{
	init = function( line, item )
		local success, _, id, name = line:find( "^(%d+) (.+)$" )

		assert( success, "bad id/name: " .. line )

		-- whoops...
		item.id = tonumber( id ) + 1
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

		local buyPrice = line:match( "^buy (%d+)z" )

		if buyPrice then
			if not item.obtain then
				item.obtain = { }
			end

			item.obtain.buy = { price = tonumber( buyPrice ) }

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

local encoded = json.encode( Items )

io.output( "../items.json" )
io.write( encoded )

io.output( "../js/items.js" )
io.write( "var Items=" .. encoded )

print( "genItemInfo: ok!" )
