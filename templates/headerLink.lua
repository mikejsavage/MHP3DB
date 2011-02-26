<a {{ CurrentUrl:startsWith( link.url ) and "class='cur' " or "" }}href="{{ U( link.url ) }}" title="{{ T( link.title ) }}">{{ T( link.text ) }}</a>
