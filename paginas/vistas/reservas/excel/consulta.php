<?php
$campos = "	id_temp AS reserva,
						CONCAT(ifnull(nombre_temp,''),' ',ifnull(apellidos_temp,'')) AS cliente,
 						CONCAT(IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) AS vendedor,
						mail_temp AS correo,
						CONCAT( IFNULL(telcelular_temp,''),' / ',IFNULL(telfijo_temp,'') ) AS telefonos,
						fechavuelo_temp AS fechavuelo,
						IFNULL(hora_temp,'NA') AS hora,
						IFNULL(turno_temp,'NA') AS turno,
						IFNULL((SELECT nombre_extra FROM extras_volar WHERE id_extra=procedencia_temp),'') AS procedencia,
						IFNULL((SELECT nombre_hotel FROM hoteles_volar WHERE id_hotel=hotel_temp),'') AS hotel,
						IFNULL((SELECT nombre_habitacion FROM habitaciones_volar WHERE id_habitacion=habitacion_temp),'') AS habitacion,
						IFNULL(pasajerosa_temp,'') AS adultos,
						IFNULL(pasajerosn_temp,'') AS ninos,
						IFNULL((SELECT nombre_extra FROM extras_volar WHERE id_extra=motivo_temp),'') AS motivo,
						IFNULL((SELECT nombre_vc FROM vueloscat_volar WHERE id_vc=tipo_temp),'') AS tipo,
						IFNULL(kg_temp,'NA') AS peso,
						IFNULL(tipopeso_temp,'') AS tipopeso,
						IFNULL(tdescuento_temp,'') AS tdescuento,
						IFNULL(cantdescuento_temp,'0') AS descuento,
						IFNULL(total_temp,'0') AS cotizado,
						tv.status,
						IFNULL((SELECT SUM(cantidad_bp) FROM bitpagos_volar WHERE idres_bp = id_temp AND status IN (1,2)  ),0) AS pagado,
						IFNULL(comentarioint_temp,'') AS comentariosint ";
$tabla = " temp_volar tv INNER JOIN volar_usuarios vu  ON id_usu = idusu_temp ";
$filtro="tv.status not in (0,6) ";
if(isset($_GET['fechaI']) && $_GET['fechaI']!='' ){
	$filtro.= " and fechavuelo_temp >='".$_GET['fechaI']."'";
}
if(isset($_GET['fechaF']) && $_GET['fechaF']!='' ){
	$filtro.= " and fechavuelo_temp <='".$_GET['fechaF']."'";
}
if(isset($_GET['status']) && $_GET['status']!='0' ){
	$filtro.= " and tv.status = ".$_GET['status'];
}
if(isset($_GET['empleado']) && $_GET['empleado']!='0' ){
	$filtro.= " and idusu_temp = ".$_GET['empleado'];
}
if(isset($_GET['reserva']) && $_GET['reserva']!='' ){
	$filtro.= " and id_temp = ".$_GET['reserva'];
}
if($_GET['fechaI']=='' &&  $_GET['fechaF']=='' && $_GET['reserva']=='' ){
	$filtro .= " and fechavuelo_temp >= CURRENT_TIMESTAMP ";
}
$con->query("SET NAMES UTF8");
$reservas=$con->consulta($campos,$tabla,$filtro);

 ?>
