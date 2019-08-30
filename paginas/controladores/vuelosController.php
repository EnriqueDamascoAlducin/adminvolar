<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$id = $_POST['id'];
		$eliminar=$con->actualizar("vueloscat_volar","status=0", " id_vc=".$id);
		if ($eliminar=='ok'){
			$eliminar='Actualizado';
		}
		echo $id;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){	
		$nombre = $_POST['nombre'];
		$tipo = $_POST['tipo'];
		$precioa = $_POST['precioa'];
		$precion = $_POST['precion'];
		$registro=$con->insertar("vueloscat_volar","nombre_vc,tipo_vc,precioa_vc,precion_vc","'".$nombre."', ".$tipo.",".$precioa.",".$precion);
		if ($registro=='ok'){
			$registro='Agregado';
		}
		echo $registro;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	
		$nombre = $_POST['nombre'];
		$tipo = $_POST['tipo'];
		$precioa = $_POST['precioa'];
		$precion = $_POST['precion'];
		$id = $_POST['id'];
		$campos = "nombre_vc='".$nombre."', tipo_vc=".$tipo.",precioa_vc=".$precioa.",precion_vc=".$precion;
		$actualizar=$con->actualizar("vueloscat_volar",$campos, " id_vc=".$id);
		if ($actualizar=='ok'){
			$actualizar='Actualizado';
		}
		echo $actualizar;
	}
		
	
		
?>
