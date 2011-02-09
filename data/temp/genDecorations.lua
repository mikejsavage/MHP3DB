#! /usr/bin/lua

require( "common" )

function loadDecorNames( path )
	local contents = readFile( path )

	local names = { }

	contents:gsub( "(.-)%s+%[%d%][\n]", function( name )
		names[ name ] = true
	end )
	
	return names
end

Items = json.decode( readFile( "../items.json" ) )
Skills = json.decode( readFile( "../skills.json" ) )

local DataPath = "armor/decorations.txt"

local Names = loadDecorNames( "armor/namesDecorations.txt" )

local MaxSlots = 3

-- perhaps a gigantic FSM was not
-- the best way of doing this

local Actions =
{
	init = function( line, decor )
		assert( Names[ line ], "bad name: " .. line )

		decor.name = { hgg = line }

		return "colorRarity"
	end,

	colorRarity = function( line, decor )
		local success, _, color, rarity = line:find( "^(%l+) (%d)$" )

		assert( success, "bad colorRarity in " .. decor.name.hgg .. ": " .. line )

		decor.color = color
		decor.rarity = tonumber( rarity )

		return "slots"
	end,

	slots = function( line, decor )
		local success, _, slots = line:find( "^(%d)$" )

		assert( success, "bad slots in " .. decor.name.hgg .. ": " .. line )

		decor.slots = tonumber( slots )

		return "skills"
	end,

	skills = function( line, decor )
		local id, points = parseSkill( line )

		if not id then
			local success, _, price = line:find( "^(%d+)z$" )

			assert( success, "bad price in " .. decor.name.hgg .. ": " .. line )

			decor.price = tonumber( price )

			return "create"
		end

		if not decor.skills then
			decor.skills = { }
		end

		table.insert( decor.skills, { id = id, points = points } )

		return "skills"
	end,

	create = function( line, piece )
		local id, count = parseItem( line )

		assert( id, "bad material in " .. piece.name.hgg .. ": " .. line )

		if not piece.create then
			piece.create = { }
		end

		table.insert( piece.create, { id = id, count = count } )

		return "create"
	end,
}

function doLine( line, piece, state )
	if not Actions[ state ] then
		print( state )
	end

	return Actions[ state ]( line, piece )
end

local Decorations = { }

io.input( DataPath )

local state = "init"
local decoration = { }

for line in io.lines() do
	if line == "" then
		table.insert( Decorations, decoration )

		state = "init"
		decoration = { }
	else
		state = doLine( line, decoration, state )
	end
end

table.insert( Decorations, decoration )

print( "genDecorations: ok!" )

io.output( "../decorations.json" )
io.write( json.encode( Decorations ) )
