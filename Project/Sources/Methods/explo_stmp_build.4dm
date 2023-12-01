//%attributes = {}

// explo_stmp_build { ( date { ; time } ) } --> time stamp
//
// return a timestamp (nb of second from 2003/1/1)
// if no time, time is current time
// if no date;, date is current date

If (False:C215)
	// ----------------------------------------------------
	// Nom utilisateur (OS) : Olivier DESCHANELS
	// Date et heure : 02/02/03, 16:24:06
	// ----------------------------------------------------
	// Méthode : explo_stmp_build
	// Description
	// 
	//
	// Paramètres
	// ----------------------------------------------------
End if 

C_DATE:C307($1)
C_TIME:C306($2)

C_LONGINT:C283($0; $heure_en_seconde; $seconde; $minute_en_seconde; $jours_en_seconde)

Case of 
	: (Count parameters:C259=0)
		$date_ref:=Current date:C33
		$heure_ref:=Current time:C178
	: (Count parameters:C259=1)
		$date_ref:=$1
		$heure_ref:=Current time:C178
	: (Count parameters:C259=2)
		$date_ref:=$1
		$heure_ref:=$2
End case 

$date_reference:=Add to date:C393(!00-00-00!; 2003; 1; 1)
$heure_en_seconde:=$heure_ref+0
$jours_en_seconde:=($date_ref-$date_reference)*86400

$0:=$jours_en_seconde+$heure_en_seconde
