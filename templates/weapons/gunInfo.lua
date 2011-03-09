{%
local ShotMaxLevel = 3
%}

Attack: {{ weapon.attack }}<br>
Reload: {{ weapon.reload }}<br>
Drift: {{ weapon.drift }}<br>
Recoil: {{ weapon.recoil }}<br>

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


<h2>Shots</h2>

	<table class="data shots">
		<thead>
			<tr>
				<th>Shot</th>
				<th>Lv1</th>
				<th>Lv2</th>
				<th>Lv3</th>
			</tr>
		</thead>

		<tbody>
			{%
			for i, shot in ipairs( Shots ) do
				printf( "<tr><td>%s</td>", T( shot.name ) )

				for _, level in ipairs( weapon.shots[ i ] ) do
					printf( "<td>%s</td>", level.clip == 0 and "-" or level.clip )
				end

				for j = shot.levels, ShotMaxLevel - 1 do
					print( "<td>&nbsp;</td>" )
				end

				print( "</tr>" )
			end
			%}
		</tbody>
	</table>
