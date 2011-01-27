// http://zarb.org/~gc/html/libpng.html

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PNG_DEBUG 3
#include <png.h>

#define DEF_ICON  "items/garbage.png"
#define DEF_COLOR "ffffff"

typedef enum { false, true } bool;

enum
{
	R = 0,
	G,
	B,
	A
} PixelIndices;

void loadPng( char* path, png_structp *outPng, png_infop *outInfo, png_bytep **outRows,
		int *outWidth, int *outHeight, png_byte *outDepth, png_byte *outColorType )
{
	FILE *file = fopen( path, "rb" );

	if( file == NULL )
	{
		// oh
		exit( 1 );
	}

	char header[ 8 ];
	fread( header, 1, 8, file );

	if( png_sig_cmp( header, 0, 8 ) )
	{
		// not a png
		exit( 1 );
	}

	png_structp png = png_create_read_struct( PNG_LIBPNG_VER_STRING, NULL, NULL, NULL );

	if( png == NULL )
	{
		// fail
		exit( 1 );
	}

	png_infop info = png_create_info_struct( png );

	if( info == NULL )
	{
		// fail
		exit( 1 );
	}

	if( setjmp( png_jmpbuf( png ) ) ) // i don't understand this
	{
		exit( 1 );
	}

	png_init_io( png, file );
	png_set_sig_bytes( png, 8 );

	png_read_info( png, info );

	int width  = png_get_image_width( png, info );
	int height = png_get_image_height( png, info );

	png_byte depth = png_get_bit_depth( png, info );
	png_byte colorType = png_get_color_type( png, info );

	int numPasses = png_set_interlace_handling( png );

	png_read_update_info( png, info );

	if( setjmp( png_jmpbuf( png ) ) ) // i don't understand this
	{
		exit( 1 );
	}

	png_bytep *rows = malloc( sizeof( png_bytep ) * height );

	int rowBytes = png_get_rowbytes( png, info );

	for( int y = 0; y < height; y++ )
	{
		rows[ y ] = malloc( rowBytes );
	}

	png_read_image( png, rows );

	fclose( file );


	*outPng = png;
	*outInfo = info;
	*outRows = rows;
	*outWidth = width;
	*outHeight = height;
	*outDepth = depth;
	*outColorType = colorType;
}


void printPng( png_bytep *rows, int width, int height, png_byte depth, png_byte colorType )
{
	png_structp png = png_create_write_struct( PNG_LIBPNG_VER_STRING, NULL, NULL, NULL );

	if( png == NULL )
	{
		// fail
		exit( 1 );
	}

	png_infop info = png_create_info_struct( png );

	if( info == NULL )
	{
		// fail
		exit( 1 );
	}

	if( setjmp( png_jmpbuf( png ) ) )
	{
		exit( 1 );
	}

	png_init_io( png, stdout );

	if( setjmp( png_jmpbuf( png ) ) )
	{
		exit( 1 );
	}

	png_set_IHDR( png, info, width, height, depth, colorType,
			PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE );

	png_write_info( png, info );

	if( setjmp( png_jmpbuf( png ) ) )
	{
		exit( 1 );
	}

	png_write_image( png, rows );

	if( setjmp( png_jmpbuf( png ) ) )
	{
		exit( 1 );
	}

	png_write_end( png, NULL );
}

unsigned int htou( char *str )
{
	return strtoul( str, NULL, 16 );
}

int main()
{
	char *get = getenv( "QUERY_STRING" );

	if( get == NULL )
	{
		exit( 1 );
	}

	// this is a bit messy but it extracts "icon" and "color"
	// from GET, with a default value for both and it doesn't
	// matter which comes first

	char *icon = strstr( get, "icon=" );
	bool checkIcon;

	if( icon == NULL )
	{
		icon = DEF_ICON;

		checkIcon = false;
	}
	else
	{
		icon += strlen( "icon=" );

		checkIcon = true;
	}

	char *color = strstr( get, "color=" );
	bool checkColor;

	if( color == NULL )
	{
		color = DEF_COLOR;

		checkColor = false;
	}
	else
	{
		color += strlen( "color=" );

		checkColor = true;
	}

	if( checkIcon )
	{
		char *c = strchr( icon, '&' );

		if( c != NULL )
		{
			*c = '\0';
		}
	}

	if( checkColor )
	{
		char *c = strchr( color, '&' );

		if( c != NULL )
		{
			*c = '\0';
		}
	}

	// 7 so it doesn't look like a proper string
	// if somebody tries to gank my server
	if( strnlen( color, 7 ) != 6 )
	{
		exit( 1 );
	}

	// i know this sucks a bit...
	char r[] = { color[ 0 ], color[ 1 ], '\0' };
	char g[] = { color[ 2 ], color[ 3 ], '\0' };
	char b[] = { color[ 4 ], color[ 5 ], '\0' };

	float redScale = htou( r ) / 255.0f;
	float blueScale = htou( b ) / 255.0f;
	float greenScale = htou( g ) / 255.0f;

	png_structp png;
	png_infop info;
	png_bytep *rows;
	int width, height;
	png_byte depth, colorType;

	loadPng( icon, &png, &info, &rows, &width, &height, &depth, &colorType ); // &kitchenSink

	for( int y = 0; y < height; y++ )
	{
		png_byte *row = rows[ y ];

		for( int x = 0; x < width; x++ )
		{
			png_byte *pixel = &row[ x * 4 ];

			if( pixel[ A ] != 0 )
			{
				pixel[ R ] *= redScale;
				pixel[ B ] *= blueScale;
				pixel[ G ] *= greenScale;
			}
		}
	}

	printPng( rows, width, height, depth, colorType );

	return EXIT_SUCCESS;
}
