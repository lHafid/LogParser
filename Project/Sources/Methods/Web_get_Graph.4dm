//%attributes = {}
C_OBJECT:C1216($0; $obj)
C_TEXT:C284($1; $type; \
$2; $byTime)

$type:=$1
$byTime:=$2
$obj:=New object:C1471()
TRACE:C157
Case of 
	: ($type="pie")
		$objTmp:=OB Copy:C1225(Storage:C1525.tmp_stats)
		$colTmp:=$objTmp.stats
		
		
		$obj.type:="pie"
		
		$obj.data:=New object:C1471()
		$obj.data.datasets:=New collection:C1472()
		$obj.data.datasets.push(New object:C1471(\
			"data"; $colTmp.extract("percent"); \
			"backgroundColor"; New collection:C1472("#115f9a"; "#1984c5"; "#22a7f0"; "#48b5c4"; "#76c68f"; "#a6d75b"; "#c9e52f"; "#d0ee11"; "#d0f400"; "#ffe699")\
			))
		$obj.data.labels:=New collection:C1472()
		For each ($stat; $colTmp)
			$obj.data.labels.push($stat.reqLabal+" "+String:C10($stat.percent)+"%")
		End for each 
		
		
		
		$obj.options:=New object:C1471()
		$obj.options.plugins:=New object:C1471()
		$obj.options.plugins.legend:=New object:C1471()
		$obj.options.plugins.legend.title:=New object:C1471()
		
		$obj.options.plugins.legend.display:=True:C214
		$obj.options.plugins.legend.title.display:=True:C214
		$obj.options.plugins.legend.title.text:="Top ten"
		
		$obj.options.plugins.legend.position:="left"
		
	: ($type="line")
		
		
		$obj.type:="line"
		$obj.data:=New object:C1471()
		
		$obj.data.datasets:=New collection:C1472()
		$obj.data.datasets.push(New object:C1471("data"; New collection:C1472()))
		$obj.data.datasets.push(New object:C1471("data"; New collection:C1472()))
		
		$obj.data.labels:=New collection:C1472()
		
		$startTime:=Time:C179(String:C10(Time:C179(Storage:C1525.startEndTime.startTime); HH MM:K7:2))
		$endTime:=Time:C179(String:C10(Time:C179(Storage:C1525.startEndTime.endTime+60); HH MM:K7:2))
		
		Case of 
			: ($byTime="min")
				
				While ($startTime<$endTime)
					$es:=Storage:C1525.requestsOfProcess.query("time >= :1 and time < :2"; Time:C179($startTime-60); $startTime)
					$obj.data.labels.push(String:C10($startTime))
					$obj.data.datasets[1].data.push($es.length)
					$obj.data.datasets[0].data.push(Storage:C1525.avg.avgMin)
					$startTime:=Time:C179($startTime+60)
				End while 
				
				
				
			: ($byTime="sec")
				While ($startTime<$endTime)
					$es:=Storage:C1525.requestsOfProcess.query("time >= :1 and time < :2"; Time:C179($startTime-1); $startTime)
					$obj.data.labels.push(String:C10($startTime))
					$obj.data.datasets[1].data.push($es.length)
					$obj.data.datasets[0].data.push(Storage:C1525.avg.avgSec)
					
					$startTime:=Time:C179($startTime+1)
				End while 
				
			Else 
				
		End case 
		
		$obj.data.datasets[1].backgroundColor:="#a6d75b"
		$obj.data.datasets[1].borderColor:="#115f9a"
		$obj.data.datasets[1].label:="Requests by minutes"
		$obj.data.datasets[1].fill:=False:C215
		$obj.data.datasets[1].pointStyle:="dash"
		
		
		$obj.data.datasets[0].borderColor:="red"
		$obj.data.datasets[0].label:="Average"
		$obj.data.datasets[0].fill:=False:C215
		$obj.data.datasets[0].pointStyle:="dash"
		
		
		
		
		
End case 

$0:=$obj


//"backgroundColor"; New collection("#ff8389"; "#ffd7d9"; "#e5f6ff"; "#82cfff"; "#1192e8"; "#e8daff"; "#d9fbfb"; "#3ddbd9"; "#009d9a"; "#005d5d")