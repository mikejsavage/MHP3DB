<img src="{{ U( "data/img/icons/" ..
	( color
		and ( "%s_%s.png" ):format( icon, color )
		or  ( "%s.png" ):format( icon ) )
	)
}}" class="icon">