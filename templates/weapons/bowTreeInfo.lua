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

local CoatingsPerRow = 3
%}

<td>{{ ( "&nbsp;&nbsp;&nbsp;" ):rep( depth ) }}<a class="rare{{ weapon.rarity }}{{ weapon.create and " create" or "" }}" href="{{ U( ( "weapons/%s/%s" ):format( class.short, urlFromName( weapon.name ) ) ) }}">{{ T( weapon.name ) }}</a></td>
<td>{{ weapon.attack }}</td>
<td>{{ getTATP( weapon ) }}</td> 
<td>{{ weapon.rain }}</td>
{{ weapon.element and ( [[<td class="elem%s">%d]] ):format( weapon.element, weapon.elemAttack ) or [[<td class="none">-]] }}</td>
<td{{ weapon.affinity ~= 0 and ( ( [[ class="%s"]] ):format( weapon.affinity > 0 and "pos" or "neg" ) ) or ""}}>{{ weapon.affinity }}%</td>

<td class="charges">{%
	for _, charge in ipairs( weapon.charges ) do
		printf( charge.load and [[<div class="load">%-7s Lv%d</div>]] or "%-7s Lv%d\n", charge.type, charge.level )
	end
%}</td>

<td>{%
	for i, coating in ipairs( BowCoatings ) do
		if weapon.coatings[ coating.short ] then
			print( icon( "items/coating", weapon.coatings[ coating.short ] and coating.color or "gray" ) )
		else
			print( icon( "items/bottle", "gray" ) )
		end

		if i == CoatingsPerRow then
			print( "<br>" )
		end
	end
%}</td>

<td{{ weapon.slots == 0 and [[ class="none">-]] or ">" .. ( "O" ):rep( weapon.slots ) }}</td>
