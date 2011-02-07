onLoad( function()
{
	hide( $( "loading" ) );
} );

var NumSkills = 1

function addSkill()
{
	var sel = document.createElement( "select" );

	sel.id = "skill" + NumSkills;

	// sobad
	$( "skill0" ).options.map( function( option, i )
	{
		sel.options[ sel.options.length ] = new Option( option.text, option.value );
	} );

	$( "selects" ).appendChild( sel );

	NumSkills++;
}

function printSets( response )
{
	var sets = JSON.parse( response );
	var len = sets.length;

	if( len == 0 )
	{
		$( "result" ).innerHTML = "No sets have the skills you requested, sorry!";
	}
	else
	{
		var output = "";

		for( var i = 0; i < len; i++ )
		{
			var set = sets[ i ];

			output += "<div class='set'>";

			Armors.map( function( type, i )
			{
				output += type.pieces[ set.pieces[ i ] - 1 ].name.T() + "<br>";
			} );

			output += "</div>";
		}

		$( "result" ).innerHTML = output;
	}
}

function requestSet()
{
	var skills = [ ];
	var fixed  = { };

	for( var i = 0; i < NumSkills; i++ )
	{
		var spl = $( "skill" + i ).value.split( " " );

		var id     = parseInt( spl[ 0 ] );
		var points = parseInt( spl[ 1 ] );

		skills.push( { "id" : id, "points" : points } );
	}

	$( "result" ).innerHTML = "";

	post(
		"setGen.lua",
		{
			"type" : $( "bg" ).selectedIndex == 0 ? "blade" : "gunner",
			"skills" : skills,
			"fixed" : fixed
		},
		printSets
	);
}
