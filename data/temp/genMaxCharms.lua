#! /usr/bin/lua

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

local function compareCharms( charm1, charm2 )
	local numSkills1 = table.getn( charm1.skills )
	local numSkills2 = table.getn( charm1.skills )

	if numSkills1 == 0 then
		if numSkills2 == 0 then
			return charm1.slots - charm2.slots
		else

	for _, skill1 in ipairs( charm1.skills ) do
		for _, skill2 in ipairs( charm2.skills ) do


local function matches( charm )
	local hasMatched = false

	for i, max in ipairs( Maxes ) do
		local cmp = compareCharms( charm, max )

		if cmp > 0 then
			Maxes[ i ] = charm

			return true
		elseif cmp < 0 then
			hasMatched = true
		end
	end

	return hasMatched
end

for _, charm in ipairs( Charms ) do
	if not matches( charm ) then
		table.insert( Maxes, charm )
	end
end
