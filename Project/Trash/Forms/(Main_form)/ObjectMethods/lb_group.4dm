

Case of 
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		
		$dureeSecond:=Form:C1466.last.time-Form:C1466.first.time
		$dureeMinutes:=$dureeSecond/60
		
		$requests:=Form:C1466.group.processes.requests
		
		Form:C1466.total:=$requests.length
		Form:C1466.avgSec:=Form:C1466.total/$dureeSecond
		Form:C1466.avgMin:=Form:C1466.total/$dureeMinutes
		
		Form:C1466.bytesOut:=$requests.sum("bytes_out")
		Form:C1466.bytesIn:=$requests.sum("bytes_in")
		Form:C1466.bytesTotal:=Form:C1466.bytesOut+Form:C1466.bytesIn
		Form:C1466.avgBytesOutSec:=Form:C1466.bytesOut/$dureeSecond
		Form:C1466.avgBytesInSec:=Form:C1466.bytesIn/$dureeSecond
		Form:C1466.avgBytesOutMin:=Form:C1466.bytesOut/$dureeMinutes
		Form:C1466.avgBytesInMin:=Form:C1466.bytesIn/$dureeMinutes
		
		$requestsNumber:=$requests.distinct("request")
		$stats:=New collection:C1472()
		For ($i; 0; $requestsNumber.length-1; 1)
			$stat:=New object:C1471()
			$stat.reqNumber:=$requestsNumber[$i]
			$stat.count:=$requests.query("request == :1"; $requestsNumber[$i]).length
			$stat.percent:=Round:C94(($stat.count/$requests.length)*100; 2)
			
			If (Storage:C1525.requestsLabel["dbmg"][String:C10($requestsNumber[$i])]#Null:C1517)
				$stat.reqLabal:=Storage:C1525.requestsLabel["dbmg"][String:C10($requestsNumber[$i])]
			Else 
				If (Storage:C1525.requestsLabel["srv4"][String:C10($requestsNumber[$i])]#Null:C1517)
					$stat.reqLabal:=Storage:C1525.requestsLabel["srv4"][String:C10($requestsNumber[$i])]
				Else 
					$stat.reqLabal:="SQL"
				End if 
			End if 
			$stats.push($stat)
		End for 
		
		$stats:=$stats.orderBy("count desc")
		Form:C1466.stats:=$stats.slice(0; 9)
		
		$sum:=Form:C1466.stats.sum("percent")
		Form:C1466.stats.push(New object:C1471("percent"; (100-$sum); "reqLabal"; "Others"))
		Use (Storage:C1525)
			$obj_tmp:=New object:C1471("stats"; Form:C1466.stats)
			Storage:C1525.tmp_stats:=OB Copy:C1225($obj_tmp; ck shared:K85:29)
			Storage:C1525.requestsOfProcess:=$requests
			Storage:C1525.avg:=New shared object:C1526("avgSec"; Form:C1466.avgSec; "avgMin"; Form:C1466.avgMin)
		End use 
		
		OBJECT SET VISIBLE:C603(*; "btn_graph"; True:C214)
	Else 
		OBJECT SET VISIBLE:C603(*; "btn_graph"; False:C215)
		OBJECT SET VISIBLE:C603(*; "graph_"; False:C215)
		
End case 

