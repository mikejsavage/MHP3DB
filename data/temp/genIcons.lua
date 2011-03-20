#! /usr/bin/lua

require( "common" )

require( "lfs" )
require( "imlib2" )

local Dir = "icons"
local OutputDir = "../img/icons"

local IgnoredFiles =
{
	"^%.%.$",
	"^%.$",
}

local RareDirs =
{
	"equipment",
}

local NamedDirs =
{
	"items",
}

local NoSuffixDirs =
{
	"equipment",
}

-- these are done by eye. I don't really care
-- -- if they're off because they still look ok
local RareColors =
{
	"ffffff",
	"875fff",
	"fafc4f",
	"ea8bd5",
	"5dd030",
	"3581e1",
	"e84458",
}

local NamedColors =
{
	white  = "ffffff",
	gray   = "aaaaaf",
	green  = "6bf36e",
	lime   = "a8d468",
	moss   = "67a838",
	teal   = "58e8c0",
	yellow = "f7f56b",
	orange = "f49e62",
	brown  = "c09428",
	red    = "e84458",
	pink   = "f599f0",
	purple = "aa70e0",
	blue   = "718fff",
	cyan   = "a6fcfd",
}

function ignored( file )
	for _, pattern in ipairs( IgnoredFiles ) do
		if file:find( pattern ) then
			return true
		end
	end

	return false
end

function recolor( img, htmlColor )
	local w, h = img:get_width(), img:get_height()

	local redScale   = tonumber( htmlColor:sub( 1, 2 ), 16 ) / 255
	local greenScale = tonumber( htmlColor:sub( 3, 4 ), 16 ) / 255
	local blueScale  = tonumber( htmlColor:sub( 5, 6 ), 16 ) / 255

	for x = 0, w - 1 do
		for y = 0, h - 1 do
			local color = img:get_pixel( x, y )

			if color.alpha ~= 0 then
				img:draw_pixel( x, y,
					imlib2.color.new( 
						color.red   * redScale,
						color.green * greenScale,
						color.blue  * blueScale,
						color.alpha
					)
				)
			end
		end
	end
end

local function copy( src, dst )
	local contents = readFile( src )

	local outFile = io.open( dst, "w" )

	outFile:write( contents )

	outFile:close()
end

for _, rareDir in ipairs( RareDirs ) do
	local dir = ( "%s/%s" ):format( Dir, rareDir )

	lfs.mkdir( OutputDir .. "/" .. rareDir )

	for file in lfs.dir( dir ) do
		if not ignored( file ) then
			for rarity, color in ipairs( RareColors ) do
				local img = imlib2.image.load( dir .. "/" .. file )

				recolor( img, color )

				img:save( OutputDir .. "/" .. rareDir .. "/" .. file:gsub( "(%l+)%.png", "%1_rare" .. rarity .. ".png" ) )

				img:free()
			end
		end
	end
end

for _, nameDir in ipairs( NamedDirs ) do
	local dir = ( "%s/%s" ):format( Dir, nameDir )

	lfs.mkdir( OutputDir .. "/" .. nameDir )

	for file in lfs.dir( dir ) do
		if not ignored( file ) then
			for name, color in pairs( NamedColors ) do
				local img = imlib2.image.load( dir .. "/" .. file )

				recolor( img, color )

				img:save( OutputDir .. "/" .. nameDir .. "/" .. file:gsub( "(%l+)%.png", "%1_" .. name .. ".png" ) )

				img:free()
			end
		end
	end
end

for _, noSuffixDir in ipairs( NoSuffixDirs ) do
	local dir = ( "%s/%s" ):format( Dir, noSuffixDir )

	lfs.mkdir( OutputDir .. "/" .. noSuffixDir )

	for file in lfs.dir( dir ) do
		if not ignored( file ) then
			copy( dir .. "/" .. file, OutputDir .. "/" .. noSuffixDir .. "/" .. file )
		end
	end
end


print( "genIcons: ok!" )
