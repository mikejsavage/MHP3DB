#! /usr/bin/lua

require( "common" )

Items = data( "items" )

local DataPath = "monsters/carves.txt"

local carveInfo = readFile( DataPath )

local dummy =
{
	blocks = 1,
}

local sep =
{
	blocks = 2,
}

local Schema =
{
	sep,

	-- anteka KO
	{
		blocks = 3,
	},

	sep,

	-- steel ura back mining
	{
		blocks = 1,
	},

	sep,

	-- dobo tail mining
	{
		blocks = 2,
	},

	sep,

	-- something to do with a living jin
	{
		blocks = 3,
	},

	sep,

	-- kelbi KO
	{
		blocks = 3,
	},

	sep,

	-- jhen's mouth
	{
		blocks = 2,
	},

	sep,

	-- jhen back mining
	{
		blocks = 2,
	},

	sep,

	-- regular ura back mining
	{
		blocks = 2,
	},

	sep,

	-- ice barroth's head
	{
		blocks = 1,
	},

	sep,

	-- regular barroth's head
	{
		blocks = 3,
	},

	sep,
	
	-- bulldrome shiny
	{
		blocks = 3,
	},

	sep,

	-- uka shiny
	{
		blocks = 1,
	},

	sep,

	-- aka shiny
	{
		blocks = 1,
	},

	sep,

	-- reg narga shiny
	{
		blocks = 2,
	},

	sep,

	-- reg tigrex shiny
	{
		blocks = 2,
	},

	sep,

	-- ice agna shiny
	{
		blocks = 1,
	},

	sep,

	-- purple ludroth shiny
	{
		blocks = 1,
	},

	sep,

	-- steel ura shiny
	{
		blocks = 1,
	},

	sep,

	-- ice barroth shiny
	{
		blocks = 1,
	},

	sep,

	-- sand barioth shiny
	{
		blocks = 1,
	},

	sep,

	-- thundr giggi shiny
	{
		blocks = 1,
	},

	sep,

	-- red peco shiny
	{
		blocks = 1,
	},

	-- no sep!
	
	-- gagua golden eggs
	{
		blocks = 3,
	},

	-- gagua normal eggs
	{
		blocks = 3,
	},

	sep,

	-- TODO: something to do with gagua
	-- Gagua Dung, Herb, Insect Husk
	{
		blocks = 1,
	},

	sep,

	-- hapu shiny
	{
		blocks = 3,
	},

	sep,
	
	-- dobo shiny
	{
		blocks = 2,
	},

	sep,

	-- grt froggi shiny
	{
		blocks = 3,
	},

	sep,

	-- ranguro shiny
	{
		blocks = 3,
	},

	sep,

	-- uru shiny
	{
		blocks = 3,
	},

	sep,

	-- TODO: aoa fish eating?
	-- Sushifish, Goldenfish
	{
		blocks = 3,
	},

	sep,

	-- TODO: aoa honey eating?
	-- Honey
	{
		blocks = 3,
	},

	sep,

	-- aoa shiny
	{
		blocks = 3,
	},

	sep,

	-- jin shiny
	{
		blocks = 3,
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
	},

	sep,

	-- green narga shiny
	{
		blocks = 1,
	},

	sep,

	-- melynx shiny
	{
		blocks = 3,
	},

	sep,

	-- felyne shiny
	{
		blocks = 3,
	},

	sep,

	-- black tigrex shiny
	{
		blocks = 1,
	},

	sep,

	-- black blos shiny
	{
		blocks = 1,
	},

	sep,

	-- agna shiny
	{
		blocks = 2,
	},

	sep,

	-- silver los shiny
	{
		blocks = 1,
	},

	sep,

	-- ludroth shiny
	{
		blocks = 3,
	},

	sep,

	-- gold ian shiny
	{
		blocks = 1,
	},

	sep,

	-- great baggi shiny
	{
		blocks = 3,
	},

	sep,

	-- great jaggi shiny
	{
		blocks = 3,
	},

	sep,

	-- ura shiny
	{
		blocks = 2,
	},

	sep,

	-- barroth shiny
	{
		blocks = 3,
	},

	sep,

	-- jho shiny
	{
		blocks = 1,
	},

	sep,

	-- blos shiny
	{
		blocks = 2,
	},

	sep,

	-- barioth shiny
	{
		blocks = 2,
	},

	sep,

	-- giggi shiny
	{
		blocks = 3,
	},

	sep,

	-- peco shiny
	{
		blocks = 3,
	},

	sep,

	-- los shiny
	{
		blocks = 2,
	},

	sep,

	-- ian shiny
	{
		blocks = 2,
	},
}

local function itemFromId( id )
	for _, item in ipairs( Items ) do
		if item.id == id then
			return item
		end
	end

	assert( nil, "bad id: " .. id )
end

local SchemaPos = 1

carveInfo:gsub( ( "([%da-f][%da-f]) " ):rep( 4 ), function( b1, b2, b3, b4 )
	if b1 == "ff" and b2 == "ff" and b3 == "ff" and b4 == "ff" then
		print( "-----------------------------" )

		SchemaPos = SchemaPos + 1

		return
	end

	if b2 .. b3 == "9bd8" then
		return
	end

	local chance = tonumber( b1, 16 )
	local count  = tonumber( b2, 16 )
	local itemId = tonumber( b4 .. b3, 16 )

	local item = itemFromId( itemId )

	print( ( "%-16s x%d %d%%" ):format(
		item.name.hgg, count, chance
	) )
end )
