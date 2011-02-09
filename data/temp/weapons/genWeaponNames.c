#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *contents( char *filename, int *len )
{
        FILE *file = fopen( filename, "r" );

        if( file == NULL )
        {
                return "";
        }

        fseek( file, 0, SEEK_END );
        *len = ftell( file );

        fseek( file, 0, SEEK_SET );

        char *contents = malloc( *len * sizeof( char ) + 1 );
        fread( contents, *len, 1, file );

        contents[ *len ] = '\0';

        fclose( file );

        return contents;
}

char *memnchr( char *haystack, char needle, int len )
{
	for( int i = 0; i < len; i++ )
	{
		if( haystack[ i ] == needle )
		{
			return haystack + i + 1;
		}
	}

	return NULL;
}

int main()
{
	int len;
	char *data = contents( "./weapons.bin", &len );

	// get rid of the damn \n vim insists on adding...
	data[ len - 1 ] = '\0';

	char *currName = data;

	while( 1 )
	{
		// want \n after the last name too to
		// make loading the list easier
		printf( "%s\n", currName );

		char *nextName = memnchr( currName, '\0', len );

		if( *nextName == NULL )
		{
			break;
		}

		currName = nextName;
	}

	return EXIT_SUCCESS;
}
