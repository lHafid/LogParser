Class constructor($formName : Text)
	
	This:C1470._requestLabels()
	$formData:=New object:C1471("main"; This:C1470)
	$ref:=Open form window:C675($formName)
	DIALOG:C40($formName; $formData)
	CLOSE WINDOW:C154($ref)
	
	
	
Function getMenu()
	$menus:=New collection:C1472()
	
	$menu:=New object:C1471()
	$menu.ident:="global"
	$menu.label:="Global"
	$menu.page:=1
	$menus.push($menu)
	
	$menu:=New object:C1471()
	$menu.label:="By Process"
	$menu.ident:="process"
	$menu.fk:="UUID_Process_Group"
	$menu.page:=2
	$menus.push($menu)
	
	$menu:=New object:C1471()
	$menu.label:="By user"
	$menu.ident:="user"
	$menu.fk:="UUID_User"
	$menu.page:=3
	$menus.push($menu)
	
	$menu:=New object:C1471()
	$menu.ident:="host"
	$menu.label:="By host"
	$menu.fk:="UUID_Host"
	$menu.page:=4
	$menus.push($menu)
	
	return $menus
	
	
Function metrics($duration : Object)
	$bytesOutSum:=This:C1470.processes.sum("bytes_out")
	$bytesInSum:=This:C1470.processes.sum("bytes_in")
	$bytesSum:=$bytesOutSum+$bytesInSum
	
	
	$metrics:=New object:C1471()
	$metrics.durationMin:=New object:C1471("value"; $duration.min; "label"; "Duration min")
	$metrics.durationSec:=New object:C1471("value"; $duration.sec; "label"; "Duration sec")
	$metrics.totalReq:=New object:C1471("value"; This:C1470.requests.length; "label"; "Total req")
	$metrics.reqPerMin:=New object:C1471("value"; Int:C8(This:C1470.requests.length/$duration.min); "label"; "Req/min")
	$metrics.reqPerSec:=New object:C1471("value"; Int:C8(This:C1470.requests.length/$duration.sec); "label"; "Req/sec")
	$metrics.byetsOut:=New object:C1471("value"; $bytesOutSum; "label"; "Bytes Out")
	$metrics.bytesIn:=New object:C1471("value"; $bytesInSum; "label"; "Bytes In")
	$metrics.totalBytes:=New object:C1471("value"; $bytesSum; "label"; "Bytes total")
	$metrics.bytesOutPerSec:=New object:C1471("value"; Int:C8($bytesOutSum/$duration.sec); "label"; "Bytes Out/sec")
	$metrics.bytesInPerSec:=New object:C1471("value"; Int:C8($bytesInSum/$duration.sec); "label"; "Bytes In/sec")
	$metrics.bytesOutPerMin:=New object:C1471("value"; Int:C8($bytesOutSum/$duration.min); "label"; "Bytes Out/min")
	$metrics.bytesInPerMin:=New object:C1471("value"; Int:C8($bytesInSum/$duration.min); "label"; "Bytes In/min")
	$metrics.byetsPerMin:=New object:C1471("value"; Int:C8($bytesSum/$duration.min); "label"; "Bytes/min")
	$metrics.byetsPerSec:=New object:C1471("value"; Int:C8($bytesSum/$duration.sec); "label"; "Bytes/sec")
	$metrics.totalProcesses:=New object:C1471("value"; This:C1470.requests.process.length; "label"; "Processes total")
	$metrics.processesPerSec:=New object:C1471("value"; This:C1470.requests.process.length/$duration.sec; "label"; "Processes/sec")
	$metrics.processesPerMin:=New object:C1471("value"; This:C1470.requests.process.length/$duration.min; "label"; "Processes/min")
	$metrics.totalUsers:=New object:C1471("value"; This:C1470.requests.process.user.length; "label"; "Uers total")
	$metrics.usersPerSec:=New object:C1471("value"; This:C1470.requests.process.user.length/$duration.sec; "label"; "Users/sec")
	$metrics.usersPerMin:=New object:C1471("value"; This:C1470.requests.process.user.length/$duration.min; "label"; "Users/min")
	$metrics.totalHosts:=New object:C1471("value"; This:C1470.requests.process.host.length; "label"; "Hosts total")
	$metrics.hostsPerSec:=New object:C1471("value"; This:C1470.requests.process.host.length/$duration.sec; "label"; "Hosts/sec")
	$metrics.hostsPerMin:=New object:C1471("value"; This:C1470.requests.process.host.length/$duration.min; "label"; "Hosts/min")
	
	return $metrics
	
	
Function _requestLabels()
	$file:=File:C1566("/RESOURCES/requests.json")
	If ($file.exists)
		$json:=JSON Parse:C1218($file.getText())
		This:C1470.requestsLabel:=New object:C1471()
		For each ($comp; $json)
			For each ($reqNbr; $json[$comp])
				This:C1470.requestsLabel[$comp+"_"+$reqNbr]:=$json[$comp][$reqNbr]
			End for each 
		End for each 
	Else 
		ALERT:C41("Requests label file doesn't exist")
	End if 
	
Function graphsType()
	
	$menu:=Create menu:C408()
	
	APPEND MENU ITEM:C411($menu; "Requests by type")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_reqByType")
	
	APPEND MENU ITEM:C411($menu; "Requests by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_reqByMin")
	
	//APPEND MENU ITEM($menu; "Requests by seconds")
	//SET MENU ITEM PARAMETER($menu; -1; "line_reqBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of components")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distComp")
	
	APPEND MENU ITEM:C411($menu; "Processes by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_procByMin")
	
	//APPEND MENU ITEM($menu; "Processes by second")
	//SET MENU ITEM PARAMETER($menu; -1; "line_procBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of processes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distProc")
	
	APPEND MENU ITEM:C411($menu; "Users by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_usersByMin")
	
	//APPEND MENU ITEM($menu; "Users by second")
	//SET MENU ITEM PARAMETER($menu; -1; "line_usersBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of users")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distUser")
	
	APPEND MENU ITEM:C411($menu; "Hosts by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_hostsByMin")
	
	//APPEND MENU ITEM($menu; "Hosts by second")
	//SET MENU ITEM PARAMETER($menu; -1; "line_hostsBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of hosts")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distHost")
	
	APPEND MENU ITEM:C411($menu; "Distribution of tables")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distTable")
	
	
	
	$choice:=Dynamic pop up menu:C1006($menu)
	
	Case of 
		: ($choice="")
			
		: ($choice="@reqByType")
			
			$settings:=New object:C1471()
			$settings.requestsLabel:=Form:C1466.main.requestsLabel
			$settings.options:=New object:C1471("title"; "Top ten: request type")
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
			
		: ($choice="@reqByMin")
			$settings:=New object:C1471()
			$settings.terminals:=Form:C1466.terminals
			$settings.options:=New object:C1471("title"; "Request distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@reqBySec")
			$settings:=New object:C1471()
			$settings.terminals:=Form:C1466.terminals
			$settings.options:=New object:C1471("title"; "Request distribution by second")
			$settings.metrics:=Form:C1466.metrics
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@distComp")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of components")
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
			
		: ($choice="@procByMin")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Process distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			$settings.context:={menu: Form:C1466.menu}
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@procBySec")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Process distribution by second")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@distProc")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of processes")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@usersByMin")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Users distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			$settings.context:={menu: Form:C1466.menu}
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@usersBySec")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Users distribution by second")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@distUser")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of users")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@hostsByMin")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Hosts distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			$settings.context:={menu: Form:C1466.menu}
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@hostsBySec")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Hosts distribution by second")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@distHost")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of hosts")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
		: ($choice="@distTable")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of tables")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.requests; $settings).load()
			
	End case 
	
	If ($choice#"")
		This:C1470.showGraphArea()
	End if 
	
	RELEASE MENU:C978($menu)
	
Function hideGraphArea()
	OBJECT SET VISIBLE:C603(*; "graph_"; False:C215)
	
Function showGraphArea()
	OBJECT SET VISIBLE:C603(*; "graph_"; True:C214)
	
Function clearMetrics()->$metrics : Object
	OBJECT SET VISIBLE:C603(*; "graph_"; True:C214)
	$metrics:=New object:C1471()