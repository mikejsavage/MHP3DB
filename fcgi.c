#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <fcgi_stdio.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

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
		printf( "Content-type: text/html\r\n\r\n" );

		lua_getglobal( L, "FCGI_Accept" );

		if( lua_pcall( L, 0, 0, 0 ) )
		{
			printf( "ERR: %s\n", lua_tostring( L, -1 ) );

			lua_pop( L, 1 );
		}

		//assert( lua_gettop( L ) == 0 );
	}

	( void ) luaL_dofile( L, "fcgi_shutdown.lua" );

	lua_close( L );

	return EXIT_SUCCESS;
}	
