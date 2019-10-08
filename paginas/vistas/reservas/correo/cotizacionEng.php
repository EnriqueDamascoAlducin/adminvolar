<?php

	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/pdfs/cotizacionEng.php';
	if(isset($_SESSION['usuario'])){
        $usuario= unserialize((base64_decode($_SESSION['usuario'])));
    }

			$totalReserva=0.0;
			$totalReserva+=$totalVuelo;
			$totalReserva +=$datosReserva[0]->precio1;
		 $totalReserva +=$datosReserva[0]->precio2;
?>
<?php
	/// Datos de Correo
	$textoActual='QUOTE “VOLAR EN GLOBO”';
	$correos=[array($datosReserva[0]->correo,$datosReserva[0]->nombre)];
	$asunto = "FLIGHT INFORMATION";
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
	$cuerpo.=			'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/quoteHeader.jpeg" style="width:100%; max-width=100%;" alt="Quote">';
	$cuerpo.=			'<b>Dear '.$datosReserva[0]->nombre.'</b>';
	$cuerpo.=			'<p>';
	$cuerpo.=				'It’s a pleasure to reply to your flight request. Our operation is located in Teotihuacan Valley, here you will enjoy the best view of pyramids and the whole arquelogical site. The appointment is at ';
	$cuerpo.=				'<a href="https://www.google.com/maps/place/VOLAR+EN+GLOBO/@19.6956597,-98.8269825,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.6956597!4d-98.8247938">';
	$cuerpo.=				' our reception';
	$cuerpo.=				'</a>';
	$cuerpo.=				', located 5 minutes from arquelogical site, where our team will welcome you and you can see the inflation of the hot air balloons. The adventure of flying begins, so prepare your camera! Get ready to live the dream of hot air ballooning!';
	$cuerpo.=			'</p>';


	$cuerpo.=			'<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">';
	$cuerpo.=				'<table border="1">';
	$cuerpo.=					'<thead>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<th class="tdtitulo" colspan="4">';
	$cuerpo.=								'FLIGHT INFORMATION';
	$cuerpo.=							'</th>';
	$cuerpo.=						'</tr>';
	$cuerpo.=					'</thead>';
	$cuerpo.=					'<tbody>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">REFERENCE</td>';
	$cuerpo.=							'<td class="largeTd">'.$reserva.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">FLIGHT DATE:</td>';
	$cuerpo.=							'<td class="largeTd">'.$fechavuelo.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">NAME: </td>';
	$cuerpo.=							'<td class="largeTd" >'.$datosReserva[0]->nombre.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">FLIGHT:</td>';
	$cuerpo.=							'<td  class="largeTd">'.utf8_encode($datosReserva[0]->tipoVuelo).'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">ADULTS:</td>';
	$cuerpo.=							'<td  class="largeTd">'.$datosReserva[0]->pasajerosA.'</td>';
	$cuerpo.=							'<td colspan="2">$ '. number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ), 2, '.', ',') .'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">KIDS:</td>';
	$cuerpo.=							'<td  class="largeTd">'.$datosReserva[0]->pasajerosN.'</td>';
	$cuerpo.=							'<td colspan="2">$ '. number_format(($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') .'</td>';
	$cuerpo.=						'</tr>';


	if($datosReserva[0]->comentario!=''){
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">COMMENTS:</td>';
		$cuerpo.=							'<td class="largeTd">'. $datosReserva[0]->comentario.'</td>';
		$cuerpo.=							'<td colspan="2"></td>';
		$cuerpo.=						'</tr>';
	}
	if($datosReserva[0]->motivo!=''){
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">OCASSION:</td>';
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
		$cuerpo.=							'<td class="tdtitulo" >ROOM</td>';
		$cuerpo.=							'<td >'.$nombreHabitacion.'</td>';
		$cuerpo.=							'<td ></td>';
		$cuerpo.=						'</tr>';
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo" >PRICE/NIGHT</td>';
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
		$cuerpo.=						'<td class="tdseparador" colspan="4">SERVICES:</td>';
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
				$cuerpo.=					'COURTESY';
				$cuerpo.=				'</td>';
				$cuerpo.=				'<td colspan="2"></td>';
			}
			$cuerpo.=				'</tr>';
		}
	}
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtotal">SUBTOTAL</td>';
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
		$cuerpo.=						'<td>DISCOUNT</td>';
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

	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">*Prices valid for 30 days from date on your quote.</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">';
	$cuerpo.=								'<ol type="1">
												<li>Restrictions:</li>
												<ul>
													<li>Children under 4 years old.</li>
													<li>If you have suffered a heart disease.</li>
													<li>If you have had a recent surgery.</li>
													<li>Injured column.</li>
													<li>Pregnant women.</li>
													<li>If you are intoxicated. (Alcohol or drugs)</li>
												</ul>';
	$cuerpo.=								'</ol>';
	$cuerpo.=							'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">*People over 100 kg, must pay $25.00 per extra kilo.</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">*All Our Prices are Expressed in Mexican Pesos</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=					'</tbody>';
	$cuerpo.=				'</table>';
	$cuerpo.=			'</div>';
	$cuerpo .= 			'<h3>How to pay?</h3>';
	$cuerpo .= 			'<p>Advance payment for $2,000.00 on bank account or transfer. The remainder will be paid the flight day.</p>';

	$cuerpo.=			'<h3 style="color:red";><b>Deposit bank account:</b></h3>';
	$cuerpo.=			'Bank: BBVA Bancomer<br>';
	$cuerpo.=			'Account Number: 0191809393  Branch office: 399<br>';
	$cuerpo.=			'Name: Volar en Globo Aventura y Publicidad S.A. de C.V.<br>';
	$cuerpo.=			'Interbank CLABE: 012180001918093935<br>';
	$cuerpo.=							'<td colspan="4"><b>IMPORTANT:</b> Once you have done the payment, you must notify your deposit by phone, email or message so we can send you a confirmation. If you have questions, call us or write to our email.</td>';
	/*$cuerpo.=			'Tenemos otras opciones de pago como: PayPal, cargo en línea a Tarjeta de crédito y/o depósitos en OXXO, comunícate con tu vendedor<br>';*/
	$cuerpo.=			'<hr><p style="font-size:14px"><b>For more information contact us</b></p>';
	$cuerpo.=			'<b>'.$getVendedorInfo[0]->nombre.'</b><br>';
	$cuerpo.=			'<i>'.$vendedor[1].'<br>'.$vendedor[2].'</i>';
	$cuerpo.=		'</body>';
	$cuerpo.=	'</html>';
	//	echo $cuerpo;
	$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
	require_once  $ruta;

	$accion = $con->actualizar("temp_volar","status=3","id_temp=".$reserva);
?>
