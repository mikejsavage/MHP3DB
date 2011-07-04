#! /usr/bin/lua

require( "common" )

local Files =
{
	"armors",
	"charms",
	"charmsFiltered",
	"decorations",
	"guns",
	"items",
	"modified",
	"monsters",
	"posts",
	"shots",
	"skills",
	"tips",
	"weapons",
}

for _, file in ipairs( Files ) do
	local arr = data( file )

	local output = assert( io.open( "../" .. file .. ".lua", "w" ) )

	serializeToFile( output, arr )

	output:close()
end

print( "genLuaData: done!" )
