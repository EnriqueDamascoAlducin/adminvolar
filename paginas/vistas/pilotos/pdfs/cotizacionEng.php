<?php
require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/FPDF/fpdf.php';


Class PDF extends FPDF{

	function Header(){
		//Imagen, SETX,SETY, tamaño
		$this->Image( $_SERVER['DOCUMENT_ROOT'].'/admin1/sources/images/correos/quoteHeader.jpeg',35,10,135,25);
		$this->Ln(30);
	}
	/*function Footer(){
		$this->SetY(-15);
		$this->SetFont('Arial','I', 8);
		$this->Cell(0,10, 'Pagina '.$this->PageNo().'/{nb}',0,0,'C' );
	}*/
}


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

			$descripcionHospedaje = " From ".convertirFecha($checkin). " to ". convertirFecha($checkout). "(".$days." days).";
			$totalReserva+=$totalHabitacion;
		}
		$totalReserva +=$datosReserva[0]->precio1;
		//echo "otros->".$datosReserva[0]->precio1."<br>";
		$totalReserva +=$datosReserva[0]->precio2;
	}

	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$fechavuelo = convertirFecha($datosReserva[0]->fechavuelo);
	$encabezado = "Dear ". $datosReserva[0]->nombre .". It's a pleasure to reply to your flight request. Our operation is located in Teotihuacan Valley, here you will enjoy the best view of pyramids and the whole arquelogical site. The appointment is at our reception, located 5 minutes from arquelogical site, where our team will welcome you and you can see the inflation of the hot air balloons. The adventure of flying begins, so prepare your camera! Get ready to live the dream of hot air ballooning!";
	$importante ="IMPORTANT: Once you have done the payment, you must notify your deposit by phone, email or message so we can send you a confirmation. If you have questions, call us or write to our email.";
	$tiempo="*Prices valid for 30 days from date on your quote.";
	$pdf = new PDF();
	$pdf->AliasNbPages();
	$pdf->AddPage();

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,($encabezado),0,'J',0);


	$pdf->SetFillColor(51,255,147);
	$pdf->SetFont('Arial','B',10);
	$pdf->Cell(186,6,'FLIGHT INFORMATION ',1,1,'C',1);


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
	$pdf->Cell(70,6,'FLIGHT DATE: ',1,0,'C',1);
	$pdf->Cell(58,6,$fechavuelo,1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);

/*
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
*/

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'FLIGHT: ',1,0,'C',1);
	$pdf->Cell(58,6,utf8_encode($datosReserva[0]->tipoVuelo),1,0,'C',0);
	$pdf->Cell(58,6,'',1,1,'C',0);



	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'ADULTS: ',1,0,'C',1);
	$pdf->Cell(58,6,($datosReserva[0]->pasajerosA),1,0,'C',0);
	$pdf->Cell(58,6,'$ '.number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ), 2, '.', ','),1,1,'C',0);

	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'KIDS: ',1,0,'C',1);
	$pdf->Cell(58,6,($datosReserva[0]->pasajerosN),1,0,'C',0);
	$pdf->Cell(58,6,'$ '.number_format(($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ','),1,1,'C',0);


/*
	$pdf->SetFillColor(105,165,247);
	$pdf->SetFont('Arial','',10);
	$pdf->Cell(70,6,'PASAJEROS',1,0,'C',1);
	$pdf->Cell(58,6,utf8_decode('Niños '.$datosReserva[0]->pasajerosN.' /  Adultos '.$datosReserva[0]->pasajerosA),1,0,'C',0);
	$pdf->Cell(58,6,'$ '.number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ','),1,1,'C',0);

*/

	if($datosReserva[0]->comentario!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'COMMENTS',1,0,'C',1);
		$pdf->MultiCell(58,6, utf8_decode(str_replace("â€¢","°",$datosReserva[0]->comentario)),1,'L',0);
	  $pdf->setXY(138,102);
	  $pdf->setTextColor(255, 255, 255);
		$pdf->MultiCell(58,6, utf8_decode($datosReserva[0]->comentario),1,'L',0);
    $pdf->setTextColor(0, 0, 0);
	}

	if($datosReserva[0]->motivo!=''){
		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,'OCASSION: ',1,0,'C',1);
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
		$pdf->Cell(70,6,utf8_decode('ROOM'),1,0,'C',1);
		$pdf->Cell(58,6,utf8_decode($nombreHabitacion .'($ '. number_format(  $precioHabitacion, 2, '.', ',') .')') ,1,0,'C',0);
		$pdf->Cell(58,6,'',1,1,'C',0);


		$pdf->SetFillColor(105,165,247);
		$pdf->SetFont('Arial','',10);
		$pdf->Cell(70,6,utf8_decode('HOTEL PRICE'),1,0,'C',1);
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
		$pdf->Cell(186,6,'SERVICES',1,1,'C',1);



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
					$pdf->Cell(58,6,'COURTESY',1,0,'C',0);
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
		$pdf->Cell(70,6,'DISCOUNT',1,0,'C',1);
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
	$pdf->MultiCell(186,5,utf8_decode('Restrictions:'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Children under 4 years old.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °If you have suffered a heart disease.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °If you have had a recent surgery.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Injured column.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °Pregnant women.'),0,'J',0);

	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode(' °If you are intoxicated. (Alcohol or drugs)'),0,'J',0);


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('*People over 100 kg, must pay $25.00 per extra kilo.'),0,'J',0);


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('*All Our Prices are Expressed in Mexican Pesos'),0,'J',0);



    $pdf->setTextColor(252, 0, 0);
	$pdf->SetFont('Arial','B',11);
	$pdf->MultiCell(186,5,utf8_decode('How to pay?'),0,'J',0);


    $pdf->setTextColor(0, 0, 0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Advance payment for $2,000.00 on bank account or transfer. The remainder will be paid the flight day.'),0,'J',0);




    $pdf->setTextColor(252, 0, 0);
	$pdf->SetFont('Arial','B',11);
	$pdf->MultiCell(186,5,utf8_decode('Deposit bank account:'),0,'J',0);
    $pdf->setTextColor(0, 0, 0);


	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Bank: BBVA Bancomer'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Account Number: 0191809393  Branch office: 399'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Name: Volar en Globo Aventura y Publicidad S.A. de C.V.'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Interbank CLABE: 012180001918093935'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($importante),0,'J',0);
	/*$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('Tenemos otras opciones de pago como: PayPal, cargo en línea a Tarjeta de crédito y/o depósitos en OXXO, comunícate con tu vendedor'),0,'J',0);
	*/
	$pdf->MultiCell(186,6,'',0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode('For more information contact us'),0,'J',0);
	$pdf->SetFont('Arial','',9);
	$pdf->MultiCell(186,5,utf8_decode($getVendedorInfo[0]->nombre),0,'J',0);
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode($vendedor[1]),0,'J',0);
	$pdf->SetFont('Arial','B',9);
	$pdf->MultiCell(186,5,utf8_decode($vendedor[2]),0,'J',0);



	$archivo=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/pdfs/cotizacion2-'.$reserva.'.pdf';
	$pdf->Output($archivo,'F');
	//$pdf->Output();
?>
