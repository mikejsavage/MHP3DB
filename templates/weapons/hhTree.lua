{%
-- args: class

local treeItem = loadTemplate( "weapons/hhTreeItem" )
%}

<h1>{{ icon( "equipment/" .. class.short ) }} {{ T( class.name ) }}</h1>

<table class="data eq weapons">
	<thead>
		<tr>
			<th>Name</th>
			<th>Atk</th>
			<th>TATP</th>
			<th>Notes</th>
			<th>Element</th>
			<th>Affn</th>
			<th>Sharpness</th>
			<th>Slots</th>
		</tr>
	</thead>

	{%
	function doTree( idx, depth )
		if not depth then
			depth = 0
		end

		local weapon = class.weapons[ idx ]

		print( treeItem( { class = class, weapon = weapon, depth = depth } ) )

		if weapon.upgrades then
			for _, upgrade in ipairs( weapon.upgrades ) do
				doTree( upgrade, depth + 1 )
			end
		end
	end

	for i, weapon in ipairs( class.weapons ) do
		if not weapon.improve then
			doTree( i )
		end
	end
	%}
</table>
