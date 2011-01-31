<div class="sharpness">{%
	for i, sharp in ipairs( sharpness ) do
		print( ( "<div class='sharp%d' style='width: %dpx'>&nbsp;</div>" ):format( i, sharp * SharpWidth ) )
	end
%}</div>
