// I set elem.style and not elem.className in this
// because setting elem.className is horrendously
// slow in FF...

// this can still definitely be sped up by precomputing $( "wpn..." )
// and with a smarter algorithm if needs be

function markWpn( elem )
{
	elem.style.backgroundColor = "#222";
	elem.style.color = "#fff";
	elem.style.fontWeight = "bold";
}

function markPath( path )
{
	path.map( function( weaponId )
	{
		markWpn( $( "wpn" + weaponId ) );
	} );
}

function dimWpn( elem )
{
	elem.style.backgroundColor =
		elem.style.color =
		elem.style.fontWeight = "";
}

function dimPath( path )
{
	path.map( function( weaponId )
	{
		dimWpn( $( "wpn" + weaponId ) );
	} );
}
