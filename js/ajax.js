function post( url, data, callback )
{
	var dataStr = "request=" + JSON.stringify( data );

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
