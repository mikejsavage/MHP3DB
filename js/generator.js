onLoad( function()
{
	hide( $( "loading" ) );
} );

var NumSkills = 1

function requestSet()
{
	for( var i = 0; i < NumSkills; i++ )
	{
		var spl = $( "skill" + i ).value.split( " " );

		var skill  = spl[ 0 ];
		var points = spl[ 1 ];

		post( "setGen.lua",
			{ "request" : "{\"blade\" : true, \"skills\" : [ { \"id\" : " + skill + ", \"points\" : " + points + "}]}" },
			function( response )
			{
				$( "result" ).innerHTML = "";

				var sets = JSON.parse( response );

				sets.map( function( set )
				{
					Armors.map( function( type, i )
					{
						$( "result" ).innerHTML += type.pieces[ set.pieces[ i ] - 1 ].name.T() + "<br>";
					} );

					$( "result" ).innerHTML += "<hr>";
				} );
			}
		);
	}
}
