#! /usr/bin/lua

require( "json" )
require( "imlib2" )

local Dir = "weapons"
local SharpDir = "sharp"

local Types =
{
	"gs",
	"ls",
	"sns",
	"ds",
	"hm",
	"hh",
	"lc",
	"gl",
	"sa",
}

local Bases =
{
	gs = { name = { hgg = "Great Swords" } },
	ls = { name = { hgg = "Long Swords" } },
	sns = { name = { hgg = "Swords" } },
	ds = { name = { hgg = "Dual Swords" } },
	hm = { name = { hgg = "Hammers" } },
	hh = { name = { hgg = "Hunting Horns" } },
	lc = { name = { hgg = "Lances" } },
	gl = { name = { hgg = "Gunlances" } },
	sa = { name = { hgg = "Switch Axes" } },
}

local Elements =
{
	"fire",
	"water",
	"thunder",
	"ice",
	"dragon",
	"poison",
	"paralyze",
	"sleep",
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

local SharpX = 101
local SharpY = 60

local SharpOOMult = 3

local SharpColors =
{
	-- c00c38
	imlib2.color.new( 192,  12,  56 ),
	-- e85018
	imlib2.color.new( 232,  80,  24 ),
	-- f0c830
	imlib2.color.new( 240, 200,  48 ),
	-- 58d000
	imlib2.color.new(  88, 208,   0 ),

	imlib2.color.new(  48, 104, 232 ),
}

-- so we can tell if it's actually the end or just
-- a color i've not added yet
local SharpEnd = imlib2.color.new( 0, 0, 0 )

function sharpIdx( color )
	if color.red == SharpEnd.red and
	   color.green == SharpEnd.green and
	   color.blue == SharpEnd.blue then
		return -1
	end

	for i, col in ipairs( SharpColors ) do
		if col.red == color.red and
		   col.green == color.green and
		   col.blue == color.blue then
			return i
		end
	end

	return 0
end

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

function isElement( element )
	for _, elem in ipairs( Elements ) do
		if elem == element then
			return true
		end
	end

	return false
end

local MaxSlots = 3

local function parseItem( line )
	local success, _, name, count = line:find( "^([%a%d%-%+ ]+) (%d+)$" )

	if not success then
		return
	end

	return itemID( name ), tonumber( count )
end

-- perhaps a gigantic FSM was not
-- the best way of doing this

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

		if line:find( "%a+ %d+" ) then
			local _, _, element, elemAttack = line:find( "(%a+) (%d+)" )

			element = element:lower()

			if not isElement( element ) then
				assert( nil, "bad element in " .. weapon.name.hgg .. ": " .. line )
			end

			weapon.element = element
			weapon.elemAttack = elemAttack
			
			return "special"
		end

		weapon.phial = line:lower()

		return "special"
	end,

	affinity = function( line, weapon )
		local success, _, affinity = line:find( "^(-?%d+)%%$" )

		if not success then
			assert( nil, "bad affinity in " .. weapon.name.hgg .. ": " .. line )
		end

		weapon.affinity = tonumber( affinity )

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

			if not weapon.improve then
				weapon.price = weapon.price / 1.5
			end

			return "create"
		end

		local id, count = parseItem( line )

		if not id then
			weapon.description = line

			return "scraps"
		end

		if not weapon.improve then
			assert( nil, "bad improve in " .. weapon.name.hgg .. ": " .. line )
		end

		table.insert( weapon.improve.materials, { id = id, count = count } )

		return "improve"
	end,

	create = function( line, weapon )
		local id, count = parseItem( line )

		if not id then
			weapon.description = line

			return "scraps"
		end

		if not weapon.create then
			weapon.create = { }
		end

		table.insert( weapon.create, { id = id, count = count } )

		return "create"
	end,

	scraps = function( line, weapon )
		local id, count = parseItem( line )

		if not weapon.scraps then
			weapon.scraps = { }
		end

		table.insert( weapon.scraps, { id = id, count = count } )

		return "scraps"
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

function readSharpness( weapon )
	local img = imlib2.image.load( ( "%s/%s/%s.png" ):format( Dir, SharpDir, weapon.name.hgg ) )

	if not img then
		return
	end

	weapon.sharpness = { }

	local x = SharpX
	local lastColor = 1
	local currSharp = 1

	while true do
		local color = img:get_pixel( x, SharpY )
		local idx = sharpIdx( color )

		if idx ~= lastColor then
			table.insert( weapon.sharpness, currSharp --[[/ SharpOOMult]] )
			
			lastColor = idx
			currSharp = 1
		else
			currSharp = currSharp + 1
		end

		-- unrecognised color
		if idx == 0 then
			assert( nil, "unrecognised sharpness color in " .. weapon.name.hgg .. ": " .. color.red .. ", " .. color.green .. ", " .. color.blue .. " (idx " .. idx .. ")" )
		end

		-- end of sharpness bar
		if idx == -1 then
			break
		end

		x = x + 1
	end

	img:free()
end

local Weapons = { }

for _, short in pairs( Types ) do
	io.input( Dir .. "/" .. short .. ".txt" )

	local class = Bases[ short ]
	class.short = short
	class.weapons = { }

	local state = "init"
	local weapon = { }

	local lastDepth = { }
	local currentIdx = 1

	for line in io.lines() do
		if line == "" then
			readSharpness( weapon )

			table.insert( class.weapons, weapon )

			state = "init"
			weapon = { }

			currentIdx = currentIdx + 1
		else
			local depth = 1

			if state == "init" then
				while line:sub( depth, depth ) == '\t' do
					depth = depth + 1
				end

				lastDepth[ depth ] = currentIdx

				if depth ~= 1 then
					local from = lastDepth[ depth - 1 ]

					weapon.improve = { from = { from }, materials = { } }

					if not class.weapons[ from ].upgrades then
						class.weapons[ from ].upgrades = { }
					end

					table.insert( class.weapons[ from ].upgrades, currentIdx )
				end
			end

			state = doLine( line, weapon, state )
		end
	end

	readSharpness( weapon )

	table.insert( class.weapons, weapon )
	table.insert( Weapons, class )
end

print( "genWeapons: ok!" )

io.output( "../weapons.json" )
io.write( json.encode( Weapons ) )
