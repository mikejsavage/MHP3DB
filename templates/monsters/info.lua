{%
local Ranks =
{
	{
		short = "low",
		name =
		{
			hgg = "Low Rank",
		},
	},
	{
		short = "high",
		name =
		{
			hgg = "High Rank",
		},
	},
	{
		short = "event",
		name =
		{
			hgg = "Something Rank",
		},
	},
}

local itemChances = loadTemplate( "itemChances" )
%}

<h1>{{ icon( "monsters/" .. monster.name.hgg ) }} {{ T( monster.name ) }}</h1>

{%
	if monster.carves then
		print( "<h2>Carves</h2>" )

		print( "<table class='data'><thead>" )

		print( "<tr><th>Location</th>" )

		for _, rank in ipairs( Ranks ) do
			printf( "<th>%s</th>", T( rank.name ) )
		end

		print( "</tr></head>" )

		for _, location in ipairs( monster.carves ) do
			printf( "<tr><td>%s</td>", T( location.name ) )

			for _, rank in ipairs( Ranks ) do
				if location[ rank.short ] then
					printf( "<td>%s</td>", itemChances( { materials = location[ rank.short ] } ) )
				else
					print( "<td class='none'>-</td>" )
				end
			end

			print( "</tr>" )
		end

		print( "</table>" )
	end

	if monster.shinies then
		print( "<h2>Shinies</h2>" )

		print( "<table class='data'><thead>" )

		print( "<tr><th>Action</th>" )

		for _, rank in ipairs( Ranks ) do
			printf( "<th>%s</th>", T( rank.name ) )
		end

		print( "</tr></head>" )

		for _, location in ipairs( monster.shinies ) do
			printf( "<tr><td>%s</td>", T( location.action ) )

			for _, rank in ipairs( Ranks ) do
				if location[ rank.short ] then
					printf( "<td>%s</td>", itemChances( { materials = location[ rank.short ] } ) )
				else
					print( "<td class='none'>-</td>" )
				end
			end

			print( "</tr>" )
		end

		print( "</table>" )
	end
%}
