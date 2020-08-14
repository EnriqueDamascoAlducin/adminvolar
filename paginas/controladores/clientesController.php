<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	if(isset($_POST['accion']) && $_POST['accion']=='eliminar'){
		$eliminar = $con->actualizar("clientes_volar","status=0","id_cliente=".$_POST['cliente']);
		if($eliminar=='ok'){
			echo "Eliminado";
		}else{
			echo $eliminar;
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='agregar') {
		$campos = "id_cliente";
		$valores = "null";
		foreach ($_POST as $campo => $valor) {
			if($campo!='accion'){
				$campos.=",".$campo."_cliente";
				if($valor==""){
					$valores.=",null";
				}else{
					$valores.=",'".$valor."'";
				}
			}
		}
		$insertar = $con->insertar("clientes_volar",$campos,$valores);
		if($insertar=='ok'){
			echo "Correctamente";
		}else{
			echo "error";
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='editar'  ) {
			$campos = "";
			$valores = "";
		foreach ($_POST as $campo => $valor) {
			if($campo!='accion' && $campo!='id' ){
				if($valor==""){
					$valor="null";
				}else{
					$valor="'".$valor."'";
				}
				$campos.= $campo ."_cliente =".$valor.",";
			}
		}
		$campos = substr($campos, 0, strlen($campos)-1);
		$actualizar = $con->actualizar("clientes_volar",$campos,"id_cliente = ".$_POST['id']);
	}
?>
