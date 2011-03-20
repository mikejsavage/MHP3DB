Monsters = data( "monsters" )

local function monsterFromName( name )
	for _, monster in ipairs( Monsters ) do
		if urlFromName( monster.name ) == name then
			return monster
		end
	end

	return nil
end


local state = "nothing"

if Get.monster then
	local monster = monsterFromName( Get.monster )

	if monster then
		local monsterInfo = loadTemplate( "monsters/info" )

		header( T( monster.name ) )

		print( monsterInfo( { monster = monster } ) )

		state = "monster"
	end
end

if state == "nothing" then
	grid     = loadTemplate( "monsters/grid" )
	gridCell = loadTemplate( "monsters/gridCell" )

	header( "Monsters" )

	print( grid( { cols = 5 } ) )
end

footer()
