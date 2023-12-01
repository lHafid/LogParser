//%attributes = {"preemptive":"capable"}


//TRUNCATE TABLE([Table_1])
//FLUSH CACHE(*)


$start:=Milliseconds:C459

If (False:C215)
	
	For ($i; 1; 20000000)
		$a:=$i*200
		$b:=$a*5
		$max1:=5000
	End for 
	
	For ($i; 20000001; 40000000)
		$a:=$i*200
		$b:=$a*5
		$max2:=5000
	End for 
	
	For ($i; 40000001; 60000000)
		$a:=$i*200
		$b:=$a*5
		$max3:=5000
	End for 
	
	For ($i; 60000001; 80000000)
		$a:=$i*200
		$b:=$a*5
		$max4:=5000
	End for 
	
	For ($i; 80000001; 100000000)
		$a:=$i*200
		$b:=$a*5
		$max5:=5000
	End for 
	
	$moyenn:=($max1+$max2+$max3+$max4+$max5)/5
	
Else 
	
	$signal:=New signal:C1641()
	
	Use (Storage:C1525)
		Storage:C1525.col:=New shared collection:C1527()
	End use 
	
	Use (Storage:C1525.col)
		$proc:=New process:C317("DB_test_ManyProc"; 0; "process 1"; 1; 20000000; $signal)
		Storage:C1525.col.push($proc)
	End use 
	
	Use (Storage:C1525.col)
		$proc:=New process:C317("DB_test_ManyProc"; 0; "process 2"; 20000001; 40000000; $signal)
		Storage:C1525.col.push($proc)
	End use 
	
	Use (Storage:C1525.col)
		$proc:=New process:C317("DB_test_ManyProc"; 0; "process 3"; 40000001; 60000000; $signal)
		Storage:C1525.col.push($proc)
	End use 
	
	Use (Storage:C1525.col)
		$proc:=New process:C317("DB_test_ManyProc"; 0; "process 4"; 60000001; 80000000; $signal)
		Storage:C1525.col.push($proc)
	End use 
	
	Use (Storage:C1525.col)
		$proc:=New process:C317("DB_test_ManyProc"; 0; "process 5"; 80000001; 100000000; $signal)
		Storage:C1525.col.push($proc)
	End use 
	
	$signal.wait()
	
	$moyenn:=$signal.obj.average()
	
End if 

ALERT:C41(String:C10(Milliseconds:C459-$start))
ALERT:C41(String:C10($moyenn))