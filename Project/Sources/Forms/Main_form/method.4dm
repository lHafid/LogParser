

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		$es:=ds:C1482.Request.all().orderBy("date, time")
		Form:C1466.first:=$es.first()
		Form:C1466.last:=$es.last()
		
		Use (Storage:C1525)
			Storage:C1525.startEndTime:=New shared object:C1526("startTime"; Form:C1466.first.time; "endTime"; Form:C1466.last.time)
		End use 
		
		$formula:=Formula:C1597(This:C1470.processes.requests.length)
		Form:C1466.groups:=ds:C1482.Process_Group.all().orderByFormula($formula; dk descending:K85:32)
		
End case 