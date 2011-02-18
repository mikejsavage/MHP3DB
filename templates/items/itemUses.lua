{%
local function classFromShort( equipment, short )
	for _, class in ipairs( equipment ) do
		if class.short == short then
			return class
		end
	end

	return nil
end
%}

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
			local class = classFromShort( Weapons, weaponUse.short )

			print( ( "<tr><td>%s</td><td>%s</td><td>%d</td></tr>" ):format(
				weaponUse.type == "create" and "Creating" or "Upgrading to",
				weaponNameURL( { class = class, weapon = class.weapons[ weaponUse.id ] } ),
				weaponUse.count
			) )
		end
	end

	if item.uses.guns then
		local weaponNameURL = loadTemplate( "weapons/weaponNameURL" )

		for _, gunUse in ipairs( item.uses.guns ) do
			local class = classFromShort( Guns, gunUse.short )

			print( ( "<tr><td>%s</td><td>%s</td><td>%d</td></tr>" ):format(
				gunUse.type == "create" and "Creating" or "Upgrading to",
				weaponNameURL( { class = class, weapon = class.weapons[ gunUse.id ] } ),
				gunUse.count
			) )
		end
	end

	if item.uses.armors then
		local pieceNameURL = loadTemplate( "armory/pieceNameURL" )

		for _, armorUse in ipairs( item.uses.armors ) do
			local class = classFromShort( Armors, armorUse.short )

			print( ( "<tr><td>Creating</td><td>%s</td><td>%d</td></tr>" ):format(
				pieceNameURL( { class = class, piece = class.pieces[ armorUse.id ] } ),
				armorUse.count
			) )
		end
	end

	--[[if item.uses.decorations then
		local decorNameURL = loadTemplate( "armory/decorNameURL" )

		for _, decorUse in ipairs( item.uses.decorations ) do
			print( ( "<tr><td>Creating</td><td>%s</td><td>%d</td></tr>" ):format(
				decorNameURL( { decor = Decorations[ decorUse.id ] } ),
				decorUse.count
			) )
		end
	end]]
	%}
</table>
