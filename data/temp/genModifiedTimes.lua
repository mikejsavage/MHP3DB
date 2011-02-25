#! /usr/bin/lua

require( "json" )

require( "lfs" )

local BaseDir = "../.."

local IgnoredFiles =
{
	"^%.$",
	"^%.%.$",
	"^%.tags$",
}

local DirsToCheck =
{
	"js",
	"data/js",
	"css",
}

local LastModified = { }

function ignored( file )
	for _, pattern in ipairs( IgnoredFiles ) do
		if file:find( pattern ) then
			return true
		end
	end
	
	return false
end

for _, dir in ipairs( DirsToCheck ) do
	local path = BaseDir .. "/" .. dir

	for file in lfs.dir( path ) do
		if not ignored( file ) then
			local attr = lfs.attributes( path .. "/" .. file )

			LastModified[ dir .. "/" .. file ] = attr.modification
		end
	end
end

print( "genModifiedTimes: ok!" )

io.output( "../modified.json" )
io.write( json.encode( LastModified ) )
