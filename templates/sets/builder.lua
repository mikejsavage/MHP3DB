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

local MaxSlots = 3
%}

{( "slow" )}

{{ js( "common", "builder" ) }}
{{ jsd( "armors", "decorations", "skills", "items", "charms" ) }}

<script type="text/javascript">
var SetUrl = {{ Get.set and ( "%q" ):format( Get.set ) or "false" }};
var BaseUrl = "{{ BaseUrl }}";
var BaseSetUrl = "{{ os.getenv( "SERVER_NAME" ) .. U( "sets" ) }}";
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
local Singulars =
{
	hlm = "Helmet",
	plt = "Plate",
	arm = "Gloves",
	wst = "Tasset",
	leg = "Greaves",
}

for _, class in ipairs( Armors ) do
	print( icon( "equipment/" .. class.short ) )

	printf( [[ <select id="%s" onchange="pieceChanged( '%s' )">]], class.short, class.short )

	local singular = Singulars[ class.short ]

	printf( [[<option value="-1">Any %s</option>]],           singular )
	printf( [[<option value="-2">Any 1 slotted %s</option>]], singular )
	printf( [[<option value="-3">Any 2 slotted %s</option>]], singular )
	printf( [[<option value="-4">Any 3 slotted %s</option>]], singular )

	-- if this is included, selected pieces are reselected on refresh
	-- but it makes the load time so much worse
	--for i, piece in ipairs( class.pieces ) do
	--	printf( [[<option value="%d">%s</option>]], i - 1, T( piece.name ) )
	--end

	print( [[</select><div class="slots">]] )

	for i = 0, 2 do
		printf( [[<select id="%sslot%d" onchange="slotChanged( '%s', %d )"></select>]], class.short, i, class.short, i )
	end

	print( "</div>" )
end
%}


{{ icon( "equipment/tln" ) }}

<select id="tlnskill0" onchange="tlnSkillChanged( 0 )"></select>
<input type="text" id="tlnskill0pts" onblur="tlnPointsChanged( 0 )" class="small" value="0">

<select id="tlnskill1" onchange="tlnSkillChanged( 1 )"></select>
<input type="text" id="tlnskill1pts" onblur="tlnPointsChanged( 1 )" class="small" value="0">

<small id="tlnInvalid" style="display: none">This charm doesn't exist!</small>

<div class="slots">
	<select id="tlnslot0" onchange="slotChanged( 'tln', 0 )"></select>
	<select id="tlnslot1" onchange="slotChanged( 'tln', 1 )"></select>
	<select id="tlnslot2" onchange="slotChanged( 'tln', 2 )"></select>
</div>

<br>


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


Share your set:
<a id="setUrl">http://{{ os.getenv( "SERVER_NAME" ) .. U( "sets" ) }}/<span id="setUrlSpan"></span></a>
<span id="setEmpty">but not quite yet...</span>

<br><small>(I wouldn't actually share it because the link may point to a different set when this page is updated)</small>


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
				printf( "<th>%s</th>", icon( "equipment/" .. class.short ) )
			end
			%}

			<th>{{ icon( "equipment/tln" ) }}</th>

			<th>Total</th>
		</tr>
	</thead>

	<tbody id="skills">
	</tbody>
</table>


<h3>Stats</h3>

Defense: <span id="defense"></span><br>
Fire Res: <span id="fireRes"></span><br>
Water Res: <span id="waterRes"></span><br>
Thunder Res: <span id="thunderRes"></span><br>
Ice Res: <span id="iceRes"></span><br>
Dragon Res: <span id="dragonRes"></span>


<h3>Materials</h3>

<div id="materials"></div>


<h3>Easy Copy pasta</h3>

<textarea id="textOut" rows="10"></textarea>
