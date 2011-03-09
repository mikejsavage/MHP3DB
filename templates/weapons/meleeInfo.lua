Attack: {{ weapon.attack }}<br>
TATP: {{ getTATP( weapon ) }}<br>

{%
if weapon.notes then
	print( "Notes: " )

	for _, note in ipairs( weapon.notes ) do
		printf( [[<span class="note%s">%s</span> ]], note, Special.note )
	end

	print( "<br>" )
elseif weapon.shellingType then
	printf( "Shelling: %s L%d<br>", weapon.shellingType, weapon.shellingLevel )
elseif weapon.phial then
	printf( "Phial: %s<br>", weapon.phial )
end
%}

{%
if weapon.element then
	printf( [[Element: <span class="elem%s">%d</span><br>]], weapon.element, weapon.elemAttack )
end
%}

Sharpness: {{ weapon.sharpness and sharpness( { weapon = weapon, wide = true } ) or "?" }}<br>

Affinity:
{%
if weapon.affinity ~= 0 then
	printf( [[<span class="%s">%d%%</span>]], weapon.affinity > 0 and "pos" or "neg", weapon.affinity )
else
	printf( "%s%%", weapon.affinity )
end
%}<br>

Slots: {{ weapon.slots == 0 and "none" or ( "O" ):rep( weapon.slots ) }}<br>
Rarity: <span class="rare{{ weapon.rarity }}">{{ weapon.rarity }}</span>
