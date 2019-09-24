<?php
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';


	$idioma = $con->consulta("idioma_temp","temp_volar","id_temp=".$reserva);

	if($idioma[0]->idioma_temp==2){
		require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/cotizacionEng.php';
	}else{
		require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/correo/cotizacionEsp.php';

	}

?>