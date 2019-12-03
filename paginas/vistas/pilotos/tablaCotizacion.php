<?php
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
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
	$serviciosReserva = $con->consulta("tipo_sv as tipo , nombre_servicio as servicio ,cantmax_servicio as cantmax, precio_servicio as precio "," servicios_vuelo_temp svt INNER JOIN servicios_volar sv ON svt.idservi_sv=sv.id_servicio ","  svt.status<>0 and svt.cantidad_sv>0 and idtemp_sv =".$reserva);
	$movimientosExtras = $con->consulta("motivo_ce,cantidad_ce","cargosextras_volar","status<>0 and reserva_ce= " . $reserva);
	
/* 1 = cargos ..... 2 = descuentos*/
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
			$descripcionHospedaje = " De ".convertirFecha($checkin). " a ". convertirFecha($checkout). "(<b>".$days." dias</b> )";
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
	@media (max-width: 576px){
		.largeTd{
			font-size:60%;
			width:30%
			max-width:30%;
			table-layout: fixed;
		}

		td,th{
			max-height: 5px!important;
			font-size: 10px;
		}

	}

</style>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="divCot">
	<table class="table ">
		<thead>
			<tr>
				<th colspan="3" style="text-align: center;background: #2BBBAD;color: white;">
					RESERVA No. <?php echo $reserva; ?>
				</th>
			</tr>
		</thead>
		<tbody>
			<tbody>
					<tr>
						<td class="tdtitulo">FECHA DE VUELO</td>
						<td ><?php echo convertirFecha($datosReserva[0]->fechavuelo); ?></td>
					</tr>
					<tr>
						<td class="tdtitulo">NOMBRE</td>
						<td class="largeTd"><?php echo $datosReserva[0]->nombre ?></td>
						<td></td>
					</tr>
					<tr>
						<td class="tdtitulo">CORREO</td>
						<td class="largeTd" colspan="1"><?php echo $datosReserva[0]->correo ?></td>
						<td></td>
					</tr>
					<tr>
						<td class="tdtitulo"> TELÉFONOS</td>
						<td ><?php echo $datosReserva[0]->telefonos ?></td>
						<td></td>
					</tr>
					<tr>
						<td class="tdtitulo">TIPO DE VUELO</td>
						<td  colspan="" class="largeTd"><?php echo utf8_encode($datosReserva[0]->tipoVuelo); ?></td>
						<td></td>
					</tr>

					<tr>
						<td class="tdtitulo">PASAJEROS</td>
						<td><?php echo "Adultos: ".$datosReserva[0]->pasajerosA . "<br> Ni&ntilde;os: ".$datosReserva[0]->pasajerosN  ?></td>
						<td><?php  echo "$ ". number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ?></td>
					</tr>
					<?php if($datosReserva[0]->comentario!=''){ ?>
					<tr>
						<td class="tdtitulo">COMENTARIO</td>
						<td class="largeTd"><?php echo $datosReserva[0]->comentario; ?></td>
						<td></td>
					</tr>
					<?php } ?>
					<?php if($datosReserva[0]->motivo!=''){ ?>
					<tr>
						<td class="tdtitulo">MOTIVO</td>
						<td class="largeTd"><?php echo $datosReserva[0]->motivo; ?></td>
						<td></td>
					</tr>
					<?php } ?>
					<?php if($datosReserva[0]->hotel!=''){ ?>
						<tr>
							<td class="tdseparador" colspan="3">HOTEL</td>
						</tr>
						<tr>
							<td class="tdtitulo" colspan="3"><?php echo $hotel.'<br>$ '.number_format(  $precioHabitacion, 2, '.', ','); ?></td>
						</tr>
						<tr>
							<td class="tdtitulo" >HABITACIÓN</td>
							<td   ><?php echo $nombreHabitacion; ?></td>
							<td></td>
						</tr>
						<tr>
							<td class="tdtitulo" >PRECIO/NOCHE</td>
							<td><?php echo $descripcionHospedaje; ?></td>
							<td  ><?php echo "$ ".number_format(  $totalHabitacion, 2, '.', ','); ?></td>
						</tr>
						<tr>
							<td class="tdtitulo" >DESCRIPCIÓN</td>
							<td  class="largeTd"><?php echo $descripHabitacion; ?></td>
							<td></td>
						</tr>
					<?php } ?>
					<?php if($datosReserva[0]->otroscar1!=''){ ?>
						<tr>
							<td class="tdtitulo"><?php echo $datosReserva[0]->otroscar1 ?></td>
							<td></td>
							<td><?php echo "$ ".number_format(  $datosReserva[0]->precio1 , 2, '.', ','); ?></td>
						</tr>
					<?php } ?>
					<?php if($datosReserva[0]->otroscar2!=''){ ?>
						<tr>
							<td class="tdtitulo"><?php echo $datosReserva[0]->otroscar2 ?></td>
							<td></td>
							<td><?php echo "$ ".number_format(  $datosReserva[0]->precio2 , 2, '.', ',');  ?></td>

						</tr>
					<?php } ?>
					<?php if(sizeof($serviciosReserva)>0){ ?>
						<tr>
							<td class="tdseparador" colspan="3">SERVICIOS SOLICITADOS	</td>
						</tr>
						<?php foreach ($serviciosReserva as $servicioReserva) { ?>
							<tr>
								<td class="tdtitulo"><?php echo $servicioReserva->servicio; ?></td>
								<?php if($servicioReserva->tipo==1){ ?>
									<td>
										<?php
											if ($servicioReserva->cantmax == 1){
												$totalReserva +=($totalPasajeros * $servicioReserva->precio);
												echo $tPasajeros ;
											}else{
												$totalReserva += $servicioReserva->precio ;
												echo 1;
											}
										?>
									</td>
									<td><?php

											if ($servicioReserva->cantmax == 1){
												echo "$ ".number_format(($totalPasajeros * $servicioReserva->precio) , 2, '.', ',') ;
											}else{
												echo "$ ". number_format($servicioReserva->precio, 2, '.', ',') ;
											}
									?>
									</td>
									<?php }else {?>
									<td>
										CORTESIA
									</td>
								<?php } ?>
							</tr>
						<?php } ?>
					<?php } ?>

					<tr>
						<td class="tdtotal">SUB TOTAL</td>
						<td></td>
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
							<td class="tdtitulo">DESCUENTO</td>
							<td><?php
								if($datosReserva[0]->tdescuento==1) {
									echo $datosReserva[0]->cantdescuento."%";
								}
							?></td>
							<td>
								<?php
									if($datosReserva[0]->tdescuento==1) {
										echo "$ " .number_format($totalDescuento, 2, '.', ',');
									}else{
										echo "$ ".$totalDescuento;
									}
								?>
							</td>
						</tr>
					<?php
							$totalReserva-=$totalDescuento;
						}
					?>
					<tr>
						<td class="tdtotal">TOTAL</td>
						<td></td>
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
	if($totalReserva<0){
?>
	<script type="text/javascript">
		$("#divCot").html("El total de la reserva no puede ser menor $ 0.00");
		$("#ConfirmarCotizacion").hide();
	</script>
<?php
	}
?>
