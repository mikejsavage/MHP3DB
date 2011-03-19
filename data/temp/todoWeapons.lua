#! /usr/bin/lua

require( "common" )

Weapons = data( "weapons" )

io.input( "weapons/names.txt" )

local function getClass( name )
	for _, class in ipairs( Weapons ) do
		for _, weapon in ipairs( class.weapons ) do
			if weapon.name.hgg == name then
				return class
			end
		end
	end

	return false
end

local curClass
local lastGood

for line in io.lines() do
	local class = getClass( line )

	if not class then
		print( line .. " (last good: " .. lastGood .. ")" )
	else
		if class ~= curClass then
			print( "\n" .. class.name.hgg .. "\n" .. ( "-" ):rep( 50 ) )

			curClass = class
		end

		lastGood = line
	end
end
