/* useless example:

bench(
	function( a )
	{
		for( var i = 0; i < a; i++ );
	},
	function( a )
	{
		for( var i = a; i > 0; i-- );
	},
	[ 100 ],
	1000,
	alert
);
*/

function bench( f1, f2, params, iterations, callback )
{
	var startTime1 = new Date().getTime();

	for( var i = 0; i < iterations; i++ )
	{
		f1.apply( null, params );
	}

	var endTime1 = new Date().getTime();

	for( var i = 0; i < iterations; i++ )
	{
		f2.apply( null, params );
	}

	var endTime2 = new Date().getTime();

	callback(
		"f1 took " + ( endTime1 - startTime1 ) + "ms\n" +
		"f2 took " + ( endTime2 - endTime1 ) + "ms"
	);
}
