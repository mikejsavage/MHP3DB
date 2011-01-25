<table class="grid eq">
{%
local Cols = 3
local col = 0

for _, class in ipairs( weapons ) do
	if col == 0 then
		print( "<tr>" )
	end

	print( gridCell( { class = class } ) )

	col = col + 1

	if col == Cols then
		print( "</tr>" )

		col = 0
	end
end
%}
</table>
