<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	if(isset($_POST['accion']) && $_POST['accion']=='cancelar'){
		$conciliar = $con->actualizar("bitpagos_volar","status=0","id_bp=".$_POST['pago']);
		if($conciliar=='ok'){
			echo "Eliminado";
		}else{
			echo $conciliar;
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='conciliar') {
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		$parametros = $_POST['pago'].',0,0,0,0,"",0,"0",'.$idUsu.',0,0,0,0';
		$sql="CALL registrarPago(". $parametros .",@respuesta)";
		$registrarPago = $con->query($sql);
		$registrarPago = $con->query("Select @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
		if($registrarPago[0]->respuesta=="ERROR EN PAGO"){
			echo $registrarPago[0]->respuesta;
		}else{
			$respuesta=explode("|", $registrarPago[0]->respuesta);
			$pago = $respuesta[1];
			require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/correoRespuestaConciliacion.php';
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='simple'  ) {
		$validar = $con->actualizar("bitpagos_volar","status=2","id_bp=".$_POST['pago']);
		echo $validar;
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/correoConfirmacion.php';
		$cotizado = $con->consulta("total_temp","temp_volar","id_temp=".$reserva);
		$pagado = $con->consulta("SUM(cantidad_bp) as pagado","bitpagos_volar","status<> 0 and idres_bp=".$reserva);
		if($cotizado[0]->total_temp==$pagado[0]->pagado){
			$accion = $con->actualizar("temp_volar","status=8","id_temp=".$reserva);
		}elseif($cotizado[0]->total_temp>$pagado[0]->pagado){
			$accion = $con->actualizar("temp_volar","status=8","id_temp=".$reserva);
		}elseif($cotizado[0]->total_temp<$pagado[0]->pagado){
			echo "Sobrepasaste los pagos";
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='regalo'  ) {
		$validar = $con->actualizar("bitpagos_volar","status=1","id_bp=".$_POST['pago']);
		echo $validar;
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/correoRegalo.php';
	}elseif (isset($_POST['accion']) && $_POST['accion']=='registrarPago'  ) {
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		$peso=$_POST['peso'];
		$tipopeso=$_POST['tipopeso'];
		$reserva=$_POST['reserva'];
		if(isset($_POST['metodo'])){
			$metodo=$_POST['metodo'];
			$banco=$_POST['banco'];
			$referencia=$_POST['referencia'];
			$cantidad=$_POST['cantidad'];
			$fecha=$_POST['fecha'];
			$moneda=$_POST['moneda'];
			$monedaPrecio=$_POST['monedaPrecio'];
			//Actualiza peso
			$actualizarPeso=$con->actualizar("temp_volar","kg_temp='".$peso."',tipopeso_temp=".$tipopeso,"id_temp=".$reserva);
			//Registra Pagos
			$parametros = '0,'. $reserva.','.$idUsu.','.$metodo.','.$banco.',"'.$referencia.'",'.$cantidad.',"'.$fecha.'",0,0,0,'.$moneda.',"'. $monedaPrecio .'"';
			$sql="CALL registrarPago(". $parametros .",@respuesta)";
			//echo $sql;
			$registrarPago = $con->query($sql);
			$registrarPago = $con->query("Select @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
			if($registrarPago[0]->respuesta=="ERROR EN PAGO"){
				echo $registrarPago[0]->respuesta;
			}else{
				$respuesta=explode("|", $registrarPago[0]->respuesta);
				$pago = $respuesta[1];
				require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/correoSolicitudConciliacion.php';
			}
		}else{
			//Actualiza Peso
			$actualizarPeso=$con->actualizar("temp_volar","kg_temp='".$peso."',tipopeso_temp=".$tipopeso,"id_temp=".$reserva);
			if($actualizarPeso=='ok'){
				echo "Peso Actualizado";
			}else{
				echo $actualizarPeso;
			}
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='registrarPagoSitio'  ) {
		require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		$metodo=$_POST['metodo'];
		$banco=$_POST['banco'];
		$referencia=$_POST['referencia'];
		$reserva=$_POST['reserva'];
		$cantidad=$_POST['cantidad'];
		$fecha=$_POST['fecha'];
		$comision=$_POST['comision'];
		$cupon=$_POST['cupon'];
		$moneda=$_POST['moneda'];
		$monedaPrecio=$_POST['monedaPrecio'];
		if($cupon==''){
			$cupon=0;
		}
		//Registra Pagos
		$pagado = $con->consulta("sum(cantidad_bp) as pagado","bitpagos_volar","status<>0 AND idres_bp=".$reserva);
		$totalReserva = $con->consulta("total_temp","temp_volar","id_temp=".$reserva);
		$porAplicarDesc = $totalReserva[0]->total_temp -$pagado[0]->pagado;
		$parametros = '0,'. $reserva.','.$idUsu.','.$metodo.','.$banco.',"'.$referencia.'",'.$cantidad.',"'.$fecha.'",0,'.$comision.','.$cupon.','.$moneda.',"'. $monedaPrecio .'"';
		$sql="CALL registrarPago(". $parametros .",@respuesta)";
		//echo $sql;
		$registrarPago = $con->query($sql);
		$registrarPago = $con->query("Select @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
	//	print_r($registrarPago);
		if($registrarPago[0]->respuesta=="ERROR EN PAGO"){
			echo $registrarPago[0]->respuesta;
		}else{
			$respuesta=explode("|", $registrarPago[0]->respuesta);
			//print_r( $respuesta);
			$pago = $respuesta[1];
			echo $respuesta[0];
		}
		if($cupon==1){
			$desc = $porAplicarDesc * .05;
			$nuevoTotal = $totalReserva[0]->total_temp - $desc;
			$valores = $reserva.",".$idUsu.",'Aplica Cupón de 5%',".$desc.",'Se aplicó cupón por pago en efectivo',2";
			$registrarCargo = $con->insertar("cargosextras_volar", "reserva_ce,usuario_ce,motivo_ce,cantidad_ce,comentario_ce,tipo_ce", $valores);
			$nuevoTotal = $con->actualizar("temp_volar","total_temp=".$nuevoTotal,"id_temp=".$reserva);
		}
	}elseif (isset($_POST['accion']) && $_POST['accion']=='cargosExtras'  ) {
			require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
			$usuario= unserialize((base64_decode($_SESSION['usuario'])));
			$idUsu=$usuario->getIdUsu();
			$motivoCar = $_POST['motivoCar'];
			$cantidadCar = $_POST['cantidadCar'];
			$comentarioCar = $_POST['comentarioCar'];
			$reserva = $_POST['reserva'];
			$valores = $reserva.','.$idUsu.',"'.$motivoCar.'","'.$cantidadCar.'","'.$comentarioCar.'",1';
			$registrarCargo = $con->insertar("cargosextras_volar", "reserva_ce,usuario_ce,motivo_ce,cantidad_ce,comentario_ce,tipo_ce", $valores);
			echo $registrarCargo;

			$totalReserva = $con->consulta("total_temp","temp_volar","id_temp=".$reserva);
			$nuevoTotal = $totalReserva[0]->total_temp + $cantidadCar;
			$nuevoTotal = $con->actualizar("temp_volar","total_temp=".$nuevoTotal,"id_temp=".$reserva);
	}elseif (isset($_POST['accion']) && $_POST['accion']=='descuentos'  ) {
			require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
			$usuario= unserialize((base64_decode($_SESSION['usuario'])));
			$idUsu=$usuario->getIdUsu();
			$motivoCar = $_POST['motivoCar'];
			$cantidadCar = $_POST['cantidadCar'];
			$comentarioCar = $_POST['comentarioCar'];
			$reserva = $_POST['reserva'];
			$valores = $reserva.','.$idUsu.',"'.$motivoCar.'","'.$cantidadCar.'","'.$comentarioCar.'",2';
			$registrarCargo = $con->insertar("cargosextras_volar", "reserva_ce,usuario_ce,motivo_ce,cantidad_ce,comentario_ce,tipo_ce", $valores);
			echo $registrarCargo;

			$totalReserva = $con->consulta("total_temp","temp_volar","id_temp=".$reserva);
			$nuevoTotal = $totalReserva[0]->total_temp - $cantidadCar;
			$nuevoTotal = $con->actualizar("temp_volar","total_temp=".$nuevoTotal,"id_temp=".$reserva);
	}
?>
