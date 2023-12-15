//%attributes = {"preemptive":"capable"}


$cores:=4
$requests:=ds:C1482.Request.all()

$pas:=Int:C8($requests.length/$cores)



$signal:=New signal:C1641
Use ($signal)
	$signal.result:=New shared collection:C1527()
	$signal.cores:=$cores
End use 
For ($i; 0; $cores-1)
	$start:=$i*$pas
	If ($i=3)
		$end:=$requests.length
	Else 
		$end:=$pas+($i*$pas)
	End if 
	
	$es:=$requests.slice($start; $end)
	$proc:=New process:C317("_test"; 0; "_test"; $es; $i; $signal)
End for 

$signal.wait()

$e:=Milliseconds:C459-$s
ALERT:C41(String:C10($e))









//TRACE

//$startTime:=658628341
////$startTime:=1
//$endTime:=658835190
////$endTime:=$startTime+1000

//$cores:=4
//$requests:=ds.Request.all()

//$delta:=$endTime-$startTime
//$pas:=Int($delta/$cores)

//While (Mod($pas; 60)#0)
//$pas+=1
//End while 

//$s:=Milliseconds
//$signal:=New signal
//Use ($signal)
//$signal.result:=New shared collection()
//$signal.cores:=$cores
//End use 
//For ($i; 0; $cores-1)
//$start:=$startTime+($i*$pas)
//If ($i=3)
//$end:=$endTime
//Else 
//$end:=$startTime+($i*$pas)+$pas
//End if 
//$proc:=New process("_test"; 0; "calculateGraph"; $requests; $start; $end; $i; $signal)
//End for 

//$signal.wait()


//$data:=$signal.result.orderBy("order")
//$dataConsolidated:=New object("labels"; New collection(); "datasets"; New collection())
//For each ($d; $data)

//$dataConsolidated.labels:=$dataConsolidated.labels.concat($d.labels)
//$dataConsolidated.datasets:=$dataConsolidated.datasets.concat($d.datasets)

//End for each 

//$e:=Milliseconds-$s
//ALERT(String($e))
