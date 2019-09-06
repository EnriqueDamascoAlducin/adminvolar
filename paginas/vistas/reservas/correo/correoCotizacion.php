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

	$fechavuelo = convertirFecha($datosReserva[0]->fechavuelo);
	
?>
<?php 
	/// Datos de Correo
	$textoActual='Cotización Volar en Globo';
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
							@media (max-width: 576){
								.largeTd{
									font-size:65%;
									width:100px;
									max-width:100px;
  									table-layout: fixed;
								}
								td,th{
									max-height: 5px!important;
									font-size: 10px;
								}
							}
						</style>
						<script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
					</head>';
	$cuerpo.=		'<body>';
	$cuerpo.=			'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/banner_cotiza.png" style="width:100%; max-width=100%;" alt="Cotización">';
	$cuerpo.=			'<b>Estimado(a) '.$datosReserva[0]->nombre.'</b>';
	$cuerpo.=			'<p>';
	$cuerpo.=				'Es un gusto poder atender tu solicitud de vuelo en globo. Nuestra operación se encuentra en el';
	$cuerpo.=				'<a href="https://www.google.com/maps/place/VOLAR+EN+GLOBO/@19.695002,-98.8258507,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.695002!4d-98.823662"> Valle de Teotihuacan, Estado de M&eacute;xico</a>, ';
	$cuerpo.=				'te ofrecemos la mejor vista de las pirámides y de la zona arqueológica. La cita es en nuestra recepción ubicada a 5 minutos de la zona arqueológica, en este lugar nuestro equipo te recibirá y te trasladara a nuestra zona de despegue, allí podrás ver el armado y el inflado de tu globo, desde ese momento inicia la aventura así que prepara tu cámara para tomar muchas fotos. ¡Prepárate para la mejor parte! Al aterrizar la tripulación se hará cargo del globo mientras tú y el piloto llevan a cabo el tradicional brindis, recibirás un certificado de vuelo (suvenir) y la tripulación te trasladará de regreso a la recepción.';
	$cuerpo.=			'</p>';


	$cuerpo.=			'<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">';
	$cuerpo.=				'<table border="1">';
	$cuerpo.=					'<thead>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<th class="tdtitulo" colspan="4">';
	$cuerpo.=								'RESERVA No.'. $reserva;
	$cuerpo.=							'</th>';
	$cuerpo.=						'</tr>';
	$cuerpo.=					'</thead>';
	$cuerpo.=					'<tbody>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">FECHA DE VUELO</td>';
	$cuerpo.=							'<td class="largeTd">'.$fechavuelo.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">NOMBRE</td>';
	$cuerpo.=							'<td class="largeTd" >'.$datosReserva[0]->nombre.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">CORREO</td>';
	$cuerpo.=							'<td  class="largeTd">'.$datosReserva[0]->correo.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">TELEFONOS</td>';
	$cuerpo.=							'<td class="largeTd" >'.$datosReserva[0]->telefonos.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">TIPO DE VUELO</td>';
	$cuerpo.=							'<td  class="largeTd">'.utf8_encode($datosReserva[0]->tipoVuelo).'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">PASAJEROS</td>';
	$cuerpo.=							'<td >Adultos:'.$datosReserva[0]->pasajerosA.'<br>Ni&ntilde;os:'.$datosReserva[0]->pasajerosN .'</td>';
	$cuerpo.=							'<td colspan="2">$ ';
	$cuerpo.=									number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ;
	$cuerpo.=							'</td>';
	$cuerpo.=						'</tr>';
	if($datosReserva[0]->comentario!=''){ 
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">COMENTARIO</td>';
		$cuerpo.=							'<td class="largeTd">'. $datosReserva[0]->comentario.'</td>';
		$cuerpo.=							'<td colspan="2"></td>';
		$cuerpo.=						'</tr>';
	} 
	if($datosReserva[0]->motivo!=''){ 
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">MOTIVO</td>';
		$cuerpo.=							'<td class="largeTd">'. $datosReserva[0]->motivo.'</td>';
		$cuerpo.=							'<td colspan="2"></td>';
		$cuerpo.=						'</tr>';
	} 

	if($datosReserva[0]->otroscar1!=''){
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar1. '</td>';
		$cuerpo.=						'<td ></td>';
		$cuerpo.=						'<td colspan="2">$ '. number_format( $datosReserva[0]->precio1 , 2, '.', ','). '</td>';
		$cuerpo.=					'</tr>';				
	}
	if($datosReserva[0]->otroscar2!=''){
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar2. '</td>';
		$cuerpo.=						'<td ></td>';
		$cuerpo.=						'<td colspan="2">$ '.number_format( $datosReserva[0]->precio2 , 2, '.', ','). '</td>';
		$cuerpo.=					'</tr>';				
	}
	if(sizeof($serviciosReserva)>0){ 
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdseparador" colspan="3">SERVICIOS SOLICITADOS	</td>';
		$cuerpo.=					'</tr>';
		foreach ($serviciosReserva as $servicioReserva) {
			$cuerpo.=				'<tr>';
			$cuerpo.=					'<td class="tdtitulo">'. $servicioReserva->servicio .'</td>';
			if($servicioReserva->tipo==1){
				if ($servicioReserva->cantmax == 1){
					$totalReserva +=($totalPasajeros * $servicioReserva->precio );
					$cuerpo.=				'<td>'.$tPasajeros.'</td>';
					$cuerpo.=				'<td colspan="2">$ '.number_format(($totalPasajeros * $servicioReserva->precio ), 2, '.', ',').'</td>';
				}else{
					$totalReserva += $servicioReserva->precio ;
					$cuerpo.=				'<td></td>';
					$cuerpo.=				'<td colspan="2">$ '.number_format($servicioReserva->precio, 2, '.', ',').'</td>';
				}
			}else{
				$cuerpo.=				'<td>';
				$cuerpo.=					'Cortesia';	
				$cuerpo.=				'<td>';
				$cuerpo.=				'<td colspan="2"></td>';
			}
			$cuerpo.=				'</tr>';
		}
	}
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtotal">SUB TOTAL</td>';
	$cuerpo.=							'<td ></td>';
	$cuerpo.=							'<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
	$cuerpo.=						'</tr>';
	if($datosReserva[0]->tdescuento!='' && $datosReserva[0]->cantdescuento>0) {
		if($datosReserva[0]->tdescuento==1){
			$totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
		}else{
			$totalDescuento = $datosReserva[0]->cantdescuento;
		}
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td>DESCUENTO</td>';
		$cuerpo.=							'<td class="largeTd">';
		if($datosReserva[0]->tdescuento==1) {
			$cuerpo.=						$datosReserva[0]->cantdescuento."%";
		}
		$cuerpo.=							'</td>';
		$cuerpo.=						'<td colspan="2">';
		if($datosReserva[0]->tdescuento==1) {
			$cuerpo.=						 "$" .number_format($totalDescuento, 2, '.', ',');
		}else{
			$cuerpo.=						'$'.$totalDescuento;
		}
		$cuerpo.=						'</td>';
		$cuerpo.=					'</tr>';
		$totalReserva-=$totalDescuento;
	}
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtotal">TOTAL</td>';
	$cuerpo.=							'<td ></td>';
	$cuerpo.=							'<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
	$cuerpo.=						'</tr>';

	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">IMPORTANTE: Notificar vía telefónica o por mail tu depósito para poderte enviar la RESERVACION e itinerario del vuelo. Si te surgen dudas llámanos o escríbenos a nuestro correo electrónico</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">Tu cotización es válida por un período de 30 días desde la fecha de envío</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">';
	$cuerpo.=								'<ol type="1">
												<li>Restricciones:</li>
												<ul>
													<li>Ni&ntilde;os menores a 4 a&ntilde;os.</li>
													<li>Si ha padecido del corazón.</li>
													<li>Si tiene una cirugia reciente.</li>
													<li>Lastimada de la columna.</li>
													<li>Mujeres embarazadas.</li>
													<li>No se puede abordar en estado de ebriedad.</li>
												</ul>';
	$cuerpo.=								'</ol>';
	$cuerpo.=							'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">Personas con peso superior a los 100 kg deben pagar $25 por kilo extra.</td>';
	$cuerpo.=						'</tr>';
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
	$cuerpo.=			'IMPORTANTE: Notificar vía telefónica o por mail tu depósito para poderte enviar la RESERVACION e itinerario del vuelo. Si te surgen dudas llámanos o escríbenos a nuestro correo electrónico.<br>';
	$cuerpo.=			'<p style="font-size:14px">Para mas información por favor comunicate con tu vendedor</p>';
	$cuerpo.=			'<b>'.$getVendedorInfo[0]->nombre.'</b><br>';
	$cuerpo.=			'<i>'.$vendedor[1].'<br>'.$vendedor[2].'</i>';
	$cuerpo.=		'</body>';
	$cuerpo.=	'</html>';
	//	echo $cuerpo;
	$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
	require_once  $ruta;

	$accion = $con->actualizar("temp_volar","status=3","id_temp=".$reserva);
?>
