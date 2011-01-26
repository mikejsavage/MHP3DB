#! /usr/bin/lua

require( "json" )

local Dir = "armor"

local Types =
{
	"head",
	"body",
	"arms",
	"waist",
	"legs",
}

local Bases =
{
	head = { name = { hgg = "Helmets" }, short = "hlm" },
	body = { name = { hgg = "Plates" }, short = "plt" },
	arms = { name = { hgg = "Gloves" }, short = "arm" },
	waist = { name = { hgg = "Tassets" }, short = "wst" },
	legs = { name = { hgg = "Greaves" }, short = "leg" },
}

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
	local success, _, name, count = line:find( "^([%a ]+) (%d+)$" )

	if not success then
		-- don't throw anything since this usually marks
		-- the start of another block

		return
	end

	return itemID( name ), tonumber( count )
end

local function parseSkill( line )
	local success, _, name, points = line:find( "^([%a ]+) (%-?%d+)$" )

	if not success then
		return
	end

	return skillID( name ), tonumber( points )
end

-- perhaps a gigantic FSM was not
-- the best way of doing this

local Actions =
{
	init = function( line, piece )
		piece.name = { hgg = line }

		return "defense"
	end,

	defense = function( line, piece )
		local success, _, defense = line:find( "(%d+)" )

		if not success then
			assert( nil, "bad defense " .. piece.name.hgg .. ": " .. line )
		end

		piece.defense = tonumber( defense )

		return "elemdef"
	end,

	elemdef = function( line, piece )
		-- TODO: correct order?
		local success, _, fire, water, thunder, ice, dragon = line:find( "(%-?%d+) (%-?%d+) (%-?%d+) (%-?%d+) (%-?%d+)" )

		if not success then
			assert( nil, "bad elemdef " .. piece.name.hgg .. ": " .. line )

			return
		end

		piece.fireRes    = tonumber( fire )
		piece.waterRes   = tonumber( water )
		piece.thunderRes = tonumber( thunder )
		piece.iceRes     = tonumber( ice )
		piece.dragonRes  = tonumber( dragon )

		return "bladegun"
	end,

	bladegun = function( line, piece )
		piece.blade  = ( line:find( "B" ) ) ~= nil
		piece.gunner = ( line:find( "G" ) ) ~= nil

		return "rarity"
	end,

	rarity = function( line, piece )
		local success, _, rarity = line:find( "R(%d+)" )

		if not success then
			assert( nil, "bad rarity " .. piece.name.hgg .. ": " .. line )
		end

		piece.rarity = tonumber( rarity )

		return "slots"
	end,

	slots = function( line, piece )
		local success = line:find( "O*%-*" )

		if not success then
			assert( nil, "bad slots in " .. piece.name.hgg .. ": " .. line )
		end

		local slots = 0

		for i = 1, MaxSlots do
			if line:sub( i, i ) == "O" then
				slots = slots + 1
			else
				break
			end
		end

		piece.slots = slots

		return "create"
	end,

	create = function( line, piece )
		if line:sub( -1 ) == "z" then
			piece.price = tonumber( line:sub( 1, -2 ) )

			return "skills"
		end

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

	skills = function( line, piece )
		local id, points = parseSkill( line )

		if not id then
			piece.description = line

			return "scraps"
		end

		if not piece.skills then
			piece.skills = { }
		end

		table.insert( piece.skills, { id = id, points = points } )

		return "skills"
	end,

	scraps = function( line, piece )
		local id, count = parseItem( line )

		if not id then
			assert( nil, "bad scrap in " .. piece.name.hgg .. ": " .. line )
		end

		if not piece.scraps then
			piece.scraps = { }
		end

		table.insert( piece.scraps, { id = id, count = count } )

		return "scraps"
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

local Armor = { }

for _, short in pairs( Types ) do
	io.input( Dir .. "/" .. short .. ".txt" )

	local class = Bases[ short ]
	class.pieces = { }

	local state = "init"
	local piece = { }

	local lastDepth = { }
	local currentIdx = 1

	for line in io.lines() do
		if line == "" then
			table.insert( class.pieces, piece )

			state = "init"
			piece = { }

			currentIdx = currentIdx + 1
		else
			state = doLine( line, piece, state )
		end
	end

	table.insert( class.pieces, piece )
	table.insert( Armor, class )
end

local encoded = json.encode( Armor )

print( encoded )

io.output( "../armors.json" )
io.write( encoded )
