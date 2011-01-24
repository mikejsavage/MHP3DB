{%
for _, material in ipairs( materials ) do
	local item = Items[ material.id ]
	%}

	{{ item.name }} x{{ material.count }}

	{%
end
%}
