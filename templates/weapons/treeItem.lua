{%
local path = weapon.path and json.encode( weapon.path ) or "[]"
%}

<tr{{ depth == 0 and [[ class="split"]] or "" }} id="wpn{{ weaponIdx }}" onmouseover="markPath( {{ path }} )" onmouseout="dimPath( {{ path }} )">
	{{ treeInfo( { weapon = weapon, class = class, depth = depth } ) }}
</tr>
