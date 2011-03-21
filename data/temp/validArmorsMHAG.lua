#! /usr/bin/lua

require( "common" )

Armors = data( "armors" )
Skills = data( "skills" )

local DataFile = "armor/mhag_armor.dat"

local MHAGShorts =
{
	H = "hlm",
	C = "plt",
	A = "arm",
	W = "wst",
	L = "leg",
}

io.input( DataFile )

local function classFromMHAG( short )
	for _, class in ipairs( Armors ) do
		if class.short == MHAGShorts[ short ] then
			return class
		end
	end

	assert( nil, "classFromMHAG failed: " .. short )
end

local function pieceFromNameClass( name, short )
	local class = classFromMHAG( short )

	for _, piece in ipairs( class.pieces ) do
		if piece.name.hgg == name then
			return piece
		end
	end

	return nil
end


for line in io.lines() do
	if line:sub( 1, 1 ) ~= "#" then
		local name, useBy, class, def, slots,
		      fireRes, waterRes, iceRes, thunderRes, dragonRes, skills
			= line:match( "^([%a %+%-'/]-)%s+: (%u) : (%u) : %s*([%d%-]+) : %s*(%d+) : (%d) : %s*([%d%-]+) : %s*([%d%-]+) : %s*([%d%-]+) : %s*([%d%-]+) : %s*([%d%-]+)(.+)$" )

		local piece = pieceFromNameClass( name, class )

		if not piece then
			print( "bad name: " .. name )
		end
	end
end
