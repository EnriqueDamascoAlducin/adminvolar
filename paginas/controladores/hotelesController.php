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
		$noext = $_POST['noext'];
		$colonia = $_POST['colonia'];
		$municipio = $_POST['municipio'];
		$estado = $_POST['estado'];
		$cp = $_POST['cp'];
		$telefono = $_POST['telefono'];
		$telefono2 = $_POST['telefono2'];
		if($cp==""){
			$cp="null";
		}
		$campos ='nombre_hotel,calle_hotel,noint_hotel,noext_hotel,colonia_hotel,municipio_hotel,estado_hotel,cp_hotel,telefono_hotel,telefono2_hotel';
		$valores = '"'.$nombre.'", "'.$calle.'","'.$noint.'","'.$noext.'","'.$colonia.'","'.$municipio.'",'.$estado.','.$cp.',"'.$telefono.'","'.$telefono2.'"';
		$registro=$con->insertar($tabla,$campos,$valores);
		if ($registro=='ok'){
			$registro='Agregado';
		}
		echo $registro;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	
		$nombre = $_POST['nombre'];
		$calle = $_POST['calle'];
		$noint = $_POST['noint'];
		$noext = $_POST['noext'];
		$colonia = $_POST['colonia'];
		$municipio = $_POST['municipio'];
		$estado = $_POST['estado'];
		$cp = $_POST['cp'];
		$telefono = $_POST['telefono'];
		$telefono2 = $_POST['telefono2'];
		$id = $_POST['id'];
		if($cp==""){
			$cp="null";
		}

		$campos ='nombre_hotel="'.$nombre.'",calle_hotel="'.$calle.'",noint_hotel="'.$noint.'",noext_hotel="'.$noext.'" ,colonia_hotel ="'.$colonia.'",municipio_hotel="'.$municipio.'",estado_hotel="'.$estado.'",cp_hotel='.$cp.',telefono_hotel="'.$telefono.'",telefono2_hotel="'.$telefono2.'"';
		
		$actualizar=$con->actualizar($tabla,$campos, " id_hotel=".$id);
		if ($actualizar=='ok'){
			$actualizar='Actualizado';
		}
		echo $actualizar;
	}
		
	
		
?>
