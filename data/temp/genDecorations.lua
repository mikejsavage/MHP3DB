#! /usr/bin/lua

require( "json" )

local DataPath = "armor/decorations.txt"

local MaxSlots = 3

function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

local Items = json.decode( readFile( "../items.json" ) )
local Skills = json.decode( readFile( "../skills.json" ) )

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

local function parseItem( line )
	local success, _, name, count = line:find( "^([%a%d%- ]+) (%d+)$" )

	if not success then
		-- don't throw anything since this usually marks
		-- the start of another block

		return
	end

	return itemID( name ), tonumber( count )
end

local function parseSkill( line )
	local success, _, name, points = line:find( "^([%a%-/ ]+) (%-?%d+)$" )

	if not success then
		return
	end

	return skillID( name ), tonumber( points )
end

-- perhaps a gigantic FSM was not
-- the best way of doing this

local Actions =
{
	init = function( line, decor )
		decor.name = { hgg = line }

		return "colorRarity"
	end,

	colorRarity = function( line, decor )
		local success, _, color, rarity = line:find( "^(%l+) (%d)$" )

		if not success then
			assert( nil, "bad colorRarity in " .. decor.name.hgg .. ": " .. line )
		end

		decor.color = color
		decor.rarity = tonumber( rarity )

		return "slots"
	end,

	slots = function( line, decor )
		local success, _, slots = line:find( "^(%d)$" )

		if not success then
			assert( nil, "bad slots in " .. decor.name.hgg .. ": " .. line )
		end

		decor.slots = tonumber( slots )

		return "skills"
	end,

	skills = function( line, decor )
		local id, points = parseSkill( line )

		if not id then
			local success, _, price = line:find( "^(%d+)z$" )

			if not success then
				assert( nil, "bad price in " .. decor.name.hgg .. ": " .. line )
			end

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

		if not id then
			assert( nil, "bad material in " .. piece.name.hgg .. ": " .. line )
		end

		if not piece.create then
			piece.create = { }
		end

		table.insert( piece.create, { id = id, count = count } )

		return "create"
	end,

	null = function( line, piece )
		return "null"
	end,
}

function string.detab( self )
	return self:gsub( "^\t+", "" )
end

function doLine( line, piece, state )
	if not Actions[ state ] then
		print( state )
	end

	return Actions[ state ]( line:detab(), piece )
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

local encoded = json.encode( Decorations )

print( encoded )

io.output( "../decorations.json" )
io.write( encoded )
