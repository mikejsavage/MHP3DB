{%
local Infos =
{
	lbg = "weapons/gunInfo",
	hbg = "weapons/gunInfo",
	bow = "weapons/bowInfo",

	def = "weapons/meleeInfo",
}
%}

<h1>{{ weaponName( { class = class, weapon = weapon } ) }}</h1>

<h2>Stats</h2>

	{{ loadTemplate( Infos[ class.short ] or Infos.def )( { class = class, weapon = weapon } ) }}


<h2>Crafting</h2>

	{%
	if weapon.path then
		local creationPath = loadTemplate( "weapons/creationPath" )

		print( creationPath( { class = class, weapon = weapon } ) )
	end

	--[[ these are kind of redundant
	if weapon.create then
		print( "<h3>Create</h3>" )

		print( itemCounts( { materials = weapon.create } ) )

		printf( "Price: %sz", commas( weapon.price * 1.5 ) )

		if weapon.buyable then
			printf( " (buyable for %sz)", commas( weapon.price * 2 ) )
		end
	end

	if weapon.improve then
		printf( "<h3>Improve from %s</h3>", weaponNameURL( { class = class, weapon = class.weapons[ weapon.improve.from ] } ) )

		print( itemCounts( { materials = weapon.improve.materials } ) )

		printf( "Price: %sz", commas( weapon.price ) )
	end]]

	if weapon.upgrade then
		print( "<h3>Attack upgrade</h3>" )

		print( itemCounts( { materials = weapon.upgrade.materials } ) )

		printf( "Price: %sz", commas( weapon.upgrade.price ) )
	end

	if weapon.scraps then
		print( "<h3>Scraps</h3>" )

		print( itemCounts( { materials = weapon.scraps } ) )
	end

	if weapon.upgrades then
		print( "<h3>Upgrades into</h3>" )

		for _, id in ipairs( weapon.upgrades ) do
			printf( "%s<br>", weaponNameURL( { class = class, weapon = class.weapons[ id ] } ) )
		end
	end
	%}
