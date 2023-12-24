Class extends Entity


Function getGraph($requests : cs:C1710.RequestSelection; $type : Text)
	var $result : Object
	
	$groups:=$requests.process.group
	If (This:C1470.ident="global")
		return This:C1470.graph[$type]
	Else 
		$result:=New object:C1471()
		$result.labels:=This:C1470.graph[$type].labels
		$result.datasets:=[{data: New collection:C1472().resize($result.labels.length; 0)}]
		
		For each ($group; $groups)
			For ($i; 0; $result.datasets[0].data.length-1; 1)
				$result.datasets[0].data[$i]+=This:C1470.graph[$type].data[$group.UUID][$i]
			End for 
		End for each 
		return $result
	End if 
	