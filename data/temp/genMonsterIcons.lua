#! /usr/bin/lua

require( "common" )

require( "lfs" )
require( "imlib2" )

function colorEqual( c1, c2 )
	return c1.red   == c2.red   and
	       c1.green == c2.green and
	       c1.blue  == c2.blue
end

local Dir = "monsters/icons"
local OutputDir = "../img/icons/monsters"

local XRes = 46
local YRes = 46

local Padding = 3

local StartX = 311
local StartY = 70

local IgnoredFiles =
{
	"^%.%.$",
	"^%.$",
}

local DropColors =
{
	imlib2.color.new( 248, 244, 232 ),
	imlib2.color.new( 248, 240, 224 ),
	imlib2.color.new( 240, 236, 224 ),
	imlib2.color.new( 240, 232, 216 ),
	imlib2.color.new( 232, 228, 216 ),
	imlib2.color.new( 232, 224, 208 ),
	imlib2.color.new( 232, 220, 208 ),
	imlib2.color.new( 224, 216, 200 ),
	imlib2.color.new( 224, 208, 176 ),
	imlib2.color.new( 192, 180, 136 ),
	imlib2.color.new( 184, 184, 144 ),
	imlib2.color.new( 184, 180, 136 ),
	imlib2.color.new( 184, 172, 168 ),
	imlib2.color.new( 184, 176, 160 ),
	imlib2.color.new( 176, 168, 160 ),
	imlib2.color.new( 168, 164, 128 ),
	imlib2.color.new( 168, 144, 136 ),
	imlib2.color.new( 160, 164, 152 ),
	imlib2.color.new( 160, 152, 128 ),
	imlib2.color.new( 160, 148, 128 ),
	imlib2.color.new( 160, 148, 120 ),
	imlib2.color.new( 160, 144, 136 ),
	imlib2.color.new( 152, 144, 136 ),
	imlib2.color.new( 144, 140, 128 ),

	imlib2.color.new( 184, 196, 208 ), -- too aggressive?
	imlib2.color.new( 192, 176, 192 ), -- too aggressive?
	imlib2.color.new( 232, 220, 192 ), -- too aggressive?
	imlib2.color.new( 144, 148, 176 ), -- too aggressive?
	imlib2.color.new( 216, 184, 120 ), -- too aggressive?
	imlib2.color.new( 208, 152, 112 ), -- too aggressive? great froggi's mane
}

function ignored( file )
	for _, pattern in ipairs( IgnoredFiles ) do
		if file:find( pattern ) then
			return true
		end
	end

	return false
end

function drop( color )
	for _, doDrop in ipairs( DropColors ) do
		if colorEqual( color, doDrop ) then
			return true
		end
	end

	return false
end

local function genIcon( img, name, startX )
	local outImg = imlib2.image.new( XRes, YRes )

	outImg:set_has_alpha( true )
	outImg:clear()

	for x = 0, XRes - 1 do
		for y = 0, YRes - 1 do
			local color = img:get_pixel( x + startX, y + StartY )

			if not drop( color ) then
				outImg:draw_pixel( x, y, color )
			end
		end
	end

	outImg:save( OutputDir .. "/" .. name:gsub( " ", "_" ) .. ".png" )
	outImg:free()
end

lfs.mkdir( OutputDir )

for file in lfs.dir( Dir ) do
	if not ignored( file ) then
		local img = imlib2.image.load( Dir .. "/" .. file )

		local names = { }
		local numNames = 0

		file:gsub( "%.png$", "" ):gsub( "([%a ]+)", function( name )
			table.insert( names, name )

			numNames = numNames + 1
		end )

		local x = StartX - ( XRes + Padding ) * ( numNames - 1 )

		for i, name in ipairs( names ) do
			genIcon( img, name, x )

			x = x + StartX + Padding
		end

		img:free()
	end
end


print( "genMonsterIcons: ok!" )
