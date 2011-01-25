{%
for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	print( ( "%s <strong>x%d</strong><br>" ):format( itemName( { item = item } ), material.count ) )
end
%}
