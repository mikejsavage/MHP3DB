<h1>{{ itemName( { item = item } ) }}</h1>

ID: {{ item.id }} (0x{{ ( "%04x" ):format( item.id ):upper() }})<br>
{% --Rarity: <span class="rare{{ item.rarity }}">{{ item.rarity }}</span> %}
