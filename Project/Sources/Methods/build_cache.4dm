//%attributes = {"preemptive":"capable"}
#DECLARE($ident : Text; $startTime : Integer; $endTime : Integer)
var $e : cs:C1710.CacheEntity
var $graph : cs:C1710.Graph

$start:=Milliseconds:C459

$es:=ds:C1482.Cache.query("ident == :1"; $ident)
$es:=$es.drop()

If ($es.length=0)
	
	$e:=ds:C1482.Cache.new()
	$e.ident:=$ident
	
	$graph:=cs:C1710.Graph.new()
	
	$graphToStore:=New object:C1471()
	$graphToStore.min:=New object:C1471()
	$graphToStore.min.labels:=$graph.lablesLine($startTime; $endTime; 60)
	
	$graphToStore.min.process:=New object:C1471
	$graphToStore.min.user:=New object:C1471
	$graphToStore.min.host:=New object:C1471
	Case of 
		: ($ident="global")
			$es:=ds:C1482.Request.all()
			
			$result:=$graph.lineData($es; $startTime; $endTime; 60; {process: True:C214; user: True:C214; host: True:C214})
			$graphToStore.min.process.data:=$result.process
			$graphToStore.min.user.data:=$result.user
			$graphToStore.min.host.data:=$result.host
			
		: ($ident="process")
			$groups:=ds:C1482.Process_Group.all()
			
			For each ($group; $groups)
				$req:=$group.processes.requests
				
				$result:=$graph.lineData_v2($req; $startTime; $endTime; 60; {process: True:C214; user: True:C214; host: True:C214})
				$graphToStore.min.process[$group.UUID]:=$result.process
				$graphToStore.min.user[$group.UUID]:=$result.user
				$graphToStore.min.host[$group.UUID]:=$result.host
			End for each 
			
		: ($ident="user")
			$users:=ds:C1482.User.all()
			
			For each ($user; $users)
				$req:=$user.processes.requests
				
				$result:=$graph.lineData_v2($req; $startTime; $endTime; 60; {process: True:C214; user: True:C214; host: True:C214})
				$graphToStore.min.process[$user.UUID]:=$result.process
				$graphToStore.min.user[$user.UUID]:=$result.user
				$graphToStore.min.host[$user.UUID]:=$result.host
			End for each 
			
		: ($ident="host")
			$hosts:=ds:C1482.Host.all()
			
			For each ($host; $hosts)
				$req:=$host.processes.requests
				
				$result:=$graph.lineData_v2($req; $startTime; $endTime; 60; {process: True:C214; user: True:C214; host: True:C214})
				$graphToStore.min.process[$host.UUID]:=$result.process
				$graphToStore.min.user[$host.UUID]:=$result.user
				$graphToStore.min.host[$host.UUID]:=$result.host
			End for each 
			
			
	End case 
	
	$e.cache:=$graphToStore
	$e.save()
	
Else 
	ALERT:C41($ident+" Exists and not removed")
End if 

//ALERT($ident+" - "+String(Milliseconds-$start))