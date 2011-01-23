#! /usr/bin/lua

require( "json" )

local Dir = "weapons"

local Types =
{
	"gs",
	"ls",
	"ds",
	"sns",
	"hm",
	"hh",
	"lc",
	"gl",
}

local Bases =
{
	gs = { name = { hgg = "Great Swords" } },
	ls = { name = { hgg = "Long Swords" } },
	ds = { name = { hgg = "Dual Swords" } },
	sns = { name = { hgg = "Swords" } },
	hm = { name = { hgg = "Hammers" } },
	hh = { name = { hgg = "Hunting Horns" } },
	lc = { name = { hgg = "Lances" } },
	gl = { name = { hgg = "Gunlances" } },
}

local Elements =
{
	FI = fire,
	WA = water,
	TH = thunder,
	IC = ice,
	DR = dragon,
	PO = poison,
	PA = paralyze,
	SL = sleep,
}

local Shells =
{
	N = "normal",
	S = "spread",
	L = "long",
}

local Notes =
{
	B = "blue",
	C = "cyan",
	G = "green",
	P = "purple",
	R = "red",
	W = "white",
	Y = "yellow",
}

local MaxSlots = 3

local function parseItem( line )
	local _, _, name, count = line:find( "^([%a ]+) (%d+)$" )

	-- TODO: name lookup
	
	return 0, count
end

local Actions =
{
	init = function( line, weapon )
		weapon.name = { hgg = line }

		return "attack"
	end,

	attack = function( line, weapon )
		weapon.attack = tonumber( line )

		return "special"
	end,

	-- TODO: phials
	special = function( line, weapon )
		if line:find( "%u%d" ) then
			local u = line:sub( 1, 1 )
			local d = tonumber( line:sub( 2, 2 ) )

			if u == "R" then
				weapon.rarity = d

				return "affinity"
			end

			weapon.shellingType = Shells[ u ]
			weapon.shellingLevel = d

			return "special"
		end

		if line:find( "%u%u%u" ) then
			weapon.notes =
			{
				Notes[ line:sub( 1, 1 ) ],
				Notes[ line:sub( 2, 2 ) ],
				Notes[ line:sub( 3, 3 ) ],
			}

			return "special"
		end

		if line:find( "Def %d+" ) then
			weapon.defense = tonumber( line:sub( 5 ) )

			return "special"
		end

		if line:find( "%[?%u%u %d+%]?" ) then
			-- elem
			
			return "special"
		end

		print( "special failed: " .. weapon.name.hgg )
	end,

	affinity = function( line, weapon )
		weapon.affinity = tonumber( line:sub( 1, -2 ) ) -- strip %

		return "slots"
	end,

	slots = function( line, weapon )
		local slots = 0

		for i = 1, MaxSlots do
			if line:sub( i, i ) == "O" then
				slots = slots + 1
			else
				break
			end
		end

		weapon.slots = slots

		return "improve"
	end,

	improve = function( line, weapon )
		if line:sub( -1 ) == "z" then
			weapon.price = tonumber( line:sub( 1, -2 ) )

			return "null"
		end

		local id, count = parseItem( line )

		if not weapon.improve then
			weapon.improve = { }
		end

		table.insert( weapon.improve, { id = id, count = count } )

		return "improve"
	end,

	null = function( line, weapon )
		return "null"
	end,
}

function string.detab( self )
	return self:gsub( "^\t+", "" )
end

function doLine( line, weapon, state )
	if not Actions[ state ] then
		print( state )
	end

	return Actions[ state ]( line:detab(), weapon )
end

local Weapons = { }

for _, short in pairs( Types ) do
	io.input( Dir .. "/" .. short .. ".txt" )

	local class = Bases[ short ]
	class.short = short
	class.weapons = { }

	local state = "init"
	local weapon = { }

	for line in io.lines() do
		if line == "" then
			table.insert( class.weapons, weapon )

			state = "init"
			weapon = { }
		else
			state = doLine( line, weapon, state )
		end
	end

	table.insert( class.weapons, weapon )
	table.insert( Weapons, class )
end

local encoded = json.encode( Weapons )

print( encoded )

io.output( "../weapons.json" )
io.write( encoded )
