#! /usr/bin/lua

require( "common" )

local DataPath = "skills/info.txt"

local Actions =
{
	init = function( line, skill )
		local success, _, name = line:find( "^([%a%d /%+%-%[%]]+)$" )

		assert( success, "bad name: " .. line )

		skill.name = { hgg = name }

		return "main"
	end,

	main = function( line, skill )
		local success, _, copy = line:find( "^copy (%l+)$" )

		if success then
			skill.copy = copy
			
			return "main"
		end

		local success, _, points, name = line:find( "^([%d-]+) ([%a%d '/%+%-%%%%[%]%(%)]+)$" )

		assert( success, "bad skill in " .. skill.name.hgg .. ": " .. line )

		if not skill.bounds then
			skill.bounds = { }
		end

		table.insert( skill.bounds, { points = points, name = { hgg = name } } )

		return "main"
	end,
}

function doLine( line, piece, state )
	if not Actions[ state ] then
		print( state )
	end

	return Actions[ state ]( line, piece )
end

local Skills = { }

io.input( DataPath )

local state = "init"
local skill = { }

for line in io.lines() do
	if line == "" then
		table.insert( Skills, skill )

		state = "init"
		skill = { }
	else
		state = doLine( line, skill, state )
	end
end

table.insert( Skills, skill )

print( "genSkillInfo: ok!" )

io.output( "../skills.json" )
io.write( json.encode( Skills ) )
