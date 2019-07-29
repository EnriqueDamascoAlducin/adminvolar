<?php
	include "conexion.php";
	$var1=$_POST['var1'];
	$var2=$_POST['var2'];
	$var3=$_POST['var3'];
	$select=$con->consulta($var1,$var2,$var3);
	echo utf8_encode(json_encode($select));

?>