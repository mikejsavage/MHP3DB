#! /usr/bin/lua

require( "lfs" )

local function dirSize( dir )
	local total = 0

	for file in lfs.dir( dir ) do
		if file ~= "." and file ~= ".." then
			local path = dir .. "/" .. file

			local attr = lfs.attributes( path )

			if attr.mode == "directory" then
				total = total + dirSize( path )
			elseif file:find( "%.png$" ) then
				total = total + attr.size
			end
		end
	end

	return total
end

print( dirSize( "." ) )
