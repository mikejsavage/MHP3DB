{( "slow" )}

<script type="text/javascript" src="{{ U( "js/common.js" ) }}"></script>
<script type="text/javascript" src="{{ U( "js/ajax.js" ) }}"></script>
<script type="text/javascript" src="{{ U( "js/generator.js" ) }}"></script>

<script type="text/javascript">
var Armors = {{ ArmorsJSON }};
var Decorations = {{ DecorationsJSON }};
var Skills = {{ SkillsJSON }};

var SetUrl = {{ Get.set and ( "%q" ):format( Get.set ) or "false" }};
var BaseUrl = "{{ BaseUrl }}";
</script>

<h3>I want...</h3>

A <select id="bg"><option>blademaster</option><option>gunner</option></select> set with

<div id="skills">
	<select id="skill0">
		{%
		for skillId, skill in ipairs( Skills ) do
			if skill.bounds then
				for _, bound in ipairs( skill.bounds ) do
					print( ( "<option value='%d %d'>%s</option>" ):format( skillId, bound.points, T( bound.name ) ) )
				end
			end
		end
		%}
	</select>

	<br>
	<a href="JavaScript: addSkill()">Add another</a>
</div>

<a href="JavaScript: requestSet()">{{ math.random( 2 ) == 1 and "and I want it now" or "Do you have one in stock?" }}</a>


<div id="result"></div>
