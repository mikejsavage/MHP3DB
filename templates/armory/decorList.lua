{%
local listItem = loadTemplate( "armory/decorListItem" )

UsedNames = { }
%}

<h1>{{ icon( "items/jewel" ) }} Decorations</h1>

<table class="data eq decorations">
	<thead>
		<tr>
			<th>&nbsp;</th>
			<th class="name">Name</th>
			<th>Slots</th>
			<th>Skill points</th>
		</tr>
	</thead>

	<tbody>
		{%
		for _, decor in ipairs( Decorations ) do
			print( listItem( { decor = decor } ) )
		end
		%}
	</tbody>
</table>
