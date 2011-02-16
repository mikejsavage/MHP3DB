{{ icon( "items/" .. ( item.icon and item.icon or "garbage" ), item.color or "white" ) }} <a href="{{ U( ( "items/%s" ):format( urlFromName( item.name ) ) ) }}">{{ T( item.name ) }}</a>
