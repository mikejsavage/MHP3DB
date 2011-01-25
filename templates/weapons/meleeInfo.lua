<h1>{{ weaponName( { class = class, weapon = weapon } ) }}</h1>


<h2>Stats</h2>

	Attack: {{ weapon.attack }}<br>
	TATP: ?<br>
	Sharpness: ?<br>

	Affinity:
	{%
	if weapon.affinity ~= 0 then
		E( "span", weapon.affinity > 0 and "pos" or "neg", weapon.affinity )
	else
		print( weapon.affinity )
	end
	%}%<br>

	Slots: {{ weapon.slots == 0 and "none" or ( "O" ):rep( weapon.slots ) }}<br>
	Rarity: <span class="rare{{ weapon.rarity }}">{{ weapon.rarity }}</span>


<h2>Crafting</h2>

	{%
	if weapon.create then
		print( E( "h3", nil, "Create" ) )

		print( itemCounts( { materials = weapon.create } ) )

		print( ( "Price: %dz" ):format( weapon.price * 1.5 ) )

		if weapon.buyable then
			print( ( " (buyable for %dz)" ):format( weapon.price * 2 ) )
		end
	end

	if weapon.improve then
		print( E( "h3", nil, ( "Improve from %s" ):format( weaponNameURL( { class = class, weapon = class.weapons[ weapon.improve.from[ 1 ] ] } ) ) ) )

		print( itemCounts( { materials = weapon.improve.materials } ) )

		print( ( "Price: %dz" ):format( weapon.price ) )
	end

	if weapon.scraps then
		print( E( "h3", nil, "Scraps" ) )

		print( itemCounts( { materials = weapon.scraps } ) )
	end

	if weapon.upgrades then
		print( E( "h3", nil, "Upgrades into" ) )

		for _, id in ipairs( weapon.upgrades ) do
			print( ( "%s<br>" ):format( weaponNameURL( { class = class, weapon = class.weapons[ id ] } ) ) )
		end
	end
	%}
