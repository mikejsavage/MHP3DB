#! /usr/bin/lua

require( "cgi" )

local Armors = data( "armors" )
local Skills = data( "skills" )

-- prevent ugly kids from ruining my shit
local MaxSkills = 6

-- end of header
print( "" )

--[[ expects a struct like:

{
	// eg "blade" : true
	(type) : true

	"skills" : [
		{
			"id" : int
			"points" : int
		}
		...
	]

	"fixed" : {
		// eg "plt" : 5
		(short) : int
		...
	}
}

--]]


local Shorts = { "hlm", "plt", "arm", "wst", "leg" }

function hasSkills( piece, wantedSkills )
	if not piece.skills then
		return false
	end

	for _, skill in ipairs( piece.skills ) do
		for _, wanted in ipairs( wantedSkills ) do
			if skill.id == wanted.id then
				return true
			end
		end
	end

	return false
end

function addSkills( skills, piece )
	local new = table.copy( skills )

	for _, skill in ipairs( piece.skills ) do
		new[ skill.id ] =
			new[ skill.id ]
				and new[ skill.id ] + skill.points
				or  skill.points
	end

	return new
end

function check( pieces, sets, currSet, classIdx, currSkills )
	if not currSet then
		sets = { }
		currSet = { }
		classIdx = 1
		currSkills = { }
	end

	if classIdx == table.getn( Shorts ) + 1 then
		table.insert( sets, { pieces = table.copy( currSet ), skills = currSkills } )
	else
		local short = Shorts[ classIdx ]

		-- it's faster to put the table.copy here and in
		-- the table.insert above than it is in the next
		-- block
		local new = table.copy( currSet )

		for _, piece in ipairs( pieces[ short ] ) do
			--local new = table.copy( currSet )

			new[ short ] = { piece = piece.piece, id = piece.id }

			check( pieces, sets, new, classIdx + 1, addSkills( currSkills, piece.piece ) )
		end
	end

	return sets
end

function goodSet( skills, wantedSkills )
	for _, wanted in ipairs( wantedSkills ) do
		if not skills[ wanted.id ] or skills[ wanted.id ] < wanted.points then
			return false
		end
	end

	return true
end

if Get.request then
	local req = json.decode( Get.request:gsub( "%%22", "\"" ) )

	if not req.skills or table.getn( req.skills ) > MaxSkills then
		return
	end

	if not ( req.blade or req.gunner ) or
	   ( req.blade and req.gunner ) then
		-- if they don't want a set then that's fine
		-- if they're trying to overload this then they can get bent
		return
	end

	local toCheck = { }

	-- meh
	if not req.fixed then
		req.fixed = { }
	end

	for _, class in ipairs( Armors ) do
		local pieces

		local fixed = req.fixed[ class.short ]

		if fixed then
			local piece = class.pieces[ fixed ]

			if not piece then
				return
			end

			pieces = { { piece = piece, id = fixed } }
		else
			pieces = { }

			-- i think it's worth preprocessing this
			for id, piece in pairs( class.pieces ) do
				if req.blade  and piece.blade  or
				   req.gunner and piece.gunner then
					if hasSkills( piece, req.skills ) then
						table.insert( pieces, { piece = piece, id = id } )
					end
				end
			end
		end

		toCheck[ class.short ] = pieces
	end

	local skills = { }

	io.write( "[" )

	-- this innocuous looking line actually hides an O( fuck )
	-- algorithm, but thanks to the (massive) reduction in pieces
	-- to check in the above block, it runs in reasonable time
	--
	-- (actually O( n^5 ) at the moment - will be even worse once
	-- decorations and talismans are in)

	local sets = check( toCheck )

	local first = true

	for _, set in ipairs( sets ) do
		if goodSet( set.skills, req.skills ) then
			if first then
				first = false
			else
				--io.write( "," )
				print( "" )
			end

			io.write( [[{"pieces":[]] )

			local firstPiece = true

			for _, piece in pairs( set.pieces ) do
				if firstPiece then
					firstPiece = false
				else
					io.write( "," )
				end

				io.write( piece.id )
			end

			io.write( [[],"skills":]] .. json.encode( set.skills ) .. [[}]] )
		end
	end

	io.write( "]" )
else
	print( "" )
end
