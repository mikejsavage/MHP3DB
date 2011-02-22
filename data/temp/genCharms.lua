#! /usr/bin/lua

require( "common" )

local DataPath = "charms/charms.csv"

Skills = data( "skills" )

local Charms = { }

local Used = { }
local Bad = { }

for _, skill in ipairs( Skills ) do
	Used[ skill.name.hgg ] = false
end

io.input( DataPath )

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

			Used[ name ] = true
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

				Used[ name ] = true
			end

			--assert( id2, "bad skill1 in " .. line )
		end
	end
end

for name, _ in pairs( Bad ) do
	if not used then
		print( "bad: " .. name )
	end
end

for name, used in pairs( Used ) do
	if not used then
		print( "unused: " .. name )
	end
end

print( "genCharms: ok!" )

--io.output( "../charms.json" )
--io.write( json.encode( Charms ) )
