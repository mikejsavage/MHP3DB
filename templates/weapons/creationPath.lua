{%
local creationPathItem = loadTemplate( "weapons/creationPathItem" )
%}

<h2>Creation path</h2>

<table class="data path">
	<tr>
		<th>Name</th>
		<th>Improve</th>
		<th>Create</th>
	</tr>

	{%
	for depth, idx in ipairs( weapon.path ) do
		print( creationPathItem( { class = class, weapon = class.weapons[ idx ] } ) )
	end
	%}
</table>
