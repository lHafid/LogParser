//%attributes = {}


$es:=ds:C1482.Process_Group.all()
For each ($e; $es)
	$e.name:=Substring:C12(String:C10($e.name); 2; Length:C16(String:C10($e.name))-2)
	$result:=$e.save()
	If ($result.success=False:C215)
		TRACE:C157
	End if 
End for each 

$es:=ds:C1482.Host.all()
For each ($e; $es)
	$e.name:=Substring:C12(String:C10($e.name); 2; Length:C16(String:C10($e.name))-2)
	$result:=$e.save()
	If ($result.success=False:C215)
		TRACE:C157
	End if 
End for each 

$es:=ds:C1482.User.all()
For each ($e; $es)
	$e.name:=Substring:C12(String:C10($e.name); 2; Length:C16(String:C10($e.name))-2)
	$result:=$e.save()
	If ($result.success=False:C215)
		TRACE:C157
	End if 
End for each 

$es:=ds:C1482.Component.all()
For each ($e; $es)
	$e.name:=Substring:C12(String:C10($e.name); 2; Length:C16(String:C10($e.name))-2)
	$result:=$e.save()
	If ($result.success=False:C215)
		TRACE:C157
	End if 
End for each 



ALERT:C41("ok")