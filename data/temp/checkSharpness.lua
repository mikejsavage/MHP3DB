#! /usr/bin/lua

require( "common" )

require( "lfs" )

local Dir      = "weapons"
local SharpDir = "sharp"
local CacheDir = "cache"

local Names, NamesCount = loadNames( Dir .. "/names.txt" )

for file in lfs.dir( Dir .. "/" .. SharpDir ) do
	if file ~= "." and file ~= ".." and file ~= CacheDir then
		assert( Names[ file:match( "^(.+)%.png$" ) ], "bad name: " .. file )
	end
end

print( "checkSharpness: ok!" )
