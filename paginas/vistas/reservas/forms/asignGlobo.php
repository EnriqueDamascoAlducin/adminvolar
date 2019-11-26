<?php

	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*Datos Generales de la reserva*/
	$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, IFNULL(hora_temp,'') as hora,IFNULL(globo_temp,'') as globo,IFNULL(piloto_temp,'') as piloto ,status, IFNULL(kg_temp,'0.0') as kg,IFNULL(tipopeso_temp,'1') as tipopeso,  tipo_temp as vuelo, fechavuelo_temp as fecha","temp_volar tv", "id_temp=".$_POST['reserva']);
	/* Consulta de tipo de vuelo */
	$tVuelo = $con->consulta("nombre_extra,tipo_vc","vueloscat_volar INNER JOIN extras_volar on tipo_vc = id_extra"," id_vc =" . $datoReserva[0]->vuelo);
	/* Consulta de peso ocupado */
	$pesoOcupado = $con->consulta("IFNULL(sum(peso_ga),0) as ocupado","globosasignados_volar","status<>0 and reserva_ga =".$_POST['reserva']);
	$version = $con->consulta("IFNULL(max(version_ga),0) as version","globosasignados_volar","status<>0 and reserva_ga =".$_POST['reserva']);
	echo "<h3>". $datoReserva[0]->nombre ."</h3>";
	echo "(".$_POST['reserva'].'-' .$tVuelo[0]->nombre_extra.")";

	/* Establecer rango de horario en que se usa el filtro */
	$horaVuelo = $datoReserva[0]->hora;
  $deHora = strtotime($horaVuelo.' - 15 minute');
	$deHora= date('H:i:s', $deHora);
  $aHora = strtotime($horaVuelo.' + 15 minute');
	$aHora= date('H:i:s', $aHora);

	 if($datoReserva[0]->tipopeso=='1'){
		 $pesoTotal =$datoReserva[0]->kg;
	 }else{
		 $pesoTotal=($datoReserva[0]->kg * 0.453592);
	 }
	 $pesoLibre = $pesoTotal - $pesoOcupado[0]->ocupado;
	 /*Consulta de Globos Dependiendo del tipo de vuelo */
	 if($tVuelo[0]->tipo_vc==47){
		 /*Compartido*/
		 $campos = "CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value,peso_globo";
		 $tabla  = "globos_volar ";
		 $filtro = "status<>0 AND id_globo not  in(SELECT globo_temp from temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc WHERE tipo_vc = 46 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp = '". $datoReserva[0]->fecha ."' AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."') and peso_globo>=".$pesoTotal ;
		 $globos = $con->consulta($campos,$tabla,$filtro);
		 //echo  "SELECT $campos from $tabla WHERE $filtro";
	 }else{
		 /*46 privado*/
		 	$globos = $con->consulta("CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value","globos_volar","status<>0 and peso_globo>=".$pesoTotal. "  order by peso_globo asc");
	 }

	 	$globosAsignados = $con->consulta("tipo_temp as tipo,fechavuelo_temp as fecha, hora_temp as hora ,reserva_ga,peso_ga, nombre_globo, CONCAT(IFNULL(nombre_usu,''), ' ', IFNULL(apellidop_usu,'')) as piloto","globosasignados_volar ga INNER JOIN volar_usuarios on piloto_ga=id_usu INNER JOIN globos_volar on globo_ga = id_globo INNER JOIN temp_volar tv on tv.id_temp = ga.reserva_ga","ga.status<>0 and tv.status<>0 and  fechavuelo_temp = '". $datoReserva[0]->fecha ."' AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."'");
	 	$pilotos = $con->consulta("CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","status<>0 and puesto_usu = 4 and id_usu  in(SELECT piloto_temp from temp_volar WHERE id_temp=". $_POST['reserva'] .")");

?>
<div class="row">
	<div class="col-sm-12 col-lg-4 col-md-4 col-12 col-xl-3 ">
		<div class="form-group">
			<label for="hora">Hora de Vuelo</label>
			<input type="time" class="form-control"  onchange="confirmarAsignarGlobo(<?php echo $_POST['reserva']; ?>)" id="hora" placeholder="Hora de Vuelo" value = "<?php echo $datoReserva[0]->hora; ?>" >
		</div>
	</div>
	<?php
		$display="";
		if($datoReserva[0]->hora=='' || $pesoLibre==0){
			$display = "display:none";
		}
	?>
	<div class="col-sm-12 col-lg-4 col-md-4 col-12 col-xl-3 " style="margin-top:25px" >
		<div class="form-group">
			<?php if($datoReserva[0]->tipopeso=='1'){ ?>
				<label >Peso: <?php echo $datoReserva[0]->kg; ?> Kg </label>
			<?php }else{ ?>
				<label>Peso: <?php echo ($datoReserva[0]->kg * 0.453592); ?> Kg</label>
			<?php } ?>
		</div>
	</div>
	<div class="col-sm-12 col-lg-4 col-md-4 col-12 col-xl-3 " style="margin-top:25px" >
		<div class="form-group">
				<label >Peso Ocupado: <?php echo $pesoOcupado[0]->ocupado; ?> Kg </label>
		</div>
	</div>
		<input type="hidden" id="reservaG" value="<?php echo $_POST['reserva']; ?>">
		<input type="hidden" id="version" value="<?php echo $version[0]->version + 1; ?>">
</div>

<div class="row">
	<div class="col-12 col-sm-6 col-md-4 col-lg-4 col-xl-4"  style="<?php echo $display; ?>">
		<div class="form-group">
			<label class="form-label" for="peso">Peso</label>
			<input class="form-control" type="number" name="peso" id="peso" value="<?php echo $pesoLibre; ?>" onkeypress="return isNumber(event)" onchange="validaPeso(this.value);">
		</div>
	</div>
	<div class="col-12 col-sm-6 col-md-4 col-lg-4 col-xl-4"  style="<?php echo $display; ?>">
		<div class="form-group">
			<label for="globo">Globo</label>
			<select class="selectpicker form-control" id="globo" name="globo" data-live-search="true">
				<option value='0'>Ninguno...</option>
				<?php
					foreach ($globos as $globo) {
						$sel ="";
						if($tVuelo[0]->tipo_vc==46){
							$tot = $con->consulta("count(id_temp) as total","temp_volar tv INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp"," fechavuelo_temp = '". $datoReserva[0]->fecha ."' AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."'  and globo_ga=".$globo->value );
							if($tot[0]->total>0){
								$sel="disabled";
							}
						}else{
							$pesoAguanta = $globo->peso_globo;

							/*Peso en Libras*/
							$pesoActual= $con->consulta("sum(peso_ga) as peso","temp_volar tv INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp ","tv.status=8 and ga.status<>0 and globo_ga = ".$globo->value . " and fechavuelo_temp ='".$datoReserva[0]->fecha."' AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");
							//$pesoActualLib=($pesoActualLib[0]->peso* 0.453592);

							/*Peso en Kg*/
						/*	$pesoActualKg = $con->consulta("sum(kg_temp) as peso","temp_volar","status=8 and tipopeso_temp=1 and globo_temp = ".$globo->value . " and fechavuelo_temp ='".$datoReserva[0]->fecha."' AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");*/
							$pesoActual=$pesoActual[0]->peso;
							$sumaPeso = $pesoActual + $pesoOcupado[0]->ocupado;
							if($sumaPeso>$pesoAguanta){
								$sel = "disabled";
								$globo->text.="(Sobre pasa el Peso)";
							}else{
								$aunSoporta =($pesoAguanta+ $pesoOcupado[0]->ocupado-$sumaPeso);
								$globo->text.="->(Aun soporta ". $aunSoporta ." kg)";

							}

						}
						echo "<option ". $sel ." value='".$globo->value."'>".$globo->text."</option>";
					}
				?>

			</select>
		</div>
	</div>
	<div class="col-12 col-sm-6 col-md-4 col-lg-4 col-xl-4"  style="<?php echo $display; ?>">
		<div class="form-group">
			<label class="form-label" for="piloto">Piloto</label>
			<select class="form-control" name="piloto" id="piloto">
				<option value="4">Prueba</option>
			</select>
		</div>
	</div>
	<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12"  style="<?php echo $display; ?>">
		<div class="form-group">
			<button class="btn btn-success" type="button" name="guardarGlobo" id="guardarGlobo" onclick="guardaGlobo();"> Guardar Globo</button>
		</div>
	</div>
</div>

<table class="table DataTable">
	<thead>
		<tr>
			<th>Reserva</th>
			<th>Globo</th>
			<th>Peso</th>
			<th>Piloto</th>
			<th>Fecha</th>
			<th>Hora</th>
			<th>Tipo de Vuelo</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach ($globosAsignados as $globosAsignado) { ?>
			<tr>
				<td><?php echo $globosAsignado->reserva_ga ; 	?></td>
				<td><?php echo $globosAsignado->nombre_globo ; 	?></td>
				<td><?php echo $globosAsignado->peso_ga ; 	?></td>
				<td><?php echo $globosAsignado->piloto ; 	?></td>
				<td><?php echo $globosAsignado->fecha ; 	?></td>
				<td><?php echo $globosAsignado->hora ; 	?></td>
				<?php $tipoV = $con->consulta("nombre_extra","extras_volar ev INNER JOIN vueloscat_volar vv on id_extra=tipo_vc","id_vc=".$globosAsignado->tipo); ?>
				<td><?php echo $tipoV[0]->nombre_extra ; 	?></td>
			</tr>
		<?php } ?>
	</tbody>
</table>

<script type="text/javascript" src="vistas/reservas/js/index.js"></script>
<script type="text/javascript">
	function cambiarhora(){
		$("button[id^='btnAsignarGlobo']").trigger("click");
	}
	var limitePeso = <?php echo $pesoLibre ?>;
	function validaPeso(valor){
		if(valor>limitePeso){
			$("#peso").focus();
			abrir_gritter("Advertencia","Sobrepasaste el peso","warning");
			$("#peso").val(limitePeso);
		}
	}
	tables();

</script>
