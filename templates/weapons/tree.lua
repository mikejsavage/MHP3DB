{%
-- args: class


local TreeHeaders =
{
	hh  = "weapons/hhTreeHeader",
	gl  = "weapons/glTreeHeader",
	sa  = "weapons/saTreeHeader",

	lbg = "weapons/gunTreeHeader",
	hbg = "weapons/gunTreeHeader",

	def = "weapons/meleeTreeHeader",
}

-- moneys
local TreeInfos =
{
	hh  = "weapons/hhTreeInfo",
	gl  = "weapons/glTreeInfo",
	sa  = "weapons/saTreeInfo",

	lbg = "weapons/gunTreeInfo",
	hbg = "weapons/gunTreeInfo",

	def = "weapons/meleeTreeInfo",
}

local treeItem = loadTemplate( "weapons/treeItem" )
local treeInfo = loadTemplate( TreeInfos[ class.short ] or TreeInfos.def )
%}

{{ js( "common", "weaponTree" ) }}

<h1>{{ icon( "equipment/" .. class.short ) }} {{ T( class.name ) }}</h1>

<table class="data eq weapons">
	<thead>
		<tr>
			{( TreeHeaders[ class.short ] or TreeHeaders.def )}
		</tr>
	</thead>

	{%
	function doTree( idx, depth )
		if not depth then
			depth = 0
		end

		local weapon = class.weapons[ idx ]

		print( treeItem( { class = class, weapon = weapon, weaponIdx = idx, depth = depth, treeInfo = treeInfo } ) )

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
