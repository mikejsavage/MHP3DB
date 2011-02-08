<h2>What is this?</h2>

An English (based on Team HGG's translation) info site for Monster Hunter Portable 3rd.


<h2>Can I use your data in my own projects?</h2>

Sure, and to make things easier I've got it all in <a href="http://www.json.org">JSON format</a> <a href="https://github.com/mikejsavage/MHP3DB/tree/master/data">on GitHub</a>.
<br>
You can find docs for it <a href="https://github.com/mikejsavage/MHP3DB/tree/master/data/temp/docs">here</a> (sorry for the lack of completeness)
<br><br>
No need to ask before using or even give credit, I'm not bothered at all.


<h2>GitHub? So I can use your code?</h2>

Sure. It's MIT licensed (in short - do whatever you like so long as you give credit).
<br>
<small>(Also keep in mind that this is the first proper project I've done in Lua)</small>


<br><br><br>

On that note...

<h2>Latest commits</h2>

{%
local MaxCommits = 5
local Months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }

local function dateSuffix( date )
	if date ==  1 or
	   date == 21 or
	   date == 31 then
		return "st"
	end

	if date ==  2 or
	   date == 22 then
		return "nd"
	end

	if date ==  3 or
	   date == 23 then
		return "rd"
	end

	return "th"
end

local function neatDate( ts, now )
	local year  = tonumber( ts:sub( 1, 4 ) )
	local month = tonumber( ts:sub( 6, 7 ) )
	local day   = tonumber( ts:sub( 9, 10 ) )

	local hour = tonumber( ts:sub( 12, 13 ) )
	local mins = tonumber( ts:sub( 15, 16 ) )
	local secs = tonumber( ts:sub( 19, 20 ) )

	local offsetHour = tonumber( ts:sub( 21, 22 ) )
	local offsetMins = tonumber( ts:sub( 24, 25 ) )

	if ts:sub( 20, 20 ) == "-" then
		offsetHour = -offsetHour
		offsetMins = -offsetMins
	end

	-- cba to come up with proper arithmetic for this
	-- so let's do it the lazy and slow way

	local unixTime = os.time( {
		year = year,
		month = month,
		day = day,
		hour = hour - offsetHour,
		min = mins - offsetMins,
		sec = secs
	} )

	local actualTime = os.date( "*t", unixTime )

	return ( "%s at %d:%02d" ):format(
		actualTime.day == now.day
			and "today"
			or ( actualTime.day == now.day - 1
				and "yesterday"
				or ( "on %d%s %s" ):format( actualTime.day, dateSuffix( actualTime.day ), Months[ actualTime.day ] )
			),

		actualTime.hour,
		actualTime.min
	)
end

for i, commit in ipairs( commits.commits ) do
	print( ( [[<h4><a href="http://github.com%s">%s %s</a></h4>]] ):format(
		commit.url,
		commit.author.name,
		neatDate( commit.committed_date, os.date( "*t" ) )
	) )

	print( ( commit.message:gsub( "\n", "<br>" ):gsub( "\\<br>", "\\n" ):gsub( "<", "&lt;" ):gsub( ">", "&gt;" ) ) )

	print( "<br><br>" )

	if i == MaxCommits then
		break
	end
end
%}

<small><a href="https://github.com/mikejsavage/MHP3DB/commits/master">See more on GitHub...</a></small>
