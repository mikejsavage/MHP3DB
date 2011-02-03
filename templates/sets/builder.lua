{%
local WeaponIcons =
{
	"gs",
	"ls",
	"sns",
	"ds",
	"hm",
	"hh",
	"lc",
	"gl",
	"sa",
	"lbg",
	"hbg",
}

local weaponIcon = WeaponIcons[ math.random( table.getn( WeaponIcons ) ) ]
%}

{( "slow" )}

<script type="text/javascript" src="{{ U( "js/common.js" ) }}"></script>
<script type="text/javascript" src="{{ U( "js/sets.js" ) }}"></script>

<script type="text/javascript">
var Armors = {{ ArmorsJSON }};
var Decorations = {{ DecorationsJSON }};
var Skills = {{ SkillsJSON }};
</script>

<h3>Equipment</h3>


{{ icon( "equipment/" .. weaponIcon ) }}
<select id="wpn" onchange="weaponChanged()">
	<option value="0">No slots</option>
	<option value="1">1 slot</option>
	<option value="2">2 slots</option>
	<option value="3">3 slots</option>
</select>

<div class="slots">
	<select id="wpnslot0" onchange="slotChanged( 'wpn', 0 )"></select>
	<select id="wpnslot1" onchange="slotChanged( 'wpn', 1 )"></select>
	<select id="wpnslot2" onchange="slotChanged( 'wpn', 2 )"></select>
</div>


{%
local Singular =
{
	hlm = "Helmet",
	plt = "Plate",
	arm = "Gloves",
	wst = "Tasset",
	leg = "Greaves",
}

for _, class in ipairs( Armors ) do
	print( icon( "equipment/" .. class.short ) )

	print( ( "<select id=\"%s\" onchange=\"pieceChanged( '%s' )\">" ):format( class.short, class.short ) )

	print( ( "<option value=\"-1\">Any %s</option>" ):format( Singular[ class.short ] ) )
	print( ( "<option value=\"-2\">Any 1 slotted %s</option>" ):format( Singular[ class.short ] ) )
	print( ( "<option value=\"-3\">Any 2 slotted %s</option>" ):format( Singular[ class.short ] ) )
	print( ( "<option value=\"-4\">Any 3 slotted %s</option>" ):format( Singular[ class.short ] ) )

	for i, piece in ipairs( class.pieces ) do
		print( ( "<option value=\"%d\">%s</option>" ):format( i - 1, T( piece.name ) ) )
	end

	print( "</select><div class=\"slots\">" )

	for i = 0, 2 do
		print( ( "<select id=\"%sslot%d\" onchange=\"slotChanged( '%s', %d )\"></select>" ):format( class.short, i, class.short, i ) )
	end

	print( "</div>" )

	print( "</select>" )
end
%}


<label for="decorInfo">
	<input type="checkbox" id="decorInfo" onchange="decorInfoChanged()">
	Informative decoration names
</label>
<br>
<label for="autoCalc">
	<input type="checkbox" id="autoCalc" onchange="autoCalcChanged()" checked>
	Auto-calculate (uncheck if it's too slow)
</label>

<input type="button" id="calcButton" onclick="calc( true )" style="display: none" value="Calculate">


<hr>


Share your set: <a id="setUrl">asdf</a>


<h3>Skills</h3>

<table class="data skills">
	<col class="br">
	<col class="br">
	<colgroup span="7"></colgroup>
	<col class="bl">

	<thead>
		<tr>
			<th>Active Skill</th>
			<th>Skill Tree</th>
			<th>{{ icon( "equipment/" .. weaponIcon ) }}</th>

			{%
			for _, class in ipairs( Armors ) do
				print( ( "<th>%s</th>" ):format( icon( "equipment/" .. class.short ) ) )
			end
			%}

			<th>Total</th>
		</tr>
	</thead>

	<tbody id="skills">
	</tbody>
</table>
