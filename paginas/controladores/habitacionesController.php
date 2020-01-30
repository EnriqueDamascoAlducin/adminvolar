<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	$tabla= 'habitaciones_volar';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$id = $_POST['id'];
		$eliminar=$con->actualizar($tabla,"status=0", " id_habitacion=".$id);
		if ($eliminar=='ok'){
			$eliminar='Eliminado';
		}
		echo $eliminar;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){	
		$nombre = $_POST['nombre'];
		$precio = $_POST['precio'];
		$capacidad = $_POST['capacidad'];
		$descripcion = $_POST['descripcion'];
		$hotel = $_POST['hotel'];
		
		$campos ='nombre_habitacion,idhotel_habitacion,precio_habitacion,capacidad_habitacion,descripcion_habitacion';
		$valores = '"'.$nombre.'", "'.$hotel.'","'.$precio.'","'.$capacidad.'","'.$descripcion.'"';
		$registro=$con->insertar($tabla,$campos,$valores);
		if ($registro=='ok'){
			$registro='Agregado';
		}
		echo $registro;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	
		$nombre = $_POST['nombre'];
		$precio = $_POST['precio'];
		$capacidad = $_POST['capacidad'];
		$descripcion = $_POST['descripcion'];
		$idHabitacion = $_POST['idHabitacion'];
		$id = $_POST['id'];

		$campos ='nombre_habitacion="'.$nombre.'",precio_habitacion="'.$precio.'",capacidad_habitacion="'.$capacidad.'",descripcion_habitacion="'.$descripcion.'"';
		$actualizar=$con->actualizar($tabla,$campos, " id_habitacion=".$idHabitacion);
		if ($actualizar=='ok'){
			$actualizar='Actualizado';
		}
		echo $actualizar;
	}
		
	
		
?>
