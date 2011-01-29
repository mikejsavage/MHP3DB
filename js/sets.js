// constants

var Classes = [ "wpn", "hlm", "plt", "arm", "wst", "leg"/*, "tln"*/ ];
var MaxSlots = 3;
var MaxTalismanSkills = 2;
var Elements =
{
	"fire" : "Fire",
	"water" : "Water",
	"thunder" : "Thunder",
	"ice" : "Ice",
	"dragon" : "Dragon"
};
var NoSkill = "--"; // = "gunners";

// globals

var Ready = false;
var AutoCalc = getCookie( "setAutoCalc" );

var EatenSlots = [ ];

var Blade = true;
var Gunner = true;

// init

onLoad( function()
{
	// initialize EatenSlots array and setup UI
	Classes.map( function( type )
	{
		EatenSlots[ type ] = [ ];

		for( var slot = 0; slot < MaxSlots; slot++ )
		{
			EatenSlots[ type ][ slot ] = [ ];
		}

		if( type == "tln" )
		{
			talismanChanged();
		}
		else
		{
			pieceChanged( type );
		}
	} );



	$( "autoCalc" ).checked = AutoCalc == "1" || AutoCalc === null; // default to on

	autoCalcChanged();


	// we are done loading
	hide( $( "loading" ) );

	Ready = true;

	calc( true );
} );

// skill sorting func
function sortByPoints( a, b )
{
	var activeA = a.name != "--";
	var activeB = b.name != "--";

	// could be neater but this has fewer branches
	if( activeA )
	{
		if( activeB )
		{
			return b.points - a.points;
		}
		else
		{
			return -1;
		}
	}
	else
	{
		if( activeB )
		{
			return 1;
		}
		else
		{
			return b.points - a.points;
		}
	}

	// this is unreachable
}

function activatedSkill( skill, points )
{
	var bounds = Skills[ skill.id ];

	if( bounds == null )
	{
		return NoSkill;
	}

	// :)
	bounds = bounds.bounds;

	if( points > 0 )
	{
		bounds.map( function( bound )
		{
			if( bound.points < 0 )
			{
				return NoSkill;
			}

			if( points >= bound.points )
			{
				return bound.name.T();
			}
		} );
	}
	else
	{
		bounds.rmap( function( bound )
		{
			if( bound.points > 0 )
			{
				return NoSkill;
			}

			if( points <= bound.points )
			{
				return bound.name.T();
			}
		} );
	}
}

function classFromShort( short )
{
	for( var i = 0, m = Armors.length; i < m; i++ )
	{
		var class = Armors[ i ];

		if( class.short == short )
		{
			return class;
		}
	}

	alert( "classFromShort: " + short );
}

function decorationInfo( decoration )
{
	// first skill is always main
	// TODO: are there decorations with multiple +ve skills?
	var skill = decoration.skills[ 0 ];

	return Skills[ skill.id ].name.T() + " +" + skill.points +
		( decoration.slots == 0 ? "" : " " + "O".repeat( decoration.slots ) );

}

// slot functions

function numSlots( short )
{
	// get value of select
	var idx = parseInt( $( short ).value );

	// for weapons, value = slots
	if( short == "wpn" )
	{
		return parseInt( idx );
	}

	if( short == "tln" )
	{
		// TODO
		return 0;
	}

	// for "x slotted y", value = -( slots + 1 )
	if( idx < 0 )
	{
		return -( parseInt( idx ) + 1 )
	}

	var class = classFromShort( short );

	return class.pieces[ idx ].slots;
}

function showSlots( short )
{
	var slots = numSlots( short );

	//var decorInfo = $( "decorInfo" ).checked;
	var decorInfo = !false;

	var shortSlot = short + "slot"; // save some concats

	for( var i = 0; i < slots; i++ )
	{
		var selSlot = $( shortSlot + i );

		clearSelect( selSlot );

		selSlot.disabled = false;
		show( selSlot );

		selSlot.options[ 0 ] = new Option( "No decoration" );

		Decorations.map( function( decoration, j )
		{
			if( decoration.slots <= slots )
			{
				pushSelect( selSlot, new Option(
					decorInfo ?
						decorationInfo( decoration ) :
						decoration.name.T(),
					j
				) );
			}
		} );
	}

	for( var i = slots; i < MaxSlots; i++ )
	{
		var selSlot = $( shortSlot + i );

		selSlot.disabled = true;
		hide( selSlot );
	}
}

function canEat( selSlot )
{
	return !selSlot.disabled && selSlot.selectedIndex == 0;
}

// selSlot is $( type + "slot" + idx )
// but we did this in eatASlot so let's just speed things up a tad
function eatSlot( short, parent, selSlot, idx, decorIdx )
{
	selSlot.disabled = true;
	clearSelect( selSlot );

	selSlot.options[ 0 ] = new Option( selectHTML( $( short + "slot" + parent ) ), decorIdx );

	EatenSlots[ short ][ parent ].push( idx );
}

function eatASlot( short, parent, decorIdx )
{
	for( var i = 0; i < MaxSlots; i++ )
	{
		if( i == parent )
		{
			continue;
		}

		var selSlot = $( short + "slot" + i );

		if( canEat( selSlot ) )
		{
			eatSlot( short, parent, selSlot, i, decorIdx );

			break;
		}
	}
}

function freeSlots( short, parent )
{
	EatenSlots[ short ][ parent ].map( function( eaten )
	{
		var selSlot = $( short + "slot" + eaten );

		selSlot.disabled = false;

		clearSelect( selSlot );
		selSlot.options[ 0 ] = new Option( "No Decoration" );

		selSlot.selectedIndex = 0;
	} );

	EatenSlots[ short ][ parent ] = [ ];
}

function refreshSlots( short )
{
}

// onChange callbacks

function decorInfoChanged()
{
	Classes.map( function( short )
	{
		refreshSlots( short );
	} );
}

function autoCalcChanged()
{
	AutoCalc = $( "autoCalc" ).checked;

	setVis( $( "calcButton" ), !AutoCalc );

	setCookie( "setAutoCalc", AutoCalc ? "1" : "0", 9001 );

	if( AutoCalc )
	{
		calc();
	}
}

function pieceChanged( short )
{
	showSlots( short );

	calc();
}

function weaponChanged()
{
	showSlots( "wpn" );

	calc();
}

function slotChanged( short, slot )
{
	freeSlots( short, slot );

	var shortSlot = short + "slot";

	var selSlot = $( shortSlot + slot );

	if( selSlot.selectedIndex != 0 )
	{
		var decorIdx = selSlot.value;
		var decoration = Decorations[ decorIdx ];

		// do nothing if it's a 1 slot decoration
		for( var i = 1; i < decoration.slots; i++ )
		{
			eatASlot( short, slot, decorIdx );
		}
	}

	calc();
}

function calc( force )
{
	// nested functions are horrid but it has to be done

	function addSkills( short, skills )
	{
		if( skills == null )
		{
			return;
		}

		skills.map( function( skill )
		{
			// corrects lua arrays being 0 based
			var id = skill.id - 1;

			var copy = Skills[ id ].copy;

			if( copy != null )
			{
				pieces[ type ] = pieces[ copy ];

				return;
			}

			var skillIdx = pieces[ short ].objIdxOf( "id", id );

			if( skillIdx == null )
			{
				pieces[ short ].push( { "id" : id, "points" : skill.points } );
			}
			else
			{
				pieces[ short ][ skillIdx ].points += skill.points;
			}
		} );
	}

	function addDecorationSkills( short )
	{
		for( var i = 0, m = numSlots( short ); i < m; i++ )
		{
			var selSlot = $( short + "slot" + i );

			if( !selSlot.disabled && selSlot.selectedIndex != 0 )
			{
				addSkills( short, Decorations[ selSlot.value ].skills );
			}
		}
	}

	function skillTotals()
	{
		var result = [ ];

		pieces.map( function( piece, short )
		{
			piece.map( function( skill )
			{
				var idx = result.objIdxOf( "id", skill.id );

				if( idx == null )
				{
					idx = result.push(
					{
						"id" : skill.id,
						"points" : skill.points,
						"classes" : { }
					} ) - 1;
				}
				else
				{
					result[ idx ].points += skill.points;
				}

				result[ idx ].classes[ short ] = skill.points;
			} );
		} );

		result.map( function( skill )
		{
			skill.name = activatedSkill( skill.id, skill.points );
		} );

		return result;
	}



	// if we're not ready then do nothing
	// if autocalc is off and it wasn't forced then do nothing
	if( !Ready || ( !force && !AutoCalc ) )
	{
		return;
	}

	var pieces = { };

	var materials = [ ];
	var price = 0;

	var defense = 0;
	var resistances = { };

	// init resistances
	Elements.map( function( elem )
	{
		resistances[ elem ] = 0;
	} );

	// init types and add decoration info
	Classes.map( function( short )
	{
		pieces[ short ] = [ ];

		addDecorationSkills( short );
	} );

	Armors.map( function( class )
	{
		var idx = $( class.short ).value;

		// values < 0 are for "no x" or "y slotted x"
		if( idx >= 0 )
		{
			var piece = class.pieces[ idx ];

			addSkills( class.short, piece.skills );
		}
	} );

	var result = skillTotals().sort( sortByPoints );

	var skillTable = $( "skills" );
	clearTable( skillTable );

	var numSkills = result.length;

	if( numSkills == 0 )
	{
		var row  = skillTable.insertRow( 0 );
		var cell = row.insertCell( 0 );

		cell.colSpan = "10";
		cell.innerHTML = "You have no skills. Are you a gunner?";
	}
	else
	{
		for( var i = 0; i < numSkills; i++ )
		{
			var skill = result[ i ];

			if( skill.points == 0 )
			{
				continue;
			}

			var row = skillTable.insertRow( skillTable.rows.length );

			var name = row.insertCell( 0 );
			name.innerHTML = skill.name;

			if( skill.points < 0 && skill.name != NoSkill )
			{
				name.className = "neg";
			}

			row.insertCell( 1 ).innerHTML = Skills[ skill.id ].name.T();

			Classes.map( function( short, j )
			{
				var classPoints = skill.classes[ short ];

				row.insertCell( j + 2 ).innerHTML =
					classPoints == 0 || classPoints == null ? "" : classPoints;
			} );

			row.insertCell( 8 ).innerHTML = skill.points;
		}
	}
}
