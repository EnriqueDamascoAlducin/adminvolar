<?php

	include_once 'conexion.php';
	$pass=$_POST['pass'];
	$usr = $_POST['user'];
	$usuario=$con->query("CALL usuarioLoggeado('". $usr ."' , '". md5($pass) ."')");
	$usuario = $usuario->fetchALL (PDO::FETCH_OBJ);
	if(sizeof($usuario)>0){
		include_once'../modelos/login.php';
		session_start();

		$_SESSION['usuario']=createSession($usuario);
		print_r($_SESSION['usuario']->getIdUsu());
		
	}else{
		echo "falla";
	}
?>
