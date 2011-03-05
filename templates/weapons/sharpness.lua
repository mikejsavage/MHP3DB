<div class="sharpness{%
if wide then
	print( " wide" )
end
%}">{%
	for i, sharp in ipairs( weapon.sharpness ) do
		printf( [[<div class="sharp%d" style="width: %dpx">&nbsp;</div>]], i, wide and sharp * 2 * SharpWidth or sharp * SharpWidth )
	end

	if weapon.sharpnessp then
		print( [[<div class="p">]] )

		for i, sharp in ipairs( weapon.sharpnessp ) do
			if not weapon.sharpness[ i ] or sharp > weapon.sharpness[ i ] then
				local width = sharp - ( weapon.sharpness[ i ] or 0 )

				printf( [[<div class="sharp%d" style="width: %dpx">&nbsp;</div>]], i, wide and width * 2 * SharpWidth or width * SharpWidth )
			end
		end

		print( "</div>" )
	end
%}</div>
