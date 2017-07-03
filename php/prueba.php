<?php
$rest = substr("abcdef", -3, 1); // devuelve "d"


$actual = date('Y').'-'.date('m').'-'.date('d');
$cualquiera = '2017-06-01 18:24:00';

echo '<br>'.$actual;
echo '<br>'.$cualquiera;

$cualquiera = substr($cualquiera, -19, 10);
echo '<br>'.$cualquiera;

echo '<br>';
if( $actual == $cualquiera )
	echo 'si';
else
	echo 'no';


$fecha = '2017-07-09';
$nuevafecha = strtotime ( '+10 month' , strtotime ( $fecha ) ) ;
$nuevafecha = date ( 'Y-m-j' , $nuevafecha );
 
echo '<br>'.'nueva fecha: '.$nuevafecha;

$vector = [];
$vector[] = '1';
$vector[] = '2';
$vector[] = '3';
foreach ($vector as $key => $value) {
	echo '<br>'.$vector[$key];
}

?>