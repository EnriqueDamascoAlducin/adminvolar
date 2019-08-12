<?php
	date_default_timezone_set("America/Mexico_City");
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$eliminarServicio=$con->query("CALL eliminarServicio(". $_POST['servicio'] .",@respuesta)");
		$respuesta = $con->query("Select @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
		echo $respuesta[0]->respuesta;
	}else{
		$imagen = $_FILES['imagen'];
		$tamano = $imagen['size'];
		$nombre = $imagen['name'];
		$provieneDe = $imagen['tmp_name'];

		$servicio = $_POST['servicio'];
		$precio = $_POST['precio'];
		$cortesia = $_POST['cortesia'];
		$cantmax = $_POST['cantmax'];
		if(isset($_POST['id'])){
			$campos= "nombre_servicio='".$servicio."',precio_servicio='".$precio."',cortesia_servicio=".$cortesia.",cantmax_servicio=".$cantmax;
			if($tamano>0){
				$tipo= $imagen['type'];
				if ($tipo=='image/png' || $tipo=='image/jpg' || $tipo=='image/jpeg'){
					$fechaHora = date('YmdHis');
					$nuevoNombre=$fechaHora.'_'.$nombre;
		   			$guardarEn= $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/images/servicios/'.$nuevoNombre;	
		   			move_uploaded_file($provieneDe, $guardarEn );
		   			$campos.= ", img_servicio='".$nuevoNombre."'";
				}else{
					echo "Error. Debe de ser un archivo tipo jpg o png";
				}
			}else{
		   		$campos.= ", img_servicio='noimage.png'";
			}
			$actualizaServicio = $con->actualizar("servicios_volar",$campos,"id_servicio=".$_POST['id']);
			if ($actualizaServicio=="ok"){
				echo "Actualizado";
			}else{
				echo "Error al procesar la solicitud";
			}
		}else{
			$nuevoNombre="noimage.png";
			if($tamano>0){
				$tipo= $imagen['type'];
				if ($tipo=='image/png' || $tipo=='image/jpg' || $tipo=='image/jpeg'){
					$fechaHora = date('YmdHis');
					$nuevoNombre=$fechaHora.'_'.$nombre;
		   			$guardarEn= $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/images/servicios/'.$nuevoNombre;	
		   			move_uploaded_file($provieneDe, $guardarEn );
		   			$campos.= ", img_servicio='".$nuevoNombre."'";
				}else{
					echo "Error. Debe de ser un archivo tipo jpg o png";
				}
			}
			$tabla = "servicios_volar";
			$campos = "nombre_servicio,precio_servicio,img_servicio,cortesia_servicio,cantmax_servicio";
			$valores = "'".$servicio."','".$precio."','".$nuevoNombre."',".$cortesia.",".$cantmax;
			$registrarServicio = $con->insertar($tabla,$campos,$valores); 
			if($registrarServicio=="ok"){
				echo "Registrado";
			}else{
				echo "Error al procesar la solicitud";
			}
		}
	}
	 
	
	
	
?>