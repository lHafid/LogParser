

Case of 
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		Form:C1466.main.requests:=ds:C1482.Request.query("request in :1"; Form:C1466.requests_selected.distinct("request"))
		Form:C1466.main.processes:=Form:C1466.main.requests.process
		Form:C1466.metrics:=Form:C1466.main.metrics(Form:C1466.terminals.duration)
		Form:C1466.main.hideGraphArea()
End case 

