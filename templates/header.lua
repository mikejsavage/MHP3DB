{%
local headerLink = loadTemplate( "headerLink" )
%}
<!DOCTYPE HTML>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="{{ C( "css/common.css" ) }}">
		<link rel="shortcut icon" href="{{ U( "favicon.ico" ) }}">

		<title>{{ title and title .. " - " or "" }}P3DB</title>
	</head>

	<body>
		<div class="header">
			<a href="{{ U( "" ) }}" class="home">p3db</a>

			<div class="nav">
				{%
				for _, link in ipairs( HeaderLinks ) do
					print( headerLink( { link = link } ) )
				end
				%}

				<div class="calcs">
					{%
					for _, link in ipairs( HeaderCalcs ) do
						print( headerLink( { link = link } ) )
					end
					%}
				</div>
			</div>
		</div>

		<div class="wrapper">
			<div class="curve L">&nbsp;</div>
			<div class="curve R">&nbsp;</div>

			<div class="main">
				<div class="tip">{{ table.random( Tips ) }}</div>
