<!DOCTYPE HTML>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="{{ U( "css/common.css" ) }}">

		<link rel="shortcut icon" href="{{ U( "favicon.ico" ) }}">

		<title>{{ title and title .. " - " or "" }}3rdDB</title>
	</head>

	<body>
		<header>
			<a href="{{ U( "" ) }}" class="home">3rddb</a>

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
