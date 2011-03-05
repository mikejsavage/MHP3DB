{%
for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	printf( "%s <strong>x%d</strong><br>", itemNameURL( { item = item } ), material.count )
end
%}
