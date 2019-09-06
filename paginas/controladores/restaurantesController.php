<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	$tabla= 'restaurantes_volar';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$id = $_POST['id'];
		$eliminar=$con->actualizar($tabla,"status=0", " id_restaurant=".$id);
		if ($eliminar=='ok'){
			$eliminar='Eliminado';
		}
		echo $eliminar;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){	
		$nombre = $_POST['nombre'];
		$hotel = $_POST['hotel'];
		$calle = $_POST['calle'];
		$noint = $_POST['noint'];
		$noext = $_POST['noext'];
		$colonia = $_POST['colonia'];
		$municipio = $_POST['municipio'];
		$estado = $_POST['estado'];
		$cp = $_POST['cp'];
		$telefono = $_POST['telefono'];
		$telefono2 = $_POST['telefono2'];
		$precioa = $_POST['precioa'];
		$precion = $_POST['precion'];
		if($hotel==0){
			$campos ='nombre_restaurant,hotel_restaurant,calle_restaurant,noint_restaurant,noext_restaurant,colonia_restaurant,municipio_restaurant,estado_restaurant,cp_restaurant,telefono_restaurant,telefono2_restaurant,precioa_restaurant,precion_restaurant';
			$valores = '"'.$nombre.'","'.$hotel.'","'.$calle.'","'.$noint.'","'.$noext.'","'.$colonia.'","'.$municipio.'","'.$estado.'","'.$cp.'","'.$telefono.'","'.$telefono2.'","'.$precioa.'","'.$precion.'"';
			//echo "INSERT INTO $tabla ($campos) values($valores) ";
			$registro=$con->insertar($tabla,$campos,$valores);
		}else{
			$registro=$con->query("CALL registrarHabitacionHotel(".$hotel.",'".$nombre."', '".$precion."','".$precioa."',@LID )");
			$registro= $con->query("Select @LID as lid")->fetchAll(PDO::FETCH_OBJ);
			if($registro[0]->lid>0){
				$registro='ok';
			}
		}
		if ($registro=='ok'){
			$registro='Agregado';
		}
		echo $registro;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	
		$nombre = $_POST['nombre'];
		$hotel = $_POST['hotel'];
		$calle = $_POST['calle'];
		$noint = $_POST['noint'];
		$noext = $_POST['noext'];
		$colonia = $_POST['colonia'];
		$municipio = $_POST['municipio'];
		$estado = $_POST['estado'];
		$cp = $_POST['cp'];
		$telefono = $_POST['telefono'];
		$telefono2 = $_POST['telefono2'];
		$precioa = $_POST['precioa'];
		$precion = $_POST['precion'];
		$id = $_POST['id'];
		if($hotel==0){
			$campos = 'nombre_restaurant="'.$nombre.'",hotel_restaurant="'.$hotel.'",calle_restaurant="'.$calle.'",noint_restaurant="'.$noint.'",noext_restaurant="'.$noext.'",colonia_restaurant="'.$colonia.'",municipio_restaurant="'.$municipio.'",estado_restaurant="'.$estado.'",cp_restaurant="'.$cp.'",telefono_restaurant="'.$telefono.'",telefono2_restaurant="'.$telefono2.'",precioa_restaurant="'.$precioa.'",precion_restaurant="'.$precion.'"';	

			$actualizar=$con->actualizar($tabla,$campos, " id_restaurant=".$id);
		}else{
			$act=$con->query("CALL actualizarDireccionesRestaurantes(".$hotel.", '".$nombre."' ,'".$precion."','".$precioa."',".$id.", @respuesta)");
		
			$act= $con->query("Select @respuesta as respuesta")->fetchAll(PDO::FETCH_OBJ);
			if($act[0]->respuesta!=''){
				$actualizar='ok';
			}else{
				$actualizar='Falla';
			}
		}
		if ($actualizar=='ok'){
			$actualizar='Actualizado';
		}
		echo $actualizar;
		/*

		*/
	}
		
	
		
?>
