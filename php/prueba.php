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

?>