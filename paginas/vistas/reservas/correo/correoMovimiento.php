<?php
	$reserva = $_POST['reserva'];
	$movimiento = $_POST['movimiento'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	if(isset($_SESSION['usuario'])){
        $usuario= unserialize((base64_decode($_SESSION['usuario'])));
    }
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico

	$idioma = $con->consulta("idioma_temp","temp_volar","id_temp=".$reserva);
	if($idioma[0]->idioma_temp==2){
		require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/modificacionEng.php';
	}else{
		require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/modificacionEsp.php';

	}
	?>
