Class extends EntitySelection


Function metrics($duration : Object)->$metrics : Object
	
	$bytesOutSum:=This:C1470.sum("bytes_out")
	$bytesInSum:=This:C1470.sum("bytes_in")
	$bytesSum:=$bytesOutSum+$bytesInSum
	
	
	$metrics:=New object:C1471()
	$metrics.durationMin:=New object:C1471("value"; $duration.min; "label"; "Duration min")
	$metrics.durationSec:=New object:C1471("value"; $duration.sec; "label"; "Duration sec")
	$metrics.totalReq:=New object:C1471("value"; This:C1470.length; "label"; "Total req")
	$metrics.reqPerMin:=New object:C1471("value"; Int:C8(This:C1470.length/$duration.min); "label"; "Req/min")
	$metrics.reqPerSec:=New object:C1471("value"; Int:C8(This:C1470.length/$duration.sec); "label"; "Req/sec")
	$metrics.byetsOut:=New object:C1471("value"; $bytesOutSum; "label"; "Bytes Out")
	$metrics.bytesIn:=New object:C1471("value"; $bytesInSum; "label"; "Bytes In")
	$metrics.totalBytes:=New object:C1471("value"; $bytesSum; "label"; "Bytes total")
	$metrics.bytesOutPerSec:=New object:C1471("value"; Int:C8($bytesOutSum/$duration.sec); "label"; "Bytes Out/sec")
	$metrics.bytesInPerSec:=New object:C1471("value"; Int:C8($bytesInSum/$duration.sec); "label"; "Bytes In/sec")
	$metrics.bytesOutPerMin:=New object:C1471("value"; Int:C8($bytesOutSum/$duration.min); "label"; "Bytes Out/min")
	$metrics.bytesInPerMin:=New object:C1471("value"; Int:C8($bytesInSum/$duration.min); "label"; "Bytes In/min")
	$metrics.byetsPerMin:=New object:C1471("value"; Int:C8($bytesSum/$duration.min); "label"; "Bytes/min")
	$metrics.byetsPerSec:=New object:C1471("value"; Int:C8($bytesSum/$duration.sec); "label"; "Bytes/sec")
	$metrics.totalProcesses:=New object:C1471("value"; This:C1470.process.length; "label"; "Processes total")
	$metrics.processesPerSec:=New object:C1471("value"; This:C1470.process.length/$duration.sec; "label"; "Processes/sec")
	$metrics.processesPerMin:=New object:C1471("value"; This:C1470.process.length/$duration.min; "label"; "Processes/min")
	$metrics.totalUsers:=New object:C1471("value"; This:C1470.process.user.length; "label"; "Uers total")
	$metrics.usersPerSec:=New object:C1471("value"; This:C1470.process.user.length/$duration.sec; "label"; "Users/sec")
	$metrics.usersPerMin:=New object:C1471("value"; This:C1470.process.user.length/$duration.min; "label"; "Users/min")
	$metrics.totalHosts:=New object:C1471("value"; This:C1470.process.host.length; "label"; "Hosts total")
	$metrics.hostsPerSec:=New object:C1471("value"; This:C1470.process.host.length/$duration.sec; "label"; "Hosts/sec")
	$metrics.hostsPerMin:=New object:C1471("value"; This:C1470.process.host.length/$duration.min; "label"; "Hosts/min")