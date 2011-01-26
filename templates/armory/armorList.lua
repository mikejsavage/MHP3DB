{%
-- args: class

local listItem = loadTemplate( "armory/armorListItem" )
%}

<h1>{{ icon( "equipment/" .. class.short ) }} {{ T( class.name ) }}</h1>

<table class="data eq armor">
	<thead>
		<tr>
			<th>Name</th>
			<th>B</th>
			<th>G</th>
			<th>Def</th>
			<th>FRes</th>
			<th>WRes</th>
			<th>TRes</th>
			<th>IRes</th>
			<th>DRes</th>
			<th>Slots</th>
			<th>Skills</th>
		</tr>
	</thead>

	<tbody>
		{%
		for _, piece in ipairs( class.pieces ) do
			print( listItem( { class = class, piece = piece } ) )
		end
		%}
	</tbody>
</table>
