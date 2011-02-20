{%
-- args: class


local treeItem = loadTemplate( "weapons/meleeTreeItem" )

local TreeHeaders =
{
	hh = "weapons/hhTreeHeader",
	gl = "weapons/glTreeHeader",
	sa = "weapons/saTreeHeader",
	default = "weapons/meleeTreeHeader",
}
%}

<script type="text/javascript" src="{{ U( "js/common.js" ) }}"></script>
<script type="text/javascript" src="{{ U( "js/weaponTree.js" ) }}"></script>

<h1>{{ icon( "equipment/" .. class.short ) }} {{ T( class.name ) }}</h1>

<table class="data eq weapons">
	<thead>
		<tr>
			{( TreeHeaders[ class.short ] or TreeHeaders.default )}
		</tr>
	</thead>

	{%
	function doTree( idx, depth )
		if not depth then
			depth = 0
		end

		local weapon = class.weapons[ idx ]

		print( treeItem( { class = class, weapon = weapon, weaponIdx = idx, depth = depth } ) )

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
