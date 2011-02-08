#! /usr/bin/lua

require( "cgi" )

header()

local commits = json.decode( readFile( "./commits.json" ) )

print( loadTemplate( "index" )( { commits = commits } ) )

footer()
