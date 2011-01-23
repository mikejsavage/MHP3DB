#! /usr/bin/lua

-- this is obv incomplete...

require( "cgi" )
require( "json" )

local Weapons = json.decode( readFile( "data/weapons.json" ) )
local Items   = json.decode( readFile( "data/items.json" ) )

print( "Content-type: text/html\n" )

function recursiveWeaponTree( class, startId, depth )
	if not depth then
		depth = 0
	end

	for i = 0, depth do
		print( "# " )
	end

	local weapon = class.weapons[ startId ]

	print( weapon.name.hgg .. "<br>" )

	if weapon.improve then
		for _, part in ipairs( weapon.improve.materials ) do
			print( "- " .. Items[ part.id ].name .. " x" .. part.count .. "<br>" )
		end
	end

	if weapon.upgrades then
		for _, upgrade in ipairs( weapon.upgrades ) do
			recursiveWeaponTree( class, upgrade, depth + 1 )
		end
	end
end

for _, class in ipairs( Weapons ) do
	print( "<h1>" .. class.name.hgg .. "</h1>" )

	for i, weapon in ipairs( class.weapons ) do
		if not weapon.improve then
			recursiveWeaponTree( class, i )
		end
	end
end
