//%attributes = {"preemptive":"capable"}

$e:=ds:C1482.Cache.query("ident == :1"; "process").first()
$e.drop()
//$e.save()