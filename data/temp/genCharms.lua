#! /usr/bin/lua

require( "common" )

local DataPath = "charms/charms.csv"

Skills = data( "skills" )

local Charms = { }

local Unused = { }
local Bad = { }

for _, skill in ipairs( Skills ) do
	Unused[ skill.name.hgg ] = true
end

io.input( DataPath )

-- \r because io.lines() only removes \n...

for line in io.lines() do
	if line ~= "ID,Charm Type,Charm Name,Skill 1,Skill 2,Charm Slot,Table No.\r" then
		local success, _, skill1, skill2, slots, table =
			line:find( "^%d+,[%a ]+,[%a ]+,([%a%+%-/%d ]*),([%a%+%-/%d ]*),(%d+),([%a%d]+)\r$" )

		assert( success, "bad line: " .. line )

		local id1, points1 = parseSkill( skill1 )

		if not id1 then
			local _, _, name = skill1:find( "^([%a%-/ ]+) [%+%-]?%d+$" )

			assert( name, "what " .. skill1 )

			Bad[ name ] = true
		else
			local _, _, name = skill1:find( "^([%a%-/ ]+) [%+%-]?%d+$" )

			Unused[ name ] = nil
		end

		--assert( id1, "bad skill1 in " .. line )

		if skill2 ~= "" then
			local id2, points2 = parseSkill( skill2 )

			if not id2 then
				local _, _, name = skill2:find( "^([%a%-/ ]+) [%+%-]?%d+$" )

				assert( name, "what " .. skill2 )

				Bad[ name ] = true
			else
				local _, _, name = skill2:find( "^([%a%-/ ]+) [%+%-]?%d+$" )

				Unused[ name ] = nil
			end

			--assert( id2, "bad skill1 in " .. line )
		end
	end
end

for name, _ in pairs( Bad ) do
	print( "bad: " .. name )
end

for name, _ in pairs( Unused ) do
	print( "unused: " .. name )
end

print( "genCharms: ok!" )

--io.output( "../charms.json" )
--io.write( json.encode( Charms ) )
