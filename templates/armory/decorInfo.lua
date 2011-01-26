<h1>{{ icon( "items/jewel", colorFromName( decor.color ) ) }} {{ T( decor.name ) }}</h1>

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

<h3>Create</h3>

	{{ itemCounts( { materials = decor.create } ) }}
	Price: {{ decor.price }}z
