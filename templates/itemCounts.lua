{%
for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	printf( "%s <b>x%d</b><br>", itemNameURL( { item = item } ), material.count )
end
%}
