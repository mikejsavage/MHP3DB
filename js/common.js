function onLoad( func )
{
	if( window.addEventListener )
	{
		window.addEventListener( "load", func, false );
	}
	else if( window.attachEvent )
	{
		window.attachEvent( "onload", func )
	}
	else
	{
		alert( "onLoad failed to add event. You probably need to upgrade your browser." )
	}
}

// jquery
function $( id )
{
	return document.getElementById( id );
}

function show( elem )
{
	elem.style.display = "";
}
function hide( elem )
{
	elem.style.display = "none";
}

String.prototype.urlEscape = function()
{
	return this.replace( /'/g, "" ).replace( / /g, "_" );
}
