#! /usr/bin/lua

require( "cgi" )

-- data

Armors,      ArmorsJSON      = dataJSON( "armors" )
Decorations, DecorationsJSON = dataJSON( "decorations" )
Skills,      SkillsJSON      = dataJSON( "skills" )
Items,       ItemsJSON       = dataJSON( "items" )

-- templates

local setBuilder = loadTemplate( "sets/builder" )



header( "Set Builder" )

print( setBuilder() )

footer()