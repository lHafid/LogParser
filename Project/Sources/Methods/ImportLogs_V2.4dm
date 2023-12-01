//%attributes = {"preemptive":"capable"}


var $e_group; $e_host; $e_user; $e_component; $e_process : Object

For each ($dc_name; ds:C1482)
	$num:=ds:C1482[$dc_name].getInfo().tableNumber
	TRUNCATE TABLE:C1051(Table:C252($num)->)
End for each 

$lofFolder:=Select folder:C670("Select the logs folder"; 1)
$folder:=Folder:C1567($lofFolder; fk platform path:K87:2)

$start:=Milliseconds:C459
If ($folder.exists)
	$files:=$folder.files()
	For each ($file; $files)
		If ($file.name="@ProcessInfo@") & (False:C215)
			//$text:=$file.getText()
			$text:=Document to text:C1236($file.platformPath)
			$lines:=Split string:C1554($text; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			$lines.shift()
			$lines.shift()
			For each ($line; $lines)
				$columns:=Split string:C1554($line; "\t")
				
				$e_group:=ds:C1482.Process_Group.query("name == :1"; String:C10($columns[7])).first()
				If ($e_group=Null:C1517)
					$e_group:=ds:C1482.Process_Group.new()
					$e_group.name:=String:C10($columns[7])
					$e_group.save()
				End if 
				
				$e_host:=ds:C1482.Host.query("name == :1"; String:C10($columns[11])).first()
				If ($e_host=Null:C1517)
					$e_host:=ds:C1482.Host.new()
					$e_host.name:=String:C10($columns[11])
					$e_host.save()
				End if 
				
				$e_user:=ds:C1482.User.query("name == :1"; String:C10($columns[12])).first()
				If ($e_user=Null:C1517)
					$e_user:=ds:C1482.User.new()
					$e_user.name:=String:C10($columns[12])
					$e_user.save()
				End if 
				
				$e_process:=ds:C1482.Process.new()
				$e_process.sequence:=Num:C11($columns[0])
				$e_process.date:=Date:C102($columns[1])
				$e_process.time:=Time:C179($columns[1])
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
	
	
	$text:=""
	For each ($file; $files)
		If ($file.name="@4DRequestsLog@") & ($file.name#"@ProcessInfo@")
			
			//$text:=$file.getText()
			$text:=Document to text:C1236($file.platformPath)
			$lines:=Split string:C1554($text; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			$lines.shift()
			$lines.shift()
			$lines.shift()
			TRACE:C157
			For each ($line; $lines)
				If ($line#"@'INFO'@")
					$columns:=Split string:C1554($line; "\t")
					If (String:C10($columns[3])="'SQLS'") & (String:C10($columns[5])#"@SQL protocol@")
						If ($columns.length>=6)
							$e_component:=ds:C1482.Component.query("name == :1"; String:C10($columns[3])).first()
							If ($e_component=Null:C1517)
								$e_component:=ds:C1482.Component.new()
								$e_component.name:=String:C10($columns[3])
								$e_component.save()
							End if 
							
							$e_process:=ds:C1482.Process.query("index == :1"; String:C10($columns[4])).first()
							If ($e_process=Null:C1517)
								$UUID_Process:=""
							Else 
								$UUID_Process:=$e_process.UUID
							End if 
							
							$e_request:=ds:C1482.Request.new()
							$e_request.sequence:=Num:C11($columns[0])
							$e_request.date:=Date:C102($columns[1])
							$e_request.time:=Time:C179($columns[1])
							$e_request.UUID_Component:=String:C10($e_component.UUID)
							$e_request.UUID_Process:=$UUID_Process
							$e_request.request:=Num:C11($columns[5])
							
							If ($columns.length>=7)
								$e_request.bytes_out:=Num:C11($columns[6])
							End if 
							If ($columns.length>=8)
								$e_request.bytes_in:=Num:C11($columns[7])
							End if 
							If ($columns.length>=9)
								$e_request.exec_duration:=Num:C11($columns[8])
							End if 
							If ($columns.length>=8)
								$e_request.write_duration:=Num:C11($columns[9])
							End if 
							$result:=$e_request.save()
						End if 
					End if 
				End if 
			End for each 
			
		End if 
	End for each 
	
Else 
	ALERT:C41("Dossier n'existe pas")
End if 

$duration:=Milliseconds:C459-$start
ALERT:C41(String:C10($duration))
ALERT:C41($text)

