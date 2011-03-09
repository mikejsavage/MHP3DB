{%
local creationPathItem = loadTemplate( "weapons/creationPathItem" )
%}

<h3>Creation path</h3>

<table class="data path">
	<tr>
		<th>Name</th>
		<th>Improve</th>
		<th>Create</th>
	</tr>

	{{ creationPathItem( { class = class, weapon = weapon } ) }}

	{%
	for depth, idx in ipairs( weapon.path ) do
		print( creationPathItem( { class = class, weapon = class.weapons[ idx ] } ) )
	end
	%}
</table>
