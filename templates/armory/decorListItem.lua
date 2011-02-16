<tr>
	<td>{{ icon( "items/jewel", decor.color ) }}</td>
	<td class="name"><a href="{%
		-- this is stupid slow - perhaps we could preprocess this?

		if UsedNames[ decor.name.hgg ] then
			print( U( ( "armory/jwl/%s_%d" ):format( decor.name.hgg:urlEscape(), decor.slots ) ) )
		else
			print( U( "armory/jwl/" .. decor.name.hgg:urlEscape() ) )

			UsedNames[ decor.name.hgg ] = true
		end
	%}" class="rare{{ decor.rarity }}">{{ T( decor.name ) }}</a></td>
	<td>{{ ( "O" ):rep( decor.slots ) }}</td>
	<td>{%
		local first = true

		for _, skill in ipairs( decor.skills ) do
			local form =
				skill.points > 0 and
					( first and "%-10s %2d" or ", %-10s %2d" )
				or
					( first and [[<span class="neg">%-10s %2d]] or [[, <span class="neg">%-10s %2d]] ) .. "</span>"

			print( form:format( T( Skills[ skill.id ].name ), skill.points ) )

			first = false
		end
	%}</td>
</tr>
