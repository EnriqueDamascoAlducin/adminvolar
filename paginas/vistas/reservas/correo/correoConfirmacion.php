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

	$textoActual='Confirmación Volar en Globo';
	$correos=[array($datosReserva[0]->correo,$datosReserva[0]->nombre)];
	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$asunto = "Confirmación de Vuelo: ". $reserva;
	$cuerpo='<!DOCTYPE html>
				<html>
					<head>
						<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
						<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
						<style type="text/css">

							#direccionvga{
								background:#aa66cc;
								width:100%;
								height:35px;
								color:white;

							}
							#direccionvga:hover{
								background:#9933CC;

							}
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
							td,th{
								max-height: 5px!important;
								font-size: 10px;
							}
							@media (max-width: 576){
								td{
									font-size:60%;
									width:30%
									max-width:30%;
  									table-layout: fixed;	
								}
							}
						</style>
						<script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
					</head>';
	$cuerpo.=		'<body>';
	$cuerpo.=			'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/bannersito.png" style="width:100%; max-width=100%;" alt="Confiramcion">';
	$cuerpo.=			'<p>';
	$cuerpo.=				'Hola!!! <b>'.$datosReserva[0]->nombre.'</b>. Envío confirmación de vuelo, no olvides llevarla contigo el día de tu vuelo (No es necesario imprimirla). </p>';
	$cuerpo.=				'<p><b>Registro y Pago:</b> El día de tu vuelo deberás presentarte con nuestro anfitrión en la recepción para que registre tu asistencia y te reciba el pago del restante. Recuerda estar a tiempo en el lugar de la cita para no retrasar tu vuelo ni el de los demás. Te aconsejamos traer ropa cómoda, tal como si fueras a un día de campo: gorra, bufanda, guantes, bloqueador solar, cámara fotográfica o de video.</p>';


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
	$cuerpo.=							'<td >'.convertirFecha($datosReserva[0]->fechavuelo).'</td>';
	$cuerpo.=							'<td colspan="2" ></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">NOMBRE</td>';
	$cuerpo.=							'<td >'.$datosReserva[0]->nombre.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">TELÉFONOS</td>';
	$cuerpo.=							'<td >'.$datosReserva[0]->telefonos.'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">TIPO DE VUELO</td>';
	$cuerpo.=							'<td >'.utf8_encode($datosReserva[0]->tipoVuelo).'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">PASAJEROS</td>';
	$cuerpo.=							'<td >Adultos:'.$datosReserva[0]->pasajerosA.'<br>Ni&ntilde;os:'.$datosReserva[0]->pasajerosN .'</td>';
	$cuerpo.=							'<td colspan="2"colspan="2">$ ';
	$cuerpo.=									number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ;
	$cuerpo.=							'</td>';
	$cuerpo.=						'</tr>';
	if($datosReserva[0]->comentario!=''){ 
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">COMENTARIO</td>';
		$cuerpo.=							'<td>'. $datosReserva[0]->comentario.'</td>';
		$cuerpo.=							'<td colspan="2"></td>';
		$cuerpo.=						'</tr>';
	} 
	if($datosReserva[0]->motivo!=''){ 
		$cuerpo.=						'<tr>';
		$cuerpo.=							'<td class="tdtitulo">MOTIVO</td>';
		$cuerpo.=							'<td>'. $datosReserva[0]->motivo.'</td>';
		$cuerpo.=							'<td colspan="2"></td>';
		$cuerpo.=						'</tr>';
	} 

	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">VENDEDOR</td>';
	$cuerpo.=							'<td >'.$vendedor[0].'</td>';
	$cuerpo.=							'<td colspan="2"></td>';
	$cuerpo.=						'</tr>';
	if($datosReserva[0]->otroscar1!=''){
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar1. '</td>';
		$cuerpo.=						'<td >$ '. number_format( $datosReserva[0]->precio1 , 2, '.', ','). '</td>';
	$cuerpo.=							'<td colspan="2"></td>';
		$cuerpo.=					'</tr>';				
	}
	if($datosReserva[0]->otroscar2!=''){
		$cuerpo.=					'<tr>';
		$cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar2. '</td>';
		$cuerpo.=						'<td >$'. number_format( $datosReserva[0]->precio2 , 2, '.', ','). '</td>';
	$cuerpo.=							'<td colspan="2"></td>';
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
		$cuerpo.=						'<td class="tddesc">DESCUENTO</td>';
		$cuerpo.=						'<td ></td>';
		$cuerpo.=						'<td colspan="2">';
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
	$cuerpo.=							'<td class="tdtitulo">ANTICIPO</td>';
	$cuerpo.=							'<td ></td>';
	$cuerpo.=							'<td colspan="2">$ '.number_format($pagoInfo[0]->cantidad, 2, '.', ',').'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">ANTICIPO TOTAL</td>';
	$cuerpo.=							'<td ></td>';
	$cuerpo.=							'<td colspan="2">$ '.number_format($totalPagos[0]->totalPagos, 2, '.', ',').'</td>';
	$cuerpo.=						'</tr>';
									$totalReserva-=$totalPagos[0]->totalPagos;
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtotal">TOTAL</td>';
	$cuerpo.=							'<td ></td>';
	$cuerpo.=							'<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
	$cuerpo.=						'</tr>';

	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="" colspan="4">A partir de 6:00 AM los esperamos en nuestra recepción, sin embargo esta hora sera CONFIRMADA UN DIA ANTES de acuerdo a la logística de operación del día o a las condiciones meteorológicas, te pido estés al tanto ya que recibirás una llamada para confirmar horario</td>';
	$cuerpo.=						'</tr>';

	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdseparador" colspan="4">PUNTO DE REUNION:	</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td  colspan="4"><a href="https://www.google.com/maps/place//data=!4m2!3m1!1s0x85d1c03008c08e6d:0x2cd1a4cc8c3f3d5c?utm_source=mstt_1&utm_medium=mstt_2">
Recepción Volar en Globo, Aventura y Publicidad SA de CV. Esquina Francisco Villa con Carretera Libre Mexico- Tulancingo (132) C.P. 55850 (Puedes dar clic aqui para abrir la ubicación en maps).</a></td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td colspan="4">';
	$cuerpo.=								'<ol type="1">
												<li>Que incluye tu vuelo:</li>
												<ul>
													<li>Tiempo de vuelo de 45 minutos aproximadamente.</li>
													<li>Coffee Break.</li>
													<li>Transporte local durante toda la actividad (Teotihuacan).</li>
													<li>Seguro de Viajero.</li>
													<li>Certificado personalizado.</li>
													<li>Brindis tradicional con vino blanco espumoso durante o después del vuelo dependiendo del tipo de vuelo contratado.</li>
												</ul>
												<li>Restricciones:</li>
												<ul>
													<li>Ni&ntilde;os menores a 4 a&ntilde;os.</li>
													<li>Si ha padecido del corazón.</li>
													<li>Si tiene una cirugia reciente.</li>
													<li>Lastimada de la columna.</li>
													<li>Mujeres embarazadas.</li>
													<li>No se puede abordar en estado de ebriedad.</li>
												</ul>
												<li>Restricciones para los vuelos:</li>
												<ul>
													<li>Cuando las condiciones climatológicas no lo permita (Vientos mayor a 20 Km.).</li>
													<li>Lluvia.</li>
													<li>Exceso de neblina.</li>
													<li>En caso de alguna de estas causas se reprogramara el vuelo en acuerdo mutuo.</li>
												</ul>
													<li>Cambio de fecha de vuelo o cancelaciones:</li>
												<ul>
													<li>
														En caso de no poder asistir a la cita por circunstancias adversas e imprevistas, se debera cancelar y confirmar la cancelacion via telefonica con al menos 36 horas de anticipación para que se te haga una reprogramacion de tu vuelo sin cargo alguno, si la cancelación se hace dentro del periodo de las 36 a 12 horas previo a la realizacion del vuelo, se podra reprogramar el vuelo con un cargo adicional al precio total del 35% por gastos de administración y operación. Si no existe cancelacion y confirmacion de cancelacion o no se presentara el pasajero perderá el derecho a reembolso alguno.
													</li>
													<li>
														En caso de que se requiera posponer un vuelo; es responsabilidad del pasajero reprogramar en un período no mayor a 12 meses de lo contrario se perderá el derecho al vuelo.
													</li>
													<li>
														Recuerda estar a tiempo en el lugar de la cita para no perder tu vuelo.
													</li>
													<li>
														El tiempo estimado de vuelo es hasta de una hora pero si las condiciones no lo permiten, la empresa lo deja a consideración del piloto. Así que no habrá reembolso alguno por vuelos con duración menor a una hora.
													</li>
												</ul>
											</ol>';
	$cuerpo.=							'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>
										<td colspan="4" class="tdseparador">Direccion y Como Llegar:</td>
									</tr>';
	$cuerpo.=						'<tr>';
		$cuerpo.=						'<td colspan="4">';
			$cuerpo.=						'Tomar insurgentes hacia Pachuca numero de autopistá 132-D en cuanto llegues a las casetas tomar las del lado derecho mas con dirección a pirámides - Tulancingo, ( extremo derecho ), ahí pagaras una caseta de $75.00, INMEDIATAMENTE PEGARTE A LADO DERECHO Y SEGUIR LOS SE&ntilde;ALAMIENTOS HACIA PIRAMIDES seguir sobre la autopista en el Km. 17 y pasandoÂ  la gasolinera tomar la desviación hacia pirámidesÂ y continuar hasta la desviación a Tulancingo continuas sobre esta carretera donde a tu mano izquierda vas a encontrar una Estación de Policía Federal, un poco más adelante encontraras una salida a mano izquierda antes del puente, debes girar a la izquierda nuevamente y allí encontraras nuestra recepción.
				<hr>
				<a href="https://www.google.com/maps/place//data=!4m2!3m1!1s0x85d1c03008c08e6d:0x2cd1a4cc8c3f3d5c?utm_source=mstt_1&utm_medium=mstt_2">
				<button type="button" class="btn btn-info btn-lg" id="direccionvga">Ver Dirección</button></a>
				<hr>
				Sin más por el momento quedo a sus órdenes para cualquier duda o aclaración respecto al servicio contratado.';
		$cuerpo.='</td>';
	$cuerpo.='</tr>';
	$cuerpo.=					'</tbody>';
	$cuerpo.=				'</table>';
	$cuerpo.=			'</div>';
	if($_POST['accion']=='regalo'){
		$cuerpo.=		'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/cupon-descuento-volar-en-globo.jpg" style="width:100%;max-width:100%">';
	}
	$cuerpo.=			'<p style="font-size:14px">Para mas información por favor comunicate con tu vendedor</p>';
	$cuerpo.=			'<b>'.$getVendedorInfo[0]->nombre.'</b><br>';
	$cuerpo.=			'<i>'.$vendedor[1].'<br>'.$vendedor[2].'</i>';
	$cuerpo.=		'</body>';
	$cuerpo.=	'</html>';
	//echo $cuerpo;
	$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
	require_once  $ruta;

?>
