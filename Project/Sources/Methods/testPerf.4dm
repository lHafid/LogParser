//%attributes = {"preemptive":"capable"}

C_OBJECT:C1216($1; $es_tmp)
C_OBJECT:C1216($2; $signal)

$es_tmp:=$1
$signal:=$2

FLUSH CACHE:C297(*)


$start:=Milliseconds:C459

If (Count parameters:C259=0)
	$es:=ds:C1482.Request.all()
	$range:=Int:C8($es.length/5)
	
	
	Use (Storage:C1525)
		Storage:C1525.proc:=New shared collection:C1527()
		Storage:C1525.sum:=New shared collection:C1527()
	End use 
	
	$signal:=New signal:C1641()
	For ($i; 0; 5; 1)
		$tmp:=$es.slice($i*$range; ($i*$range)+$range)
		$proc:=New process:C317(Current method name:C684; 0; "testPerf"+String:C10($i); $tmp; $signal)
		
		Use (Storage:C1525.proc)
			Storage:C1525.proc.push($proc)
		End use 
	End for 
	
	$signal.wait()
	
	ALERT:C41(String:C10(Milliseconds:C459-$start))
	TRACE:C157
Else 
	
	$sumDBMG:=0
	$sumSQL:=0
	$sumSRV:=0
	For each ($e; $es_tmp)
		Case of 
			: (Replace string:C233($e.component.name; "'"; "")="dbmg")
				$sumDBMG:=$sumDBMG+1
				
			: (Replace string:C233($e.component.name; "'"; "")="srv4")
				$sumSRV:=$sumSRV+1
				
			: (Replace string:C233($e.component.name; "'"; "")="sqls")
				$sumSQL:=$sumSQL+1
				
		End case 
	End for each 
	
	
	Use (Storage:C1525.sum)
		Storage:C1525.sum.push(New shared object:C1526("label"; "dbmg"; "count"; $sumDBMG))
		Storage:C1525.sum.push(New shared object:C1526("label"; "srv4"; "count"; $sumSRV))
		Storage:C1525.sum.push(New shared object:C1526("label"; "SQL"; "count"; $sumSQL))
	End use 
	
	Use (Storage:C1525.proc)
		
		$index:=Storage:C1525.proc.indexOf(Current process:C322)
		If ($index#-1)
			Storage:C1525.proc.remove($index)
		End if 
		If (Storage:C1525.proc.length=0)
			$signal.trigger()
		End if 
	End use 
	
End if 


