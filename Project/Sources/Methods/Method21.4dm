//%attributes = {}


$step:=60
$terminals:=ds:C1482.Request.terminals
$startTime:=$terminals.first.stmp
$endTime:=$terminals.last.stmp
$result:={process: New collection:C1472()}
$graph:=cs:C1710.Graph.new()




$items:=ds:C1482.Request.all()
$start:=Milliseconds:C459
While ($startTime<$endTime)
	$es:=$items.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+$step))
	$result.process.push($es.distinct("UUID_Process"))
	$startTime+=$step
End while 
$end:=Milliseconds:C459-$start
SET TEXT TO PASTEBOARD:C523(String:C10($end))


