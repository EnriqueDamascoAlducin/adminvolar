<?php
	$actual_link = $_SERVER['PHP_SELF'];
	@session_start();
	if( strpos($actual_link, "adminTest") ){
		$_SESSION['servidor']= "adminTest/";
		$_SESSION['produccion']= false;
	}else{
		$_SESSION['servidor']= "admin1/";
		$_SESSION['produccion']= true;
	}
	require_once 'login.php';
	//require_once 'mantenimiento.php';


?>
