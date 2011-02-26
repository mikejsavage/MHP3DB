#! /usr/bin/lua

require( "common" )

local Charms = data( "charmsFiltered" )

io.output( "../charmsFiltered.bin" )

--[[
this is all the info we need for validation

struct Charm
{
	char skill1Id;
	char skill1Points;

	char skill2Id;
	char skill2Points;

	char numSlots;
}
]]

for _, charm in ipairs( Charms ) do
	io.write( ( "%c%c%c%c%c" ):format(
		charm.skills[ 1 ] and charm.skills[ 1 ].id or 0,
		charm.skills[ 1 ] and charm.skills[ 1 ].points or 0,
		charm.skills[ 2 ] and charm.skills[ 2 ].id or 0,
		charm.skills[ 2 ] and charm.skills[ 2 ].points or 0,
		charm.slots
	) )
end
