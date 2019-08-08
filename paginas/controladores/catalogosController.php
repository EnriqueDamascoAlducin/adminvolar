<?php
	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		
			$eliminar = $con->actualizar("extras_volar","status=0","id_extra=".$_POST['elemento']);
			echo $eliminar;
		
		
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){
		$clasificacion="'".$_POST['clasificacion']."'";
		$nombre = "'".$_POST['nombre']."'";
		if($_POST['abrev']==''){
			$abrev="null";
		}else{
			$abrev="'".$_POST['abrev']."'";	
		}
		$registra = $con->insertar("extras_volar","nombre_extra,abrev_extra,clasificacion_extra",$nombre.",".$abrev.",".$clasificacion);
		
		if($registra=='ok'){
			echo "Agregado";
		}else{
			echo $registra;
		}
	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){
		$clasificacion="'".$_POST['clasificacion']."'";
		$nombre = "'".$_POST['nombre']."'";
		$extra = $_POST['id'];
		if($_POST['abrev']==''){
			$abrev="null";
		}else{
			$abrev="'".$_POST['abrev']."'";	
		}
		$registra = $con->actualizar("extras_volar","nombre_extra=".$nombre.",abrev_extra=".$abrev.",clasificacion_extra=".$clasificacion ,"id_extra=".$extra);
		if( $registra){
			echo "Actualizado";
		}
	}

?>