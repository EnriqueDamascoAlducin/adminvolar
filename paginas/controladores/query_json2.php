<?php
	include_once "conexion.php";
	$remplazar=  array("contar","entre" ,"selecciona","unir","concatenar","esvacio","sumar","YYY","detabla");
	$por=  array("COUNT","BETWEEN","Select","INNER JOIN","CONCAT","IFNULL","sum","AND","from");
	$var1=str_replace($remplazar, $por, $_POST['var1']);
	$var2=str_replace($remplazar, $por, $_POST['var2']);
	$var3= str_replace($remplazar, $por, $_POST['var3']);
	if(isset($_POST['var4'])){
		$var4=str_replace($remplazar, $por," (". $_POST['var4'].")");
		$var3=$var3.$var4;
		if(isset($_POST['var5'])){
			$var3 .= str_replace($remplazar, $por,$_POST['var5']);
			if(isset($_POST['var6'])){
				$var6=str_replace($remplazar, $por," (". $_POST['var6'].")");
				$var3 .= $var6;
			}
		}
	}else{
		$var1 =str_replace($remplazar,$por,$var1);
		$var3 =str_replace($remplazar,$por,$var3);
	}
	//$con->query("SET NAMES utf8");

	$select=$con->consulta($var1,$var2,$var3);
	echo (json_encode($select));


?>
