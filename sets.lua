require( "cgi" )

print( "Content-type: text/html\n" )

-- data

Armors, ArmorsJSON = dataJSON( "armors" )
Decorations, DecorationsJSON = dataJSON( "decorations" )
Skills, SkillsJSON = dataJSON( "skills" )
Items  = data( "items" )

-- templates

local setBuilder = loadTemplate( "sets/builder" )



header( "Set Builder" )

print( setBuilder() )

footer()
