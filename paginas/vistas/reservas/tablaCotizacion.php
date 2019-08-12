<?php 
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
//	$datosVuelo = $con->consulta("IFNULL(fechavuelo_temp,' No asignada' as fechavuelo, ")
		//2 es de cortesia ;1 es de paga
	//cantmax 0 = automatico
	$totalReserva=0.0;
	$totalPasajeros = $con->consulta("FORMAT(ifnull(pasajerosa_temp,0) + ifnull(pasajerosn_temp,0),2)  Total"," temp_volar "," id_temp = $reserva");
	$datosReserva = $con->query("CALL getResumenREserva(".$reserva.");")->fetchALL (PDO::FETCH_OBJ);
	$serviciosReserva = $con->consulta("tipo_sv as tipo , nombre_servicio as servicio ,cantmax_servicio as cantmax, precio_servicio as precio "," servicios_vuelo_temp svt INNER JOIN servicios_volar sv ON svt.idservi_sv=sv.id_servicio ","  svt.status<>0 and svt.cantidad_sv>0 and idtemp_sv =".$reserva);

		
	$hotel=$datosReserva[0]->hotel;
	$habitacion=$datosReserva[0]->habitacion;
	$habitacion=explode("|", $habitacion);
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
		
		

	}
	
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
	

</style>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
	<table class="table ">
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
						<td><?php echo $datosReserva[0]->fechavuelo ?></td>
					</tr>
					<tr>
						<td class="tdtitulo">Nombre</td>
						<td><?php echo $datosReserva[0]->nombre ?></td>
					</tr>
					<tr>
						<td class="tdtitulo">Correo</td>
						<td><?php echo $datosReserva[0]->correo ?></td>
					</tr>
					<tr>
						<td class="tdtitulo">Telefono Fijo - Telefono Celular</td>
						<td><?php echo $datosReserva[0]->telefonos ?></td>
					</tr>
					<tr>
						<td class="tdtitulo">Tipo de Vuelo</td>

						<td><?php echo $datosReserva[0]->tipoVuelo ?></td>
					</tr>

					<tr>
						<td class="tdtitulo">Pasajeros</td>
						<td><?php echo "Adultos:".$datosReserva[0]->pasajerosA ."(<b>". ($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) ."</b>) <br> Niños:".$datosReserva[0]->pasajerosN ."(<b>". ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ) ."</b>) " ?></td>
					</tr>
					<?php if($datosReserva[0]->comentario!=''){ ?>
					<tr>
						<td class="tdtitulo">Comentario</td>
						<td><?php echo $datosReserva[0]->comentario; ?></td>
					</tr>
					<?php } ?>	
					<?php if($datosReserva[0]->hotel!=''){ ?>
						<tr>
							<td class="tdseparador" colspan="2">Hotel</td>
						</tr>
						<tr>
							<td class="tdtitulo" colspan="2"><?php echo $hotel.'<br>'.$descripcionHospedaje; ?></td>
						</tr>
						<tr>
							<td class="tdtitulo" >Habitación</td>
							<td  ><?php echo $nombreHabitacion; ?></td>
						</tr>
						<tr>
							<td class="tdtitulo" >Precio/Noche</td>
							<td  ><?php echo $precioHabitacion; ?></td>
						</tr>
						<tr>
							<td class="tdtitulo" >Descripción</td>
							<td  ><?php echo $descripHabitacion; ?></td>
						</tr>
					<?php } ?>		
					<?php if($datosReserva[0]->otroscar1!=''){ ?>
						<tr>
							<td class="tdtitulo"><?php echo $datosReserva[0]->otroscar1 ?></td>
							<td><?php echo  $datosReserva[0]->precio1 ?></td>
						</tr>
					<?php } ?>
					<?php if($datosReserva[0]->otroscar2!=''){ ?>
						<tr>
							<td class="tdtitulo"><?php echo $datosReserva[0]->otroscar2 ?></td>
							<td><?php echo  $datosReserva[0]->precio2 ?></td>
						</tr>
					<?php } ?>		
					<?php if(sizeof($serviciosReserva)>0){ ?>
						<tr>
							<td class="tdseparador" colspan="2">Servicios Solicitados	</td>
						</tr>
						<?php foreach ($serviciosReserva as $servicioReserva) { ?>
							<tr>
								<td class="tdtitulo"><?php echo $servicioReserva->servicio; ?></td>
								<?php if($servicioReserva->tipo==1){ ?>
									<td>
										<?php 
											if ($servicioReserva->cantmax == 0){
												$totalReserva +=($totalPasajeros * $servicioReserva->precio);
												echo number_format( ( $servicioReserva->precio ) , 2, '.', ',')."x".$tPasajeros ."=".($totalPasajeros * $servicioReserva->precio) ;
											}else{
												$totalReserva += $servicioReserva->precio ;
												echo number_format($servicioReserva->precio, 2, '.', ',') ;
											}
										?>
									</td>
								<?php }else {?>
									<td>
										Cortesia
									</td>
								<?php } ?>			
							</tr>
						<?php } ?>
					<?php } ?>

					<tr>
						<td class="tdtotal">Sub Total</td>
						<td><?php echo  "$ ". number_format($totalReserva, 2, '.', ','); ?></td>
					</tr>

					<?php 
						if($datosReserva[0]->tdescuento!='' && $datosReserva[0]->cantdescuento>0) {
							$desc="";
							if($datosReserva[0]->tdescuento==1){

								$totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
							}else{
								$totalDescuento = $datosReserva[0]->cantdescuento;
							}
					?>
						<tr>
							<td class="tdtitulo">
								Descuento								
							</td>
							<td>
								<?php 
									if($datosReserva[0]->tdescuento==1) { 
										echo $datosReserva[0]->cantdescuento."% ($" .number_format($totalDescuento, 2, '.', ',').")";
									}else{
										echo "$".$totalDescuento;
									}
								?>
							</td>
						</tr>
					<?php
							$totalReserva-=$totalDescuento;
						}
					?>
					<tr>
						<td class="tdtotal">Total</td>
						<td> <?php echo "$ ". number_format($totalReserva, 2, '.', ','); ?></td>
					</tr>
				</tbody>
		</tbody>	

	</table>
</div>
<?php 
	if($_POST['accion']!='ver'){
		$accion = $con->actualizar("temp_volar","total_temp=".$totalReserva,"id_temp=".$reserva);

	}
?>