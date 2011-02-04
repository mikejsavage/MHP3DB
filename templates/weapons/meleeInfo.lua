{%
local pathItemCounts = loadTemplate( "weapons/pathItemCounts" )
%}

<h1>{{ weaponName( { class = class, weapon = weapon } ) }}</h1>

<h2>Stats</h2>

	Attack: {{ weapon.attack }}<br>

	{%
	if weapon.notes then
		print( "Notes: " )

		for _, note in ipairs( weapon.notes ) do
			print( ( "<span class='note%s'>%s</span> " ):format( note, Special.note ) )
		end

		print( "<br>" )
	elseif weapon.shellingType then
		print( ( "Shelling: %s L%d<br>" ):format( weapon.shellingType, weapon.shellingLevel ) )
	elseif weapon.phial then
		print( ( "Phial: %s<br>" ):format( weapon.phial ) )
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

		print( ( "Price: %sz" ):format( commas( weapon.price * 1.5 ) ) )

		if weapon.buyable then
			print( ( " (buyable for %sz)" ):format( commas( weapon.price * 2 ) ) )
		end
	end

	if weapon.improve then
		print( E( "h3", nil, ( "Improve from %s" ):format( weaponNameURL( { class = class, weapon = class.weapons[ weapon.improve.from[ 1 ] ] } ) ) ) )

		print( itemCounts( { materials = weapon.improve.materials } ) )

		print( ( "Price: %sz" ):format( commas( weapon.price ) ) )
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
	-- and i guess it would be a better idea to put this in genWeapons
	
	local function newPath()
		return { path = { }, price = 0, materials = { } }
	end

	local function forkPath( oldPath )
		return table.copy( oldPath )
	end

	local function pathAddWeapon( path, currWeapon )
		table.insert( path.path, 1, currWeapon )
	end

	local function pathAddPrice( path, price )
		path.price = path.price + price
	end

	local function pathAddMaterials( path, materials )
		for _, material in ipairs( materials ) do
			if path.materials[ material.id ] then
				path.materials[ material.id ] = path.materials[ material.id ] + material.count
			else
				path.materials[ material.id ] = material.count
			end
		end
	end

	local function upgradePaths( currWeapon, paths, currPath, pathStart )
		-- init paths array
		if not paths then
			currPath = newPath()

			paths = { }

			pathStart = currWeapon
		end

		-- note to future self:
		-- can't group the id ~= start ifs into one
		-- if you don't believe me then think about it
		-- think harder if you still don't

		if currWeapon ~= pathStart and currWeapon.create then
			local new = nil

			-- should we keep going in a separate path?
			if currWeapon.improve then
				-- fork before ending old path as we don't want it
				new = forkPath( currPath )
			end

			-- end current path
			currPath.from = currWeapon

			pathAddWeapon( currPath, currWeapon )
			pathAddPrice( currPath, currWeapon.price * 1.5 )
			pathAddMaterials( currPath, currWeapon.create )
			
			table.insert( paths, currPath )

			-- if we forked then let's get recursing
			if new then
				-- this set of parameters is basically jumping it
				-- to the "elseif weapon.improve" block

				upgradePaths( currWeapon, paths, new, currWeapon )
			end
		elseif currWeapon ~= pathStart and not currWeapon.improve then
			-- this happens with free weapons like barbarian blade in tri
			-- simply set path.from = currId
			-- and end it here because this isn't an upgrade
			--
			-- not sure this is needed for p3
		elseif currWeapon.improve then
			-- continue current path

			pathAddWeapon( currPath, currWeapon )
			pathAddPrice( currPath, currWeapon.price )
			pathAddMaterials( currPath, currWeapon.improve.materials )


			-- continue path for every upgrade
			-- this was added for the lightcrystal weapons in tri
			-- i've not got far enough to know if this is still needed

			-- unroll for first path
			upgradePaths( class.weapons[ currWeapon.improve.from[ 1 ] ], paths, currPath, pathStart )

			-- TODO: some special handling for paths > 1 but i forget what
			--[[for i = 2, table.getn( currWeapon.improve.from ) do
				local new = forkPath( currPath )

				upgradePaths( class.weapons[ currWeapon.improve.from[ i ] ], paths, new, pathStart )
			end]]
		else
			-- or the current weapon is the one we started with and
			-- we can't go anywhere with it - so there's no point
			-- doing anything with it

			-- making sure this is correct
			assert( currWeapon == pathStart and not currWeapon.improve, "not handling some case in upgradePaths: " .. currWeapon.name.hgg .. " (started from " .. pathStart.name.hgg .. ")" )
		end

		return paths
	end

	local paths = upgradePaths( weapon )

	for _, path in ipairs( paths ) do
		print( ( "<h3>Create from %s</h3>" ):format( weaponNameURL( { class = class, weapon = path.from } ) ) )

		print( "Path: " )

		local len = table.getn( path.path )
		local lastUpgrades = 0

		for i = 1, len do
			if i == 1 or lastUpgrades > 1 or i == len then
				print( weaponNameURL( { class = class, weapon = path.path[ i ] } ) )

				if i ~= len then
					print( ( " %s " ):format( Special.arrow ) )
				end
			end

			lastUpgrades = path.path[ i ].upgrades and table.getn( path.path[ i ].upgrades ) or 0
		end

		print( "<br>" )

		print( pathItemCounts( { materials = path.materials } ) )

		print( ( "Price: %sz" ):format( commas( path.price ) ) )
	end
	%}
