<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
		$reserva = $_POST['id'];
	if(!isset($_POST['tipo'])){
		$campo = $_POST['campo'];
		$valor = $_POST['valor'];
		$id= $_POST['id'];
		if($valor==""){
			$valor = "null";
		}else{
			$valor="'".$valor."'";
		}
		if($campo=="tdescuento"){	
			$registrarDato=$con->actualizar("temp_volar","cantdescuento_temp=0" , "id_temp=$id");
		}
		if($campo=="hotel"){	
			$registrarDato=$con->actualizar("temp_volar","habitacion_temp=null" , "id_temp=$id");
		}
		$registrarDato=$con->actualizar("temp_volar",$campo ."_temp=". $valor , "id_temp=$id");
		echo $registrarDato;
	}else{
		$valor = $_POST['valor'];
		$tipo = $_POST['tipo'];
		$servicio = $_POST['servicio'];
		$servicio =  $con->query("CALL agregarServiciosReservas($reserva,$servicio,$tipo,$valor,@accion)");
		$servicio = $con->query("Select @accion as respuesta")->fetchALL (PDO::FETCH_OBJ);
		echo $servicio[0]->respuesta;
	}
		
?>
