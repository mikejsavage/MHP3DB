#! /usr/bin/lua

require( "common" )

Armors = data( "armors" )
Items  = data( "items" )
Skills = data( "skills" )

local DataDir = "armor/hgm"

local function materialIdx( items, id )
	for idx, item in ipairs( items ) do
		if item.id == id then
			return idx
		end
	end

	return nil
end

local function skillIdx( skills, id )
	for idx, skill in ipairs( skills ) do
		if skill.id == id then
			return idx
		end
	end

	return nil
end

local NameMappings =
{
	[ "Scholar Beret(Female only)" ] = "Scholar Beret",
	[ "Snake Face[1]" ] = "Snake Mask",
	[ "The Boss Face[2]" ] = "The Boss Mask",

	[ "Nightmare ToronKO S" ] = "Nightmare Toronko S",
	[ "Rouage Pectus S" ] = "Pouage Pectus S",

	[ "Tigrex Tasset S" ] = "Tigrex  Tasset S",
	[ "Doboru Coat S" ] = "Doburu Coat S",

	[ "Urukusu Leggings S" ] = "Urukuru Leggings S",
	[ "Ranguro Leggings S" ] = "Rangura Leggings S",
	[ "Dober Leggings" ] = "Dober Legings",
	[ "Doboru Leggings S" ] = "Doburu Leggings S",
	[ "Jolly Roger Boots" ] = "Jolly Roger Pants",
	[ "Jolly Roger Pants" ] = "Jolly Roger Skirt",
}

local Actions =
{
	gender = function( piece, part )
		if tonumber( part ) then
			e( piece.rarity == tonumber( part ) )
			
			return "regender"
		end

		--e( part == "Both" and piece.name.hgg or part == "Male" and piece.name.hgg or part == "Female" and piece.name.hgg_fem )

		return "rarity"
	end,

	regender = function( piece, part )
		--e( part == "Both" and piece.name.hgg or part == "Male" and piece.name.hgg or part == "Female" and piece.name.hgg_fem )

		return "BG"
	end,

	rarity = function( piece, part )
		e( piece.rarity == tonumber( part ) )

		return "BG"
	end,

	BG = function( piece, part )
		local blade = part:match( "Blademaster" ) and true or false
		local gunner = part:match( "Gunner" ) and true or false

		e( blade == piece.blade and gunner == piece.gunner )

		return "defense"
	end,

	defense = function( piece, part )
		e( piece.defense == tonumber( part ) )

		return "fireRes"
	end,

	fireRes = function( piece, part )
		e( piece.fireRes == tonumber( part ) )

		return "waterRes"
	end,

	waterRes = function( piece, part )
		e( piece.waterRes == tonumber( part ) )

		return "thunderRes"
	end,

	thunderRes = function( piece, part )
		e( piece.thunderRes == tonumber( part ) )

		return "iceRes"
	end,

	iceRes = function( piece, part )
		e( piece.iceRes == tonumber( part ) )

		return "dragonRes"
	end,

	dragonRes = function( piece, part )
		e( piece.dragonRes == tonumber( part ) )

		return "slots"
	end,

	slots = function( piece, part )
		e( ( part == "-" and piece.slots == 0 ) or ( part == ( "O" ):rep( piece.slots ) ) )

		return "materials", { count = 1 }
	end,

	materials = function( piece, part, store )
		if part == "-" then
			e( table.getn( piece.create ) == store.count - 1, store )

			return "materialsEndCount", { count = store.count }
		end

		local idx = materialIdx( piece.create, itemID( part ) )

		e( idx )

		return "materialsCount", { count = store.count, idx = idx }
	end,

	materialsCount = function( piece, part, store )
		if store.matIdx then
			e( piece.create[ store.idx ].count == tonumber( part ), store )
		end

		if store.count == 4 then
			return "price"
		end

		return "materials", { count = store.count + 1 }
	end,

	materialsEnd = function( piece, part, store )
		e( part == "-", store )

		return "materialsEndCount", { count = store.count }
	end,

	materialsEndCount = function( piece, part, store )
		e( part == "-", store )

		if store.count == 4 then
			return "price"
		end

		return "materialsEnd", { count = store.count + 1 }
	end,

	price = function( piece, part )
		e( part == piece.price .. "z" )

		return "skills", { count = 1 }
	end,

	skills = function( piece, part, store )
		if part == "-" then
			e( ( not piece.skills and store.count == 1 ) or ( table.getn( piece.skills ) == store.count - 1 ), store )

			return "skillsEndCount", { count = store.count }
		end

		local idx = skillIdx( piece.skills, skillID( part ) )

		e( idx )

		return "skillsCount", { count = store.count, idx = idx }
	end,

	skillsCount = function( piece, part, store )
		if store.matIdx then
			e( piece.create[ store.idx ].count == tonumber( part ), store )
		end

		if store.count == 4 then
			return "invalid"
		end

		return "skills", { count = store.count + 1 }
	end,

	skillsEnd = function( piece, part, store )
		e( part == "-", store )

		return "skillsEndCount", { count = store.count }
	end,

	skillsEndCount = function( piece, part, store )
		e( part == "-", store )

		if store.count == 4 then
			return "invalid"
		end

		return "skillsEnd", { count = store.count + 1 }
	end,
}

local function pieceFromName( pieces, name )
	if NameMappings[ name ] then
		name = NameMappings[ name ]
	end

	for _, piece in ipairs( pieces ) do
		if piece.name.hgg == name or piece.name.hgg_fem == name then
			return piece
		end
	end

	assert( nil, "bad piece name: " .. name )
end

local function validatePiece( pieces, line )
	line = line .. ","

	local piece

	local state = "gender"
	local store = { }

	line:gsub( "%s*(.-)%s*,", function( part )
		if not piece then
			piece = pieceFromName( pieces, part )
		else
			local action = Actions[ state ]

			if action then
				local context =
				{
					e = function( cond, store )
						if not store then
							store = { }
						end

						if not cond then
							print( ( "bad %16s in %-22s: %s" ):format(
								state .. ( store.count or "" ),
								piece.name.hgg,
								part
							) )
						end
					end
				}

				setmetatable( context, { __index = _G } )
				setfenv( action, context )

				state, count = action( piece, part, count )
			end
		end
	end )
end

local function validateClass( class )
	local path = ( "%s/%s.csv" ):format( DataDir, class.short )

	io.input( path )

	for line in io.lines() do
		if line:sub( 1, ( "Japanese Name" ):len() ) ~= "Japanese Name" then
			validatePiece( class.pieces, line )
		end
	end
end

for _, class in ipairs( Armors ) do
	validateClass( class )
end

print( "validArmorsHGM: done!" )
