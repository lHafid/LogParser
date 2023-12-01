//%attributes = {}


$start:=Milliseconds:C459
For ($i; 0; 4000000)
	$name:="'Hafid El hour'"
	$name1:=Substring:C12(String:C10($name); 2; Length:C16(String:C10($name))-2)
	$name1:=Substring:C12(String:C10($name); 2; Length:C16(String:C10($name))-2)
	$name1:=Substring:C12(String:C10($name); 2; Length:C16(String:C10($name))-2)
End for 

ALERT:C41(String:C10(Milliseconds:C459-$start))