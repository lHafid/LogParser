

Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		
		Form:C1466.main.requests:=ds:C1482.Request.all()
		Form:C1466.main.processes:=ds:C1482.Process.all()
		
		Form:C1466.menus:=Form:C1466.main.getMenu()
		Form:C1466.terminals:=ds:C1482.Request.terminals
		
		Form:C1466.metrics:=Form:C1466.main.metrics(Form:C1466.terminals.duration)
		
		Form:C1466.main.hideGraphArea()
	: (FORM Event:C1606.code=On Page Change:K2:54)
		Case of 
			: (FORM Get current page:C276()=1)
				Form:C1466.main.requests:=ds:C1482.Request.all()
				Form:C1466.metrics:=Form:C1466.main.metrics(Form:C1466.terminals.duration)
				
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
				
			: (FORM Get current page:C276()=5)
				$formula:=Formula:C1597(This:C1470.requests.length)
				Form:C1466.tables:=ds:C1482.Table.all().orderByFormula($formula; dk descending:K85:32)
				Form:C1466.metrics:=Form:C1466.main.clearMetrics()
				
			: (FORM Get current page:C276()=6)
				$formula:=Formula:C1597(This:C1470.requests.length)
				//Form.requests:=ds.Request.all().distinct("request"; dk count values).orderBy("count desc")
				
				$requestsNumber:=ds:C1482.Request.all().distinct("request")
				Form:C1466.requests:=New collection:C1472()
				
				For ($i; 0; $requestsNumber.length-1; 1)
					For each ($comp; ds:C1482.Component.all().distinct("name"))
						$requests:=ds:C1482.Request.query("request == :1 and component.name == :2"; $requestsNumber[$i]; $comp)
						//If ($requests.component.length>=2)
						//TRACE
						//End if 
						
						If ($requests.length>0)
							$componentName:=$requests.first().component.name
							$item:=New object:C1471()
							$item.count:=$requests.length
							$item.request:=$requests.first().request
							
							If (String:C10(Form:C1466.main.requestsLabel[$componentName+"_"+String:C10($requestsNumber[$i])])="")
								$item.label:=$componentName+"_"+String:C10($requestsNumber[$i])
							Else 
								$item.label:=String:C10(Form:C1466.main.requestsLabel[$componentName+"_"+String:C10($requestsNumber[$i])])
							End if 
							Form:C1466.requests.push($item)
						End if 
					End for each 
				End for 
				
				
				Form:C1466.requests:=Form:C1466.requests.orderBy("count desc")
				
				Form:C1466.metrics:=Form:C1466.main.clearMetrics()
				
		End case 
		
		
		
		Form:C1466.main.hideGraphArea()
End case 