{%
local itemNameURLAligned = loadTemplate( "itemNameURLAligned" )

for _, material in ipairs( materials ) do
	local item = Items[ material.id - 1 ]

	printf( "%s <strong>%3d%%</strong><br>",
		itemNameURLAligned( { item = item } ),
		material.chance
	)
end
%}
