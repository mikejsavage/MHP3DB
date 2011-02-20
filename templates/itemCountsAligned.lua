{%
local itemNameURLAligned = loadTemplate( "itemNameURLAligned" )

for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	print( ( "%s <strong>%3s</strong><br>" ):format(
		itemNameURLAligned( { item = item } ),
		"x" .. material.count
	) )
end
%}