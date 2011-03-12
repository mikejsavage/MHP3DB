<h2>What is this?</h2>

An English (based on Team HGG's translation) info site for Monster Hunter Portable 3rd.


<h2>Can you add my translation?</h2>

Send it to me in a non-stupid format and sure.


<h2>Can I use your data in my own projects?</h2>

Sure, and to make things easier I've got it all in <a href="http://www.json.org">JSON format</a> <a href="https://github.com/mikejsavage/MHP3DB/tree/master/data">on GitHub</a>.
<br>
You can find docs for it <a href="https://github.com/mikejsavage/MHP3DB/tree/master/data/temp/docs">here</a> (sorry for some of them being poor/missing/incomplete)
<br><br>
No need to ask before using or even give credit, I'm not bothered at all.


<h2>GitHub? So I can use your code?</h2>

Sure, it's <a href="https://github.com/mikejsavage/MHP3DB/blob/master/license.txt">WTFPL licensed</a> so you can do what you like with it.
<br>
<small>(keep in mind that this is the first proper project I've done in Lua and my code is almost certainly awful)</small>


<h2>News</h2>

<table>
	{%
	local MaxPosts = math.min( 5, table.getn( Posts ) )
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

	-- UTC time
	local now = os.time( os.date( "!*t" ) )

	local function postDate( ts, now )
		local delta = os.difftime( now, ts )

		if delta <= 86400 then
			return "Today"
		end

		if delta <= 86400 * 2 then
			return "Yesterday"
		end

		local date = os.date( "*t", ts )

		return ( "%d%s %s" ):format(
			date.day,
			dateSuffix( date.day ),
			Months[ date.month ]
		)
	end

	printf( [[<tr class="post"><td class="date">%s</td><td>%s</td></tr>]], postDate( Posts[ 1 ].date, now ), Posts[ 1 ].content )

	if MaxPosts ~= 1 then
		for i = 2, MaxPosts do
			local post = Posts[ i ]

			printf( [[<tr><td colspan="2"><hr></td></tr><tr class="post"><td class="date">%s</td><td>%s</td></tr>]], postDate( post.date, now ), post.content )
		end
	end
	%}
</table>
