

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.main.set_es_request(ds:C1482.Request.all())
		Form:C1466.menus:=Form:C1466.main.getMenu()
		Form:C1466.terminals:=ds:C1482.Request.getTerminals_dateTime()
		Form:C1466.metrics:=Form:C1466.main.es_request.metrics(Form:C1466.terminals.duration)
		Form:C1466.main.hideGraphArea()
	: (FORM Event:C1606.code=On Page Change:K2:54)
		Case of 
			: (FORM Get current page:C276()=1)
				Form:C1466.main.set_es_request(ds:C1482.Request.all())
				Form:C1466.metrics:=Form:C1466.main.es_request.metrics(Form:C1466.terminals.duration)
				
			: (FORM Get current page:C276()=2)
				$formula:=Formula:C1597(This:C1470.processes.requests.length)
				Form:C1466.groups:=ds:C1482.Process_Group.all().orderByFormula($formula; dk descending:K85:32)
				Form:C1466.metrics:=Form:C1466.main.clearMetrics()
				
			: (FORM Get current page:C276()=3)
				$formula:=Formula:C1597(This:C1470.processes.requests.length)
				Form:C1466.users:=ds:C1482.User.all().orderByFormula($formula; dk descending:K85:32)
				Form:C1466.metrics:=Form:C1466.main.clearMetrics()
				
			: (FORM Get current page:C276()=4)
				$formula:=Formula:C1597(This:C1470.processes.requests.length)
				Form:C1466.hosts:=ds:C1482.Host.all().orderByFormula($formula; dk descending:K85:32)
				Form:C1466.metrics:=Form:C1466.main.clearMetrics()
		End case 
		
		
		
		Form:C1466.main.hideGraphArea()
End case 