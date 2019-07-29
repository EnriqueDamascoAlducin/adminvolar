<?php

	include_once 'conexion.php';
		$reserva = $_POST['id'];
	if(!isset($_POST['tipo'])){
		$campo = $_POST['campo'];
		$valor = $_POST['valor'];
		$id= $_POST['id'];
		if($valor==""){
			$valor = "null";
		}else{
			$valor="'".$valor."'";
		}
		if($campo=="tdescuento"){	
			$registrarDato=$con->actualizar("temp_volar","cantdescuento_temp=0" , "id_temp=$id");
		}
		$registrarDato=$con->actualizar("temp_volar",$campo ."_temp=". $valor , "id_temp=$id");
		echo $registrarDato;
	}else{
		$valor = $_POST['valor'];
		$tipo = $_POST['tipo'];
		$servicio = $_POST['servicio'];
		$servicio =  $con->query("CALL agregarServiciosReservas($reserva,$servicio,$tipo,$valor,@accion)");
		$servicio = $con->query("Select @accion as respuesta")->fetchALL (PDO::FETCH_OBJ);
		echo $servicio[0]->respuesta;
	}
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico
	$totalReserva=0.0;
	$totalPasajeros = $con->consulta("FORMAT(ifnull(pasajerosa_temp,0) + ifnull(pasajerosn_temp,0),2)  Total"," temp_volar "," id_temp = $reserva");
	$datosReserva = $con->consulta("ifnull(pasajerosa_temp,0) as pasajerosA , ifnull(pasajerosn_temp,0) as pasajerosN , IFNULL(habitacion_temp,'') as habitacion, tipo_temp, checkin_temp,checkout_temp, IFNULL(precio1_temp,0) as otroscar, IFNULL(precio2_temp,0) as otroscar2, IFNULL(tdescuento_temp,'') as tdescuento, IFNULL(cantdescuento_temp,0) as cantdescuento"," temp_volar "," id_temp = $reserva");
	
		
	
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
		echo "<br>Vuelo = ".$totalVuelo."<br>";
		if($datosReserva[0]->habitacion!=''){
			$precioHabitacion = $con->consulta("precio_habitacion","habitaciones_volar","id_habitacion=".$datosReserva[0]->habitacion);
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

			$totalHabitacion= $days * $precioHabitacion[0]->precio_habitacion;
			
			echo "Habitacion->".  $totalHabitacion."<br>";
			$totalReserva+=$totalHabitacion;
		}
		$totalReserva +=$datosReserva[0]->otroscar;
		echo "otros->".$datosReserva[0]->otroscar."<br>";
		$totalReserva +=$datosReserva[0]->otroscar2;
		if($datosReserva[0]->tdescuento!=''){
			if($datosReserva[0]->tdescuento==1){
				$totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
			}else{
				$totalDescuento = $datosReserva[0]->cantdescuento;
			}
			$totalReserva-=$totalDescuento;
		}
	}
	echo $totalReserva;

?>
