#! /usr/bin/lua

require( "common" )

Decorations = data( "decorations" )

io.input( "armor/namesDecorations.txt" )

local function exists( name )
	name = name:gsub( "%s+%[%d+%]", "" )

	for _, decoration in ipairs( Decorations ) do
		if decoration.name.hgg == name then
			return true
		end
	end

	return false
end

local lastGood

for line in io.lines() do
	if exists( line ) then
		lastGood = line
	else
		print( line .. " (last good: " .. lastGood .. ")" )
	end
end
