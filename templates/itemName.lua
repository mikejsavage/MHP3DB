{{ icon( "items/" .. ( item.icon and item.icon or "garbage" ), item.color or "ffffff" ) }} <a href="{{ U( ( "items/%s" ):format( item.name.hgg:urlEscape() ) ) }}">{{ T( item.name ) }}</a>
