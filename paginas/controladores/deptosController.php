<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$eliminarReserva = $con->query("CALL eliminarDepartamento(".$_POST['depto'].",@respuesta)");
		$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);;
		echo $respuesta[0]->respuesta;
		echo "<br>El departamento ha sido eliminado. Se elimino este departamento y los puestos de los usuarios que lo ocupaban";
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
	}elseif(isset($_POST['accion']) && $_POST['accion']=='eliminarPuesto'){
		$puesto = $_POST['puesto'];
		$eliminarPuesto = $con->query("CALL eliminarPuesto(". $puesto .",@respuesta)") ;
		$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
		if($respuesta[0]->respuesta=="Eliminado"){
			echo "El puesto ha sido eliminado. Se elimino este puesto de los usuarios que lo ocupaban";
		}else{
			echo $respuesta[0]->respuesta;
		}
	}elseif(isset($_POST['accion']) && $_POST['accion']=='actualizarPuesto'){
		$puesto = $_POST['puesto'];
		$actPuesto = $con->consulta("nombre_puesto as nombre, id_puesto as id","puestos_volar","id_puesto=".$puesto) ;
		echo $actPuesto[0]->nombre.'|'.$actPuesto[0]->id;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='registrarPuesto'){
		$puesto = $_POST['puesto'];
		$nombre = strtoupper($_POST['nombre']);
		$depto = $_POST['depto'];
		if($puesto==""){
			$regPuesto = $con->insertar("puestos_volar","nombre_puesto,depto_puesto","'".$nombre."',".$depto);
			if($regPuesto=='ok'){
				echo "Puesto Registrado";
			}else{
				echo "Error";
			}
		}else{
			$regPuesto = $con->actualizar("puestos_volar","nombre_puesto='".$nombre."'","id_puesto=".$puesto);
			if($regPuesto=='ok'){
				echo "Puesto Actualizado";
			}else{
				echo "Error";
			}
		}
		
	}
		
?>
