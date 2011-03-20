<h2>What is this?</h2>

An English (based on Team HGG's translation) info site for Monster Hunter Portable 3rd.


<h2>Why is so much missing?</h2>

I'm one guy doing this in my spare time.


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


<h2>Thanks to</h2>

<ul>
	<li>Capcom</li>
	<li><a href="http://www.gamefaqs.com/psp/991479-monster-hunter-portable-3rd/faqs/61490?page=0#section12">VioletKira</a> for her explanation on carve data</li>
	<li><a href="http://forums.minegarde.com/user/51-nosuke/">Nosuke</a> for providing ancient charm tables</li>
	<li><a href="http://zedshaw.com/">Zed Shaw</a> for his <a href="http://tir.mongrel2.org/">Tir framework</a> which I used some ideas and template code from</li>
	<li>Gunnil for making a female char so I don't have to play the game twice</li>
</ul>


<h2>News</h2>

<table>
	{%
	local MaxPosts = math.min( 5, table.getn( Posts ) )

	-- TODO: not translation friendly...
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

	local function sameDay( date1, date2 )
		return date1.year == date2.year and date1.yday == date2.yday
	end

	local now       = os.date( "!*t" ) -- ! for UTC
	local yesterday = os.date( "*t", os.time( now ) - 86400 )

	local function postDate( ts )
		local date = os.date( "*t", ts )

		if sameDay( date, now ) then
			return "Today"
		end

		if sameDay( date, yesterday ) then
			return "Yesterday"
		end

		local date = os.date( "*t", ts )

		return ( "%d%s %s" ):format(
			date.day,
			dateSuffix( date.day ),
			Months[ date.month ]
		)
	end

	printf( [[<tr class="post"><td class="date">%s</td><td>%s</td></tr>]], postDate( Posts[ 1 ].date ), Posts[ 1 ].content )

	for i = 2, MaxPosts do
		local post = Posts[ i ]

		printf( [[<tr><td colspan="2"><hr></td></tr><tr class="post"><td class="date">%s</td><td>%s</td></tr>]], postDate( post.date, now ), post.content )
	end
	%}
</table>

{{ defer( "armors", "decorations", "skills", "items", "charms" ) }}
