{%
local itemCountsAligned = loadTemplate( "itemCountsAligned" )
%}

<h1>{{ weaponName( { class = class, weapon = weapon } ) }}</h1>

<h2>Stats</h2>

	Attack: {{ weapon.attack }}<br>
	TATP: {{ getTATP( weapon ) }}<br>

	{%
	if weapon.notes then
		print( "Notes: " )

		for _, note in ipairs( weapon.notes ) do
			print( ( "<span class='note%s'>%s</span> " ):format( note, Special.note ) )
		end

		print( "<br>" )
	elseif weapon.shellingType then
		print( ( "Shelling: %s L%d<br>" ):format( weapon.shellingType, weapon.shellingLevel ) )
	elseif weapon.phial then
		print( ( "Phial: %s<br>" ):format( weapon.phial ) )
	end
	%}

	{%
	if weapon.element then
		print( ( "Element: <span class='elem%s'>%d</span><br>" ):format( weapon.element, weapon.elemAttack ) )
	end
	%}

	Sharpness: {{ weapon.sharpness and sharpness( { sharpness = weapon.sharpness, wide = true } ) or "?" }}<br>

	Affinity:
	{%
	if weapon.affinity ~= 0 then
		print( E( "span", weapon.affinity > 0 and "pos" or "neg", weapon.affinity .. "%" ) )
	else
		print( ( "%s%%" ):format( weapon.affinity ) )
	end
	%}<br>

	Slots: {{ weapon.slots == 0 and "none" or ( "O" ):rep( weapon.slots ) }}<br>
	Rarity: <span class="rare{{ weapon.rarity }}">{{ weapon.rarity }}</span>


<h2>Crafting</h2>

	{%
	if weapon.create then
		print( E( "h3", nil, "Create" ) )

		print( itemCounts( { materials = weapon.create } ) )

		print( ( "Price: %sz" ):format( commas( weapon.price * 1.5 ) ) )

		if weapon.buyable then
			print( ( " (buyable for %sz)" ):format( commas( weapon.price * 2 ) ) )
		end
	end

	if weapon.improve then
		print( E( "h3", nil, ( "Improve from %s" ):format( weaponNameURL( { class = class, weapon = class.weapons[ weapon.improve.from ] } ) ) ) )

		print( itemCounts( { materials = weapon.improve.materials } ) )

		print( ( "Price: %sz" ):format( commas( weapon.price ) ) )
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



	print( "<h2>Creation path</h2>" )

	print( "<table class='data path'>" )
	print( "<tr><th>Name</th><th>Improve</th><th>Create</th></tr>" )

	for depth, idx in ipairs( weapon.path ) do
		local pathWeapon = class.weapons[ idx ]

		print( "<tr>" )

		print( ( "<td>%s%s</td>" ):format(
			"", --( "&nbsp;&nbsp;&nbsp;" ):rep( depth - 1 ),
			weaponNameURL( { class = class, weapon = pathWeapon } )
		) )

		if pathWeapon.improve then
			print( ( "<td>%s%sz</td>" ):format(
				itemCountsAligned( { materials = pathWeapon.improve.materials } ),
				commas( pathWeapon.price )
			) )
		else
			print( "<td class='none'>-</td>" )
		end

		if pathWeapon.create then
			print( ( "<td>%s%sz</td>" ):format(
				itemCountsAligned( { materials = pathWeapon.create } ),
				commas( pathWeapon.price * WeaponCreatePriceScale )
			) )
		else
			print( "<td class='none'>-</td>" )
		end

		print( "</tr>" )
	end

	print( "</table>" )
	%}
