<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$eliminarGlobo=$con->actualizar("globos_volar","status=0","id_globo=".$_POST['globo']);
		if($eliminarGlobo=='ok'){
			echo "Globo Eliminado Correcatamente";
		}else{
			echo '';
		}
	}elseif(isset($_POST['accion']) && $_POST['accion']=='agregar'){	
		$imagen = $_FILES['imagen'];
		$tamano = $imagen['size'];
		$nombreImagen = $imagen['name'];
		$provieneDe = $imagen['tmp_name'];
		$errores=0;
		$nuevoNombre="'noimage.png'";
		$nombre = "'".$_POST['nombre']."'";
		$placa = "'".$_POST['placa']."'";
		$peso = "'".$_POST['peso']."'";
		$maxpersonas = $_POST['maxpersonas'];
		if($maxpersonas==''){
			$maxpersonas="null";
		}
		$tabla="globos_volar";
		$campos="placa_globo,nombre_globo,peso_globo,maxpersonas_globo,imagen_globo";
		if($tamano>0){
			$tipo= $imagen['type'];
			if ($tipo=='image/png' || $tipo=='image/jpg' || $tipo=='image/jpeg'){
				$fechaHora = date('YmdHis');
				$nuevoNombre=$fechaHora.'_'.$nombreImagen;
	   			$guardarEn= $_SERVER['DOCUMENT_ROOT'].'/admin/sources/images/globos/'.$nuevoNombre;	
	   			$nuevoNombre="'".$nuevoNombre."'";

	   			move_uploaded_file($provieneDe, $guardarEn );
			}else{
				$errores++;
				echo "Error. Debe de ser un archivo tipo jpg o png";
			}
		}
		$valores=$placa.','.$nombre.','.$peso.','.$maxpersonas.','.$nuevoNombre;
		if($errores<=0){
			$actualizarGlobo = $con->insertar($tabla,$campos,$valores);
			if ($actualizarGlobo=="ok"){
				echo "Agregado";
			}else{
				echo "Error al procesar la solicitud";
			}
		}
		

	}elseif(isset($_POST['accion']) && $_POST['accion']=='editar'){	

		$imagen = $_FILES['imagen'];
		$tamano = $imagen['size'];
		$nombreImagen = $imagen['name'];
		$provieneDe = $imagen['tmp_name'];
		$errores=0;
		$nombre = "'".$_POST['nombre']."'";
		$placa = "'".$_POST['placa']."'";
		$peso = "'".$_POST['peso']."'";
		$maxpersonas = $_POST['maxpersonas'];
		if($maxpersonas==''){
			$maxpersonas="null";
		}
		$campos="nombre_globo=".$nombre.", placa_globo=".$placa.",peso_globo=".$peso.",maxpersonas_globo=".$maxpersonas;
		if($tamano>0){
			$tipo= $imagen['type'];
			if ($tipo=='image/png' || $tipo=='image/jpg' || $tipo=='image/jpeg'){
				$fechaHora = date('YmdHis');
				$nuevoNombre=$fechaHora.'_'.$nombreImagen;
	   			$guardarEn= $_SERVER['DOCUMENT_ROOT'].'/admin/sources/images/globos/'.$nuevoNombre;	

	   			move_uploaded_file($provieneDe, $guardarEn );
	   			$campos.= ", imagen_globo='".$nuevoNombre."'";
			}else{
				echo "Error. Debe de ser un archivo tipo jpg o png";
				$errores++;
			}
		}
		if($errores<=0){
			$actualizarGlobo = $con->actualizar("globos_volar",$campos,"id_globo=".$_POST['id']);
			if ($actualizarGlobo=="ok"){
				echo "Actualizado";
			}else{
				echo "Error al procesar la solicitud";
			}
		}
		

	}
		
?>
