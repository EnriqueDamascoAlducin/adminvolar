<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	if(isset($_SESSION['usuario'])){
        $usuario= unserialize((base64_decode($_SESSION['usuario'])));
    }
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico

	$pago = $_POST['pago'];
	$pagoInfo= $con->consulta("cantidad_bp as cantidad, idres_bp as reserva","bitpagos_volar","id_bp=".$pago);
	$reserva=$pagoInfo[0]->reserva;

	$totalPagos  = $con->consulta("SUM(cantidad_bp) as totalPagos ","bitpagos_volar","idres_bp=".$reserva);
	$totalReserva=0.0;
	$totalPasajeros = $con->consulta("FORMAT(ifnull(pasajerosa_temp,0) + ifnull(pasajerosn_temp,0),2)  Total"," temp_volar "," id_temp = $reserva");
	$datosReserva = $con->query("CALL getResumenREserva(".$reserva.");")->fetchALL (PDO::FETCH_OBJ);
	$serviciosReserva = $con->consulta("tipo_sv as tipo , nombre_servicio as servicio ,cantmax_servicio as cantmax, precio_servicio as precio "," servicios_vuelo_temp svt INNER JOIN servicios_volar sv ON svt.idservi_sv=sv.id_servicio ","  svt.status<>0 and cantidad_sv>0 and idtemp_sv =".$reserva);

	$habitacion=$datosReserva[0]->habitacion;
	$habitacion=explode("|", $habitacion);

	$getVendedorInfo = $con->consulta("CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as nombre, correo_usu as correo,telefono_usu as telefono", " volar_usuarios vu INNER JOIN temp_volar tv ON tv.idusu_temp=vu.id_usu ","id_temp=".$reserva);
	$tPasajeros = $datosReserva[0]->pasajerosN+ $datosReserva[0]->pasajerosA;
	$tipoVuelo = $datosReserva[0]->tipo_temp;
	$totalPasajeros = $totalPasajeros[0]->Total;
	if($tPasajeros == $totalPasajeros){
		//echo $totalPasajeros;
		$preciosTipoVuelo = $con->consulta("precioa_vc,precion_vc","vueloscat_volar","id_vc=$tipoVuelo");
		$totalVueloAdultos = $datosReserva[0]->pasajerosA * $preciosTipoVuelo[0]->precioa_vc;
		$totalVueloNinos = $datosReserva[0]->pasajerosN * $preciosTipoVuelo[0]->precion_vc;
		$totalVuelo= $totalVueloAdultos+$totalVueloNinos;
		$totalReserva+=$totalVuelo;
		//echo "<br>Vuelo = ".$totalVuelo."<br>";
		if($datosReserva[0]->habitacion!=''){
			$precioHabitacion=$habitacion[1];
			$nombreHabitacion=$habitacion[0];
			$capacidadHabitacion=$habitacion[2];
			$descripHabitacion=$habitacion[3];
			$checkin= $datosReserva[0]->checkin;
			$checkout = $datosReserva[0]->checkout;
			$date1 = strtotime($checkin);
			$date2 = strtotime($checkout);

			// Formulate the Difference between two dates
			$diff = abs($date2 - $date1);
			// To get the year divide the resultant date into
			// total seconds in a year (365*60*60*24)
			$years = floor($diff / (365*60*60*24));


			// To get the month, subtract it with years and
			// divide the resultant date into
			// total seconds in a month (30*60*60*24)
			$months = floor(($diff - $years * 365*60*60*24)
			                               / (30*60*60*24));


			// To get the day, subtract it with years and
			// months and divide the resultant date into
			// total seconds in a days (60*60*24)
			$days = floor(($diff - $years * 365*60*60*24 -
			             $months*30*60*60*24)/ (60*60*24));

			$totalHabitacion= $days * $precioHabitacion;

			$descripcionHospedaje = " De ".$checkin. " a ". $checkout. "(<b>".$days." dias</b> )";
			$totalReserva+=$totalHabitacion;
		}
		$totalReserva +=$datosReserva[0]->precio1;
		//echo "otros->".$datosReserva[0]->precio1."<br>";
		$totalReserva +=$datosReserva[0]->precio2;

		function convertirFecha($fecha){
			$fecha=explode("-",$fecha);
			if($fecha[1]=='01'){
				$Nvafecha="$fecha[2]-ENE-$fecha[0]";
			}else if($fecha[1]=='02'){
				$Nvafecha="$fecha[2]-FEB-$fecha[0]";
			}else if($fecha[1]=='03'){
				$Nvafecha="$fecha[2]-MAR-$fecha[0]";
			}else if($fecha[1]=='04'){
				$Nvafecha="$fecha[2]-ABR-$fecha[0]";
			}else if($fecha[1]=='05'){
				$Nvafecha="$fecha[2]-MAYO-$fecha[0]";
			}else if($fecha[1]=='06'){
				$Nvafecha="$fecha[2]-JUN-$fecha[0]";
			}else if($fecha[1]=='07'){
				$Nvafecha="$fecha[2]-JUL-$fecha[0]";
			}else if($fecha[1]=='08'){
				$Nvafecha="$fecha[2]-AGO-$fecha[0]";
			}else if($fecha[1]=='09'){
				$Nvafecha="$fecha[2]-SEP-$fecha[0]";
			}else if($fecha[1]=='10'){
				$Nvafecha="$fecha[2]-OCT-$fecha[0]";
			}else if($fecha[1]=='11'){
				$Nvafecha="$fecha[2]-NOV-$fecha[0]";
			}else if($fecha[1]=='12'){
				$Nvafecha="$fecha[2]-DIC-$fecha[0]";
			}else{
				$Nvafecha="Error $";
			}
			return $Nvafecha;
		}

	}

?>
<?php
	/// Datos de Correo
	//$getVendedorInfo[0]->nombre

	$textoActual='Cupón de Descuento';
	$correos=[array($datosReserva[0]->correo,$datosReserva[0]->nombre)];
	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$asunto = "Cupón de Regalo para Reserva: ". $reserva;
	$cuerpo='<!DOCTYPE html>
				<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
						<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">

						<script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
					</head>';
	$cuerpo.=		'<body>';
	$cuerpo.=			'<p>Hola!!! <b>'.$datosReserva[0]->nombre.'</b> </p>';
	$cuerpo.=			'<p>Aprovecha tu cupón de descuento, válido al momento de tu registro en nuestra Recepción.</p>';
	$cuerpo.=			'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/cupon-descuento-volar-en-globo.jpg" style="width:100%;max-width:100%">';
	$cuerpo.=			'<p style="font-size:14px">Para mas información por favor comunicate con tu vendedor</p>';
	$cuerpo.=			'<b>'.$getVendedorInfo[0]->nombre.'</b><br>';
	$cuerpo.=			'<i>'.$vendedor[1].'<br>'.$vendedor[2].'</i>';
	$cuerpo.=		'</body>';
	$cuerpo.=	'</html>';
	//echo $cuerpo;
	$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
	require_once  $ruta;

?>
