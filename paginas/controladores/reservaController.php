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
	}elseif (isset($_POST['accion']) && $_POST['accion']=='no-show'  ) {
		$confirmarAsistencia = $con->actualizar("temp_volar","status=10","id_temp=".$_POST['reserva']);
		echo $confirmarAsistencia;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='horario'){
		$hora=$_POST['hora'];
		$turno=$_POST['turno'];
		$reserva=$_POST['reserva'];
		if($reserva==""){
			$reserva="null";
		}
		if($turno==""){
			$turno="null";
		}
		if($hora==""){
			$hora="null";
		}else{
			$hora="'".$hora."'";
		}
		$upd="hora_temp=".$hora .", turno_temp=".$turno;
		$asignarVuelo = $con->actualizar("temp_volar",	$upd ," id_temp=".$reserva);
		echo $asignarVuelo;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='globos'){
		$piloto=$_POST['piloto'];
		$globo=$_POST['globo'];
		$reserva=$_POST['reserva'];
		$version=$_POST['version'];
		$peso=$_POST['peso'];
		$pax=$_POST['pax'];
		if(isset($_POST['comentario']) && !empty($_POST['comentario'])){
			$comentario = "'".$_POST['comentario']."'";
		}else{
			$comentario ="null";
		}
		$asignarVuelo = $con->insertar("globosasignados_volar",	"reserva_ga,version_ga,globo_ga,peso_ga,piloto_ga,pax_ga,comentario_ga" ,$reserva.",".$version.",".$globo.",".$peso.",".$piloto.",".$pax.",".$comentario);
		echo $asignarVuelo;
	}elseif(isset($_POST['accion']) && $_POST['accion']=='eliminarGlobos'){
		$version=$_POST['version'];
		$reserva=$_POST['reserva'];

		$asignarVuelo = $con->actualizar("globosasignados_volar",	"status=0" ,"reserva_ga = ".$reserva . " and version_ga =".$version);
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
			$registrarCargo = $con->insertar("cargosextras_volar", "reserva_ce,usuario_ce,motivo_ce,cantidad_ce,comentario_ce,tipo_ce,status", $valores.",1");
			
			//Actualizar el total de la reserva
			//$nuevoTotal = $con->actualizar("temp_volar","total_temp=".$nuevoTotal,"id_temp=".$reserva);

			//Solicitar Conciliación de Pago
			$tipoCorreo = "Cargos";
			$tipo = "CARGO";
			$motivo = "Cargo por Reprogramación";
			$cantidad = $extra;
			include_once 'correoController.php';
		}
		/*
			$ultimoPago = $con->consulta("(id_bp) as ultimoPago ","bitpagos_volar","status in(1,2) and idres_bp=".$reserva);
			if(sizeof($ultimoPago)>0){
				$actulizarUltimoPago = $con->actualizar("bitpagos_volar","status= 3","id_bp=".$ultimoPago[0]->ultimoPago);
			}
		*/
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
	}elseif(isset($_POST['accion']) && $_POST['accion']=='conciliarMovimiento'){
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
		$movimiento = $_POST['movimiento'];
		$status = $_POST['status'];
		$tipo = strtoupper($_POST['tipo']);
		$infoCargo = $con->consulta("motivo_ce as motivo,cantidad_ce as cantidad,reserva_ce as reserva,CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,'')) as usuario, correo_usu as correo","cargosextras_volar INNER JOIN volar_usuarios ON usuario_ce = id_usu ","id_ce=".$movimiento);
		$correos[] = array($infoCargo[0]->correo, $infoCargo[0]->usuario);
		$updateStatusMovimiento = $con->actualizar("cargosextras_volar","status=".$status,"id_ce=".$movimiento);

		
		//Para responder correo
		$tipoCorreo = 'CargoConciliado';
		$encabezado = $infoCargo[0]->motivo;
		if($status == 1){
			$totalReserva = $con->consulta("total_temp as total","temp_volar","id_temp=".$infoCargo[0]->reserva);
			if($tipo=="CARGO"){
				$nuevoTotal = $totalReserva[0]->total + $infoCargo[0]->cantidad;
			}else{
				$nuevoTotal = $totalReserva[0]->total - $infoCargo[0]->cantidad;
			}
			$updatePrecio = $con->actualizar("temp_volar","total_temp='".$nuevoTotal."'","id_temp=".$infoCargo[0]->reserva);
			$asunto = $tipo." Conciliado";
			$texto = "No olvides enviar el movimiento al cliente";
			$texto_a = "Entra aqui para enviar la confirmación ";
		}else{
			$texto = "El movimiento fue rechazado";
			$texto_a = "";
			$asunto = $tipo." Rechazado";
		}
		include_once 'correoController.php';
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
				if($campo=="tipo"){
					
					$getPrecios = $con->consulta("precioa_vc as precioa, precion_vc as precion","vueloscat_volar","id_vc = ".$valor);
					$registrarDato=$con->actualizar("temp_volar","preciovueloa_temp='".$getPrecios[0]->precioa."', preciovuelon_temp='".$getPrecios[0]->precion ."'", "id_temp=$id");
				}
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
			$precioActual = $_POST['precioActual'];
			$servicio =  $con->query("CALL agregarServiciosReservas($reserva,$servicio,$tipo,$valor,$precioActual,@accion)");
			$servicio = $con->query("Select @accion as respuesta")->fetchALL (PDO::FETCH_OBJ);
			echo $servicio[0]->respuesta;
		}
	}

?>
