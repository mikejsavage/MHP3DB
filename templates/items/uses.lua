{%
	local use = loadTemplate( "items/use" )
%}

<h2>Used for</h2>

<table class="data">
	<thead>
		<tr>
			<th>Use</th>
			<th>Object</th>
			<th>Req</th>
		</tr>
	</thead>

	<tbody>
		{%
			if item.uses.weapons then
				local weaponNameURL = loadTemplate( "weapons/weaponNameURL" )

				for _, weaponUse in ipairs( item.uses.weapons ) do
					local class = weaponClassFromShort( weaponUse.short )

					print( use( {
						type = weaponUse.type == "create" and "Creating" or "Upgrading to",
						name = weaponNameURL( { class = class, weapon = class.weapons[ weaponUse.id ] } ),
						count = weaponUse.count
					} ) )
				end
			end

			if item.uses.guns then
				local weaponNameURL = loadTemplate( "weapons/weaponNameURL" )

				for _, gunUse in ipairs( item.uses.guns ) do
					local class = gunClassFromShort( gunUse.short )

					print( use( {
						type = gunUse.type == "create" and "Creating" or "Upgrading to",
						name = weaponNameURL( { class = class, weapon = class.weapons[ gunUse.id ] } ),
						count = gunUse.count
					} ) )
				end
			end

			if item.uses.armors then
				local pieceNameURL = loadTemplate( "armory/pieceNameURL" )

				for _, armorUse in ipairs( item.uses.armors ) do
					local class = armorClassFromShort( armorUse.short )

					print( use( {
						type = "Creating",
						name = pieceNameURL( { class = class, piece = class.pieces[ armorUse.id ] } ),
						count = armorUse.count
					} ) )
				end
			end

			if item.uses.decorations then
				local decorNameSlotsURL = loadTemplate( "armory/decorNameSlotsURL" )

				for _, decorUse in ipairs( item.uses.decorations ) do
					print( use( {
						type = "Creating",
						name = decorNameSlotsURL( { decor = Decorations[ decorUse.id ] } ),
						count = decorUse.count
					} ) )
				end
			end
		%}
	</tbody>
</table>
