onLoad( function()
{
	filterItems();

	$( "name" ).focus();

	hide( $( "loading" ) );
} );

function filterItems()
{
	var filter = $( "name" ).value.toLowerCase();

	if( filter == "" )
	{
		$( "items" ).innerHTML = "";

		return;
	}

	var matches = [ ];
	var numMatches = 0;

	for( var i = 0; i < ItemsCount; i++ )
	{
		var name = Items[ i ].name.toLowerCase();

		var pos = name.indexOf( filter );

		if( pos == -1 )
		{
			continue;
		}

		matches.push( { "id" : i, "pos" : pos } );
		numMatches++;
	}

	if( numMatches == 0 )
	{
		$( "items" ).innerHTML = "No matches.";

		return;
	}

	var filterLen = filter.length;

	var out = "";

	for( var i = 0; i < numMatches; i++ )
	{
		var match = matches[ i ];

		var item = Items[ match.id ];
		var name = item.name;

		out += "<a href='/" + BaseUrl + "items/" + item.url + "'>"
			+ name.substring( 0, match.pos )
			+ "<b>" + name.substring( match.pos, match.pos + filterLen ) + "</b>"
			+ name.substr( match.pos + filterLen )
			+ "</a><br>";
	}

	$( "items" ).innerHTML = out;
}
