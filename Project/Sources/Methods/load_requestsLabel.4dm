//%attributes = {}


$file:=File:C1566("/RESOURCES/requests.json")
If ($file.exists)
	$json:=JSON Parse:C1218($file.getText())
	
	Use (Storage:C1525)
		Storage:C1525.requestsLabel:=OB Copy:C1225($json; ck shared:K85:29)
	End use 
	
Else 
	ALERT:C41("Requests label file doesn't exist")
End if 