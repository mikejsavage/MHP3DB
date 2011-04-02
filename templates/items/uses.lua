<h2>Used for</h2>

<table class="data">
	<tr>
		<th>Use</th>
		<th>Object</th>
		<th>Req</th>
	</tr>

	{%
		if item.uses.weapons then
			local weaponNameURL = loadTemplate( "weapons/weaponNameURL" )

			for _, weaponUse in ipairs( item.uses.weapons ) do
				local class = weaponClassFromShort( weaponUse.short )

				printf( "<tr><td>%s</td><td>%s</td><td>%d</td></tr>",
					weaponUse.type == "create" and "Creating" or "Upgrading to",
					weaponNameURL( { class = class, weapon = class.weapons[ weaponUse.id ] } ),
					weaponUse.count
				)
			end
		end

		if item.uses.guns then
			local weaponNameURL = loadTemplate( "weapons/weaponNameURL" )

			for _, gunUse in ipairs( item.uses.guns ) do
				local class = gunClassFromShort( gunUse.short )

				printf( "<tr><td>%s</td><td>%s</td><td>%d</td></tr>",
					gunUse.type == "create" and "Creating" or "Upgrading to",
					weaponNameURL( { class = class, weapon = class.weapons[ gunUse.id ] } ),
					gunUse.count
				)
			end
		end

		if item.uses.armors then
			local pieceNameURL = loadTemplate( "armory/pieceNameURL" )

			for _, armorUse in ipairs( item.uses.armors ) do
				local class = armorClassFromShort( armorUse.short )

				printf( "<tr><td>Creating</td><td>%s</td><td>%d</td></tr>",
					pieceNameURL( { class = class, piece = class.pieces[ armorUse.id ] } ),
					armorUse.count
				)
			end
		end

		if item.uses.decorations then
			local decorNameURL = loadTemplate( "armory/decorNameSlotsURL" )

			for _, decorUse in ipairs( item.uses.decorations ) do
				printf( "<tr><td>Creating</td><td>%s</td><td>%d</td></tr>",
					decorNameURL( { decor = Decorations[ decorUse.id ] } ),
					decorUse.count
				)
			end
		end
	%}
</table>
