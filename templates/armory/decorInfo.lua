<h1>{{ icon( "items/jewel", decor.color ) }} {{ T( decor.name ) }}</h1>


<h2>Stats</h2>

	Req slots: {{ ( "O" ):rep( decor.slots ) }}<br>
	Rarity: <span class="rare{{ decor.rarity }}">{{ decor.rarity }}</span>

	<h3>Skill points</h3>

		{%
		for _, skill in ipairs( decor.skills ) do
			local form =
				skill.points > 0 and
					"%s: +%d"
				or
					"%s: <span class=\"neg\">%d</span>"

			print( form:format( T( Skills[ skill.id ].name ), skill.points ) .. "<br>" )
		end
		%}



<h2>Crafting</h2>

	Price: {{ decor.price }}z

	{%
	local firstCreate = true

	for _, create in ipairs( decor.create ) do
		print( ( "<h3>%s</h3>" ):format( firstCreate and "Materials" or "Alternatively..." ) )

		print( itemCounts( { materials = create } ) )

		firstCreate = false
	end
	%}
