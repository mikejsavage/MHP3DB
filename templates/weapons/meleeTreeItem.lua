{{ depth == 0 and "<tr class='split'>" or "<tr>" }}
	<td>{{ ( "&nbsp;&nbsp;&nbsp;" ):rep( depth ) }}<a class="rare{{ weapon.rarity }}{{ weapon.create and " create" or "" }}" href="{{ U( ( "weapons/%s/%s" ):format( class.short, urlFromName( weapon.name ) ) ) }}">{{ weapon.name.hgg }}</td>
	<td>{{ weapon.attack }}</td>
	<td>?</td>
	<td>{{ weapon.element and weapon.elemAttack .. " " .. weapon.element or "-" }}</td>
	<td>{{ weapon.affinity }}%</td>
	<td>?</td>
	<td>{{ weapon.slots == 0 and "-" or ( "O" ):rep( weapon.slots ) }}</td>
</tr>
