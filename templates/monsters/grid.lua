<table class="grid monsters">
	{%
	local col = 0

	for _, monster in ipairs( Monsters ) do
		if col == 0 then
			print( "<tr>" )
		end

		print( gridCell( { monster = monster } ) )

		col = col + 1

		if col == cols then
			print( "</tr>" )

			col = 0
		end
	end

	if col ~= 0 then
		print( "</tr>" )
	end
	%}
</table>
