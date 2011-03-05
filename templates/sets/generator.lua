{( "slow" )}

{{ js( "common", "ajax", "generator" ) }}
{{ jsd( "armors", "decorations", "skills" ) }}

<script type="text/javascript">
var SetUrl = {{ Get.set and ( "%q" ):format( Get.set ) or "false" }};
var BaseUrl = "{{ BaseUrl }}";
</script>

<h3>I want...</h3>

A <select id="bg"><option>blademaster</option><option>gunner</option></select> set with:

<div class="wanted">
	<div id="selects">
		<select id="skill0">
			{%
			for skillId, skill in ipairs( Skills ) do
				if skill.bounds then
					for _, bound in ipairs( skill.bounds ) do
						printf( "<option value='%d %d'>%s</option>", skillId, bound.points, T( bound.name ) )
					end
				end
			end
			%}
		</select>
	</div>
	
	<div class="button" onclick="addSkill()">{{ Special.plus }} Add another</div>
</div>

<input type="button" onclick="requestSet()" value="cheers">


<div id="result"></div>
