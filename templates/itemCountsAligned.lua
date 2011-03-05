{%
local itemNameURLAligned = loadTemplate( "itemNameURLAligned" )

for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	printf( "%s <strong>%3s</strong><br>",
		itemNameURLAligned( { item = item } ),
		"x" .. material.count
	)
end
%}
