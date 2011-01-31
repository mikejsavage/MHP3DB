<h1>{{ weaponName( { class = class, weapon = weapon } ) }}</h1>


<h2>Stats</h2>

	Attack: {{ weapon.attack }}<br>
	TATP: ?<br>

	{%
	if weapon.notes then
		print( "Notes: " )

		for _, note in ipairs( weapon.notes ) do
			print( ( "<span class='note%s'>%s</span> " ):format( note, Special.note ) )
		end

		print( "<br>" )
	end
	%}

	{%
	if weapon.element then
		print( ( "Element: <span class='elem%s'>%d</span><br>" ):format( weapon.element, weapon.elemAttack ) )
	end
	%}

	Sharpness: {{ weapon.sharpness and sharpness( { sharpness = weapon.sharpness } ) or "?" }}<br>

	Affinity:
	{%
	if weapon.affinity ~= 0 then
		E( "span", weapon.affinity > 0 and "pos" or "neg", weapon.affinity )
	else
		print( weapon.affinity )
	end
	%}%<br>

	Slots: {{ weapon.slots == 0 and "none" or ( "O" ):rep( weapon.slots ) }}<br>
	Rarity: <span class="rare{{ weapon.rarity }}">{{ weapon.rarity }}</span>


<h2>Crafting</h2>

	{%
	if weapon.create then
		print( E( "h3", nil, "Create" ) )

		print( itemCounts( { materials = weapon.create } ) )

		print( ( "Price: %dz" ):format( weapon.price * 1.5 ) )

		if weapon.buyable then
			print( ( " (buyable for %dz)" ):format( weapon.price * 2 ) )
		end
	end

	if weapon.improve then
		print( E( "h3", nil, ( "Improve from %s" ):format( weaponNameURL( { class = class, weapon = class.weapons[ weapon.improve.from[ 1 ] ] } ) ) ) )

		print( itemCounts( { materials = weapon.improve.materials } ) )

		print( ( "Price: %dz" ):format( weapon.price ) )
	end

	if weapon.scraps then
		print( E( "h3", nil, "Scraps" ) )

		print( itemCounts( { materials = weapon.scraps } ) )
	end

	if weapon.upgrades then
		print( E( "h3", nil, "Upgrades into" ) )

		for _, id in ipairs( weapon.upgrades ) do
			print( ( "%s<br>" ):format( weaponNameURL( { class = class, weapon = class.weapons[ id ] } ) ) )
		end
	end


	-- the following code is not simple
	
	local function newPath()
		return { path = { }, price = 0, materials = { } }
	end

	local function forkPath( oldPath )
		return table.copy( oldPath )
	end

	local function pathAddWeapon( path, currId )
		table.insert( path.path, currId, 0 )
	end

	local function pathAddPrice( path, currWeapon )
		path.price = path.price + currWeapon.price
	end

	local function pathAddMaterials( path, materials )
		for _, material in materials do
			if path.materials[ material.id ] then
				path.materials[ material.id ] = path.materials[ material.id ] + material.count
			else
				path.materials[ material.id ] = material.count
			end
		end
	end

	local function upgradePaths( currId, paths, currPath, pathStart )
		-- init paths array
		if not paths then
			currPath = newPath()

			paths = { currPath }
		end

		if not pathStart then
			pathStart = currId
		end

		local currWeapon = class.weapons[ currId ]

		-- note to future self:
		-- can't group the id ~= start ifs into one
		-- if you don't believe me then think about it
		-- think harder if you still don't

		if id ~= start and weapon.create then
			local new = nil

			-- should we keep going in a separate path?
			if weapon.improve then
				-- fork before ending old path as we don't want it
				new = forkPath( currPath )
			end

			-- end current path
			currPath.from = currId

			pathAddWeapon( currPath, currId )
			pathAddPrice( currPath, currWeapon.price )
			pathAddMaterials( currPath, currWeapon.create )
			
			table.insert( paths, currPath )

			-- if we forked then let's get recursing
			if new then
				-- this set of parameters is basically jumping it
				-- to the "elseif weapon.improve" block

				upgradePaths( currId, paths, currId, currId )
			end
		elseif id ~= start and not weapon.improve then
			-- this happens with free weapons like barbarian blade in tri
			-- simply set path.from = currId
			-- and end it here because this isn't an upgrade
		elseif weapon.improve then
			-- continue current path

			pathAddWeapon( currPath, currId )
			pathAddPrice( currPath, currWeapon.price )
			pathAddMaterials( currPath, currWeapon.improve.materials )


			-- continue path for every upgrade
			-- this was added for the lightcrystal weapons in tri
			-- i've not got far enough to know if this is still needed

			for _, from in ipairs( weapon.improve.from ) do
				-- TODO: cba, do tomorrow
			end
		elseif currId == pathStart and not weapon.improve then
			-- or the current weapon is the one we started with and
			-- we can't go anywhere with it - so there's no point
			-- doing anything with it
		else
			-- making sure this is correct
			assert( nil, "not handling some case in upgradePaths: " .. currWeapon.name.hgg .. " (started from " .. class.weapons[ pathStart ].name.hgg .. ")" )
		end

		return paths
	end
	%}
