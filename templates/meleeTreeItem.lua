{{ depth == 0 and "<tr class='split'>" or "<tr>" }}
	<td class="rare{{ weapon.rarity }}">{{ ( "&nbsp;&nbsp;&nbsp;" ):rep( depth )}}{{ weapon.name.hgg }}</td>
	<td>{{ weapon.attack }}</td>
	<td>?</td>
	<td>?</td>
	<td>{{ weapon.affinity }}%</td>
	<td>?</td>
	<td>{{ weapon.slots == 0 and "-" or ( "O" ):rep( weapon.slots ) }}</td>
</tr>
