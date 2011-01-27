<img src="{%
local form = color and "icon.cgi?icon=%s.png&color=%s" or "%s.png"

print( U( "data/img/icons/" .. form:format( icon, color ) ) )
%}" class="icon">
