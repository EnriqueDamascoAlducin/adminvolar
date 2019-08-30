<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	$tabla= 'hoteles_volar';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$id = $_POST['id'];
		$eliminar=$con->actualizar($tabla,"status=0", " id_hotel=".$id);
		if ($eliminar=='ok'){
			$eliminar='Eliminado';
		}
		echo $eliminar;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){	
		$nombre = $_POST['nombre'];
		$calle = $_POST['calle'];
		$noint = $_POST['noint'];
		$colonia = $_POST['colonia'];
		$municipio = $_POST['municipio'];
		$estado = $_POST['estado'];
		$cp = $_POST['cp'];
		$telefono = $_POST['telefono'];
		$telefono2 = $_POST['telefono2'];
		$campos ='nombre_hotel,calle_hotel,noint_hotel,noext_hotel,colonia_hotel,municipio_hotel,estado_hotel,cp_hotel,telefono_hotel,telefono2_hotel';
		$registro=$con->insertar($tabla,$campos,"'".$nombre."', ".$tipo.",".$precioa.",".$precion);
		if ($registro=='ok'){
			$registro='Agregado';
		}
		echo $registro;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	
		$nombre = $_POST['nombre'];
		$calle = $_POST['calle'];
		$noint = $_POST['noint'];
		$colonia = $_POST['colonia'];
		$municipio = $_POST['municipio'];
		$estado = $_POST['estado'];
		$cp = $_POST['cp'];
		$telefono = $_POST['telefono'];
		$telefono2 = $_POST['telefono2'];
		$id = $_POST['id'];
		$campos = "nombre_vc='".$nombre."', tipo_vc=".$tipo.",precioa_vc=".$precioa.",precion_vc=".$precion;
		$actualizar=$con->actualizar($tabla,$campos, " id_vc=".$id);
		if ($actualizar=='ok'){
			$actualizar='Actualizado';
		}
		echo $actualizar;
	}
		
	
		
?>
