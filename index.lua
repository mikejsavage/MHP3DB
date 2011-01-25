require( "cgi" )

local commits = json.decode( readFile( "./commits.json" ) )

print( "Latest commits" )

for _, commit in ipairs( commits.commits ) do
	print( "\n" .. ( "-" ):rep( 72 ) .. "\n" )

	print( ( "%s @ %s:\n" ):format( commit.author.name, commit.committed_date ) )

	print( commit.message )
end
