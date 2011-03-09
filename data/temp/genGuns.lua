#! /usr/bin/lua

require( "common" )

Items = data( "items" )
Shots = data( "shots" )

local Dir = "weapons"

local Types =
{
	"lbg",
	"hbg",
	"bow",
}

local Bases =
{
	lbg = { name = { hgg = "Light Bowguns" } },
	hbg = { name = { hgg = "Heavy Bowguns" } },
	bow = { name = { hgg = "Bows" } },
}

local Reloads =
{
	VerySlow = "vslow",
	Slow     = "slow",
	Normal   = "normal",
	Fast     = "fast",
	VeryFast = "vfast",
}

local Drifts =
{
	None      = "None",
	[ "???" ] = "???",
}

local Recoils =
{
	Heavy    = "heavy",
	Moderate = "moderate",
	Light    = "light",
	Strong   = "strong",
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

function isElement( element )
	for _, elem in ipairs( Elements ) do
		if elem == element then
			return true
		end
	end

	return false
end

local BowRains =
{
	Focused = "focused",
	Spread  = "spread",
	Blast   = "blast",
}

local BowCoatings =
{
	"power",
	"poison",
	"paralyze",
	"sleep",
	"razor",
	"paint",
	"fatigue",
}

local CoatingsPattern = "^" .. ( "([YN])" ):rep( table.getn( BowCoatings ) ) .. "$"

local ChargeTypes =
{
	R = "rapid",
	P = "pierce",
	S = "scatter",
}

local MaxSlots = 3

local LastShot = 1


-- FSM controlling how each line is parsed
-- each action returns the key of the next state

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

	special = function( line, weapon )
		local rarity = line:match( "^R(%d)$" )

		if rarity then
			weapon.rarity = tonumber( rarity )

			return "affinity"
		end


		local defense = line:match( "^Def (%d+)$" )

		if defense then
			weapon.defense = tonumber( defense )

			return "special"
		end


		local element, elemAttack = line:match( "^(%a+) (%d+)$" )

		if element then
			element = element:lower()

			assert( isElement( element ), "bad element in " .. weapon.name.hgg .. ": " .. line )

			weapon.element    = element
			weapon.elemAttack = elemAttack

			return "special"
		end


		assert( BowRains[ line ], "bad special in " .. weapon.name.hgg .. ": " .. line )

		weapon.rain = BowRains[ line ]

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

		return weapon.rain and "improve" or "reload"
	end,

	reload = function( line, weapon )
		local reload = Reloads[ line ]

		assert( reload, "bad reload in " .. weapon.name.hgg .. ": " .. line )

		weapon.reload = reload

		return "drift"
	end,

	drift = function( line, weapon )
		local drift = Drifts[ line ]

		assert( drift, "bad drift in " .. weapon.name.hgg .. ": " .. line )

		weapon.drift = drift

		return "recoil"
	end,

	recoil = function( line, weapon )
		local recoil = Recoils[ line ]

		assert( recoil, "bad recoil in " .. weapon.name.hgg .. ": " .. line )

		weapon.recoil = recoil

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

		if not id then
			if weapon.rain then
				local chargeType, chargeLevel = line:match( "^(%u)(%d)$" )
				
				assert( chargeType, "bad charge in " .. weapon.name.hgg .. ": " .. line )

				weapon.charges =
				{
					{
						type  = ChargeTypes[ chargeType ],
						level = tonumber( chargeLevel ),
					}
				}

				return "charges"
			else
				local success, _, l1, l2, l3 = line:find( "^([%d!WMSG]+) ([%d!WMSG]+) ([%d!WMSG]+)$" )

				assert( success, "bad scrap in " .. weapon.name.hgg .. ": " .. line )

				local success, _, clip, l1RapidNum, l1RapidStr = l1:find( "^(%d+)!(%d)(%u)$" )
				if success then
					l1 = clip
				else
					local success, _, clip = l1:find( "^(%d+)!$" )

					if success then
						l1 = clip
						l1siege = true
					end
				end

				local success, _, clip, l2RapidNum, l2RapidStr = l2:find( "^(%d+)!(%d)(%u)$" )
				if success then
					l2 = clip
				else
					local success, _, clip = l2:find( "^(%d+)!$" )

					if success then
						l2 = clip
						l2siege = true
					end
				end

				local success, _, clip, l3RapidNum, l3RapidStr = l3:find( "^(%d+)!(%d)(%u)$" )
				if success then
					l3 = clip
				else
					local success, _, clip = l3:find( "^(%d+)!$" )

					if success then
						l3 = clip
						l3siege = true
					end
				end

				-- lua automatically drops nils from tables so the result is clean
				weapon.shots = { {
					{ clip = tonumber( l1 ), rapidClip = tonumber( l1RapidNum ), rapidStrength = l1RapidStrength, siege = l1siege },
					{ clip = tonumber( l2 ), rapidClip = tonumber( l2RapidNum ), rapidStrength = l2RapidStrength, siege = l2siege },
					{ clip = tonumber( l3 ), rapidClip = tonumber( l3RapidNum ), rapidStrength = l3RapidStrength, siege = l3siege },
				} }

				return "shots"
			end
		end

		if not weapon.scraps then
			weapon.scraps = { }
		end

		table.insert( weapon.scraps, { id = id, count = count } )

		return "scraps"
	end,

	-- i hate guns
	shots = function( line, weapon )
		LastShot = LastShot + 1

		assert( Shots[ LastShot ], "bad shot in " .. weapon.name.hgg .. ": " .. line .. " (" .. LastShot .. ")" )

		local success, _, l1, l2, l3 = line:find( ( "([%d!WMSG]+) " ):rep( Shots[ LastShot ].levels ):sub( 1, -2 ) )

		assert( success, "bad shot in " .. weapon.name.hgg .. ": " .. line .. " (" .. Shots[ LastShot ].name.hgg .. ")" )

		local success, _, clip, l1RapidNum, l1RapidStr = l1:find( "^(%d+)!(%d)(%u)$" )
		if success then
			l1 = clip
		else
			local success, _, clip = l1:find( "^(%d+)!$" )

			if success then
				l1 = clip
				l1siege = true
			end
		end

		table.insert( weapon.shots, { { clip = tonumber( l1 ), rapidClip = tonumber( l1RapidNum ), rapidStrength = l1RapidStrength, siege = l1siege } } )

		if l2 then
			local success, _, clip, l2RapidNum, l2RapidStr = l2:find( "^(%d+)!(%d)(%u)$" )
			if success then
				l2 = clip
			else
				local success, _, clip = l2:find( "^(%d+)!$" )

				if success then
					l2 = clip
					l2siege = true
				end
			end

			table.insert( weapon.shots[ LastShot ], { clip = tonumber( l2 ), rapidClip = tonumber( l2RapidNum ), rapidStrength = l2RapidStrength, siege = l2siege } )

			if l3 then
				local success, _, clip, l3RapidNum, l3RapidStr = l3:find( "^(%d+)!(%d)(%u)$" )
				if success then
					l3 = clip
				else
					local success, _, clip = l3:find( "^(%d+)!$" )

					if success then
						l3 = clip
						l3siege = true
					end
				end

				table.insert( weapon.shots[ LastShot ], { clip = tonumber( l3 ), rapidClip = tonumber( l3RapidNum ), rapidStrength = l3RapidStrength, siege = l3siege } )
			end
		end

		return "shots"
	end,

	charges = function( line, weapon )
		local chargeType, chargeLevel, loadUp = line:match( "^(%u)(%d)(!?)$" )

		if not chargeType then
			local coatings = { line:match( CoatingsPattern ) }

			assert( table.getn( coatings ) == table.getn( BowCoatings ), "bad coatings in " .. weapon.name.hgg .. ": " .. line )

			weapon.coatings = { }

			for i, coating in ipairs( BowCoatings ) do
				weapon.coatings[ coating ] = coatings[ i ] == "Y"
			end

			return "coatingsup"
		end


		table.insert( weapon.charges, {
			type  = ChargeTypes[ chargeType ],
			level = tonumber( chargeLevel ),
			load  = loadUp ~= "" and loadUp or nil,
		} )

		return "charges"
	end,

	coatingsup = function( line, weapon )
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
	LastShot = 1

	local lastDepth = { }
	local currentIdx = 1

	for line in io.lines() do
		if line == "" then
			table.insert( class.weapons, weapon )

			state = "init"
			weapon = { }
			LastShot = 1

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

					weapon.improve = { from = from, materials = { } }

					if not class.weapons[ from ].upgrades then
						class.weapons[ from ].upgrades = { }
					end

					table.insert( class.weapons[ from ].upgrades, currentIdx )
				end
			end

			state = doLine( line, weapon, state )
		end
	end

	table.insert( class.weapons, weapon )
	table.insert( Weapons, class )
end

print( "genGuns: ok!" )

io.output( "../guns.json" )
io.write( json.encode( Weapons ) )
