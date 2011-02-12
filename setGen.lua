#! /usr/bin/lua

-- TODO: rewrite this in C

require( "profiler" )

-- if you uncomment the next line then it bumps the
-- computation time up to quite a long time (30s+)
-- you have been warned
--profiler:start( "profiled.lua" )

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
local NumShortsPP = table.getn( Shorts ) + 1 -- NumShortsPlusPlus; we use this a lot later


-- not generics but these run quick

function copySet( set )
	return { hlm = set.hlm, plt = set.plt, arm = set.arm, wst = set.wst, leg = set.leg }
end

-- TODO: this is the current bottleneck
function copySkills( skills )
	local new = { }

	for skill, points in pairs( skills ) do
		new[ skill ] = points
	end

	return new
end


function hasSkills( piece, wantedSkills )
	if not piece.skills then
		return false
	end

	for _, skill in ipairs( piece.skills ) do
		for _, wanted in ipairs( wantedSkills ) do
			if skill.id == wanted.id and skill.points > 0 then
				return true
			end
		end
	end

	return false
end

-- TODO: rewrite this so it subtracts points rather than adding them
--       so then checking if a set is good is as simple as checking
--       if they're all below 0

function addSkills( skills, piece )
	local new = copySkills( skills )

	for _, skill in ipairs( piece.skills ) do
		new[ skill.id ] =
			new[ skill.id ]
				and new[ skill.id ] + skill.points
				or  skill.points
	end

	return new
end

function check( pieces, sets, currSet, classIdx, currSkills )
	-- if goodSet( ... ) then
	-- 	table.insert( ... )
	-- else if classIdx ~= NumShortsPP then
	-- 	...
	-- end
	--
	-- TODO: implement above structure as it allows for early outs

	-- TODO: the mass copies are the bottleneck so if
	--       they can be sped up at all then it should make
	--       things quite a bit faster

	if classIdx == NumShortsPP then
		table.insert( sets, { pieces = copySet( currSet ), skills = currSkills } )
	else
		local class = Armors[ classIdx ]
		local short = class.short

		-- it's faster to do the copy here and above than
		-- it is to do it for every iteration
		local new = copySet( currSet )

		for _, piece in ipairs( pieces[ short ] ) do
			new[ short ] = piece

			check( pieces, sets, new, classIdx + 1, addSkills( currSkills, class.pieces[ piece ] ) )
		end
	end

	return sets
end

function startCheck( pieces )
	-- faster than checking args in check every iteration
	return check( pieces, { }, { }, 1, { } )
end

function goodSet( skills, wantedSkills )
	for _, wanted in ipairs( wantedSkills ) do
		if not skills[ wanted.id ] or skills[ wanted.id ] < wanted.points then
			return false
		end
	end

	return true
end

local request = Post.request and Post.request or ( Get.request and Get.request or nil )

if request then
	local req = json.decode( request:gsub( "%%22", "\"" ) )

	if not req then -- gg
		print( "no request" )

		return
	end

	if not req.skills or table.getn( req.skills ) > MaxSkills then
		print( "no/too many skills" )

		return
	end

	if not req.type then
		print( "no type" )

		return
	end

	local blade = req.type == "blade"
	local gunner = not blade

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

			pieces = { fixed }
		else
			pieces = { }

			-- i think it's worth preprocessing this
			for id, piece in pairs( class.pieces ) do
				if blade  and piece.blade  or
				   gunner and piece.gunner then
					if hasSkills( piece, req.skills ) then
						table.insert( pieces, id )
					end
				end
			end
		end

		toCheck[ class.short ] = pieces
	end

	local skills = { }

	print( "[" )

	-- this innocuous looking line actually hides an O( fuck )
	-- algorithm, but thanks to the (massive) reduction in pieces
	-- to check in the above block, it runs in reasonable time
	--
	-- (actually O( n^5 ) at the moment - will be even worse once
	-- decorations and talismans are in)
	--
	-- TODO: just kidding it runs like crap when you ask for more than
	--       like 2 skills. i need to do some srs optimization here

	local sets = startCheck( toCheck )

	local first = true

	for _, set in ipairs( sets ) do
		if goodSet( set.skills, req.skills ) then
			if first then
				first = false
			else
				print( "," )
			end

			print( [[{"pieces":[]] )

			local firstPiece = true

			for _, class in ipairs( Armors ) do
				if firstPiece then
					firstPiece = false
				else
					print( "," )
				end

				local piece = set.pieces[ class.short ]

				print( piece )
			end

			print( [[],"skills":]] .. json.encode( set.skills ) .. [[}]] )
		end
	end

	print( "]" )
else
	print( "no request" )
end

profiler:stop()
