<!DOCTYPE HTML>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/common.css">

		<link rel="shortcut icon" href="favicon.ico">

		<title>{{ title and title .. " - " or "" }}P3DB</title>
	</head>

	<body>
		<header>
			<a href="{{ U( "" ) }}" class="home">p3db</a>

			<nav>
				{%
				local headerLink = loadTemplate( "headerLink" )

				for _, link in ipairs( HeaderLinks ) do
					print( headerLink( { text = link.text.hgg, url = link.url } ) )
				end
				%}
			</nav>
		</header>

		<div class="wrapper">
			<div class="curve L">&nbsp;</div>
			<div class="curve R">&nbsp;</div>

			<div class="main">
