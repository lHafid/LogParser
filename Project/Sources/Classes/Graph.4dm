Class constructor($type : Text; $es : Object; $settings : Object)
	var $outputText : Text
	var $width : Text
	var $height : Text
	This:C1470.type:=$type
	This:C1470.es:=$es
	This:C1470.settings:=$settings
	
	Case of 
		: ($type="line@")
			$width:="1100px"
			$height:="700px"
			
		: ($type="pie@")
			$width:="750px"
			$height:="300px"
			
	End case 
	
	$file:=Get 4D folder:C485(Current resources folder:K5:16)+"template.html"
	$inputText:=Document to text:C1236($file)
	PROCESS 4D TAGS:C816($inputText; $outputText; This:C1470.type; $width; $height)
	TEXT TO DOCUMENT:C1237(Get 4D folder:C485(Current resources folder:K5:16)+"output.html"; $outputText)
	WA OPEN URL:C1020(*; "graph_"; Get 4D folder:C485(Current resources folder:K5:16)+"output.html")
	
	
Function build()->$data : Object
	var $cache : cs:C1710.CacheEntity
	$data:=New object:C1471()
	$data.data:=New object:C1471()
	
	$stats:=New collection:C1472()
	Case of 
		: (This:C1470.type="@reqByType")
			$data.type:="pie"
			
			$requestsNumber:=This:C1470.es.distinct("request")
			For ($i; 0; $requestsNumber.length-1; 1)
				$stat:=New object:C1471()
				$requests:=This:C1470.es.query("request == :1"; $requestsNumber[$i])
				$componentName:=$requests.first().component.name
				$stat.value:=Round:C94(($requests.length/This:C1470.es.length)*100; 2)
				If (String:C10(This:C1470.settings.requestsLabel[$componentName+"_"+String:C10($requestsNumber[$i])])="")
					$stat.label:=$componentName+"_"+String:C10($requestsNumber[$i])+" "+String:C10($stat.value)+"%"
				Else 
					$stat.label:=String:C10(This:C1470.settings.requestsLabel[$componentName+"_"+String:C10($requestsNumber[$i])])+" "+String:C10($stat.value)+"%"
				End if 
				$stats.push($stat)
			End for 
			
			$stats:=$stats.orderBy("value desc")
			$stats:=$stats.slice(0; 9)
			$sum:=$stats.sum("value")
			$stats.push(New object:C1471("value"; (100-$sum); "label"; "Others "+String:C10(100-$sum)+"%"))
			
			$data.data.labels:=$stats.extract("label")
			$data.data.datasets:=New collection:C1472()
			
			$dataset:=New object:C1471()
			$dataset.data:=$stats.extract("value")
			$dataset.backgroundColor:=New collection:C1472("#115f9a"; "#1984c5"; "#22a7f0"; "#48b5c4"; "#76c68f"; "#a6d75b"; "#c9e52f"; "#d0ee11"; "#d0f400"; "#ffe699")
			$data.data.datasets.push($dataset)
			
			$data.options:=New object:C1471()
			$data.options.plugins:=New object:C1471()
			$data.options.plugins.legend:=New object:C1471()
			$data.options.plugins.legend.title:=New object:C1471()
			
			$data.options.plugins.legend.display:=True:C214
			$data.options.plugins.legend.title.display:=True:C214
			$data.options.plugins.legend.title.text:=This:C1470.settings.options.title
			
			$data.options.plugins.legend.position:="left"
			
			
			
		: (This:C1470.type="@distComp")
			$data.type:="pie"
			
			$dbmg:=This:C1470.es.query("component.name == :1"; "dbmg").length
			$srv:=This:C1470.es.query("component.name == :1"; "srv4").length
			$sql:=This:C1470.es.query("component.name == :1"; "SQLS").length
			$total:=$dbmg+$srv+$sql
			
			$stats:=New collection:C1472()
			$stats.push(New object:C1471("label"; "dbmg"; "value"; ($dbmg/$total)*100))
			$stats.push(New object:C1471("label"; "srv4"; "value"; ($srv/$total)*100))
			$stats.push(New object:C1471("label"; "SQL"; "value"; ($sql/$total)*100))
			$stats:=$stats.orderBy("value desc")
			
			
			$data.data.labels:=New collection:C1472()
			For each ($stat; $stats)
				$data.data.labels.push($stat.label+" "+String:C10(Round:C94($stat.value; 2))+"%")
			End for each 
			
			$data.data.datasets:=New collection:C1472()
			$dataset:=New object:C1471()
			$dataset.data:=$stats.extract("value")
			$dataset.backgroundColor:=New collection:C1472("#115f9a"; "#1984c5"; "#22a7f0"; "#48b5c4"; "#76c68f"; "#a6d75b"; "#c9e52f"; "#d0ee11"; "#d0f400"; "#ffe699")
			$data.data.datasets.push($dataset)
			
			
			$data.options:=New object:C1471()
			$data.options.plugins:=New object:C1471()
			$data.options.plugins.legend:=New object:C1471()
			$data.options.plugins.legend.title:=New object:C1471()
			
			$data.options.plugins.legend.display:=True:C214
			$data.options.plugins.legend.title.display:=True:C214
			$data.options.plugins.legend.title.text:=This:C1470.settings.options.title
			
			$data.options.plugins.legend.position:="left"
			
			
		: (This:C1470.type="@reqByMin")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=This:C1470.settings.terminals.first.stmp  //Time(String(Time(This.settings.terminals.first.time); HH MM))
			$endTime:=This:C1470.settings.terminals.last.stmp+60  //Time(String(Time(This.settings.terminals.last.time+60); HH MM))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+60))
				$data.data.labels.push(String:C10(explo_stmp_read_time($startTime)))
				$data.data.datasets[1].data.push($es.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.reqPerMin.value)
				$startTime+=60
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
		: (This:C1470.type="@reqBySec")
			
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=This:C1470.settings.terminals.first.stmp  //Time(String(Time(This.settings.terminals.first.time); HH MM))
			$endTime:=This:C1470.settings.terminals.last.stmp  //Time(String(Time(This.settings.terminals.last.time+60); HH MM))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+1))
				$data.data.labels.push(String:C10(explo_stmp_read_time($startTime)))
				$data.data.datasets[1].data.push($es.process.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.reqPerSec.value)
				
				$startTime+=1
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
			
		: (This:C1470.type="@procByMin")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=This:C1470.settings.terminals.first.stmp  //Time(String(Time(This.settings.terminals.first.time); HH MM))
			$endTime:=This:C1470.settings.terminals.last.stmp  //Time(String(Time(This.settings.terminals.last.time+60); HH MM))
			
			
			$s:=Milliseconds:C459
			
			If (False:C215)
				
				
			Else 
				While ($startTime<$endTime)
					$es:=This:C1470.es.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+60))
					$data.data.labels.push(String:C10(explo_stmp_read_time($startTime)))
					$data.data.datasets[1].data.push($es.process.length)
					$startTime+=60
				End while 
				$data.data.datasets[0].data.resize($data.data.labels.length; This:C1470.settings.metrics.processesPerMin.value)
				
				//If (This.es.length>1000000)
				//$cache:=ds.Cache.query("ident == :1"; "procByMin").first()
				//If ($cache=Null)
				//$cache:=ds.Cache.new()
				//$cache.ident:="procByMin"
				//End if 
				
				//$datasefts:={datasets: $data.data.datasets}
				//If (This.settings.context.menu.page#1)
				
				//End if 
				//$reslt:=$cache.save()
				
				
				//End if 
				
			End if 
			
			$e:=Milliseconds:C459-$s
			//ALERT(String($e))
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
			
			
		: (This:C1470.type="@procBySec")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.first.time); HH MM:K7:2))
			$endTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.last.time+60); HH MM:K7:2))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("time >= :1 and time < :2"; Time:C179($startTime-1); $startTime)
				$data.data.labels.push(String:C10($startTime))
				$data.data.datasets[1].data.push($es.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.processesPerSec.value)
				
				$startTime:=Time:C179($startTime+1)
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
			
			
		: (This:C1470.type="@procBySec")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.first.time); HH MM:K7:2))
			$endTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.last.time+60); HH MM:K7:2))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("time >= :1 and time < :2"; Time:C179($startTime-1); $startTime)
				$data.data.labels.push(String:C10($startTime))
				$data.data.datasets[1].data.push($es.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.processesPerSec.value)
				
				$startTime:=Time:C179($startTime+1)
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
			
			
			
			
			
		: (This:C1470.type="@procBySec")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.first.time); HH MM:K7:2))
			$endTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.last.time+60); HH MM:K7:2))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("time >= :1 and time < :2"; Time:C179($startTime-1); $startTime)
				$data.data.labels.push(String:C10($startTime))
				$data.data.datasets[1].data.push($es.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.processesPerSec.value)
				
				$startTime:=Time:C179($startTime+1)
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
			
		: (This:C1470.type="@distProc")
			
			$data.type:="pie"
			$procGroups:=This:C1470.es.process.group.distinct("name")
			
			$stats:=New collection:C1472()
			For each ($group; $procGroups)
				$es:=This:C1470.es.query("process.group.name == :1"; $group)
				$stat:=New object:C1471("label"; $group; "value"; ($es.length/This:C1470.es.length)*100)
				$stats.push($stat)
			End for each 
			$stats:=$stats.orderBy("value desc")
			$stats:=$stats.slice(0; 9)
			
			$sum:=$stats.sum("value")
			$stats.push(New object:C1471("label"; "Others"; "value"; (100-$sum)))
			
			$data.data.labels:=New collection:C1472()
			For each ($stat; $stats)
				$data.data.labels.push($stat.label+" "+String:C10(Round:C94($stat.value; 2))+"%")
			End for each 
			
			
			
			$data.data.datasets:=New collection:C1472()
			
			$dataset:=New object:C1471()
			$dataset.data:=$stats.extract("value")
			$dataset.backgroundColor:=New collection:C1472("#115f9a"; "#1984c5"; "#22a7f0"; "#48b5c4"; "#76c68f"; "#a6d75b"; "#c9e52f"; "#d0ee11"; "#d0f400"; "#ffe699")
			$data.data.datasets.push($dataset)
			
			$data.options:=New object:C1471()
			$data.options.plugins:=New object:C1471()
			$data.options.plugins.legend:=New object:C1471()
			$data.options.plugins.legend.title:=New object:C1471()
			
			$data.options.plugins.legend.display:=True:C214
			$data.options.plugins.legend.title.display:=True:C214
			$data.options.plugins.legend.title.text:=This:C1470.settings.options.title
			
			$data.options.plugins.legend.position:="left"
			
			
		: (This:C1470.type="@usersByMin")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=This:C1470.settings.terminals.first.stmp  //Time(String(Time(This.settings.terminals.first.time); HH MM))
			$endTime:=This:C1470.settings.terminals.last.stmp  //Time(String(Time(This.settings.terminals.last.time+60); HH MM))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+60))
				$data.data.labels.push(String:C10(explo_stmp_read_time($startTime)))
				$data.data.datasets[1].data.push($es.process.user.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.usersPerMin.value)
				$startTime+=60
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
		: (This:C1470.type="@usersBySec")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.first.time); HH MM:K7:2))
			$endTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.last.time+60); HH MM:K7:2))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("time >= :1 and time < :2"; Time:C179($startTime-1); $startTime)
				$data.data.labels.push(String:C10($startTime))
				$data.data.datasets[1].data.push($es.process.user.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.usersPerSec.value)
				
				$startTime:=Time:C179($startTime+1)
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
		: (This:C1470.type="@distUser")
			
			$data.type:="pie"
			$usersName:=This:C1470.es.process.user.distinct("name")
			
			$stats:=New collection:C1472()
			For each ($name; $usersName)
				$es:=This:C1470.es.query("process.user.name == :1"; $name)
				$stat:=New object:C1471("label"; $name; "value"; ($es.length/This:C1470.es.length)*100)
				$stats.push($stat)
			End for each 
			$stats:=$stats.orderBy("value desc")
			$stats:=$stats.slice(0; 9)
			
			$sum:=$stats.sum("value")
			$stats.push(New object:C1471("label"; "Others"; "value"; (100-$sum)))
			
			$data.data.labels:=New collection:C1472()
			For each ($stat; $stats)
				$data.data.labels.push($stat.label+" "+String:C10(Round:C94($stat.value; 2))+"%")
			End for each 
			
			$data.data.datasets:=New collection:C1472()
			
			$dataset:=New object:C1471()
			$dataset.data:=$stats.extract("value")
			$dataset.backgroundColor:=New collection:C1472("#115f9a"; "#1984c5"; "#22a7f0"; "#48b5c4"; "#76c68f"; "#a6d75b"; "#c9e52f"; "#d0ee11"; "#d0f400"; "#ffe699")
			$data.data.datasets.push($dataset)
			
			$data.options:=New object:C1471()
			$data.options.plugins:=New object:C1471()
			$data.options.plugins.legend:=New object:C1471()
			$data.options.plugins.legend.title:=New object:C1471()
			
			$data.options.plugins.legend.display:=True:C214
			$data.options.plugins.legend.title.display:=True:C214
			$data.options.plugins.legend.title.text:=This:C1470.settings.options.title
			
			$data.options.plugins.legend.position:="left"
			
			
			
			//--------
		: (This:C1470.type="@hostsByMin")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=This:C1470.settings.terminals.first.stmp  //Time(String(Time(This.settings.terminals.first.time); HH MM))
			$endTime:=This:C1470.settings.terminals.last.stmp  //Time(String(Time(This.settings.terminals.last.time+60); HH MM))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("stmp >= :1 and stmp < :2"; $startTime; ($startTime+60))
				$data.data.labels.push(String:C10(explo_stmp_read_time($startTime)))
				$data.data.labels.push(String:C10($startTime))
				$data.data.datasets[1].data.push($es.process.host.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.hostsPerMin.value)
				$startTime+=60
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
		: (This:C1470.type="@hostsBySec")
			$data.type:="line"
			
			$data.data.datasets:=New collection:C1472()
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.datasets.push(New object:C1471("data"; New collection:C1472()))
			$data.data.labels:=New collection:C1472()
			
			$startTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.first.time); HH MM:K7:2))
			$endTime:=Time:C179(String:C10(Time:C179(This:C1470.settings.terminals.last.time+60); HH MM:K7:2))
			
			While ($startTime<$endTime)
				$es:=This:C1470.es.query("time >= :1 and time < :2"; Time:C179($startTime-1); $startTime)
				$data.data.labels.push(String:C10($startTime))
				$data.data.datasets[1].data.push($es.process.host.length)
				$data.data.datasets[0].data.push(This:C1470.settings.metrics.hostsPerSec.value)
				
				$startTime:=Time:C179($startTime+1)
			End while 
			
			$data.data.datasets[1].backgroundColor:="#a6d75b"
			$data.data.datasets[1].borderColor:="#115f9a"
			$data.data.datasets[1].label:=This:C1470.settings.options.title
			$data.data.datasets[1].fill:=False:C215
			$data.data.datasets[1].pointStyle:="dash"
			
			
			$data.data.datasets[0].borderColor:="red"
			$data.data.datasets[0].label:="Average"
			$data.data.datasets[0].fill:=False:C215
			$data.data.datasets[0].pointStyle:="dash"
			
		: (This:C1470.type="@distHost")
			
			$data.type:="pie"
			$hostsName:=This:C1470.es.process.host.distinct("name")
			
			$stats:=New collection:C1472()
			For each ($name; $hostsName)
				$es:=This:C1470.es.query("process.host.name == :1"; $name)
				$stat:=New object:C1471("label"; $name; "value"; ($es.length/This:C1470.es.length)*100)
				$stats.push($stat)
			End for each 
			$stats:=$stats.orderBy("value desc")
			$stats:=$stats.slice(0; 9)
			
			$sum:=$stats.sum("value")
			$stats.push(New object:C1471("label"; "Others"; "value"; (100-$sum)))
			
			$data.data.labels:=New collection:C1472()
			For each ($stat; $stats)
				$data.data.labels.push($stat.label+" "+String:C10(Round:C94($stat.value; 2))+"%")
			End for each 
			
			
			
			$data.data.datasets:=New collection:C1472()
			
			$dataset:=New object:C1471()
			$dataset.data:=$stats.extract("value")
			$dataset.backgroundColor:=New collection:C1472("#115f9a"; "#1984c5"; "#22a7f0"; "#48b5c4"; "#76c68f"; "#a6d75b"; "#c9e52f"; "#d0ee11"; "#d0f400"; "#ffe699")
			$data.data.datasets.push($dataset)
			
			$data.options:=New object:C1471()
			$data.options.plugins:=New object:C1471()
			$data.options.plugins.legend:=New object:C1471()
			$data.options.plugins.legend.title:=New object:C1471()
			
			$data.options.plugins.legend.display:=True:C214
			$data.options.plugins.legend.title.display:=True:C214
			$data.options.plugins.legend.title.text:=This:C1470.settings.options.title
			
			$data.options.plugins.legend.position:="left"
			
			
			
			
			
	End case 
	
	
	
	