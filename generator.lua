#! /usr/bin/lua

require( "cgi" )

-- data

Armors,      ArmorsJSON      = dataJSON( "armors" )
Decorations, DecorationsJSON = dataJSON( "decorations" )
Skills,      SkillsJSON      = dataJSON( "skills" )

-- templates

local setGenerator = loadTemplate( "sets/generator" )



header( "Set Generator" )

print( setGenerator() )

footer()
