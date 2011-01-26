{%
for _, material in ipairs( materials ) do
	local item = Items[ material.id ]

	print( ( "%s <strong>x%d</strong><br>" ):format( itemNameURL( { item = item } ), material.count ) )
end
%}
