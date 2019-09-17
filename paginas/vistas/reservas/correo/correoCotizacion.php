<?php 
	$reserva = $_POST['reserva'];

	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/pdfs/cotizacion.php';
	if(isset($_SESSION['usuario'])){
        $usuario= unserialize((base64_decode($_SESSION['usuario'])));
    }
	
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
							@media (max-width: 576px){
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

	if($datosReserva[0]->hotel!=''){
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdseparador" colspan="4">HOTEL</td>';
		$cuerpo.=						'</tr>';
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo" colspan="4">'.$hotel.'<br>$ '. number_format(  $precioHabitacion, 2, '.', ',') .'</td>';
		$cuerpo.=						'</tr>';
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo" >HABITACIÓN</td>';
		$cuerpo.=							'<td >'.$nombreHabitacion.'</td>';
		$cuerpo.=							'<td ></td>';
		$cuerpo.=						'</tr>';
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo" >PRECIO/NOCHE</td>';
		$cuerpo.=							'<td >'.$descripcionHospedaje.'</td>';
		$cuerpo.=							'<td >$ '.number_format(  $totalHabitacion, 2, '.', ',').'</td>';
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
