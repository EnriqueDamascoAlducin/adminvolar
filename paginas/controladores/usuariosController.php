<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$eliminarReserva = $con->actualizar("volar_usuarios","status=0","id_usu=".$_POST['usuario']);
		echo $eliminarReserva;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='permisos'){
		$usuario = $_POST['usuario'];
		$permiso = $_POST['permiso'];
		$status = $_POST['status'];
		$actualizarPermiso = $con->query("CALL asigarPermisosModulos(". $usuario .",". $permiso .",". $status .",@respuesta)") ;
		$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
		echo $respuesta[0]->respuesta;
	}else{	
		$idusu = $_POST['idusu'];
		$nombre = "'".$_POST['nombre']."'";
		$apellidop = "'".$_POST['apellidop']."'";
		$apellidom = $_POST['apellidom'];
		$depto = $_POST['depto'];
		$puesto = $_POST['puesto'];
		$correo = "'".$_POST['correo']."'";
		$telefono = "'".$_POST['telefono']."'";
		$usuario = "'".$_POST['usuario']."'";
		$contrasena = $_POST['contrasena'];
		if($idusu==""){
			$idusu="''";
		}
		if($apellidom==""){
			$apellidom="null";
		}else{

			$apellidom="'".$apellidom."'";
		}
		if($contrasena!=""){
			$contrasena="'".md5($contrasena)."'";
		}else{
			$contrasena="''";
		}
		$campos = $idusu.",".$nombre.",".$apellidop.",".$apellidom.",".$depto.",".$puesto.",".$correo.",".$telefono.",".$contrasena.",".$usuario;
		$registrarUsuario=$con->query("CALL registrarUsuario(".$campos.",@respuesta)");
		$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);;
		echo $respuesta[0]->respuesta;
	}
		
?>
