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

function readFile( path )
	local file = assert( io.open( path, "r" ) )

	local content = file:read( "*all" )

	file:close()

	return content
end

local Items = json.decode( readFile( "../items.json" ) )

function itemID( name )
	for id, item in ipairs( Items ) do
		if item.name.hgg == name then
			return id
		end
	end
	
	assert( nil, "itemID failed to find item: " .. name )
end

local MaxSlots = 3

local function parseItem( line )
	local success, _, name, count = line:find( "^([%a ]+) (%d+)$" )

	if not success then
		return
	end

	return itemID( name ), count
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
		local success, _, defense = line:find( "%d+" )

		if not success then
			print( "bad defense " .. piece.name.hgg .. ": " .. line )
		end

		piece.defense = defense

		return "elemdef"
	end,

	elemdef = function( line, piece )
		-- TODO: correct order?
		local success, _, fire, water, thunder, ice, dragon = line:find( "%-?%d+ %-?%d+ %-?%d+ %-?%d+ %-?%d+" )

		if not success then
			print( "bad elemdef " .. piece.name.hgg .. ": " .. line )

			return
		end

		piece.fireRes    = fire
		piece.waterRes   = water
		piece.thunderRes = thunder
		piece.iceRes     = ice
		piece.dragonRes  = dragon

		return "bladegun"
	end,

	bladegun = function( line, piece )
		piece.blade  = ( line:find( "B" ) ) ~= nil
		piece.gunner = ( line:find( "G" ) ) ~= nil

		return "rarity"
	end,

	rarity = function( line, piece )
		local success, _, rarity = line:find( "R%d+" )

		if not success then
			print( "bad rarity " .. piece.name.hgg .. ": " .. line )

			return
		end

		piece.rarity = rarity

		return "slots"
	end,

	slots = function( line, piece )
		local success = line:find( "O*%-*" )

		if not success then
			print( "bad slots in " .. piece.name.hgg .. ": " .. line )
			
			return
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
			print( "bad material in " .. piece.name.hgg .. ": " .. line )

			return
		end

		if not piece.create then
			piece.create = { }
		end

		table.insert( piece.create, { id = id, count = count } )

		return "create"
	end,

	skills = function( line, piece )
		-- TODO: this

		return "null"
	end,

	scraps = function( line, piece )
		local id, count = parseItem( line )

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
			weapon = { }

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

--io.output( "../armor.json" )
--io.write( encoded )
