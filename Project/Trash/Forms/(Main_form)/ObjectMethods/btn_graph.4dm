

$menu:=Create menu:C408()
APPEND MENU ITEM:C411($menu; "Requests by type")
SET MENU ITEM PARAMETER:C1004($menu; -1; "reqByType")


APPEND MENU ITEM:C411($menu; "Requests by minutes")
SET MENU ITEM PARAMETER:C1004($menu; -1; "reqByMin")

APPEND MENU ITEM:C411($menu; "Requests by seconds")
SET MENU ITEM PARAMETER:C1004($menu; -1; "reqBySec")




$choice:=Dynamic pop up menu:C1006($menu)

Case of 
	: ($choice="")
		
	: ($choice="reqByType")
		
		OBJECT SET VISIBLE:C603(*; "graph_"; True:C214)
		$file:=Get 4D folder:C485(Current resources folder:K5:16)+"Pie.html"
		WA OPEN URL:C1020(*; "graph_"; $file)
		
		
	: ($choice="reqByMin")
		OBJECT SET VISIBLE:C603(*; "graph_"; True:C214)
		$file:=Get 4D folder:C485(Current resources folder:K5:16)+"LineMin.html"
		WA OPEN URL:C1020(*; "graph_"; $file)
		
	: ($choice="reqBySec")
		OBJECT SET VISIBLE:C603(*; "graph_"; True:C214)
		$file:=Get 4D folder:C485(Current resources folder:K5:16)+"LineSec.html"
		WA OPEN URL:C1020(*; "graph_"; $file)
		
End case 

RELEASE MENU:C978($menu)