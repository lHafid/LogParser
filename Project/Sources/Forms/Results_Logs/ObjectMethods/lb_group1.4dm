

Case of 
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		Form:C1466.main.requests:=Form:C1466.users_selected.processes.requests
		Form:C1466.main.processes:=Form:C1466.users_selected.processes
		Form:C1466.metrics:=Form:C1466.main.metrics(Form:C1466.terminals.duration)
		Form:C1466.main.hideGraphArea()
End case 

