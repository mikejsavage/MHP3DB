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
function setVis( elem, visible )
{
	elem.style.display = visible ? "" : "none";
}

function clearTable( table )
{
	for( var i = table.rows.length; i > 0; i-- )
	{
		table.deleteRow( 0 );
	}
}

// select functions

function clearSelect( select, skip )
{
	skip = skip || 0;

	for( var i = select.options.length; i > skip; i-- )
	{
		select.remove( skip );
	}
}

function selectHTML( select )
{
	return select.options[ select.selectedIndex ].innerHTML;
}

function pushSelect( select, option )
{
	select.options[ select.length ] = option;
}

function selectWithValue( select, value )
{
	for( var i = 0, m = select.length; i < m; i++ )
	{
		if( select.options[ i ].value == value )
		{
			select.selectedIndex = i;

			break;
		}
	}
}

// prototypes

// TODO...
Object.prototype.T = function()
{
	return this.hgg;
};

String.prototype.urlEscape = function()
{
	return this.replace( /'/g, "" ).replace( / /g, "_" );
};

String.prototype.startsWith = function( str, len )
{
	return this.substr( 0, len ) == str;
};

// i can't take credit for this
// http://stackoverflow.com/questions/202605/repeat-string-javascript/202627#202627
String.prototype.repeat = function( num )
{
	return new Array( num + 1 ).join( this );
};

// yes i know this isn't really "map" but map is a short word
// word of warning: this function causes HORRIBLE
// FUCKING STUPID problems if you try to return
// from the calling function inside it
Object.prototype.map = function( func )
{
	for( var key in this )
	{
		if( this.hasOwnProperty( key ) )
		{
			func( this[ key ], key );
		}
	}
};

Object.prototype.objIdxOf = function( property, needle )
{
	for( var key in this )
	{
		if( this.hasOwnProperty( key ) && this[ key ][ property ] == needle )
		{
			return key;
		}
	}

	return null;
};

// fast map for arrays
Array.prototype.map = function( func )
{
	for( var i = 0, m = this.length; i < m; i++ )
	{
		func( this[ i ], i );
	}
};

// reverse map
Array.prototype.rmap = function( func )
{
	for( var i = this.length - 1; i >= 0; i-- )
	{
		func( this[ i ], i );
	}
};

// cookies

function setCookie( name, value, expireDays )
{
	var expires = new Date();
	expires.setDate( expires.getDate() + expireDays * 86400 ); // 86400 seconds in a day

	document.cookie = name + "=" + value + "; expires=" + expires.toUTCString() + ";  path=/";
}

function getCookie( name )
{
	var nameEq = name + "=";
	var len = nameEq.length;

	var split = document.cookie.split( "; " );

	for( var i = 0, m = split.length; i < m; i++ )
	{
		var cookie = split[ i ];

		if( cookie.startsWith( nameEq, len ) )
		{
			return cookie.substr( len );
		}
	}

	return null;
}
