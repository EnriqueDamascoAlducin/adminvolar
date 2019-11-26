<?php
	include_once "conexion.php";
	$remplazar=  array("contar","entre" );
	$por=  array("COUNT","BETWEEN");
	$var1=$_POST['var1'];
	$var2=$_POST['var2'];
	$var3= $_POST['var3'];
	if(isset($_POST['var4'])){
		$var4=str_replace("selecciona", "SELECT"," (". $_POST['var4'].")");
		$var3=$var3.$var4;
		if(isset($_POST['var5'])){
			$var3 .= $_POST['var5'];
			if(isset($_POST['var6'])){
				$var6=str_replace("selecciona", "SELECT"," (". $_POST['var6'].")");
				$var3 .= $var6;
			}
		}
	}else{
		$var1 =str_replace("contar","COUNT",$var1);
		$var3 =str_replace($remplazar,$por,$var3);
	}
	//$con->query("SET NAMES utf8");

	$select=$con->consulta($var1,$var2,$var3);
	echo (json_encode($select));


?>
