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

-- these are done by eye. I don't really care
-- -- if they're off because they still look ok
local RareColors =
{
	"ffffff",
	"875fff",
	"fafc4f",
	"f08297",
	"5dd030",
	"3581e1",
	"ff2954",
}

local NamedColors =
{
	white  = "ffffff",
	gray   = "aaaaaa",
	green  = "6bf36e",
	lime   = "a8d468",
	teal   = "58e8c0",
	yellow = "f7f56b",
	orange = "f49e62",
	brown  = "c09428",
	red    = "ff2954",
	pink   = "f599f0",
	purple = "aa70e0",
	blue   = "718fff",
	cyan   = "a6fcfd",
}

function readSharpness( weapon )
	local cachePath = ( "%s/%s/%s/%s.lua" ):format( Dir, SharpDir, CacheDir, weapon.name.hgg )

	local cached = io.open( cachePath, "r" )

	if cached then
		weapon.sharpness = loadstring( cached:read( "*all" ) )()

		cached:close()
		
		return
	end

	local img = imlib2.image.load( ( "%s/%s/%s.png" ):format( Dir, SharpDir, weapon.name.hgg ) )

	if not img then
		return
	end

	weapon.sharpness = { }

	local x = SharpX
	local lastColor = 1
	local currSharp = 1

	while true do
		local color = img:get_pixel( x, SharpY )
		local idx = sharpIdx( color )

		if idx ~= lastColor then
			table.insert( weapon.sharpness, currSharp --[[/ SharpOOMult]] )
			
			lastColor = idx
			currSharp = 1
		else
			currSharp = currSharp + 1
		end

		-- unrecognised color
		if idx == 0 then
			assert( nil, "unrecognised sharpness color in " .. weapon.name.hgg .. ": " .. color.red .. ", " .. color.green .. ", " .. color.blue .. " (idx " .. idx .. ")" )
		end

		-- end of sharpness bar
		if idx == -1 then
			break
		end

		x = x + 1
	end

	img:free()

	-- save the result for future gens
	local writeCache = assert( io.open( cachePath, "w" ) )

	writeCache:write( "return { " .. table.concat( weapon.sharpness, ", " ) .. " }" )

	writeCache:close()
end

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



print( "genIcons: ok!" )
