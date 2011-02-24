{%
local headerLink = loadTemplate( "headerLink" )
%}

<!DOCTYPE HTML>

<html>
	<head>
		<meta http-equiv="Content-type" content="text/html;charset=utf-8">

		<link rel="stylesheet" type="text/css" href="{{ C( "css/common.css" ) }}">
		<link rel="shortcut icon" href="{{ U( "favicon.ico" ) }}">

		<title>{{ title and title .. " - " or "" }}3rdDB</title>
	</head>

	<body>
		<header>
			<a href="{{ U( "" ) }}" class="home">3rddb</a>

			<nav>
				{%
				for _, link in ipairs( HeaderLinks ) do
					print( headerLink( { text = link.text.hgg, url = link.url } ) )
				end
				%}

				<div class="calcs">
					{%
					for _, link in ipairs( HeaderCalcs ) do
						print( headerLink( { text = link.text.hgg, url = link.url } ) )
					end
					%}
				</div>
			</nav>
		</header>

		<div class="wrapper">
			<div class="curve L">&nbsp;</div>
			<div class="curve R">&nbsp;</div>

			<div class="main">
