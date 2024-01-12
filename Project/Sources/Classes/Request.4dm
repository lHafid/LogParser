Class extends DataClass


Function get terminals()->$result : Object
	var $cache : cs:C1710.CacheEntity
	var $es_requests : Object
	$result:=New object:C1471()
	
	$cache:=ds:C1482.Cache.query("ident == :1"; "terminals").first()
	If ($cache=Null:C1517)
		$cache:=This:C1470.calculateCache()
	End if 
	
	
	$result:=$cache.cache
	$result.duration:=New object:C1471("min"; Int:C8((($result.last.date-$result.first.date)*24*60)+(($result.last.time-$result.first.time)/60)); \
		"sec"; Int:C8((($result.last.date-$result.first.date)*24*60*60)+($result.last.time-$result.first.time))\
		)
	
Function calculateCache()
	$requests:=This:C1470.all().orderBy("stmp")
	$first:=$requests.first()
	$last:=$requests.last()
	
	$cache:=ds:C1482.Cache.new()
	$cache.ident:="terminals"
	$cache.cache:={first: {date: $first.date; time: $first.time; stmp: $first.stmp}; \
		last: {date: $last.date; time: $last.time; stmp: $last.stmp}\
		}
	$cache.save()
	return $cache