{%
for id, count in pairs( materials ) do
	local item = Items[ id ]

	print( ( "%s <strong>x%d</strong><br>" ):format( itemNameURL( { item = item } ), count ) )
end
%}
