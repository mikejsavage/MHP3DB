<table class="grid eq {{ class }}">
	{%
	local col = 0

	for _, class in ipairs( classes ) do
		if col == 0 then
			print( "<tr>" )
		end

		print( gridCell( { class = class, page = page } ) )

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
