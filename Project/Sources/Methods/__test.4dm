//%attributes = {"preemptive":"capable"}


$startTime:=658628341
$endTime:=658835190


$col:=New collection:C1472()

$s:=Milliseconds:C459
While ($startTime<$endTime)
	$t1:=Milliseconds:C459
	
	$es:=ds:C1482.Request.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+60))
	$col.push({p: $es.process.length; req: $es.length; time: Milliseconds:C459-$t1})
	
	$startTime+=60
End while 
$e:=Milliseconds:C459-$s

ALERT:C41(String:C10($e))
SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($col; *))