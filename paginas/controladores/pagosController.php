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

		require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		$parametros = $_POST['pago'].',0,0,0,0,"",0,"0",'.$idUsu;
		$sql="CALL registrarPago(". $parametros .",@respuesta)";
		$registrarPago = $con->query($sql);
		$registrarPago = $con->query("Select @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
		echo $registrarPago[0]->respuesta;

		require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/vistas/reservas/correo/correoRespuestaConciliacion.php';
	}elseif (isset($_POST['accion']) && $_POST['accion']=='simple'  ) {
		$validar = $con->actualizar("bitpagos_volar","status=2","id_bp=".$_POST['pago']);
		echo $validar;
		require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/vistas/reservas/correo/correoConfirmacion.php';
		$accion = $con->actualizar("temp_volar","status=4","id_temp=".$reserva);

	}elseif (isset($_POST['accion']) && $_POST['accion']=='regalo'  ) {
		$validar = $con->actualizar("bitpagos_volar","status=1","id_bp=".$_POST['pago']);
		echo $validar;
		require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/vistas/reservas/correo/correoConfirmacion.php';
		$accion = $con->actualizar("temp_volar","status=4","id_temp=".$reserva);


	}elseif (isset($_POST['accion']) && $_POST['accion']=='registrarPago'  ) {
		require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$idUsu=$usuario->getIdUsu();
		
		$reserva=$_POST['reserva'];
		$metodo=$_POST['metodo'];
		$banco=$_POST['banco'];
		$referencia=$_POST['referencia'];
		$cantidad=$_POST['cantidad'];
		$fecha=$_POST['fecha'];

		$parametros = '0,'. $reserva.','.$idUsu.','.$metodo.','.$banco.',"'.$referencia.'",'.$cantidad.',"'.$fecha.'",0';
		$sql="CALL registrarPago(". $parametros .",@respuesta)";
		
		$registrarPago = $con->query($sql);
		$registrarPago = $con->query("Select @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
		if($registrarPago[0]->respuesta=="ERROR EN PAGO"){
			echo $registrarPago[0]->respuesta;
		}else{

			$respuesta=explode("|", $registrarPago[0]->respuesta);
			echo $respuesta[0];
			$pago = $respuesta[1];
			require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/vistas/reservas/correo/correoSolicitudConciliacion.php';
		}
	}
	
?>
