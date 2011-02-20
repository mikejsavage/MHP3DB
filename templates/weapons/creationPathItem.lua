{%
local itemCountsAligned = loadTemplate( "itemCountsAligned" )
%}

<tr>
	<td>{{ weaponNameURL( { class = class, weapon = weapon } ) }}</td>

	<td{%
		if weapon.improve then
			print( ( ">%s%sz" ):format(
				itemCountsAligned( { materials = weapon.improve.materials } ),
				commas( weapon.price )
			) )
		else
			print( [[ class="none">-]] )
		end
	%}</td>

	<td{%
		if weapon.create then
			print( ( ">%s%sz" ):format(
				itemCountsAligned( { materials = weapon.create } ),
				commas( weapon.price * WeaponCreatePriceScale )
			) )
		else
			print( [[ class="none">-]] )
		end
	%}</td>
</tr>
