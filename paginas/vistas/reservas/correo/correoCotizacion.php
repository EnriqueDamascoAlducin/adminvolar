<?php 
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	if(isset($_SESSION['usuario'])){
        $usuario= unserialize((base64_decode($_SESSION['usuario'])));
    }
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico
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
		
		

	}
	
?>
<?php 
	/// Datos de Correo

	$correos=[array($datosReserva[0]->correo,$datosReserva[0]->nombre)];
	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$asunto = "Cotización de la Reserva ". $reserva;
	$cuerpo='<!DOCTYPE html>
				<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
						<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
						<style type="text/css">
							.tdtitulo{
								background: #7986cb ;
								text-align: center;
								vertical-align: middle;
								color: white;	
							}
							.tdseparador{
								background: #2BBBAD ;
								text-align: center;
								vertical-align: middle;
								color: white;	
							}
							.tdtotal{
								background: #9933CC ;
								text-align: center;
								vertical-align: middle;
								color: white;	
							}
							.tddesc{
								background: #c51162 ;
								text-align: center;
								vertical-align: middle;
								color: white;	
							}
						</style>
						<script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
					</head>';
	$cuerpo.=		'<body>';
	$cuerpo.=			'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/banner_cotiza.png" style="width:100%; max-width=100%;" alt="Cotización">';
	$cuerpo.=			'<b>Estimado(a) '.$datosReserva[0]->nombre.'</b>';
	$cuerpo.=			'<p>';
	$cuerpo.=				'Es un gusto poder atender tu solicitud de vuelo en globo. Nuestra operación se encuentra en el';
	$cuerpo.=				'<a href="https://www.google.com/maps/place/VOLAR+EN+GLOBO/@19.695002,-98.8258507,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.695002!4d-98.823662">Valle de Teotihuacan, Estado de Mexico </a>, ';
	$cuerpo.=				'te ofrecemos la mejor vista de las pirámides y de la zona arqueológica. La cita es en nuestra recepción ubicada a 5 minutos de la zona arqueológica, en este lugar nuestro equipo te recibirá y te trasladara a nuestra zona de despegue, allí podrás ver el armado y el inflado de tu globo, desde ese momento inicia la aventura así que prepara tu cámara para tomar muchas fotos. ¡Prepárate para la mejor parte! Al aterrizar la tripulación se hará cargo del globo mientras tú y el piloto llevan a cabo el tradicional brindis, recibirás un certificado de vuelo (suvenir) y la tripulación te trasladará de regreso a la recepción.';
	$cuerpo.=			'</p>';


	$cuerpo.=			'<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">';
	$cuerpo.=				'<table border="1">';
	$cuerpo.=					'<thead>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<th class="tdtitulo" colspan="2">';
	$cuerpo.=								'Resserva No.'. $reserva;
	$cuerpo.=							'</th>';
	$cuerpo.=						'</tr>';
	$cuerpo.=					'</thead>';
	$cuerpo.=					'<tbody>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Fecha de Vuelo</td>';
	$cuerpo.=							'<td >'.$datosReserva[0]->fechavuelo.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Nombre</td>';
	$cuerpo.=							'<td >'.$datosReserva[0]->nombre.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Correo</td>';
	$cuerpo.=							'<td >'.$datosReserva[0]->correo.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Telefono Fijo - Telefono Celular</td>';
	$cuerpo.=							'<td >'.$datosReserva[0]->telefonos.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Tipo de Vuelo</td>';
	$cuerpo.=							'<td >'.utf8_encode($datosReserva[0]->tipoVuelo).'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Pasajeros</td>';
	$cuerpo.=							'<td > Adultos:'.$datosReserva[0]->pasajerosA.'(<b>'.($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) .'</b>) <br> '.('Ni&ntilde;os:').$datosReserva[0]->pasajerosN .'(<b>'.($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ).'</b>)</td>';
	$cuerpo.=						'</tr>';
	if($datosReserva[0]->comentario!=''){ 
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">Comentario</td>';
		$cuerpo.=							'<td>'. $datosReserva[0]->comentario.'</td>';
		$cuerpo.=						'</tr>';
	} 
	if($datosReserva[0]->otroscar1!=''){
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar1. '</td>';
		$cuerpo.=						'<td >'. $datosReserva[0]->precio1. '</td>';
		$cuerpo.=					'</tr>';				
	}
	if($datosReserva[0]->otroscar2!=''){
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar2. '</td>';
		$cuerpo.=						'<td >'. $datosReserva[0]->precio2. '</td>';
		$cuerpo.=					'</tr>';				
	}
	if(sizeof($serviciosReserva)>0){ 
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdseparador" colspan="2">Servicios Solicitados	</td>';
		$cuerpo.=					'</tr>';
		foreach ($serviciosReserva as $servicioReserva) {
			$cuerpo.=				'<tr>';
			$cuerpo.=					'<td class="tdtitulo">'. $servicioReserva->servicio .'</td>';
			if($servicioReserva->tipo==1){
				$cuerpo.=				'<td>';
				if ($servicioReserva->cantmax == 0){
					$totalReserva +=($totalPasajeros * $servicioReserva->precio );
					$cuerpo.=				number_format( ($servicioReserva->precio ) , 2, '.', ',')."x".$tPasajeros."=".($totalPasajeros * $servicioReserva->precio );
				}else{
					$totalReserva += $servicioReserva->precio ;
					$cuerpo.=				number_format($servicioReserva->precio, 2, '.', ',');
				}
				$cuerpo.=				'</td>';
			}else{
				$cuerpo.=				'<td>';
				$cuerpo.=					'Cortesia';	
				$cuerpo.=				'<td>';
			}
			$cuerpo.=				'</tr>';
		}
	}
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtotal">Sub Total</td>';
	$cuerpo.=							'<td> $'.number_format($totalReserva, 2, '.', ',') .'</td>';
	$cuerpo.=						'</tr>';
	if($datosReserva[0]->tdescuento!='' && $datosReserva[0]->cantdescuento>0) {
		if($datosReserva[0]->tdescuento==1){
			$totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
		}else{
			$totalDescuento = $datosReserva[0]->cantdescuento;
		}
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td>Descuento</td>';
		$cuerpo.=						'<td>';
		if($datosReserva[0]->tdescuento==1) {
			$cuerpo.=						 $datosReserva[0]->cantdescuento."% ($" .number_format($totalDescuento, 2, '.', ',').")";
		}else{
			$cuerpo.=						'$'.$totalDescuento;
		}
		$cuerpo.=						'</td>';
		$cuerpo.=					'</tr>';
		$totalReserva-=$totalDescuento;
	}
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtotal">Total</td>';
	$cuerpo.=							'<td> $'.number_format($totalReserva, 2, '.', ',') .'</td>';
	$cuerpo.=						'<tr>';
	$cuerpo.=					'</tbody>';
	$cuerpo.=				'</table>';
	$cuerpo.=			'</div>';
	$cuerpo .= 			'<h3>¿Cómo Pagar?</h3>';
	$cuerpo .= 			'<p>Deposito por el total o mínimo de $2000.00 en cuenta bancaria o transferencia. El resto podrás liquidarlo el día de tu vuelo.</p>';

	$cuerpo.=			'<h3 style="color:red";><b>Cuenta para depósito:</b></h3>';	
	$cuerpo.=			'Banco: BBVA Bancomer<br>';
	$cuerpo.=			'No. de cuenta: 0191809393 Sucursal: 399<br>';
	$cuerpo.=			'A nombre de: VOLAR EN GLOBO, AVENTURA Y PUBLICIDAD SA DE CV<br>';
	$cuerpo.=			'CLABE Interbancaria 012180001918093935<br>';
	$cuerpo.=			'IMPORTANTE: Notificar vía telefónica o por mail tu depósito para poderte enviar la RESERVACION e itinerario del vuelo. Si te surgen dudas llámanos o escríbenos a nuestro correo electrónico.';
	$cuerpo.=			'<p style="font-size:14px">Para mas información por favor contactate con tu vendedor</p>';
	$cuerpo.=			'<b>'.$vendedor[0].'</b><br>';
	$cuerpo.=			'<i>'.$vendedor[1].'-'.$vendedor[2].'</i>';
	$cuerpo.=		'</body>';
	$cuerpo.=	'</html>';
	//	echo $cuerpo;
	$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
	require_once  $ruta;

	$accion = $con->actualizar("temp_volar","status=3","id_temp=".$reserva);
?>
