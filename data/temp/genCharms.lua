#! /usr/bin/lua

require( "common" )

local DataPath = "charms/charms.csv"

local Classes =
{
	[ "Queen Talisman" ] = "queen",
	[ "King Talisman" ] = "king",
	[ "Dragon Talisman" ] = "dragon",
}

Skills = data( "skills" )

local Charms = { }

io.input( DataPath )

-- \r because io.lines() only removes \n...

for line in io.lines() do
	if line ~= "ID,Charm Type,Charm Name,Skill 1,Skill 2,Charm Slot,Table No.\r" then
		local success, _, class, skill1, skill2, slots, charmTable =
			line:find( "^%d+,[%a ]+,([%a ]+),([%a%+%-/%d ]*),([%a%+%-/%d ]*),(%d+),(%d+)\r?$" )

		local charm =
		{
			type = assert( Classes[ class ], "bad type: " .. class ),
			skills = { },
			slots = tonumber( slots ),
			table = tonumber( charmTable ),
		}

		assert( success, "bad line: " .. line )

		local id1, points1 = parseSkill( skill1 )

		assert( id1, "bad skill1: " .. skill1 )

		table.insert( charm.skills, { id = id1, points = points1 } )

		if skill2 ~= "" then
			local id2, points2 = parseSkill( skill2 )

			assert( id2, "bad skill2: " .. skill2 )

			table.insert( charm.skills, { id = id2, points = points2 } )
		end

		table.insert( Charms, charm )
	end
end

-- there's so many charms that everything needs to be done by hand
-- and we can't put it all in a string because my pc doesn't have
-- enough memory

function skillsJSON( skills )
	local len = table.getn( skills )

	if len == 1 then
		return ( [[{"id":%d,"points":%d}]] ):format(
			skills[ 1 ].id, skills[ 1 ].points
		)
	elseif len == 2 then
		return ( [[{"id":%d,"points":%d},{"id":%d,"points":%d}]] ):format(
			skills[ 1 ].id, skills[ 1 ].points,
			skills[ 2 ].id, skills[ 2 ].points
		)
	end

	assert( nil, "bad len" )
end

io.output( "../charms.json" )

io.write( "[" )

local lenmm = table.getn( Charms ) - 1 -- len--

for i = 1, lenmm do
	local charm = Charms[ i ]

	local charmText = ( [[{"type":"%s","table":%d,"slots":%d,"skills":[%s]},]] ):format(
		charm.type, charm.table, charm.slots, skillsJSON( charm.skills )
	)

	io.write( charmText )
end

local charm = Charms[ lenmm + 1 ]

local charmText = ( [=[{"type":"%s","table":%d,"slots":%d,"skills":[%s]}]]=] ):format(
	charm.type, charm.table, charm.slots, skillsJSON( charm.skills )
)

io.write( charmText )
