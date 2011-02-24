{( "slow" )}

<script type="text/javascript">
var Items = [{%
local key, item = next( Items, nil )

while true do
	local newKey, newItem = next( Items, key )

	print( ( "%q" ):format( T( item.name ) ) )

	if newKey then
		print( "," )
	else
		break
	end

	key = newKey
	item = newItem
end
%}];
var ItemsCount = {{ table.getn( Items ) }};

var BaseUrl = "{{ BaseUrl }}";
</script>

<script type="text/javascript" src="{{ C( "js/common.js" ) }}"></script>
<script type="text/javascript" src="{{ C( "js/items.js" ) }}"></script>

Search items: <input type="text" id="name" onkeyup="filterItems()">

<div id="items"></div>
