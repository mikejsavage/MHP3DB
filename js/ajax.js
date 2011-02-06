function ajaxPost( url, data, callback )
{
	var dataStr = "";

	data.map( function( key, val )
	{
		dataStr += "&" + key;

		if( val != null )
		{
			dataStr += "=" + val;
		}
	} );

	dataStr = dataStr.substr( 1 );


        var request = new XMLHttpRequest();

        if( callback != null )
        {
                request.onreadystatechange = function()
                {
                        if( request.readyState == 4 && request.status == 200 )
                        {
                                callback( request.responseText );
                        }
                };
        }

        request.open( "POST", url, true );

        request.setRequestHeader( "Content-type", "application/x-www-form-urlencoded" );
        request.setRequestHeader( "Content-length", dataStr.length );
        request.setRequestHeader( "Connection", "close" );

        request.send( dataStr );
}
