Class extends Entity


Function getGraph($type : Text; $uuids : Collection)
	var $result : Object
	
	$types:=Split string:C1554($type; "by"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	$theme:=$types[0]
	$temporal:=$types[1]
	
	$result:={}
	$result.labels:=This:C1470.cache[$temporal].labels
	If (This:C1470.ident="global")
		$result.datasets:=[{data: This:C1470.cache[$temporal][$theme].data}]
	Else 
		
		If (False:C215)  //for V1
			$result.datasets:=[{data: New collection:C1472().resize($result.labels.length; 0)}]
			
			For each ($uuid; $uuids)
				For ($i; 0; $result.datasets[0].data.length-1; 1)
					$result.datasets[0].data[$i]+=This:C1470.graph[$temporal][$theme][$uuid][$i]
				End for 
			End for each 
			
		Else 
			
			$result.datasets:=[{data: New collection:C1472().resize($result.labels.length; 0)}]
			$tempCol:=New collection:C1472().resize($result.labels.length; New collection:C1472())
			
			For each ($uuid; $uuids)
				For ($i; 0; $result.labels.length-1; 1)
					$tempCol[$i]:=$tempCol[$i].concat(This:C1470.cache[$temporal][$theme][$uuid][$i])
				End for 
			End for each 
			
			
			For ($i; 0; $result.labels.length-1; 1)
				$result.datasets[0].data[$i]:=$tempCol[$i].distinct().length
			End for 
			
		End if 
		
	End if 
	
	return $result