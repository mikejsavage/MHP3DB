#! /usr/bin/lua

require( "common" )

Items = data( "items" )

-- this contains a memory dump that's been hit with
-- "od -t x1", had all the new lines/addresses removed and
-- then been trimmed to only include the relevant data
local DataPath = "monsters/carves.txt"

local sep =
{
	blocks = 2,
	monster = nil
}

local Schema =
{
	-- anteka KO
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "KO", },
		monster = "Anteka"
	},

	sep,

	-- steel ura back mining
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tripped", },
		monster = "Steel Uragaan"
	},

	sep,

	-- dobo tail mining
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail Mine", },
		monster = "Doboruberuku"
	},

	sep,

	-- TODO: something to do with a living jin
	-- Mega Thunderbug, Jinouga Pelt
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "idk", },
		monster = "Jinouga"
	},

	sep,

	-- kelbi KO
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "KO", },
		monster = "Kelbi"
	},

	sep,

	-- jhen's mouth
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Mouth", },
		monster = "Jhen Mohran"
	},

	sep,

	-- jhen back mining
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Back", },
		monster = "Jhen Mohran"
	},

	sep,

	-- regular ura back mining
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tripped", },
		monster = "Uragaan"
	},

	sep,

	-- ice barroth's head
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Head", },
		monster = "Ice Barroth"
	},

	sep,

	-- regular barroth's head
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Head", },
		monster = "Barroth"
	},

	sep,
	
	-- bulldrome shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Bulldrome"
	},

	sep,

	-- uka shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Ukanlos"
	},

	sep,

	-- aka shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Akantor"
	},

	sep,

	-- reg narga shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Nargacuga"
	},

	sep,

	-- reg tigrex shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Tigrex"
	},

	sep,

	-- ice agna shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Ice Agnaktor"
	},

	sep,

	-- purple ludroth shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Purple Royal Ludroth"
	},

	sep,

	-- steel ura shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Steel Uragaan"
	},

	sep,

	-- ice barroth shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Ice Barroth"
	},

	sep,

	-- sand barioth shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Sand Barioth"
	},

	sep,

	-- thundr giggi shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Thunder Gigginox"
	},

	sep,

	-- red peco shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Red Qurupeco"
	},

	-- no sep!
	
	-- gagua golden eggs
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Gagua"
	},

	-- gagua normal eggs
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Gagua"
	},

	sep,

	-- TODO: something to do with gagua
	-- Gagua Dung, Herb, Insect Husk
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Gagua"
	},

	sep,

	-- hapu shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Hapurubokka"
	},

	sep,
	
	-- dobo shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Doboruberuku"
	},

	sep,

	-- grt froggi shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Great Froggi"
	},

	sep,

	-- ranguro shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Rangurotora"
	},

	sep,

	-- uru shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Urukusu"
	},

	sep,

	-- TODO: aoa fish eating?
	-- Sushifish, Goldenfish
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Aoashira"
	},

	sep,

	-- TODO: aoa honey eating?
	-- Honey
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Aoashira"
	},

	sep,

	-- aoa shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Aoashira"
	},

	sep,

	-- jin shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Jinouga"
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Altaroth"
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Altaroth"
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Altaroth"
	},

	sep,

	-- altaroth shiny
	-- TODO: what colour?
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Altaroth"
	},

	sep,

	-- green narga shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Green Nargacuga"
	},

	sep,

	-- melynx shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Melynx"
	},

	sep,

	-- felyne shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Felyne"
	},

	sep,

	-- black tigrex shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Black Tigrex"
	},

	sep,

	-- black blos shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Black Diablos"
	},

	sep,

	-- agna shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Agnaktor"
	},

	sep,

	-- silver los shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Silver Rathalos"
	},

	sep,

	-- ludroth shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Royal Ludroth"
	},

	sep,

	-- gold ian shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Gold Rathian"
	},

	sep,

	-- great baggi shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Great Baggi"
	},

	sep,

	-- great jaggi shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Great Jaggi"
	},

	sep,

	-- ura shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Uragaan"
	},

	sep,

	-- barroth shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Barroth"
	},

	sep,

	-- jho shiny
	{
		blocks = 1,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Deviljho"
	},

	sep,

	-- blos shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Diablos"
	},

	sep,

	-- barioth shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Barioth"
	},

	sep,

	-- giggi shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Gigginox"
	},

	sep,

	-- peco shiny
	{
		blocks = 3,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Qurupeco"
	},

	sep,

	-- los shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Rathalos"
	},

	sep,

	-- ian shiny
	{
		blocks = 2,
		type = "shiny",
		action = { hgg = "?", },
		monster = "Rathian"
	},

	sep,

	-- uka tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Ukanlos"
	},

	sep,

	-- aka tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Akantor"
	},

	sep,

	-- narga tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Nargacuga"
	},

	sep,

	-- tigrex tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Tigrex"
	},

	sep,

	-- ice agna tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Ice Agnaktor"
	},

	sep,

	-- purple ludroth tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Purple Royal Ludroth"
	},

	sep,

	-- steel ura tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Steel Uragaan"
	},

	sep,

	-- ice barroth tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Ice Barroth"
	},

	sep,

	-- sand barioth tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Sand Barioth"
	},

	sep,

	-- dobo tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Doboruberuku"
	},

	sep,

	-- ama tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Amatsumagatsuchi"
	},

	sep,

	-- jin tail
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Jinouga"
	},

	sep,

	-- green narga tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Green Nargacuga"
	},

	sep,

	-- ala tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Alatreon"
	},

	sep,

	-- black tigrex tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Black Tigrex"
	},

	sep,

	-- black blos tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Black Diablos"
	},

	sep,

	-- agna tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Agnaktor"
	},

	sep,

	-- silver los tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Silver Rathalos"
	},

	sep,

	-- royal ludroth tail
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Royal Ludroth"
	},

	sep,

	-- gold ian tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Gold Rathian"
	},

	sep,

	-- ura tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Uragaan"
	},

	sep,

	-- barroth tail
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Barroth"
	},

	sep,

	-- jho tail
	{
		blocks = 1,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Deviljho"
	},

	sep,

	-- blos tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Diablos"
	},

	sep,

	-- barioth tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Barioth"
	},

	sep,

	-- los tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Rathalos"
	},

	sep,

	-- ian tail
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Tail", },
		monster = "Rathian"
	},

	sep,

	-- Zuwaroposu carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Zuwaroposu"
	},

	sep,

	-- Anteka carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Anteka"
	},

	sep,

	-- Bullfango carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Bullfango"
	},

	sep,

	-- Bulldrome carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Bulldrome"
	},

	sep,

	-- Ukanlos carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Ukanlos"
	},

	sep,

	-- Akantor carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Akantor"
	},

	sep,

	-- Nargacuga carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Nargacuga"
	},

	sep,

	-- Tigrex carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Tigrex"
	},

	sep,

	-- Ice Agnaktor carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Ice Agnaktor"
	},

	sep,

	-- Purple Royal Ludroth carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Purple Royal Ludroth"
	},

	sep,

	-- Steel Uragaan carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Steel Uragaan"
	},

	sep,

	-- Ice Barroth carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Ice Barroth"
	},

	sep,

	-- Sand Barioth carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Sand Barioth"
	},

	sep,

	-- Thunder Gigginox carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Thunder Gigginox"
	},

	sep,

	-- Red Qurupeco carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Red Qurupeco"
	},

	sep,

	-- Gagua carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Gagua"
	},

	sep,

	-- Zuwaroposu carves
	-- yes, again...
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Zuwaroposu"
	},

	sep,

	-- Froggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Froggi"
	},

	sep,

	-- Hapurubokka carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Hapurubokka"
	},

	sep,

	-- Doboruberuku carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Doboruberuku"
	},

	sep,

	-- Great Froggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Great Froggi"
	},

	sep,

	-- Rangurotora carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Rangurotora"
	},

	sep,

	-- Urukusu carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Urukusu"
	},

	sep,

	-- Aoashira carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Aoashira"
	},

	sep,

	-- Amatsumagatsuchi carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Amatsumagatsuchi"
	},

	sep,

	-- Jinouga carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Jinouga"
	},

	sep,

	-- Bnahabra carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Bnahabra"
	},

	sep,

	-- Bnahabra carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Bnahabra"
	},

	sep,

	-- Bnahabra carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Bnahabra"
	},

	sep,

	-- Bnahabra carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Bnahabra"
	},

	sep,

	-- Kelbi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Kelbi"
	},

	sep,

	-- Altaroth carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Altaroth"
	},

	sep,

	-- Green Nargacuga carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Green Nargacuga"
	},

	sep,

	-- Rhenoplos carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Rhenoplos"
	},

	sep,

	-- Popo carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Popo"
	},

	sep,

	-- Aptanoth carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Aptanoth"
	},

	sep,

	-- Giggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Giggi"
	},

	sep,

	-- Jhen Mohran carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Jhen Mohran"
	},

	sep,

	-- Alatreon carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Alatreon"
	},

	sep,

	-- Black Tigrex carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Black Tigrex"
	},

	sep,

	-- Delex carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Delex"
	},

	sep,

	-- Uroktor carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Uroktor"
	},

	sep,

	-- Black Diablos carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Black Diablos"
	},

	sep,

	-- Agnaktor carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Agnaktor"
	},

	sep,

	-- Silver Rathalos carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Silver Rathalos"
	},

	sep,

	-- Ludroth carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Ludroth"
	},

	sep,

	-- Royal Ludroth carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Royal Ludroth"
	},

	sep,

	-- Gold Rathian carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Gold Rathian"
	},

	sep,

	-- Great Baggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Great Baggi"
	},

	sep,

	-- Baggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Baggi"
	},

	sep,

	-- Great Jaggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Great Jaggi"
	},

	sep,

	-- Jaggia carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Jaggia"
	},

	sep,

	-- Jaggi carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Jaggi"
	},

	sep,

	-- Uragaan carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Uragaan"
	},

	sep,

	-- Barroth carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Barroth"
	},

	sep,

	-- Deviljho carves
	{
		blocks = 2,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Deviljho"
	},

	sep,

	-- Diablos carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Diablos"
	},

	sep,

	-- Barioth carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Barioth"
	},

	sep,

	-- Gigginox carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Gigginox"
	},

	sep,

	-- Qurupeco carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Qurupeco"
	},

	sep,

	-- Rathalos carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Rathalos"
	},

	sep,

	-- Rathian carves
	{
		blocks = 3,
		type = "carve",
		name = { hgg = "Body", },
		monster = "Rathian"
	},
}

local MonsterNames =
{
	"Felyne",
	"Melynx",
	"Altaroth",
	"Bnahabra",
	"Delex",
	"Kelbi",
	"Aptanoth",
	"Rhenoplos",
	"Zuwaroposu",
	"Anteka",
	"Popo",
	"Gagua",
	"Jaggi",
	"Jaggia",
	"Great Jaggi",
	"Baggi",
	"Great Baggi",
	"Froggi",
	"Great Froggi",
	"Qurupeco",
	"Red Qurupeco",
	"Bullfango",
	"Bulldrome",
	"Aoashira",
	"Urukusu",
	"Rangurotora",
	"Barroth",
	"Ice Barroth",
	"Uragaan",
	"Steel Uragaan",
	"Doboruberuku",
	"Deviljho",
	"Ludroth",
	"Royal Ludroth",
	"Purple Royal Ludroth",
	"Hapurubokka",
	"Uroktor",
	"Agnaktor",
	"Ice Agnaktor",
	"Rathian",
	"Gold Rathian",
	"Rathalos",
	"Silver Rathalos",
	"Giggi",
	"Gigginox",
	"Thunder Gigginox",
	"Barioth",
	"Sand Barioth",
	"Nargacuga",
	"Green Nargacuga",
	"Diablos",
	"Black Diablos",
	"Tigrex",
	"Black Tigrex",
	"Akantor",
	"Ukanlos",
	"Jinouga",
	"Jhen Mohran",
	"Amatsumagatsuchi",
	"Alatreon",
}

local function itemIdxFromId( id )
	for idx, item in ipairs( Items ) do
		if item.id == id then
			return idx
		end
	end

	assert( nil, "bad id: " .. id )
end

local function sortByChanceDesc( a, b )
	return a.chance > b.chance
end

local function sortRanks( arr )
	if arr.high then
		table.sort( arr.high, sortByChanceDesc )
	end

	if arr.low then
		table.sort( arr.low, sortByChanceDesc )
	end

	if arr.baby then
		table.sort( arr.baby, sortByChanceDesc )
	end
end

local function sortCarves( a, b )
	if b.name.hgg == "Body" then
		return false
	end

	if a.name.hgg == "Body" then
		return true
	end

	if b.name.hgg == "Tail" then
		return false
	end

	if a.name.hgg == "Tail" then
		return true
	end

	return false
end


local Monsters = { }

local function monsterFromName( name )
	for _, monster in ipairs( Monsters ) do
		if monster.name.hgg == name then
			return monster
		end
	end

	assert( nil, "bad monster name: " .. name )
end

for _, name in ipairs( MonsterNames ) do
	local monster =
	{
		name = { hgg = name },
	}

	table.insert( Monsters, monster )
end


local SchemaPos = 1
local Block = Schema[ SchemaPos ]
local NewPosIn = Block.blocks

local carveInfo = readFile( DataPath )

local monster = monsterFromName( Block.monster )
local curData
local curRank = "pre"

if Block.type == "carve" then
	curData =
	{
		name = Block.name,
	}
elseif Block.type == "shiny" then
	curData =
	{
		action = Block.action,
	}
else
	assert( nil, "bad type: " .. Block.type )
end

-- the last block is ffffffff so don't bother with " ?"
carveInfo:gsub( ( "([%da-f][%da-f]) " ):rep( 4 ), function( b1, b2, b3, b4 )
	if b1 == "ff" and b2 == "ff" and b3 == "ff" and b4 == "ff" then
		if NewPosIn == 0 then
			if monster then
				sortRanks( curData )

				if Block.type == "carve" then
					if not monster.carves then
						monster.carves = { }
					end

					table.insert( monster.carves, curData )
				elseif Block.type == "shiny" then
					if not monster.shinies then
						monster.shinies = { }
					end

					table.insert( monster.shinies, curData )
				end
			end

			SchemaPos = SchemaPos + 1
			Block = Schema[ SchemaPos ]
			NewPosIn = Block.blocks

			if Block ~= sep then
				monster = monsterFromName( Block.monster )
				curRank = "pre"

				if Block.type == "carve" then
					curData =
					{
						name = Block.name,
					}
				elseif Block.type == "shiny" then
					curData =
					{
						action = Block.action,
					}
				else
					assert( nil, "bad type: " .. Block.type )
				end
			else
				monster = nil
				curData = { }
			end
		end

		NewPosIn = NewPosIn - 1

		if curRank == "pre" then
			curRank = "high"
		elseif curRank == "high" then
			curRank = "low"
		elseif curRank == "low" then
			curRank = "baby"
		else
			--assert( nil, "bad rank: " .. curRank )
		end

		curData[ curRank ] = { }

		return
	end

	local chance = tonumber( b1, 16 )
	local count  = tonumber( b2, 16 )
	local itemId = tonumber( b4 .. b3, 16 )

	table.insert( curData[ curRank ], { id = itemIdxFromId( itemId ), count = count, chance = chance } )
end )

sortRanks( curData )

if Block.type == "carve" then
	if not monster.carves then
		monster.carves = { }
	end

	table.insert( monster.carves, curData )
elseif Block.type == "shiny" then
	if not monster.shinies then
		monster.shinies = { }
	end

	table.insert( monster.shinies, curData )
end

for _, monster in ipairs( Monsters ) do
	if monster.carves then
		table.sort( monster.carves, sortCarves )
	end
end

io.output( "../monsters.json" )
io.write( json.encode( Monsters ) )

print( "genCarveInfo: ok!" )
