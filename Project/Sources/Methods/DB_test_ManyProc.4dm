//%attributes = {"preemptive":"capable"}
C_OBJECT:C1216($signal; $3)

$start:=$1
$end:=$2
$signal:=$3

For ($i; $start; $end)
	$a:=$i*200
	$b:=$a*5
	$max5:=5000
End for 

Use ($signal)
	$signal.obj:=New shared collection:C1527()
	$signal.obj.push($max5)
End use 

Use (Storage:C1525.col)
	$index:=Storage:C1525.col.indexOf(Current process:C322)
	If ($index#-1)
		Storage:C1525.col.remove($index)
	End if 
	If (Storage:C1525.col.length=0)
		$signal.trigger()
	End if 
End use 