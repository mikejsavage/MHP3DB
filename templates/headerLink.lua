<a {%
	if CurrentUrl:startsWith( link.url ) then
		print( [[class="cur" ]] )
	end
%}href="{{ U( link.url ) }}" title="{{ T( link.title ) }}">{{ T( link.text ) }}</a>