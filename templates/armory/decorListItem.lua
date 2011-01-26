<tr>
	<td>{{ icon( "items/jewel", colorFromName( decor.color ) ) }}</td>
	<td class="name"><a href="{{ U( "armory/jwl/" .. decor.name.hgg:urlEscape() ) }}" class="rare{{ decor.rarity }}">{{ T( decor.name ) }}</a></td>
	<td>{{ ( "O" ):rep( decor.slots ) }}</td>
	<td>{%
		local first = true

		for _, skill in ipairs( decor.skills ) do
			local form =
				skill.points > 0 and
					( first and "%-10s %2d" or ", %-10s %2d" )
				or
					( first and "<span class=\"neg\">%-10s %2d" or ", <span class=\"neg\">%-10s %2d" ) .. "</span>"

			print( form:format( T( Skills[ skill.id ].name ), skill.points ) )

			first = false
		end
	%}</td>
</tr>
