{%
for id, count in pairs( materials ) do
	local item = Items[ id ]

	print( ( "%s <b>x%d</b><br>" ):format( itemNameURL( { item = item } ), count ) )
end
%}
