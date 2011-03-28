#! /usr/bin/lua

require( "common" )

Armors = data( "armors" )

io.input( "armor/names.txt" )

local function getClass( name )
	for _, class in ipairs( Armors ) do
		for _, piece in ipairs( class.pieces ) do
			if piece.name.hgg == name or piece.name.hgg_fem == name then
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
