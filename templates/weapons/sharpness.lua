<div class="sharpness{%
if wide then
	print( " wide" )
end
%}">{%
	for i, sharp in ipairs( sharpness ) do
		print( ( [[<div class="sharp%d" style="width: %dpx">&nbsp;</div>]] ):format( i, wide and sharp * 2 * SharpWidth or sharp * SharpWidth ) )
	end
%}</div>
