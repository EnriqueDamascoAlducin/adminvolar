<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$validacion=$con->consulta("sum(cantidad_bp) as total ","bitpagos_volar","status in (1,2) AND idres_bp=".$_POST['reserva']);
		if($validacion[0]->total>0){
			echo "No puedes eliminar una reserva con pagos";
		}else{
			$eliminarReserva = $con->actualizar("temp_volar","status=0","id_temp=".$_POST['reserva']);
			$eliminarReserva = $con->actualizar("servicios_vuelo_temp","status=0","idtemp_sv=".$_POST['reserva']);
			echo $eliminarReserva;
		}

	}elseif(isset($_POST['accion']) && $_POST['accion']=='asistencia'){
		$confirmarAsistencia = $con->actualizar("temp_volar","status=1","id_temp=".$_POST['reserva']);
		$confirmarAsistencia = $con->actualizar("servicios_vuelo_temp","status=1","idtemp_sv=".$_POST['reserva']);
		echo $confirmarAsistencia;
	}elseif (isset($_POST['accion']) && $_POST['accion']=='cpc'  ) {
		$confirmarAsistencia = $con->actualizar("temp_volar","status=9","id_temp=".$_POST['reserva']);
		echo $confirmarAsistencia;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='horario'){
		$hora=$_POST['hora'];
		$reserva=$_POST['reserva'];
		if($reserva==""){
			$reserva="null";
		}
		if($hora==""){
			$hora="null";
		}else{
			$hora="'".$hora."'";
		}
		$upd="hora_temp=".$hora ;
		$asignarVuelo = $con->actualizar("temp_volar",	$upd ," id_temp=".$reserva);
		echo $asignarVuelo;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='globos'){
		$piloto=$_POST['piloto'];
		$globo=$_POST['globo'];
		$reserva=$_POST['reserva'];
		$version=$_POST['version'];
		$peso=$_POST['peso'];

		$asignarVuelo = $con->insertar("globosasignados_volar",	"reserva_ga,version_ga,globo_ga,peso_ga,piloto_ga" ,$reserva.",".$version.",".$globo.",".$peso.",".$piloto);
		echo $asignarVuelo;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='reprogramar'){
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		$reserva = $_POST['reserva'];
		$motivo = $_POST['motivo'];
		$fechavuelo = $_POST['fechavuelo'];
		$cargo = $_POST['cargo'];
		$comentario = $_POST['comentario'];
		$sql = "CALL reprogramarReserva(". $reserva .",". $idUsu .",'". $fechavuelo ."','".$comentario."','". $motivo ."',". $cargo .", @res)";
		$reprogramar = $con->query($sql);
		$reprogramar = $con->query("Select @res as rep ")->fetchALL (PDO::FETCH_OBJ);
		//Registra Pagos
		if($cargo>0){
			$totalReserva = $con->consulta("total_temp","temp_volar","id_temp=".$reserva);
			$totalReserva = $totalReserva[0]->total_temp;
			$extra        = (($totalReserva * $cargo)/100);
			$nuevoTotal   = $totalReserva + $extra;
			$valores = $reserva.",".$idUsu.",'Cargo por Reprogramación',".$extra.",'".$comentario."',1";
			$registrarCargo = $con->insertar("cargosextras_volar", "reserva_ce,usuario_ce,motivo_ce,cantidad_ce,comentario_ce,tipo_ce", $valores);
			$nuevoTotal = $con->actualizar("temp_volar","total_temp=".$nuevoTotal,"id_temp=".$reserva);
		}

		echo $reprogramar[0]->rep;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='comentar'){
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		$comentario = $_POST['comentario'];
		$reserva = $_POST['reserva'];
		$sql = "CALL registrarComentario('".$comentario."',". $idUsu .",".$reserva.",@respuesta)";
		$comentario = $con->query($sql);
		$comentario = $con->query("Select @respuesta as rep ")->fetchALL (PDO::FETCH_OBJ);
		echo $comentario[0]->rep;
	}else{
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
	}

?>
