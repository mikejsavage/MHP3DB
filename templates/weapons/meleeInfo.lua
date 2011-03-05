<h1>{{ weaponName( { class = class, weapon = weapon } ) }}</h1>

<h2>Stats</h2>

	Attack: {{ weapon.attack }}<br>
	TATP: {{ getTATP( weapon ) }}<br>

	{%
	if weapon.notes then
		print( "Notes: " )

		for _, note in ipairs( weapon.notes ) do
			printf( [[<span class="note%s">%s</span> ]], note, Special.note )
		end

		print( "<br>" )
	elseif weapon.shellingType then
		printf( "Shelling: %s L%d<br>", weapon.shellingType, weapon.shellingLevel )
	elseif weapon.phial then
		printf( "Phial: %s<br>", weapon.phial )
	end
	%}

	{%
	if weapon.element then
		printf( [[Element: <span class="elem%s">%d</span><br>]], weapon.element, weapon.elemAttack )
	end
	%}

	Sharpness: {{ weapon.sharpness and sharpness( { weapon = weapon, wide = true } ) or "?" }}<br>

	Affinity:
	{%
	if weapon.affinity ~= 0 then
		printf( [[<span class="%s">%d%%</span>]], weapon.affinity > 0 and "pos" or "neg", weapon.affinity )
	else
		printf( "%s%%", weapon.affinity )
	end
	%}<br>

	Slots: {{ weapon.slots == 0 and "none" or ( "O" ):rep( weapon.slots ) }}<br>
	Rarity: <span class="rare{{ weapon.rarity }}">{{ weapon.rarity }}</span>


<h2>Crafting</h2>

	{%
	if weapon.create then
		print( "<h3>Create</h3>" )

		print( itemCounts( { materials = weapon.create } ) )

		printf( "Price: %sz", commas( weapon.price * 1.5 ) )

		if weapon.buyable then
			printf( " (buyable for %sz)", commas( weapon.price * 2 ) )
		end
	end

	if weapon.improve then
		printf( "<h3>Improve from %s</h3>", weaponNameURL( { class = class, weapon = class.weapons[ weapon.improve.from ] } ) )

		print( itemCounts( { materials = weapon.improve.materials } ) )

		printf( "Price: %sz", commas( weapon.price ) )
	end

	if weapon.upgrade then
		print( "<h3>Attack upgrade</h3>" )

		print( itemCounts( { materials = weapon.upgrade.materials } ) )

		printf( "Price: %sz", commas( weapon.upgrade.price ) )
	end

	if weapon.scraps then
		print( "<h3>Scraps</h3>" )

		print( itemCounts( { materials = weapon.scraps } ) )
	end

	if weapon.upgrades then
		print( "<h3>Upgrades into</h3>" )

		for _, id in ipairs( weapon.upgrades ) do
			printf( "%s<br>", weaponNameURL( { class = class, weapon = class.weapons[ id ] } ) )
		end
	end

	if weapon.path then
		local creationPath = loadTemplate( "weapons/creationPath" )

		print( creationPath( { class = class, weapon = weapon } ) )
	end
	%}
