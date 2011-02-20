{%
-- moneys
local TreeInfos =
{
	hh = "weapons/hhTreeInfo",
	gl = "weapons/glTreeInfo",
	sa = "weapons/saTreeInfo",
	default = "weapons/meleeTreeInfo",
}

local treeInfo = loadTemplate( TreeInfos[ class.short ] or TreeInfos.default )

--[[
-- why did i bother...
-- HAY WHY NOT CACHE THIS TOO???????


local path = "["

if weapon.path then
	local pathLength = table.getn( weapon.path )

	if pathLength ~= 0 then
		for i = 1, pathLength - 1 do
			path = ( "%s%d," ):format( path, weapon.path[ i ] )
		end

		path = ( "%s%d" ):format( path, weapon.path[ pathLength ] )
	end
end

path = path .. "]"
]]

local path = weapon.path and json.encode( weapon.path ) or "[]"
%}

<tr{{ depth == 0 and [[ class="split"]] or "" }} id="wpn{{ weaponIdx }}" onmouseover="markPath( {{ path }} )" onmouseout="dimPath( {{ path }} )">
	{{ treeInfo( { weapon = weapon, class = class, depth = depth } ) }}
</tr>
