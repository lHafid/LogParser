//%attributes = {"preemptive":"capable"}

C_COLLECTION:C1488($1)
C_OBJECT:C1216($signal; $2)
var $e_group; $e_host; $e_user; $e_component; $e_process; $table : Object
var $UUID_Process
$files:=$1
$signal:=$2

For each ($file; $files)
	If ($file.name="@4DRequestsLog@") & ($file.name#"@ProcessInfo@") & (True:C214)
		
		
		//$text:=$file.getText()
		$text:=Document to text:C1236($file.platformPath)
		
		$lines:=Split string:C1554($text; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		$lines.shift()
		$lines.shift()
		$lines.shift()
		
		For each ($line; $lines)
			If ($line="@'SQLS'@") | ($line="@'srv4'@") | ($line="@'dbmg'@")
				If ($line#"@SQL protocol@")
					$columns:=Split string:C1554($line; "\t")
					If ($columns.length>=6)
						
						$name:=Substring:C12(String:C10($columns[3]); 2; Length:C16(String:C10($columns[3]))-2)
						$e_component:=ds:C1482.Component.query("name == :1"; $name).first()
						If ($e_component=Null:C1517)
							$e_component:=ds:C1482.Component.new()
							$e_component.name:=$name
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
						$dataTime:=Split string:C1554($columns[1]; ","; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
						If ($dataTime.length#2)
							$e_request.time:=Time:C179($columns[1])
							$e_request.date:=Date:C102($columns[1])
						Else 
							If (Date:C102($dataTime[0])=!00-00-00!)
								$dateNotISO:=Split string:C1554($dataTime[0]; "/"; sk trim spaces:K86:2+sk ignore empty strings:K86:1)
								$e_request.date:=Add to date:C393(!00-00-00!; Num:C11($dateNotISO[2]); Num:C11($dateNotISO[0]); Num:C11($dateNotISO[1]))
							Else 
								$e_request.date:=Date:C102($dataTime[0])
							End if 
							$e_request.time:=Time:C179($dataTime[1])
						End if 
						$e_request.stmp:=explo_stmp_build($e_request.date; $e_request.time)
						
						
						$e_process:=ds:C1482.Process.query("index == :1"; String:C10($columns[4])).first()
						If ($e_process=Null:C1517)
							$UUID_Process:=""
						Else 
							If ($columns.length>=7)
								$e_process.bytes_out:=Num:C11($e_process.bytes_out)+Num:C11($columns[6])
							End if 
							If ($columns.length>=8)
								$e_process.bytes_in:=Num:C11($e_process.bytes_in)+Num:C11($columns[7])
							End if 
							$rslt:=$e_process.save()
							$UUID_Process:=$e_process.UUID
						End if 
						
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
						If ($columns.length>=13) && ($columns[12]#"")
							$table:=ds:C1482.Table.query("name == :1"; $columns[12]).first()
							If ($table=Null:C1517)
								$table:=ds:C1482.Table.new()
								$table.name:=$columns[12]
								$table.save()
							End if 
							$UUID_Table:=$table.UUID
						Else 
							$UUID_Table:=""
						End if 
						$e_request.UUID_Table:=$UUID_Table
						
						$result:=$e_request.save()
						
					End if 
				End if 
				
			End if 
		End for each 
		
	End if 
End for each 


Use ($signal.processes)
	
	$index:=$signal.processes.indexOf(Current process:C322)
	If ($index#-1)
		$signal.processes.remove($index)
	End if 
	If ($signal.processes.length=0)
		
		$signal.trigger()
	End if 
End use 

