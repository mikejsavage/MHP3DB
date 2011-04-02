<h1>{{ itemName( { item = item } ) }}</h1>

ID: {{ item.id }} (0x{{ ( "%04x" ):format( item.id ):upper() }})<br>
Rarity: <span class="rare{{ item.rarity }}">{{ item.rarity or "?" }}</span>


{%
	if item.uses then
		local itemUses = loadTemplate( "items/uses" )

		print( itemUses( { item = item } ) )
	end
%}
