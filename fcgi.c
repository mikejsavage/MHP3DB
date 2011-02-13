#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <assert.h>

#include <fcgi_stdio.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#define POST_CONTENT_TYPE "application/x-www-form-urlencoded"

// i don't know why this is necessary but it is
static int fcgiPrint( lua_State *L )
{
	const char *str = luaL_checkstring( L, 1 );

	printf( "%s", str );

	return 0;
}

int main( int argc, char *argv[] )
{
	lua_State *L = lua_open();
	luaL_openlibs( L );

	lua_register( L, "print", fcgiPrint );

	( void ) luaL_dofile( L, "fcgi.lua" );

	while( FCGI_Accept() >= 0 )
	{
		// it literally does not work without this line
		// not even if it gets put in fcgi.lua
		// TODO: this makes redirects/cookies a little awkward
		printf( "Content-type: text/html\r\n\r\n" );


		// POST parsing

		char *postString = NULL;
		char *contentLength = getenv( "CONTENT_LENGTH" );

		if( contentLength )
		{
			size_t postLength = atoi( contentLength );

			if( postLength != 0 )
			{
				char *contentType = getenv( "CONTENT_TYPE" );

				if( contentType != NULL && strncmp( contentType, POST_CONTENT_TYPE, sizeof( POST_CONTENT_TYPE ) - 1 ) == 0 )
				{
					postString = malloc( postLength + 1 );

					fread( postString, 1, postLength, stdin );

					postString[ postLength ] = 0;
				}
			}
		}


		// call FCGI_Accept( postString ) in fcgi.lua

		lua_getglobal( L, "FCGI_Accept" );

		lua_pushstring( L, postString );

		if( lua_pcall( L, 1, 0, 0 ) )
		{
			printf( "ERR: %s\n", lua_tostring( L, -1 ) );

			lua_pop( L, 1 );
		}

		if( postString != NULL )
		{
			free( postString );
		}

		assert( lua_gettop( L ) == 0 );
	}

	// this fails if the file doesn't exist
	// but who cares?
	( void ) luaL_dofile( L, "fcgi_shutdown.lua" );

	lua_close( L );

	return EXIT_SUCCESS;
}	
