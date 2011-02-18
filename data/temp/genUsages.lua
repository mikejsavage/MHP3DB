#! /usr/bin/lua

require( "common" )

Items = data( "items" )

Weapons     = data( "weapons" )
Guns        = data( "guns" )
Armors      = data( "armors" )
Decorations = data( "decorations" )


function addWeaponUse( items, useType, short, id )
	for _, item in ipairs( items ) do
		if not Items[ item.id ].uses then
			Items[ item.id ].uses = { }
		end

		if not Items[ item.id ].uses.weapons then
			Items[ item.id ].uses.weapons = { }
		end

		table.insert( Items[ item.id ].uses.weapons, { type = useType, short = short, id = id, count = item.count } )
	end
end

function addGunUse( items, useType, short, id )
	for _, item in ipairs( items ) do
		if not Items[ item.id ].uses then
			Items[ item.id ].uses = { }
		end

		if not Items[ item.id ].uses.guns then
			Items[ item.id ].uses.guns = { }
		end

		table.insert( Items[ item.id ].uses.guns, { type = useType, short = short, id = id, count = item.count } )
	end
end

function addArmorUse( items, short, id )
	for _, item in ipairs( items ) do
		if not Items[ item.id ].uses then
			Items[ item.id ].uses = { }
		end

		if not Items[ item.id ].uses.armors then
			Items[ item.id ].uses.armors = { }
		end

		table.insert( Items[ item.id ].uses.armors, { short = short, id = id, count = item.count } )
	end
end

function addDecorationUse( items, id )
	for _, item in ipairs( items ) do
		if not Items[ item.id ].uses then
			Items[ item.id ].uses = { }
		end

		if not Items[ item.id ].uses.decorations then
			Items[ item.id ].uses.decorations = { }
		end

		table.insert( Items[ item.id ].uses.decorations, { id = id, count = item.count } )
	end
end

for _, class in ipairs( Weapons ) do
	for weaponId, weapon in ipairs( class.weapons ) do
		if weapon.create then
			addWeaponUse( weapon.create, "create", class.short, weaponId )
		end

		if weapon.improve then
			addWeaponUse( weapon.improve.materials, "improve", class.short, weaponId )
		end
	end
end

for _, class in ipairs( Guns ) do
	for gunId, gun in ipairs( class.weapons ) do
		if gun.create then
			addGunUse( gun.create, "create", class.short, gunId )
		end

		if gun.improve then
			addGunUse( gun.improve.materials, "improve", class.short, gunId )
		end
	end
end

for _, class in ipairs( Armors ) do
	for pieceId, piece in ipairs( class.pieces ) do
		if piece.create then
			addArmorUse( piece.create, class.short, pieceId )
		end
	end
end

for decorationId, decoration in ipairs( Decorations ) do
	for _, method in ipairs( decoration.create ) do
		addDecorationUse( method, decorationId )
	end
end

print( "genUsages: ok!" )

io.output( "../items.json" )
io.write( json.encode( Items ) )
