#! /usr/bin/lua

require( "common" )

require( "lfs" )
require( "imlib2" )

local Dir = "monsters/icons"
local OutputDir = "../img/icons/monsters"

local BaseImg = "monsters/iconbg.png"

local XRes = 60
local YRes = 60

local StartX = 211
local StartY = 67

local IgnoredFiles =
{
	"^%.%.$",
	"^%.$",
}

function ignored( file )
	for _, pattern in ipairs( IgnoredFiles ) do
		if file:find( pattern ) then
			return true
		end
	end

	return false
end

lfs.mkdir( OutputDir )

local baseImg = imlib2.image.load( BaseImg )

for file in lfs.dir( Dir ) do
	if not ignored( file ) then
		local inImg  = imlib2.image.load( Dir .. "/" .. file )

		local outImg = imlib2.image.new( XRes, YRes )

		outImg:set_has_alpha( true ) -- gg lua-imlib2
		outImg:clear()

		for x = 0, XRes - 1 do
			for y = 0, YRes - 1 do
				local baseColor = baseImg:get_pixel( x, y )
				local color     = inImg:get_pixel( x + StartX, y + StartY )

				if not colorEqual( color, baseColor ) then
					outImg:draw_pixel( x, y,
						imlib2.color.new(
							color.red,
							color.green,
							color.blue,
							color.alpha
						)
					)
				end
			end
		end

		outImg:save( OutputDir .. "/" .. file )

		outImg:free()
		inImg:free()
	end
end

baseImg:free()


print( "genMonsterIcons: ok!" )
