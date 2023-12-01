Class constructor($formName : Text)
	This:C1470._requestLabels()
	$formData:=New object:C1471("main"; This:C1470)
	$ref:=Open form window:C675($formName)
	DIALOG:C40($formName; $formData)
	CLOSE WINDOW:C154($ref)
	
Function getMenu()->$menus : Collection
	$menus:=New collection:C1472()
	
	$menu:=New object:C1471()
	$menu.label:="Global"
	$menu.page:=1
	$menus.push($menu)
	
	$menu:=New object:C1471()
	$menu.label:="By Process"
	$menu.page:=2
	$menus.push($menu)
	
	$menu:=New object:C1471()
	$menu.label:="By user"
	$menu.page:=3
	$menus.push($menu)
	
	$menu:=New object:C1471()
	$menu.label:="By host"
	$menu.page:=4
	$menus.push($menu)
	
Function set_es_request($es : Object)
	This:C1470.es_request:=$es
	
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
	
	APPEND MENU ITEM:C411($menu; "Requests by seconds")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_reqBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of components")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distComp")
	
	APPEND MENU ITEM:C411($menu; "Processes by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_procByMin")
	
	APPEND MENU ITEM:C411($menu; "Processes by second")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_procBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of processes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distProc")
	
	APPEND MENU ITEM:C411($menu; "Users by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_usersByMin")
	
	APPEND MENU ITEM:C411($menu; "Users by second")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_usersBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of users")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distUser")
	
	APPEND MENU ITEM:C411($menu; "Hosts by minutes")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_hostsByMin")
	
	APPEND MENU ITEM:C411($menu; "Hosts by second")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "line_hostsBySec")
	
	APPEND MENU ITEM:C411($menu; "Distribution of hosts")
	SET MENU ITEM PARAMETER:C1004($menu; -1; "pie_distHost")
	
	
	
	$choice:=Dynamic pop up menu:C1006($menu)
	
	Case of 
		: ($choice="")
			
		: ($choice="@reqByType")
			
			$settings:=New object:C1471()
			$settings.requestsLabel:=Form:C1466.main.requestsLabel
			$settings.options:=New object:C1471("title"; "Top ten: request type")
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
			
		: ($choice="@reqByMin")
			$settings:=New object:C1471()
			$settings.terminals:=Form:C1466.terminals
			$settings.options:=New object:C1471("title"; "Request distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@reqBySec")
			$settings:=New object:C1471()
			$settings.terminals:=Form:C1466.terminals
			$settings.options:=New object:C1471("title"; "Request distribution by second")
			$settings.metrics:=Form:C1466.metrics
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@distComp")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of components")
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
			
		: ($choice="@procByMin")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Process distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; ds:C1482.Process.all(); $settings)
			
		: ($choice="@procBySec")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Process distribution by second")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; ds:C1482.Process.all(); $settings)
			
		: ($choice="@distProc")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of processes")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@usersByMin")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Users distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@usersBySec")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Users distribution by second")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@distUser")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of users")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@hostsByMin")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Hosts distribution by minute")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@hostsBySec")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Hosts distribution by second")
			$settings.metrics:=Form:C1466.metrics
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
		: ($choice="@distHost")
			$settings:=New object:C1471()
			$settings.options:=New object:C1471("title"; "Distribution of hosts")
			$settings.terminals:=Form:C1466.terminals
			Form:C1466.graph:=cs:C1710.Graph.new($choice; This:C1470.es_request; $settings)
			
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