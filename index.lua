#! /usr/bin/lua

require( "cgi" )

header()

local commits = json.decode( readFile( "./commits.json" ) )

print( "<h1>Latest commits</h1>" )

for _, commit in ipairs( commits.commits ) do
	print( ( "<h3>%s @ %s</h3>" ):format( commit.author.name, commit.committed_date ) )

	print( ( commit.message:gsub( "\n", "<br>" ) ) )

	print( "<br><br>" )
end

footer()
