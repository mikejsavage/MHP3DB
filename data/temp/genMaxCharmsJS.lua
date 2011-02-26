#! /usr/bin/lua

require( "common" )

local Charms = data( "charmsFiltered" )

local lenmm = table.getn( Charms ) - 1 -- len--

local function getCharmJSON( charm )
	local out = "[" .. charm.slots

	if charm.skills[ 1 ] then
		out = out .. "," .. charm.skills[ 1 ].id .. "," .. charm.skills[ 1 ].points
	end

	if charm.skills[ 2 ] then
		out = out .. "," .. charm.skills[ 2 ].id .. "," .. charm.skills[ 2 ].points
	end

	return out .. "]"
end

io.output( "../data/charms.js" )

io.write( "var Charms=[" )

for i = 1, lenmm do
	io.write( getCharmJSON( Charms[ i ] ) )
	io.write( "," )
end

io.write( getCharmJSON( Charms[ lenmm + 1 ] ) )

io.write( "]" )
