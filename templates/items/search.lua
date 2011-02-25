{( "slow" )}

{%
-- i think it's simpler to not cache this due to translations

local sortedItemNames = { }
local itemsCount = 0

for _, item in ipairs( Items ) do
	table.insert( sortedItemNames, {
		name = T( item.name ),
		url = urlFromName( item.name )
	} )

	itemsCount = itemsCount + 1
end

table.sort( sortedItemNames, function( a, b )
	return a.name < b.name
end )
%}

<script type="text/javascript">
var Items = {{ json.encode( sortedItemNames ) }};
var ItemsCount = {{ itemsCount }};

var BaseUrl = "{{ BaseUrl }}";
</script>

{{ js( "common", "items" ) }}

Search items: <input type="text" id="name" onkeyup="filterItems()">

<div id="items"></div>
