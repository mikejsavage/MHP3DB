{%
local itemNameURLAligned = loadTemplate( "itemNameURLAligned" )

for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	printf( "%s <b>%3d%%</b><br>",
		itemNameURLAligned( { item = item } ),
		material.chance
	)
end
%}
