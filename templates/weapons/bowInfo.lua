{%
local BowCoatings =
{
	{
		short =	"power",
		color = "red",
	},
	{
		short =	"razor",
		color = "white",
	},
	{
		short =	"poison",
		color = "purple",
	},
	{
		short =	"paralyze",
		color = "yellow",
	},
	{
		short =	"sleep",
		color = "cyan",
	},
	--[[
	-- everything shoots paint
	{
		short =	"paint",
		color = "pink",
	},]]
	{
		short = "fatigue",
		color = "blue",
	},
}
%}

Attack: {{ weapon.attack }}<br>
TATP: {{ getTATP( weapon ) }}<br>

Rain: {{ weapon.rain }}<br>

<table class="charges">
	<tr>
		<td>Charges:</td>
		<td>{%
			for _, charge in ipairs( weapon.charges ) do
				printf( charge.load and [[<div class="load">%-7s Lv%d</div>]] or "%-7s Lv%d<br>", charge.type, charge.level )
			end
		%}</td>
	</tr>
</table>

Coatings: {%
	for _, coating in ipairs( BowCoatings ) do
		if weapon.coatings[ coating.short ] then
			print( icon( "items/coating", weapon.coatings[ coating.short ] and coating.color or "gray" ) )
		else
			--print( icon( "items/bottle", "gray" ) )
		end
	end
%}<br>

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
