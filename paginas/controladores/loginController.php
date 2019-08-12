<?php

	include_once 'conexion.php';
	$pass=$_POST['pass'];
	$usr = $_POST['user'];
	$usuario=$con->query("CALL usuarioLoggeado('". $usr ."' , '". md5($pass) ."')");
	$usuario = $usuario->fetchALL (PDO::FETCH_OBJ);
	if(sizeof($usuario)>0 && $usuario[0]->usuario_usu==$usr){
		session_start();
		$_SESSION['ruta']=$_SERVER['DOCUMENT_ROOT'].'/admin1/';
		require  $_SESSION['ruta'].'paginas/modelos/login.php';
		$_SESSION['usuario']=base64_encode(serialize(crearUsuarioBean($usuario)));
		echo "Bienvenido ".$usuario[0]->nombre_usu;//900 segundos de timepo ==15min
		$_SESSION['max-tiempo']=60*15;
		$_SESSION[ 'ULTIMA_ACTIVIDAD' ] = time();
		
	}else{
		echo "falla";
	}
?>
