<?php
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/FPDF/plantillaConfirmacion.php';
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico
	$pago = $_POST['pago'];
	$pagoInfo= $con->consulta("cantidad_bp as cantidad, idres_bp as reserva","bitpagos_volar","status in(1,2,3) AND id_bp=".$pago);
	$reserva=$pagoInfo[0]->reserva;

	$totalPagos  = $con->consulta("SUM(cantidad_bp) as totalPagos ","bitpagos_volar"," status<>0 and idres_bp=".$reserva);
	$totalReserva=0.0;
	$totalPasajeros = $con->consulta("FORMAT(ifnull(pasajerosa_temp,0) + ifnull(pasajerosn_temp,0),2)  Total"," temp_volar "," id_temp = $reserva");
	$datosReserva = $con->query("CALL getResumenREserva(".$reserva.");")->fetchALL (PDO::FETCH_OBJ);
	$serviciosReserva = $con->consulta("tipo_sv as tipo , nombre_servicio as servicio ,cantmax_servicio as cantmax, IFNULL(svt.precio_sv,sv.precio_servicio) as precio "," servicios_vuelo_temp svt INNER JOIN servicios_volar sv ON svt.idservi_sv=sv.id_servicio ","  svt.status<>0 and cantidad_sv>0 and idtemp_sv =".$reserva);

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

	    $descripcionHospedaje = " De ".$checkin. " a ". $checkout. "(".$days." dias)";
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
	      $Nvafecha="Error ";
	    }
	    return $Nvafecha;
	  }

	}

	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$fechavuelo = convertirFecha($datosReserva[0]->fechavuelo);
	$encabezado = "Hola!!! ". $datosReserva[0]->nombre .". Envío confirmación de vuelo, no olvides llevarla contigo el día de tu vuelo (No es necesario imprimirla). ";
	$registroPago = "Registro y Pago: El día de tu vuelo deberás presentarte con nuestro anfitrión en la recepción para que registre tu asistencia y te reciba el pago del restante. Recuerda estar a tiempo en el lugar de la cita para no retrasar tu vuelo ni el de los demás. Te aconsejamos traer ropa cómoda, tal como si fueras a un día de campo: gorra, bufanda, guantes, bloqueador solar, cámara fotográfica o de video.";
	$tiempo ='A partir de 6:00 AM los esperamos en nuestra recepción, sin embargo esta hora sera CONFIRMADA UN DIA ANTES de acuerdo a la logística de operación del día o a las condiciones meteorológicas, te pido estés al tanto ya que recibirás una llamada para confirmar horario';

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
	$pdf->Cell(186,6,'RESERVA No. '.$reserva,1,1,'C',1);


	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'FECHA DE VUELO',1,0,'C',1);
	$pdf->Cell(58,6,convertirFecha($datosReserva[0]->fechavuelo),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);



	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'NOMBRE',1,0,'C',1);
	$pdf->Cell(58,6,utf8_decode($datosReserva[0]->nombre),1,0,'C',0);
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
	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'VENDEDOR',1,0,'C',1);
	$pdf->Cell(58,6,$vendedor[0],1,0,'C',0);
	$pdf->Cell(58,6,"",1,1,'C',0);



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
	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'ANTICIPO ',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($pagoInfo[0]->cantidad, 2, '.', ','),1,1,'C',0);

	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'ANTICIPO TOTAL',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($totalPagos[0]->totalPagos, 2, '.', ','),1,1,'C',0);
	$totalReserva-=$totalPagos[0]->totalPagos;


	$pdf->SetFillColor(139,105,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'TOTAL ',1,0,'C',1);
	$pdf->Cell(58,6,'',1,0,'C',0);
	$pdf->Cell(58,6,"$ ".number_format($totalReserva , 2, '.', ','),1,1,'C',0);


	/*NOTAS EXTRAS QUE SE INCLUYEN EN EL CORREO*/


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($tiempo),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('* Todos nuestros precios son expresados en Pesos Mexicanos.'),0,'J',0);
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('PUNTO DE REUNIÓN'),0,'C',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($reunion),0,'J',0);
///Que incluye el vuelos


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
/////REstricciones
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

////Restricciones para vuelos

	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode('Restricciones para los vuelos:'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Cuando las condiciones climatológicas no lo permita (Vientos mayor a 20 Km.).'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Lluvia y/o tormenta eléctrica.'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Exceso de neblina.'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °En caso de alguna de estas causas se reprogramara el vuelo en acuerdo mutuo.'),0,'J',0);

/// Cambio de fecha de vuelo o cancelaciones

$pdf->SetFont('Arial','B',9);
$pdf->MultiCell(186,5,utf8_decode('Cambio de fecha de vuelo o cancelaciones:'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °  En caso de no poder asistir a la cita por circunstancias adversas e imprevistas, deberá cancelar y confirmar la cancelación vía telefónica con al menos 36 horas de anticipación para que se te haga una reprogramación de tu vuelo sin cargo alguno, si la cancelación se hace dentro del periodo de las 36 a 12 horas previo a la realización del vuelo, se podrá reprogramar el vuelo con un cargo adicional al precio total del 35% por gastos de administración y operación. Si no existe cancelación y confirmación de cancelación o no se presentara el pasajero perderá el derecho a reembolso alguno.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °  En caso de que se requiera reprogramar un vuelo; es responsabilidad del pasajero reprogramar en un período no mayor a 12 meses de lo contrario se perderá el derecho al vuelo.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode(' °  El tiempo estimado de vuelo es hasta de una hora pero si las condiciones no lo permiten, la empresa lo deja a consideración del piloto. Así que no habrá reembolso alguno por vuelos con duración menor a una hora.'),0,'J',0);

///DIRECCIÓN Y COMO LLEGAR
$pdf->SetFont('Arial','B',9);
$pdf->MultiCell(186,5,utf8_decode('Direccion y Como Llegar:'),0,'J',0);
$pdf->MultiCell(186,6,'',0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode('Tomar Insurgentes Norte hacia México-Pachuca autopista 85D,  en cuanto llegues a las casetas de peaje  tomar las del lado derecho con dirección a Pirámides – Tulancingo autopista 132D, sigue los señalamientos hacia Pirámides Tulancingo, ahí pagaras una caseta, seguir sobre la autopista hasta pasar una gasolinera del lado derecho (aproximadamente 17 Km), tomar la desviación hacia Pirámides y continuar hasta la desviación a Tulancingo Libre, continuar sobre esta carretera, 5 Km adelante a tu mano izquierda vas a encontrar una Estación de Policía Federal, un poco más adelante encontraras una salida a mano izquierda antes del puente, debes girar a la izquierda nuevamente y allí 200 metros adelante encontraras Volar en Globo.'),0,'J',0);
$pdf->SetFont('Arial','',9);
$pdf->MultiCell(186,5,utf8_decode('Para más información por favor comunícate con tu vendedor'),0,'J',0);
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
