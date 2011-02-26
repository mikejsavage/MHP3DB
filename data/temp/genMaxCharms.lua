#! /usr/bin/lua

-- this code all exists to be rewritten

require( "common" )

local DataPath = "../charms.json"

local Charms = json.decode( readFile( DataPath ) )

local Maxes = { }

-- [ A:5     ] > [ A:3     ]
-- [ A:5 B:3 ] > [ A:5 B:2 ]
-- [ A:5 B:3 ] > [ A:5     ]
-- [ A:5 OOO ] > [ A:5     ]
-- [ A:5     ] - [ B:5     ]
-- [ A:3 B:5 ] - [ A:5 B:3 ]
-- [ A:3 OOO ] - [ A:5     ]

-- [ A:3 OOO ] > [ A:5     ] if you can get >= 2 points in OOO slots
-- this is kind of tricky to check for though

local function sharedSkills( charm1, charm2 )
	local shared = 0

	for _, skill1 in ipairs( charm1.skills ) do
		for _, skill2 in ipairs( charm2.skills ) do
			if skill1.id == skill2.id then
				shared = shared + 1

				break
			end
		end
	end

	return shared
end

local function getSkill( id, charm )
	for _, skill in ipairs( charm.skills ) do
		if skill.id == id then
			return skill
		end
	end

	assert( nil, "tool" )
end

local function compareCharms( charm1, charm2 )
	local shared = sharedSkills( charm1, charm2 )

	if not shared then
		return "unrelated"
	end

	local numSkills1 = table.getn( charm1.skills )
	local numSkills2 = table.getn( charm2.skills )

	if shared == 1 then
		if numSkills1 == 1 and numSkills2 == 1 then
			local points1 = charm1.skills[ 1 ].points
			local points2 = charm2.skills[ 1 ].points

			if points1 == points2 then
				-- [ A:5 OOO ] > [ A:5     ]
				if charm1.slots > charm2.slots then
					return "charm1"
				end

				return "charm2"
			end

			-- [ A:5     ] > [ A:3     ]
			if points1 > points2 and charm1.slots >= charm2.slots then
				return "charm1"
			end

			if points2 > points1 and charm2.slots >= charm1.slots then
				return "charm2"
			end

			-- [ A:3 OOO ] - [ A:5     ]
			return "unrelated"
		end

		-- tricky stuff
	end

	if shared == 2 then
		assert( numSkills1 == 2 and numSkills2 == 2 )

		local d1 = charm1.skills[ 1 ].points - getSkill( charm1.skills[ 1 ].id, charm2 ).points
		local d2 = charm1.skills[ 2 ].points - getSkill( charm1.skills[ 2 ].id, charm2 ).points

		if d1 == 0 and d2 == 0 then
			-- [ A:5 OOO ] > [ A:5     ]
			if charm1.slots > charm2.slots then
				return "charm1"
			end

			return "charm2"
		end

		if charm1.slots == charm2.slots then
			-- [ A:5 B:3 ] > [ A:5 B:2 ]
			if d1 >= 0 and d2 >= 0 then
				return "charm1"
			end

			if d1 < 0 and d2 < 0 then
				return "charm2"
			end

			-- [ A:3 B:5 ] - [ A:5 B:3 ]
			return "unrelated"
		end
	end

	return "unrelated"
end

local function matches( charm )
	local hasMatched = false

	for i, max in ipairs( Maxes ) do
		local cmp = compareCharms( charm, max )

		if cmp == "charm1" then
			Maxes[ i ] = charm

			return true
		elseif cmp == "charm2" then
			hasMatched = true
		end
	end

	return hasMatched
end

local NumCharms = table.getn( Charms )
local NumMaxes = 0

local step = 1
for i, charm in ipairs( Charms ) do
	-- skip the slot only charms to make things easier
	if not matches( charm ) and table.getn( charm.skills ) ~= 0 then
		table.insert( Maxes, charm )

		NumMaxes = NumMaxes + 1
	end

	if step == 100 then
		print( ( "%d/%d - %d" ):format( i, NumCharms, NumMaxes ) )

		step = 0
	end

	step = step + 1
end

io.output( "../charmsFiltered.json" )
io.write( json.encode( Maxes ) )

print( "genMaxCharms: ok!" )
