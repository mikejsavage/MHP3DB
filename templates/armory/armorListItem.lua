<tr>
	<td><a class="rare{{ piece.rarity }}" href="{{ U( ( "armory/%s/%s" ):format( class.short, urlFromName( piece.name ) ) ) }}">{{ piece.name.hgg }}</td>
	<td>{{ piece.blade and "Y" or "N" }}</td>
	<td>{{ piece.gunner and "Y" or "N" }}</td>
	<td>{{ piece.defense }}</td>
	<td>{{ piece.fireRes }}</td>
	<td>{{ piece.waterRes }}</td>
	<td>{{ piece.thunderRes }}</td>
	<td>{{ piece.iceRes }}</td>
	<td>{{ piece.dragonRes }}</td>
	<td>{{ piece.slots == 0 and "-" or ( "O" ):rep( piece.slots ) }}</td>
	<td{%
		if piece.skills then
			print( ">" )

			local alt = false

			for _, skill in ipairs( piece.skills ) do
				-- :)
				local form =
					skill.points > 0 and
						( alt and ", %-10s %3d\n" or "%-10s %3d" )
					or skill.points < 0 and
						( alt and ", <span class=\"neg\">%-10s %3d</span>\n" or "<span class=\"neg\">%-10s %3d</span>" )
					or 
						( alt and ", %-10s    \n" or "%-10s    " )

				printf( form, T( Skills[ skill.id ].name ), skill.points )

				alt = not alt
			end
		else
			print( " class='none'>-" )
		end
	%}</td>
</tr>
