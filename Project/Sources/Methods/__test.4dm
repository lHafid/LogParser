//%attributes = {"preemptive":"capable"}

//TRUNCATE TABLE([Cache])

$startTime:=658628341
$endTime:=658835190


$users:=ds:C1482.User.all()
$graph:=cs:C1710.Graph.new()
$stepLink:=$graph.stepLink("usersByMin")

$graphToStore:=New object:C1471()
$graphToStore.byMin:=New object:C1471()

$e:=ds:C1482.Cache.new()
$e.ident:="user"

$graphToStore.byMin.labels:=$graph.lablesLine($startTime; $endTime; $stepLink)
$graphToStore.byMin.data:=New object:C1471()
For each ($user; $users)
	$graphToStore.byMin.data[$user.UUID]:=$graph.lineData($user.processes.requests; $startTime; $endTime; $stepLink)
End for each 

$e.graph:=$graphToStore
$e.save()



