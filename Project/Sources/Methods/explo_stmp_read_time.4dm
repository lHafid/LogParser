//%attributes = {}
// ----------------------------------------------------
// Nom utilisateur (OS) : Olivier DESCHANELS
// ----------------------------------------------------
// Méthode : 4DStmp_Read_Heure
// Description
// 
//
// Paramètres
// ----------------------------------------------------


C_LONGINT:C283($1)
C_TIME:C306($0)

//%R-
$seconde:=$1%60
$Minute:=(Int:C8($1/60))%60
$heure:=(Int:C8($1/3600))%24
//%R+
$0:=Time:C179(String:C10($heure; "00")+":"+String:C10($minute; "00")+":"+String:C10($seconde; "00"))
