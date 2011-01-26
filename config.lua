DefaultLanguage = "hgg"
TemplatesDir = "templates"
TranslationsDir = "translations"

BaseUrl = ""
CurrentUrl = os.getenv( "REQUEST_URI" ):sub( BaseUrl:len() + 2 )

HeaderLinks =
{
	{
		text =
		{
			hgg = "weapons",
		},
		url = "weapons"
	},
	{
		text =
		{
			hgg = "armory",
		},
		url = "armory"
	},
	--[[{
		text =
		{
			hgg = "sets",
		},
		url = "sets"
	},]]
	{
		text =
		{
			hgg = "items",
		},
		url = "items"
	},
}

Special =
{
	star = "&#9833;",
	note = "&#9834;",
}

-- these are done by eye. I don't really care
-- if they're off because they still look ok
RareColors =
{
	"ffffff",
	"875fff",
	"fafc4f",
	"f08297",
	"5dd030",
	"3581e1",
	"ff2954",
}

NamedColors =
{
	white  = "ffffff",
	gray   = "aaaaaa",
	green  = "6bf36e",
	yellow = "f7f56b",
	orange = "f49e62",
	red    = "ff2954",
	pink   = "f599f0",
	purple = "aa70e0",
	blue   = "718fff",
	cyan   = "a6fcfd",
}
