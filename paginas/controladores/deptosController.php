<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$eliminarReserva = $con->query("CALL eliminarDepartamento(".$_POST['depto'].",@respuesta)");
		$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);;
		echo $respuesta[0]->respuesta;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='permisos'){
		$usuario = $_POST['usuario'];
		$permiso = $_POST['permiso'];
		$status = $_POST['status'];
		$actualizarPermiso = $con->query("CALL asigarPermisosModulos(". $usuario .",". $permiso .",". $status .",@respuesta)") ;
		$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);;
		echo $respuesta[0]->respuesta;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){	

		$nombre = $_POST['nombre'];
		$registro=$con->insertar("departamentos_volar","nombre_depto","'". strtoupper( $nombre)."'");
		if ($registro=='ok'){
			$registro='Agregado';
		}
		echo $registro;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	

		$nombre = $_POST['nombre'];
		$depto = $_POST['depto'];
		$actualizar=$con->actualizar("departamentos_volar","nombre_depto='".$nombre."'", " id_depto=".$depto);
		if ($actualizar=='ok'){
			$actualizar='Actualizado';
		}
		echo $actualizar;
	}
		
?>
