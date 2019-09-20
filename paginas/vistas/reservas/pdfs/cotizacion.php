<?php
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/FPDF/plantillaCotizacion.php';
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico

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

	$totalReserva=0.0;
	$totalPasajeros = $con->consulta("FORMAT(ifnull(pasajerosa_temp,0) + ifnull(pasajerosn_temp,0),2)  Total"," temp_volar "," id_temp = $reserva");
	$datosReserva = $con->query("CALL getResumenREserva(".$reserva.");")->fetchALL (PDO::FETCH_OBJ);
	$serviciosReserva = $con->consulta("tipo_sv as tipo , nombre_servicio as servicio ,cantmax_servicio as cantmax, precio_servicio as precio "," servicios_vuelo_temp svt INNER JOIN servicios_volar sv ON svt.idservi_sv=sv.id_servicio ","  svt.status<>0 and cantidad_sv>0 and idtemp_sv =".$reserva);

	$hotel=$datosReserva[0]->hotel;
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

			$descripcionHospedaje = " De ".convertirFecha($checkin). " a ". convertirFecha($checkout). "(".$days." dias).";
			$totalReserva+=$totalHabitacion;
		}
		$totalReserva +=$datosReserva[0]->precio1;
		//echo "otros->".$datosReserva[0]->precio1."<br>";
		$totalReserva +=$datosReserva[0]->precio2;
	}

	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$fechavuelo = convertirFecha($datosReserva[0]->fechavuelo);
	$encabezado = "Estimado(a) ". $datosReserva[0]->nombre .". Es un gusto poder atender tu solicitud de vuelo en globo. Volamos en el Valle de Teotihuacán, Estado de México ofreciéndote la mejor vista de las pirámides y de la zona arqueológica. La cita es en nuestro globopuerto a 5 minutos de la zona arqueológica, en donde nuestro equipo te recibirá y podrás ver el armado e inflado de tu globo, desde ese momento inicia tu aventura así que prepara tu cámara para tomar muchas fotos. ¡Prepárate para vivir el sueño de Volar en Globo!";
	$importante ="IMPORTANTE: Notificar vía telefónica o por mail tu depósito para poderte enviar la RESERVACION e itinerario del vuelo. Si te surgen dudas llámanos o escríbenos a nuestro correo electrónico.";
	$tiempo="Tu cotización es válida por un período de 30 días desde la fecha de envío.";
	$pdf = new PDF();
	$pdf->AliasNbPages();
	$pdf->AddPage();

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($encabezado),0,'J',0);


	$pdf->SetFillColor(51,255,147);
	$pdf->SetFont('Arial','B',10);
	$pdf->Cell(186,6,'RESERVA No. '.$reserva,1,1,'C',1);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'FECHA DE VUELO',1,0,'C',1);
	$pdf->Cell(58,6,$fechavuelo,1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);



	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'NOMBRE',1,0,'C',1);
	$pdf->Cell(58,6,utf8_decode($datosReserva[0]->nombre),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',9);
	$pdf->Cell(70,6,'CORREO',1,0,'C',1);
	$pdf->Cell(58,6,$datosReserva[0]->correo,1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,utf8_decode('TELÉFONOS'),1,0,'C',1);
	$telefonos= explode("<br>", $datosReserva[0]->telefonos);
	if(trim($telefonos[0])!=""){
		$contacto1 = "CONTACTO 1:". $telefonos[1];
		$contacto2 = "CONTACTO 2: ".$telefonos[0];
		$contactos = $telefonos[1]."/".$telefonos[0];
	}else{
		$contacto1 = "CONTACTO 1: ". $telefonos[1];
		$contacto2 = "";

		$contactos = $telefonos[1];
	}
	$pdf->Cell(58,6,utf8_decode($contactos),1,0,'C',0);
	$pdf->Cell(58,6,utf8_decode(''),1,1,'C',0);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'TIPO DE VUELO',1,0,'C',1);
	$pdf->Cell(58,6,utf8_encode($datosReserva[0]->tipoVuelo),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'PASAJEROS',1,0,'C',1);
	$pdf->Cell(58,6,utf8_decode('Niños '.$datosReserva[0]->pasajerosN.' /  Adultos '.$datosReserva[0]->pasajerosA),1,0,'C',0);
	$pdf->Cell(58,6,'$ '.number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ','),1,1,'C',0);



	if($datosReserva[0]->comentario!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'COMENTARIO',1,0,'C',1);
		$pdf->MultiCell(58,4, utf8_decode(str_replace("â€¢","°",$datosReserva[0]->comentario)),1,'L',0);
  	$pdf->setXY(138,102);
  	$pdf->setTextColor(255, 255, 255);
		$pdf->MultiCell(58,4, utf8_decode($datosReserva[0]->comentario),1,'L',0);
    	$pdf->setTextColor(0, 0, 0);
	}

	if($datosReserva[0]->motivo!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'MOTIVO',1,0,'C',1);
		$pdf->Cell(58,6,utf8_decode($datosReserva[0]->motivo),1,0,'C',0);
		$pdf->Cell(58,6,'',1,1,'C',0);
	}


	if($datosReserva[0]->hotel!=''){

		$pdf->SetFillColor(51,255,147);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(186,6,'HOTEL',1,1,'C',1);

		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(186,6,utf8_decode($hotel ),1,1,'C',1);

		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,utf8_decode('HABITACIÓN'),1,0,'C',1);
		$pdf->Cell(58,6,utf8_decode($nombreHabitacion .'($ '. number_format(  $precioHabitacion, 2, '.', ',') .')') ,1,0,'C',0);
		$pdf->Cell(58,6,'',1,1,'C',0);


		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,utf8_decode('TOTAL HABITACIÓN'),1,0,'C',1);
		$pdf->SetFont('Arial','',7);
		$pdf->Cell(58,6,utf8_decode($descripcionHospedaje),1,0,'C',0);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(58,6,'$ '.number_format(  $totalHabitacion, 2, '.', ',') ,1,1,'C',0);


	}
	if($datosReserva[0]->otroscar1!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,utf8_decode($datosReserva[0]->otroscar1),1,0,'C',1);
		$pdf->Cell(58,6,'',1,0,'C',0);
		$pdf->Cell(58,6,"$ ". number_format( $datosReserva[0]->precio1 , 2, '.', ','),1,1,'C',0);
	}

	if($datosReserva[0]->otroscar2!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,utf8_decode($datosReserva[0]->otroscar2),1,0,'C',1);
		$pdf->Cell(58,6,'',1,0,'C',0);
		$pdf->Cell(58,6,"$ ". number_format( $datosReserva[0]->precio2 , 2, '.', ','),1,1,'C',0);
	}



	if(sizeof($serviciosReserva)>0){
		$pdf->SetFillColor(51,255,147);
		$pdf->SetFont('Arial','B',10);
		$pdf->Cell(186,6,'SERVICIOS SOLICITADOS ',1,1,'C',1);



		foreach ($serviciosReserva as $servicioReserva) {
			$pdf->SetFillColor(105,165,247);
			$pdf->SetFont('Arial','',10);
			$pdf->Cell(70,6,utf8_decode($servicioReserva->servicio),1,0,'C',1);


			if($servicioReserva->tipo==1){

				if ($servicioReserva->cantmax == 1){
					$totalReserva +=($totalPasajeros * $servicioReserva->precio );
					$pdf->Cell(58,6,$tPasajeros,1,0,'C',0);
					$pdf->Cell(58,6,"$ ". number_format(($totalPasajeros * $servicioReserva->precio ), 2, '.', ','),1,1,'C',0);
				}else{
					$totalReserva += $servicioReserva->precio ;
					$pdf->Cell(58,6,'',1,0,'C',0);
					$pdf->Cell(58,6,"$ ". number_format($servicioReserva->precio, 2, '.', ','),1,1,'C',0);
				}
			}else{
					$pdf->Cell(58,6,'CORTESIA',1,0,'C',0);
					$pdf->Cell(58,6,"",1,1,'C',0);

			}

		}
	}

	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'SUBTOTAL ',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,'$ '.number_format($totalReserva, 2, '.', ','),1,1,'C',0);


	if($datosReserva[0]->tdescuento!='' && $datosReserva[0]->cantdescuento>0) {

		$pdf->SetFillColor(139,105,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'DESCUENTO ',1,0,'C',1);
		if($datosReserva[0]->tdescuento==1){
			$totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
			$pdf->Cell(58,6,$datosReserva[0]->cantdescuento."%",1,0,'C',0);
		}else{
			$totalDescuento = $datosReserva[0]->cantdescuento;
			$pdf->Cell(58,6,"",1,0,'C',0);
		}

		$totalReserva-=$totalDescuento;
		$pdf->Cell(58,6,"$ ".number_format($totalDescuento, 2, '.', ','),1,1,'C',0);
	}

	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'TOTAL ',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($totalReserva , 2, '.', ','),1,1,'C',0);


	/*NOTAS EXTRAS QUE SE INCLUYEN EN EL CORREO*/

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($importante),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($tiempo),0,'J',0);

	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('Restricciones:'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Niños menores a 4 años.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Si ha padecido del corazón.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Si tiene una cirugia reciente.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Problemas de la columna.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Mujeres embarazadas.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °No se puede abordar en estado inconveniente.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °No se permiten abordar con: equipaje, armas punzocortantes o de fuego.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Personas con peso superior a los 100 kg deben pagar $25 por kilo extra.'),0,'J',0);



    $pdf->setTextColor(252, 0, 0);
	$pdf->SetFont('Arial','B',11);
	$pdf->MultiCell(186,5,utf8_decode('¿Cómo Pagar?'),0,'J',0);


    $pdf->setTextColor(0, 0, 0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Deposito por el total o mínimo de $2000.00 en cuenta bancaria o transferencia. El resto podrás liquidarlo el día de tu vuelo.'),0,'J',0);




    $pdf->setTextColor(252, 0, 0);
	$pdf->SetFont('Arial','B',11);
	$pdf->MultiCell(186,5,utf8_decode('Cuenta para depósito:'),0,'J',0);
    $pdf->setTextColor(0, 0, 0);


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Banco: BBVA Bancomer'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('No. de cuenta: 0191809393 Sucursal: 399'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('A nombre de: VOLAR EN GLOBO, AVENTURA Y PUBLICIDAD SA DE CV'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('CLABE Interbancaria 012180001918093935'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('IMPORTANTE: Notificar vía telefónica o por mail tu depósito para poderte enviar la RESERVACION e itinerario del vuelo. Si te surgen dudas llámanos o escríbenos a nuestro correo electrónico.'),0,'J',0);

	$pdf->MultiCell(186,6,'',0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Para mas información por favor comunicate con tu vendedor'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($getVendedorInfo[0]->nombre),0,'J',0);
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode($vendedor[1]),0,'J',0);
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode($vendedor[2]),0,'J',0);



	$archivo=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/pdfs/cotizacion'.$reserva.'.pdf';
	$pdf->Output($archivo,'F');
	//$pdf->Output();
?>
