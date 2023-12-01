

Case of 
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		Form:C1466.main.set_es_request(Form:C1466.groups_selected.processes.requests)
		Form:C1466.metrics:=Form:C1466.main.es_request.metrics(Form:C1466.terminals.duration)
		Form:C1466.main.hideGraphArea()
End case 

