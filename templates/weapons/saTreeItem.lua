{{ depth == 0 and "<tr class='split'>" or "<tr>" }}
	<td>{{ ( "&nbsp;&nbsp;&nbsp;" ):rep( depth ) }}<a class="rare{{ weapon.rarity }}{{ weapon.create and " create" or "" }}" href="{{ U( ( "weapons/%s/%s" ):format( class.short, urlFromName( weapon.name ) ) ) }}">{{ weapon.name.hgg }}</a></td>
	<td>{{ weapon.attack }}</td>
	<td>{{ weapon.phial }}</td>
	{{ weapon.element and ( "<td class='elem%s'>%d" ):format( weapon.element, weapon.elemAttack ) or "<td>-" }}</td>
	<td{{ weapon.affinity ~= 0 and ( ( " class='%s'" ):format( weapon.affinity > 0 and "pos" or "neg" ) ) or ""}}>{{ weapon.affinity }}%</td>
	<td>{{ weapon.sharpness and sharpness( { sharpness = weapon.sharpness } ) or "?" }}</td>
	<td>{{ weapon.slots == 0 and "-" or ( "O" ):rep( weapon.slots ) }}</td>
</tr>
