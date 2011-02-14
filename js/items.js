onLoad( function()
{
	filterItems();

	$( "name" ).focus();

	hide( $( "loading" ) );
} );

function sortByName( a, b )
{
	return Items[ a.id ].localeCompare( Items[ b.id ] );
}

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
		var name = Items[ i ].toLowerCase();

		var pos = name.indexOf( filter );

		if( pos == -1 )
		{
			continue;
		}

		matches.push( { "name" : name, "id" : i, "pos" : pos } );
		numMatches++;
	}

	if( numMatches == 0 )
	{
		$( "items" ).innerHTML = "No matches.";

		return;
	}

	// sort on load to save doing this?
	matches.sort( sortByName );

	var filterLen = filter.length;

	var out = "";

	for( var i = 0; i < numMatches; i++ )
	{
		var match = matches[ i ];

		var name = Items[ match.id ];

		out += "<a href='/" + BaseUrl + "items/" + name.urlEscape() + "'>"
			+ name.substring( 0, match.pos )
			+ "<strong>" + name.substring( match.pos, match.pos + filterLen ) + "</strong>"
			+ name.substr( match.pos + filterLen )
			+ "</a><br>";
	}

	$( "items" ).innerHTML = out;
}
