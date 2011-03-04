#! /usr/bin/lua

require( "common" )

require( "lfs" )
require( "imlib2" )

Items = data( "items" )

local Dir = "weapons"

local SharpDir = "sharp"
local CacheDir = "cache"

local Names, NamesCount = loadNames( Dir .. "/names.txt" )

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
	O = "orange",
	P = "purple",
	R = "red",
	W = "white",
	Y = "yellow",
}

local SharpX = 101
local SharpY = 60

local SharpEquipX = 342
local SharpEquipY = 173

local SharpPlusOneAdds = 12

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

	imlib2.color.new( 240, 240, 240 ),
}

-- so we can tell if it's actually the end or just
-- a color i've not added yet
local SharpEnds =
{
	imlib2.color.new(   0,   0,   0 ),
	imlib2.color.new(  48,  44,  32 ), -- for a full sharpness bar
	imlib2.color.new(  40,  40,  32 ), -- faded sharpness +1 end marker?
	imlib2.color.new(  40,  36,  32 ), -- faded sharpness +1 end marker?
}

function sharpIdx( color )
	for _, endSharp in ipairs( SharpEnds ) do
		if color.red   == endSharp.red   and
		   color.green == endSharp.green and
		   color.blue  == endSharp.blue  then
			return -1
		end
	end

	for i, col in ipairs( SharpColors ) do
		if col.red   == color.red   and
		   col.green == color.green and
		   col.blue  == color.blue  then
			return i
		end
	end

	return 0
end

function isElement( element )
	for _, elem in ipairs( Elements ) do
		if elem == element then
			return true
		end
	end

	return false
end

local Spheres =
{
	Reg = "Enhance Sphere",
	Pls = "Enhance Sphere+",
	Hrd = "Hrd Enhance Sph",
	Hvy = "Hvy Enhance Sph",
}

function sphereID( sphere )
	return itemID( assert( Spheres[ sphere ] ) )
end

local MaxSlots = 3

-- perhaps a gigantic FSM was not
-- the best way of doing this

local Actions =
{
	init = function( line, weapon )
		assert( Names[ line ], "bad name: " .. line )

		weapon.name = { hgg = line }

		return "attack"
	end,

	attack = function( line, weapon )
		weapon.attack = tonumber( line )

		return "special"
	end,

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

		if line:find( "%a+ %d+ %d+z" ) then
			local _, _, sphere, num, price = line:find( "(%a+) (%d+) (%d+)z" )

			assert( Spheres[ sphere ], "bad sphere in " .. weapon.name.hgg .. ": " .. line )

			weapon.upgrade =
			{
				materials =
				{
					{
						id = sphereID( sphere ),
						count = tonumber( num )
					}
				},

				price = tonumber( price )
			}

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

			assert( isElement( element ), "bad element in " .. weapon.name.hgg .. ": " .. line )

			weapon.element = element
			weapon.elemAttack = elemAttack
			
			return "special"
		end

		weapon.phial = line:lower()

		return "special"
	end,

	affinity = function( line, weapon )
		local success, _, affinity = line:find( "^(-?%d+)%%$" )

		assert( success, "bad affinity in " .. weapon.name.hgg .. ": " .. line )

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

		assert( weapon.improve, "bad improve in " .. weapon.name.hgg .. ": " .. line )

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

		assert( id, "bad scrap in " .. weapon.name.hgg .. ": " .. line )

		if not weapon.scraps then
			weapon.scraps = { }
		end

		table.insert( weapon.scraps, { id = id, count = count } )

		return "scraps"
	end,
}

function string.detab( self )
	return self:gsub( "^\t+", "" )
end

function doLine( line, weapon, state )
	if not Actions[ state ] then
		print( state )
	end

	return Actions[ state ]( line, weapon )
end

function readSharpness( weapon )
	local cachePath = ( "%s/%s/%s/%s.lua" ):format( Dir, SharpDir, CacheDir, weapon.name.hgg )
	local imagePath = ( "%s/%s/%s.png" ):format( Dir, SharpDir, weapon.name.hgg )

	local cached = io.open( cachePath, "r" )

	-- only read cached data if it's more recent than
	-- the screenshot
	if cached and lfs.attributes( cachePath ).modification > lfs.attributes( imagePath ).modification then
		local sharps = loadstring( cached:read( "*all" ) )()

		weapon.sharpness  = sharps.sharp
		weapon.sharpnessp = sharps.sharpp

		cached:close()
		
		return
	end

	local img = imlib2.image.load( imagePath )

	if not img then
		return
	end

	weapon.sharpness = { }

	local x, y

	-- handle change equip dialog screenshots
	-- they have the navy triangle pattern near the right
	-- edge of the screen
	-- this check is good enough
	if img:get_pixel( 472, 24 ).blue == 80 then
		x = SharpEquipX
		y = SharpEquipY
	else
		x = SharpX
		y = SharpY
	end

	local lastColor = 1
	local currSharp = 1

	while true do
		local color = img:get_pixel( x, y )
		local idx = sharpIdx( color )

		if idx ~= lastColor then
			table.insert( weapon.sharpness, currSharp )
			
			lastColor = idx
			currSharp = 1
		else
			currSharp = currSharp + 1
		end

		-- unrecognised color
		assert( idx ~= 0, "unrecognised sharpness color in " .. weapon.name.hgg .. ": " .. color.red .. ", " .. color.green .. ", " .. color.blue )

		-- end of sharpness bar
		if idx == -1 then
			local nextColor = img:get_pixel( x + 1, y )

			-- sharpness +1 handling - this checks for the blue border
			-- that sharpness +1 puts at the end of the bar
			if nextColor.red   ==  96 and
			   nextColor.green == 228 and
			   nextColor.blue  == 248 then
			   	-- the table in weapon.sharpness actually contains
				-- sharpness +1 info at this point, so let's copy
				-- the table and correct it using the fact that
				-- sharpness +1 will always add the same number of
				-- pixels
				-- which is defined as SharpPlusOneAdds

				weapon.sharpnessp = table.copy( weapon.sharpness )

				local toRemove = SharpPlusOneAdds
				local endSharp = table.getn( weapon.sharpness )

				while toRemove > 0 do
					if weapon.sharpness[ endSharp ] <= toRemove then
						-- this color doesn't exist without sharpness +1
						toRemove = toRemove - weapon.sharpness[ endSharp ]

						weapon.sharpness[ endSharp ] = nil

						endSharp = endSharp - 1
					else
						weapon.sharpness[ endSharp ] = weapon.sharpness[ endSharp ] - toRemove

						toRemove = 0
					end
				end
			end

			break
		end

		-- move along 1 pixel
		x = x + 1
	end

	img:free()

	-- save the result for future gens
	local writeCache = assert( io.open( cachePath, "w" ) )

	writeCache:write( "return { sharp = { " .. table.concat( weapon.sharpness, ", " ) .. " }" )

	if weapon.sharpnessp then
		writeCache:write( ", sharpp = { " .. table.concat( weapon.sharpnessp, ", " ) .. " }" )
	end

	writeCache:write( " }" )

	writeCache:close()
end

function generatePath( weapon, weapons, path )
	if not path then
		path = { }
	end

	if weapon.improve then
		table.insert( path, weapon.improve.from )

		return generatePath( weapons[ weapon.improve.from ], weapons, path )
	end

	return table.getn( path ) ~= 0 and path or nil
end

local Weapons = { }
local WeaponsCount = 0

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
		local trimmed = line:detab()

		if trimmed == "" then
			readSharpness( weapon )
			weapon.path = generatePath( weapon, class.weapons )

			table.insert( class.weapons, weapon )

			WeaponsCount = WeaponsCount + 1

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

					-- assuming there are no path splits in p3
					--weapon.improve = { from = { from }, materials = { } }

					weapon.improve = { from = from, materials = { } }

					if not class.weapons[ from ].upgrades then
						class.weapons[ from ].upgrades = { }
					end

					table.insert( class.weapons[ from ].upgrades, currentIdx )
				end
			end

			state = doLine( trimmed, weapon, state )
		end
	end

	readSharpness( weapon )
	weapon.path = generatePath( weapon, class.weapons )

	table.insert( class.weapons, weapon )

	WeaponsCount = WeaponsCount + 1

	table.insert( Weapons, class )
end

print( ( "genWeapons: ok, %.1f%% complete! (%d/%d)" ):format(
	100 * ( WeaponsCount / NamesCount ),
	WeaponsCount,
	NamesCount
) )

io.output( "../weapons.json" )
io.write( json.encode( Weapons ) )
