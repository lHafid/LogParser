Class extends DataClass


Function get terminals()->$result : Object
	var $es_requests : Object
	$result:=New object:C1471()
	
	$es_requests:=This:C1470.all().orderBy("stmp")
	
	$result.first:=New object:C1471("date"; $es_requests.first().date; \
		"time"; $es_requests.first().time; "stmp"; $es_requests.first().stmp)
	
	
	$result.last:=New object:C1471("date"; $es_requests.last().date; \
		"time"; $es_requests.last().time; "stmp"; $es_requests.last().stmp)
	
	$result.duration:=New object:C1471("min"; Int:C8((($result.last.date-$result.first.date)*24*60)+(($result.last.time-$result.first.time)/60)); \
		"sec"; Int:C8((($result.last.date-$result.first.date)*24*60*60)+($result.last.time-$result.first.time))\
		)
	
	