<td>{{ ( "&nbsp;&nbsp;&nbsp;" ):rep( depth ) }}<a class="rare{{ weapon.rarity }}{{ weapon.create and " create" or "" }}" href="{{ U( ( "weapons/%s/%s" ):format( class.short, urlFromName( weapon.name ) ) ) }}">{{ T( weapon.name ) }}</a></td>
<td>{{ weapon.attack }}</td>
<td>{{ weapon.reload }}</td>
<td>{{ weapon.drift }}</td>
<td>{{ weapon.recoil }}</td>

<td{%
	if weapon.affinity ~= 0 then
		printf( [[ class="%s"]], weapon.affinity > 0 and "pos" or "neg" )
	end
%}>{{ weapon.affinity }}%</td>

<td{{ weapon.slots == 0 and [[ class="none">-]] or ">" .. ( "O" ):rep( weapon.slots ) }}</td>
