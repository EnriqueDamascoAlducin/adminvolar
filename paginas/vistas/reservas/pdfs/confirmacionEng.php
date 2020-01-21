<?php
	$imagen="quoteHeader.jpeg";
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/FPDF/fpdf.php';


  Class PDF extends FPDF{

  	function Header(){
  		//Imagen, SETX,SETY, tamaño
  		$this->Image( $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/images/correos/confirmationHeader.jpeg',35,10,135,25);
  		$this->Ln(30);
  	}
  	/*function Footer(){
 			$this->SetY(-15);
 			$this->SetFont('Arial','I', 8);
 			$this->Cell(0,10, 'Pagina '.$this->PageNo().'/{nb}',0,0,'C' );
  	}*/
  }
	$pago = $_POST['pago'];
	$pagoInfo= $con->consulta("cantidad_bp as cantidad, idres_bp as reserva","bitpagos_volar","id_bp=".$pago);
	$reserva=$pagoInfo[0]->reserva;

	$totalPagos  = $con->consulta("SUM(cantidad_bp) as totalPagos ","bitpagos_volar"," status<>0 and idres_bp=".$reserva);
	$totalReserva=0.0;
	$totalPasajeros = $con->consulta("FORMAT(ifnull(pasajerosa_temp,0) + ifnull(pasajerosn_temp,0),2)  Total"," temp_volar "," id_temp = $reserva");
	$datosReserva = $con->query("CALL getResumenREserva(".$reserva.");")->fetchALL (PDO::FETCH_OBJ);
	$serviciosReserva = $con->consulta("tipo_sv as tipo , nombre_servicio as servicio ,cantmax_servicio as cantmax, precio_servicio as precio "," servicios_vuelo_temp svt INNER JOIN servicios_volar sv ON svt.idservi_sv=sv.id_servicio ","  svt.status<>0 and cantidad_sv>0 and idtemp_sv =".$reserva);

	$hotel=$datosReserva[0]->hotel;
	$habitacion=$datosReserva[0]->habitacion;
	$habitacion=explode("|", $habitacion);

	$getVendedorInfo = $con->consulta("CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as nombre, correo_usu as correo,telefono_usu as telefono", " volar_usuarios vu INNER JOIN temp_volar tv ON tv.idusu_temp=vu.id_usu ","id_temp=".$reserva);
	$movimientosExtras = $con->consulta("motivo_ce,cantidad_ce,tipo_ce","cargosextras_volar","status=1 and reserva_ce= " . $reserva);
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
			$checkin= $datosReserva[0]->checkin_temp;
			$checkout = $datosReserva[0]->checkout_temp;
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

	    $descripcionHospedaje = " From ".$checkin. " to ". $checkout. "(".$days." days)";
	    $totalReserva+=$totalHabitacion;
	  }
	  $totalReserva +=$datosReserva[0]->precio1;
	  //echo "otros->".$datosReserva[0]->precio1."<br>";
	  $totalReserva +=$datosReserva[0]->precio2;


	  	function convertirFecha($fecha){
	  		$fecha=explode("-",$fecha);
	  		if($fecha[1]=='01'){
	  			$Nvafecha="JAN-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='02'){
	  			$Nvafecha="FEB-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='03'){
	  			$Nvafecha="MAR-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='04'){
	  			$Nvafecha="APR-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='05'){
	  			$Nvafecha="MAY-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='06'){
	  			$Nvafecha="JUN-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='07'){
	  			$Nvafecha="JUL-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='08'){
	  			$Nvafecha="AUG-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='09'){
	  			$Nvafecha="SEP-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='10'){
	  			$Nvafecha="OCT-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='11'){
	  			$Nvafecha="NOV-$fecha[2]-$fecha[0]";
	  		}else if($fecha[1]=='12'){
	  			$Nvafecha="DEC-$fecha[2]-$fecha[0]";
	  		}else{
	  			$Nvafecha="Error";
	  		}
	  		return $Nvafecha;
	  	}

	}

	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$fechavuelo = convertirFecha($datosReserva[0]->fechavuelo);
	$encabezado = "Hello!!! ". $datosReserva[0]->nombre .". This is your flight confirmation. It's not necessary to be printed!. ";
	$registroPago = "Registration and Payment: Your flight date, you must get to our reception where our hostess will welcome you, make your registration and get the remaining payment. Remember to be on time at the appointment place. Our advice is to bring comfortable clothes, just as if you were on a picnic: cap, scarf, gloves, jacket, sunscreen, and camera.";
	$tiempo ='From 6:00 a.m. we wait you at our reception, however this time will be CONFIRMED ONE DAY BEFORE your flight day according to the logistic of the day or weather conditions, please be aware as you will receive a call or message to confirm the schedule.';

	$reunion='Recepción Volar en Globo, Aventura y Publicidad SA de CV. Esquina Francisco Villa con Carretera Libre Mexico- Tulancingo (132) C.P. 55850 .';
	$pdf = new PDF();
	$pdf->AliasNbPages();
	$pdf->AddPage();

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($encabezado),0,'J',0);


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($registroPago),0,'J',0);


	$pdf->SetFillColor(51,255,147);
	$pdf->SetFont('Arial','B',10);
	$pdf->Cell(186,6,'FLIGHT INFORMATION',1,1,'C',1);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'REFERENCE:',1,0,'C',1);
	$pdf->Cell(58,6,$reserva,1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'NAME: ',1,0,'C',1);
	$pdf->Cell(58,6,utf8_decode($datosReserva[0]->nombre),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,utf8_decode('TELEPHONE'),1,0,'C',1);
	$telefonos= explode("<br>", $datosReserva[0]->telefonos);
	if(trim($telefonos[0])!=""){
		$contacto1 = "CONTACT 1:". $telefonos[1];
		$contacto2 = "CONTACT 2: ".$telefonos[0];
		$contactos = $telefonos[1]."/".$telefonos[0];
	}else{
		$contacto1 = "CONTACT 1: ". $telefonos[1];
		$contacto2 = "";

		$contactos = $telefonos[1];
	}
	$pdf->Cell(58,6,utf8_decode($contactos),1,0,'C',0);
	$pdf->Cell(58,6,utf8_decode(''),1,1,'C',0);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'FLIGHT DATE',1,0,'C',1);
	$pdf->Cell(58,6,convertirFecha($datosReserva[0]->fechavuelo),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'FLIGHT',1,0,'C',1);
	$pdf->Cell(58,6,utf8_encode($datosReserva[0]->tipoVuelo),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'ADULTS:',1,0,'C',1);
	$pdf->Cell(58,6,$datosReserva[0]->pasajerosA,1,0,'C',0);
	$pdf->Cell(58,6,'$ '.	number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ), 2, '.', ',') ,1,1,'C',0);

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'KIDS:',1,0,'C',1);
	$pdf->Cell(58,6,$datosReserva[0]->pasajerosN,1,0,'C',0);
	$pdf->Cell(58,6,'$ '.	number_format(($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ,1,1,'C',0);


/*
	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'PASAJEROS',1,0,'C',1);
	$pdf->Cell(58,6,utf8_decode('Niños '.$datosReserva[0]->pasajerosN.' /  Adultos '.$datosReserva[0]->pasajerosA),1,0,'C',0);
	$pdf->Cell(58,6,'$ '.number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ','),1,1,'C',0);

*/


	if($datosReserva[0]->motivo!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'OCASSION',1,0,'C',1);
		$pdf->Cell(58,6,utf8_decode($datosReserva[0]->motivo),1,0,'C',0);
		$pdf->Cell(58,6,'',1,1,'C',0);
	}
	if($datosReserva[0]->comentario!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'COMMENTS',1,0,'C',1);
		$pdf->MultiCell(58,4, utf8_decode(str_replace("â€¢","°",$datosReserva[0]->comentario)),1,'L',0);
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
		$pdf->Cell(70,6,utf8_decode('ROOM'),1,0,'C',1);
		$pdf->Cell(58,6,utf8_decode($nombreHabitacion .'($ '. number_format(  $precioHabitacion, 2, '.', ',') .')') ,1,0,'C',0);
		$pdf->Cell(58,6,'',1,1,'C',0);


		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,utf8_decode('PRICE'),1,0,'C',1);
		$pdf->SetFont('Arial','',7);
		$pdf->Cell(58,6,utf8_decode($descripcionHospedaje),1,0,'C',0);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(58,6,'$ '.number_format(  $totalHabitacion, 2, '.', ',') ,1,1,'C',0);


	}
	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'SELLER',1,0,'C',1);
	$pdf->Cell(58,6,$vendedor[0],1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);



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
		$pdf->Cell(186,6,'SERVICES:',1,1,'C',1);

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
					$pdf->Cell(58,6,'INCLUDED',1,0,'C',0);
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
		$pdf->Cell(70,6,'DISCOUNT ',1,0,'C',1);
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
	if(sizeof($movimientosExtras)>0){ 
		foreach ($movimientosExtras as $movimientoExtra) { 
			 $pdf->SetFillColor(139,105,247);
			 $pdf->SetFont('Arial','',10);
			 $pdf->Cell(70,6,$movimientoExtra->motivo_ce,1,0,'C',1);
			 $pdf->Cell(58,6,'',1,0,'C',0);
			if($movimientoExtra->tipo_ce==1){
				$pdf->Cell(58,6,'$ '.$movimientoExtra->cantidad_ce,1,1,'C',0);
				$totalReserva+=$movimientoExtra->cantidad_ce;
			}else{
				$pdf->Cell(58,6,'-$ '.$movimientoExtra->cantidad_ce,1,1,'C',0);
				$totalReserva-=$movimientoExtra->cantidad_ce; 
			}
		} 
	}
/*
	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'ADVANCE PAYMENT ',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($pagoInfo[0]->cantidad, 2, '.', ','),1,1,'C',0);
*/
	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'ADVANCE PAYMENT',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($totalPagos[0]->totalPagos, 2, '.', ','),1,1,'C',0);
	$totalReserva-=$totalPagos[0]->totalPagos;


	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'REMAINDER ',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($totalReserva , 2, '.', ','),1,1,'C',0);


	/*NOTAS EXTRAS QUE SE INCLUYEN EN EL CORREO*/


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($tiempo),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('*All Our Prices are Expressed in Mexican Pesos'),0,'J',0);
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('Meeting Point:'),0,'C',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($reunion),0,'J',0);
///Que incluye el vuelos
/*

	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('Qué incluye tu vuelo:'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Tiempo de vuelo de 45 minutos aproximadamente.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Coffee Break.'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Transporte local durante toda la actividad (Teotihuacan).'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Seguro de Viajero.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Certificado personalizado.'),0,'J',0);


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Brindis tradicional con vino blanco espumoso durante o después del vuelo dependiendo del tipo de vuelo contratado.'),0,'J',0);
	*/
/////REstricciones
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('Restrictions:'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' ° Children under 4 years old.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
		$pdf->MultiCell(186,5,utf8_decode(' ° If you have suffered a heart disease.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' ° If you have had a recent surgery.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' ° Injured column.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °	Pregnant women.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' ° If you are intoxicated. (Alcohol or drugs)'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' ° It is not allowed to board with: luggage, sharps or firearms.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' * People over 100 kg, must pay $25.00 per extra kilo.'),0,'J',0);



////Restricciones para vuelos

	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('Weather restrictions:'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Winds over 20 km/hr. '),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Rain or electric storm.'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Fog excess.'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' *If your flight is cancelled because of weather conditions, the flight might be rescheduled on a period of one year or you might ask for the refund of the total paid.'),0,'J',0);

/// Cambio de fecha de vuelo o cancelaciones

$pdf->SetFont('Arial','B',9);
$pdf->MultiCell(186,5,utf8_decode('Change of flight date or cancellation:'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °  If you can’t attend the appointment due to adverse circumstances, you must cancel and confirm the cancellation by phone call or message at least 36 hours in advance, so that you can reschedule your flight without charge. If the cancellation is made within 36 to 12 hours prior to the flight, it can be rescheduled with an additional charge to the total price of 35% for administration and operation expenses. If there is no cancellation or the passenger doesn’t arrive the flight date, he will lose the right to any refund.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °    If you need to postpone the flight, it is the passenger\'s responsibility to reschedule in a period not exceeding 12 months, otherwise the right to flight will be lost.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °  Remember to be on time at the appointment place so you don\'t miss your flight. Arriving late to the appointment schedule may cause an extra charge of 35% from the total.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °  The estimated flight time is up to one hour but if conditions do not allow it, the company leaves it to the pilot for consideration. There won’t be refund for flights lasting less than one hour.'),0,'J',0);

///DIRECCIÓN Y COMO LLEGAR
/*
$pdf->SetFont('Arial','B',9);
$pdf->MultiCell(186,5,utf8_decode('Direccion y Como Llegar:'),0,'J',0);
$pdf->MultiCell(186,6,'',0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode('Tomar Insurgentes Norte hacia México-Pachuca autopista 85D,  en cuanto llegues a las casetas de peaje  tomar las del lado derecho con dirección a Pirámides – Tulancingo autopista 132D, sigue los señalamientos hacia Pirámides Tulancingo, ahí pagaras una caseta, seguir sobre la autopista hasta pasar una gasolinera del lado derecho (aproximadamente 17 Km), tomar la desviación hacia Pirámides y continuar hasta la desviación a Tulancingo Libre, continuar sobre esta carretera, 5 Km adelante a tu mano izquierda vas a encontrar una Estación de Policía Federal, un poco más adelante encontraras una salida a mano izquierda antes del puente, debes girar a la izquierda nuevamente y allí 200 metros adelante encontraras Volar en Globo.'),0,'J',0);
$pdf->SetFont('Arial','',9);
*/
$pdf->MultiCell(186,5,utf8_decode('If you need any more information, please call your seller.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode($getVendedorInfo[0]->nombre),0,'J',0);
$pdf->SetFont('Arial','B',9);
$pdf->MultiCell(186,5,utf8_decode($vendedor[1]),0,'J',0);
$pdf->SetFont('Arial','B',9);
$pdf->MultiCell(186,5,utf8_decode($vendedor[2]),0,'J',0);



$archivo=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/pdfs/confirmacion1-'.$reserva.'.pdf';
$pdf->Output($archivo,'F');
	//$pdf->Output();
?>
