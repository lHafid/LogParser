//%attributes = {"executedOnServer":true,"preemptive":"capable"}


var $e_group; $e_host; $e_user; $e_component; $e_process : Object

For each ($dc_name; ds:C1482)
	$num:=ds:C1482[$dc_name].getInfo().tableNumber
	TRUNCATE TABLE:C1051(Table:C252($num)->)
End for each 

$nbr_cores:=5

$lofFolder:=Select folder:C670("Select the logs folder"; 1)
$folder:=Folder:C1567($lofFolder; fk platform path:K87:2)

$start:=Milliseconds:C459
If ($folder.exists)
	$files:=$folder.files().orderBy("name")
	For each ($file; $files)
		If ($file.name="@ProcessInfo@") & (True:C214)
			$text:=Document to text:C1236($file.platformPath)
			//$text:=$file.getText()
			$lines:=Split string:C1554($text; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			$lines.shift()
			$lines.shift()
			For each ($line; $lines)
				$columns:=Split string:C1554($line; "\t")
				
				
				$name:=Substring:C12(String:C10($columns[7]); 2; Length:C16(String:C10($columns[7]))-2)
				$e_group:=ds:C1482.Process_Group.query("name == :1"; $name).first()
				If ($e_group=Null:C1517)
					$e_group:=ds:C1482.Process_Group.new()
					$e_group.name:=$name
					$e_group.save()
				End if 
				
				
				$name:=Substring:C12(String:C10($columns[11]); 2; Length:C16(String:C10($columns[11]))-2)
				$e_host:=ds:C1482.Host.query("name == :1"; $name).first()
				If ($e_host=Null:C1517)
					$e_host:=ds:C1482.Host.new()
					$e_host.name:=$name
					$e_host.save()
				End if 
				
				
				$name:=Substring:C12(String:C10($columns[12]); 2; Length:C16(String:C10($columns[12]))-2)
				$e_user:=ds:C1482.User.query("name == :1"; $name).first()
				If ($e_user=Null:C1517)
					$e_user:=ds:C1482.User.new()
					$e_user.name:=$name
					$e_user.save()
				End if 
				
				$e_process:=ds:C1482.Process.new()
				$e_process.sequence:=Num:C11($columns[0])
				$dataTime:=Split string:C1554($columns[1]; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
				If ($dataTime.length#2)
					$e_process.time:=Time:C179($columns[1])
					$e_process.date:=Date:C102($columns[1])
				Else 
					If (Date:C102($dataTime[0])=!00-00-00!)
						$dateNotISO:=Split string:C1554($dataTime[0]; "/"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
						$e_process.date:=Add to date:C393(!00-00-00!; Num:C11($dateNotISO[2]); Num:C11($dateNotISO[0]); Num:C11($dateNotISO[1]))
					Else 
						$e_process.date:=Date:C102($dataTime[0])
					End if 
					$e_process.time:=Time:C179($dataTime[1])
				End if 
				$e_process.stmp:=explo_stmp_build($e_process.date; $e_process.time)
				
				
				$e_process.bytes_out:=0
				$e_process.bytes_in:=0
				$e_process.index:=Num:C11($columns[2])
				$e_process.serverProcessID:=Num:C11($columns[5])
				$e_process.remoteProcessID:=Num:C11($columns[6])
				$e_process.UUID_Process_Group:=String:C10($e_group.UUID)
				$e_process.UUID_Host:=String:C10($e_host.UUID)
				$e_process.UUID_User:=String:C10($e_user.UUID)
				$result:=$e_process.save()
				
				
			End for each 
		End if 
	End for each 
	
	
	$requestLog:=New collection:C1472()
	For each ($file; $files)
		If ($file.name="@4DRequestsLog@") & ($file.name#"@ProcessInfo@")
			$requestLog.push($file)
		End if 
	End for each 
	
	$numFilesPerProcess:=Int:C8($requestLog.length/$nbr_cores)
	If ($numFilesPerProcess=0)
		$numFilesPerProcess+=1
	End if 
	
	TRACE:C157
	$signal:=New signal:C1641()
	$continue:=True:C214
	For ($i; 0; $nbr_cores)
		If ($i=$nbr_cores)
			$col:=$requestLog.slice($i*$numFilesPerProcess; $requestLog.length)
		Else 
			$col:=$requestLog.slice($i*$numFilesPerProcess; ($i*$numFilesPerProcess)+$numFilesPerProcess)
		End if 
		If ($col.length#0)
			$proc:=New process:C317("importReqLogs"; 0; "ImportProc"+String:C10($i); $col; $signal)
			Use ($signal)
				If ($signal.processes=Null:C1517)
					$signal.processes:=New shared collection:C1527()
				End if 
				$signal.processes.push($proc)
			End use 
		Else 
			$i:=$nbr_cores+1
		End if 
	End for 
	
	
	$signaled:=$signal.wait()
	
	
	
	
	TRUNCATE TABLE:C1051([Cache:7])
	
	$cache:=ds:C1482.Request.calculateCache()
	build_cache("global"; $cache.cache.first.stmp; $cache.cache.last.stmp)
	build_cache("process"; $cache.cache.first.stmp; $cache.cache.last.stmp)
	build_cache("user"; $cache.cache.first.stmp; $cache.cache.last.stmp)
	build_cache("host"; $cache.cache.first.stmp; $cache.cache.last.stmp)
	
	//$proc_global:=New process("build_cache"; 0; "global"; "global"; $terminals.first.stmp; $terminals.last.stmp)
	//$proc_process:=New process("build_cache"; 0; "process"; "process"; $terminals.first.stmp; $terminals.last.stmp)
	//$proc_process:=New process("build_cache"; 0; "user"; "user"; $terminals.first.stmp; $terminals.last.stmp)
	//$proc_process:=New process("build_cache"; 0; "host"; "host"; $terminals.first.stmp; $terminals.last.stmp)
	
	
	
	
Else 
	ALERT:C41("Dossier n'existe pas")
End if 

$duration:=Milliseconds:C459-$start
ALERT:C41(String:C10($duration))

ALERT:C41("ok")
