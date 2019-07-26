<?php

	include_once 'conexion.php';
	$pass=$_POST['pass'];
	$usr = $_POST['user'];
	$usuario=$con->query("CALL usuarioLoggeado('". $usr ."' , '". md5($pass) ."')");
	$usuario = $usuario->fetchALL (PDO::FETCH_OBJ);
	if(sizeof($usuario)>0){
		session_start();
		$_SESSION['ruta']=$_SERVER['DOCUMENT_ROOT'].'/admin/';
		require  $_SESSION['ruta'].'paginas/modelos/login.php';
		$_SESSION['usuario']=base64_encode(serialize(crearUsuarioBean($usuario)));
		echo "Bienvenido ".$usuario[0]->nombre_usu;
		
	}else{
		echo "falla";
	}
?>
