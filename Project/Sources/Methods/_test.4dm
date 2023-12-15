//%attributes = {"preemptive":"capable"}
#DECLARE($requests : cs:C1710.RequestSelection; $order : Integer; $signal : 4D:C1709.Signal)->$data : Object

$stmps:=$requests.extract("stmp")

Use ($signal.result)
	$signal.result.push(1)
End use 

If ($signal.result.length=$signal.cores)
	$signal.trigger()
End if 









//#DECLARE($requests : cs.RequestSelection; $start : Integer; $end : Integer; $order : Integer; $signal : 4D.Signal)->$data : Object


//$data:=New object("labels"; New collection(); "datasets"; New collection(); "order"; $order)

//Repeat 
//$es:=$requests.query("stmp >= :1 and stmp < :2"; $start; ($start+60))
//$data.labels.push(String(explo_stmp_read_time($start)))
//$data.datasets.push($es.process.length)
//$start+=60
//Until ($start>=$end)



//Use ($signal.result)
//$signal.result.push(OB Copy($data; ck shared; $signal.result))
//End use 

//If ($signal.result.length=$signal.cores)
//$signal.trigger()
//End if 