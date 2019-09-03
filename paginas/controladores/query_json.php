<?php
	include "conexion.php";
	$var1=$_POST['var1'];
	$var2=$_POST['var2'];
	$var3=$_POST['var3'];
	//$con->query("SET NAMES utf8"); 
	$select=$con->consulta($var1,$var2,$var3);
	echo (json_encode($select));


?>