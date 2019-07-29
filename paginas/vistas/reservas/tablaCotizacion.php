<?php 
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
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
<style type="text/css">
	.tdtitulo{
		    background: #7986cb;
		    text-align: center;
		    vertical-align: middle;
		    color: white;
	}
	.tdtotal {
	    background: #9933CC;
	    text-align: center;
	    vertical-align: middle;
	    color: white;
	}
	.tdseparador{
		text-align: center;
		background: #2BBBAD;
		color: white;
	}
	td,th{
		max-height: 5px!important;
		font-size: 15px;
	}
	table{
		    max-width: 100%;
		    width: 100%;
		    border-color: #673ab7;
		    max-height: 100%;
		    height: 100%;
		    overflow-y: scroll;
	}

</style>
<table class="table">
	<thead>
		<tr>
			<th colspan="2" style="text-align: center;background: #2BBBAD;color: white;">
				Reserva No. <?php echo $reserva; ?>
			</th>
		</tr>
	</thead>
	<tbody>
		<tbody>
				<tr>
					<td class="tdtitulo">Fecha de Vuelo</td>
					<td>2019-07-15</td>
				</tr>
				<tr>
					<td class="tdtitulo">Nombre</td>
					<td>FRANCISCA GUAJARDO</td>
				</tr>
				<tr>
					<td class="tdtitulo">Correo</td>
					<td>alducin.asesori@outlook.com</td>
				</tr>
				<tr>
					<td class="tdtitulo">Telefono Fijo - Telefono Celular</td>
					<td>5529212556 - 015529212556</td>
				</tr>
				<tr>
					<td class="tdtitulo">Tipo de Vuelo</td>

					<td>Compartido Normal<br>Adultos($2,300.00), Niños ($1,700.00)</td>
				</tr>
				<tr>
					<td class="tdtitulo">Pasajeros</td>
					<td>Adultos 3 - Niños 1 <br>($8,600.00)</td>
				</tr>
								
				
				<tr>
					<td class="tdseparador" colspan="2">Servicios Solicitados	</td>
				</tr>
				<tr>
					<td colspan="2">
					</td></tr><tr><td class="tdtitulo">Lona Personalizada</td><td>Cortesia * 1</td></tr><tr><td class="tdtitulo">Cuatrimotos</td><td>800.00*16</td></tr><tr><td class="tdtitulo">Desayuno</td><td>140.00*1</td></tr><tr><td class="tdtitulo">Rosas</td><td>200.00*1</td></tr>					
				
								<tr>
					<td class="tdtotal">Sub Total</td>
					<td> $21,740.00 </td>
				</tr>
								<tr>
					<td class="tdtotal">Total</td>
					<td> $21,740.00 </td>
				</tr>
			</tbody>
	</tbody>	

</table>