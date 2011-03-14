// this doesn't depend on common.js so we need to define onLoad

function onLoad( func )
{
	if( window.addEventListener )
	{
		window.addEventListener( "load", func, false );
	}
	else if( window.attachEvent )
	{
		window.attachEvent( "onload", func );
	}
	else
	{
		alert( "onLoad failed to add event. You probably need to upgrade your browser." )
	}
}

function defer()
{
	var scripts = arguments;

	onLoad( function()
	{
		for( var i = 0, m = scripts.length; i < m; i++ )
		{
			var elem = document.createElement( "script" );

			elem.src = scripts[ i ];

			document.body.appendChild( elem );
		}
	} );
}
