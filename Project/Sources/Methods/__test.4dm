//%attributes = {"preemptive":"capable"}

//TRUNCATE TABLE([Cache])

$startTime:=658628341
$endTime:=658835190


$groups:=ds:C1482.Process_Group.all()
$graph:=cs:C1710.Graph.new()
$stepLink:=$graph.stepLink("procByMin")

$graphToStore:=New object:C1471()
$graphToStore.byMin:=New object:C1471()

$e:=ds:C1482.Cache.new()
$e.ident:="process"

$graphToStore.byMin.labels:=$graph.lablesLine($startTime; $endTime; $stepLink)
$graphToStore.byMin.data:=New object:C1471()
For each ($group; $groups)
	$graphToStore.byMin.data[$group.UUID]:=$graph.lineData($group.processes.requests; $startTime; $endTime; $stepLink)
End for each 

$e.graph:=$graphToStore
$e.save()




//$e:=ds.Cache.new()
//$e.ident:="process"

//$graph:=cs.Graph.new()
//$stepLink:=$graph.stepLink("procByMin")

//$graphToStore:=New object()
//$graphToStore.byMin:=New object()



//$graphToStore.byMin.datasets:=[{data: $graph.lineData(ds.Request.all(); $startTime; $endTime; $stepLink)}]
//$graphToStore.byMin.labels:=$graph.lablesLine($startTime; $endTime; $stepLink)

//$e.graph:=$graphToStore
//$e.save()