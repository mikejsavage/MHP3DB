<h1>{{ T( weapon.name ) }}</h1>


<h2>Stats</h2>

	Attack: {{ weapon.attack }}<br>
	TATP: ?<br>
	Sharpness: ?<br>

	Affinity:
	{% if weapon.affinity ~= 0 then %}
		<span class="{{ weapon.affinity > 0 and "pos" or "neg" }}">
			{{ weapon.affinity }}
		</span>
	{% else %}
		{{ weapon.affinity }}
	{% end %}%<br>

	Slots: {{ weapon.slots == 0 and "none" or ( "O" ):rep( weapon.slots ) }}<br>
	Rarity: <span class="rare{{ weapon.rarity }}">{{ weapon.rarity }}</span>


<h2>Crafting</h2>

	Price: {{ weapon.price }}z

	{% if weapon.create then %}
		<h3>Create</h3>

		{% for _, material in ipairs( weapon.create ) do %}
			{{ T( Items[ material.id ].name ) }} x{{ material.count }}<br>
		{% end %}
	{% end %}

	{% if weapon.improve then %}
		<h3>Improve from {{ T( class.weapons[ weapon.improve.from[ 1 ] ].name ) }}</h3>

		{% for _, material in ipairs( weapon.improve.materials ) do %}
			{{ T( Items[ material.id ].name ) }} x{{ material.count }}<br>
		{% end %}
	{% end %}

	{% if weapon.upgrades then %}
		<h3>Upgrades into</h3>

		{% for _, id in ipairs( weapon.upgrades ) do %}
			{{ T( class.weapons[ id ].name ) }}<br>
		{% end %}
	{% end %}
