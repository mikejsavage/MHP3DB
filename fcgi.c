#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <assert.h>

#include <fcgi_stdio.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#define POST_CONTENT_TYPE "application/x-www-form-urlencoded"

lua_State *L;

// this is needed because libfcgi temporarily sets stdout
// to something else during a request, and lua can't see
// the change
static int fcgiPrint( lua_State *L )
{
	const char *str = luaL_checkstring( L, 1 );

	printf( "%s", str );

	return 0;
}

void cleanup( int signal )
{
	// if fcgi_shutdown.lua doesn't exist then
	// lua_close is still called
	( void ) luaL_dofile( L, "fcgi_shutdown.lua" );

	lua_close( L );
}

int main( int argc, char *argv[] )
{
	L = lua_open();
	luaL_openlibs( L );

	// SIGUSR1 is sent when the server is shutting down
	signal( SIGUSR1, cleanup );

	lua_register( L, "print", fcgiPrint );

	( void ) luaL_dofile( L, "fcgi.lua" );

	// put debug.traceback on the stack
	lua_getglobal( L, "debug" );
	lua_getfield( L, -1, "traceback" );
	lua_remove( L, -2 );

	while( FCGI_Accept() >= 0 )
	{
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

					// if malloc fails then don't die completely
					if( postString != NULL )
					{
						fread( postString, 1, postLength, stdin );

						postString[ postLength ] = 0;
					}
				}
			}
		}


		// call FCGI_Accept( postString ) in fcgi.lua

		lua_getglobal( L, "FCGI_Accept" );

		lua_pushstring( L, postString );

		if( lua_pcall( L, 1, 0, -3 ) )
		{
			printf( "ERR: %s\n", lua_tostring( L, -1 ) );
		}

		if( postString != NULL )
		{
			free( postString );
		}

		// i don't understand why lua_gettop varies depending on
		// whether lua_pcall fails but this damn well fixes it
		while( lua_gettop( L ) != 1 )
		{
			lua_pop( L, 1 );
		}
	}

	// this will get called when this is run as
	// a CGI script but not as FCGI
	cleanup( SIGUSR1 );

	return EXIT_SUCCESS;
}	
