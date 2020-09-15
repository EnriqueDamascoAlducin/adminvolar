<?php

	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*Datos Generales de la reserva*/
	$turno = "";
	$opc1="";
	$opc2="";
	$opc3="";
	if(isset($_POST['reserva'])){
		$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, IFNULL(hora_temp,'') as hora,IFNULL(globo_temp,'') as globo,IFNULL(piloto_temp,'') as piloto ,status, IFNULL(kg_temp,'0.0') as kg,IFNULL(tipopeso_temp,'1') as tipopeso,  tipo_temp as vuelo, fechavuelo_temp as fecha, IFNULL(pasajerosa_temp,0) as pasajerosa ,IFNULL(pasajerosn_temp,0) as pasajerosn,IFNULL(turno_temp,0) as turno","temp_volar tv", "id_temp=".$_POST['reserva']);

		$fecha = $datoReserva[0]->fecha;
		$turno = $datoReserva[0]->turno;
		/* Consulta de tipo de vuelo */
		$tVuelo = $con->consulta("nombre_extra,tipo_vc","vueloscat_volar INNER JOIN extras_volar on tipo_vc = id_extra"," id_vc =" . $datoReserva[0]->vuelo);
		$totalPax = ($datoReserva[0]->pasajerosa + $datoReserva[0]->pasajerosn);
		/* Consulta de peso ocupado */
		$pesoOcupado_Version = $con->consulta("IFNULL(sum(peso_ga),0) as ocupado,IFNULL(max(version_ga),0) as version,IFNULL(sum(pax_ga),0) as pax","globosasignados_volar","status<>0 and reserva_ga =".$_POST['reserva']);
		echo "<h2>". $datoReserva[0]->nombre ."</h2>";
		echo "<h4>(".$_POST['reserva'].'-' .utf8_decode($tVuelo[0]->nombre_extra).")</h4>";
		echo "<h3> PAX: ". $totalPax ."</h3>";
		/* Establecer rango de horario en que se usa el filtro */
		$horaVuelo = $datoReserva[0]->hora;
		$deHora = strtotime($horaVuelo.' - 55 minute');
		$deHora= date('H:i:s', $deHora);
		$aHora = strtotime($horaVuelo.' + 55 minute');
		$aHora= date('H:i:s', $aHora);

		if($datoReserva[0]->tipopeso=='1'){
			$pesoTotal =$datoReserva[0]->kg;
		}else{
			$pesoTotal=($datoReserva[0]->kg * 0.453592);
		}
		$paxLib = $totalPax - $pesoOcupado_Version[0]->pax;
		$pesoLibre = $pesoTotal - $pesoOcupado_Version[0]->ocupado;
		 /*Consulta de Globos Dependiendo del tipo de vuelo */
		if($tVuelo[0]->tipo_vc==47){
			/*Compartido*/
			$campos = "CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value,peso_globo";
			$tabla  = "globos_volar ";
			$filtro = "status<>0  and  id_globo not  in(SELECT globo_ga from temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp WHERE tipo_vc = 46 and ga.status<>0 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp = '". $fecha ."' AND turno_temp = ".$turno." ) and peso_globo>=".$pesoLibre ;
			$globos = $con->consulta($campos,$tabla,$filtro);
// 			 echo  "SELECT $campos from $tabla WHERE $filtro";
// die();
		}else{
			/*46 privado*/
			$globos = $con->consulta("CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value","globos_volar","status<>0 and peso_globo>=".$pesoLibre. "  order by peso_globo asc");
		}
		}elseif(isset($_POST['fechaI']) && $_POST['fechaI']!=''){
				$fecha = $_POST['fechaI'];
		}else{
				$fecha=date("Y-m-d");
		}

		if($turno==1){
			$opc1="selected";
		}elseif($turno==2){
			$opc2="selected";
		}elseif($turno==3){
			$opc3="selected";
		}

		$globosAsignados = $con->consulta("tipo_temp as tipo,fechavuelo_temp as fecha, hora_temp as hora,nombre_extra, id_temp, CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre","temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc INNER JOIN extras_volar ev ON tipo_vc = id_extra","tv.status= 8 and  fechavuelo_temp = '". $fecha ."'");

?>
<?php if(isset($_POST['reserva'])){ ?>
	<div class="row">
		<div class="col-sm-12 col-lg-4 col-md-4 col-12 col-xl-3 ">
			<div class="form-group">
				<label for="hora">Hora de Vuelo</label>
				<input type="time" class="form-control"   id="hora" placeholder="Hora de Vuelo" value = "<?php echo $datoReserva[0]->hora; ?>" onchange="confirmarAsignarGlobo(<?php echo $_POST['reserva']; ?>)" >
			</div>
		</div>
			<div class="col-sm-12 col-lg-4 col-md-4 col-12 col-xl-3 ">
				<div class="form-group">
					<label for="hora">Turno</label>
					<select class="form-control" name="turno" id="turno" onchange="confirmarAsignarGlobo(<?php echo $_POST['reserva']; ?>)" >
						<option value="">Selecciona un Turno</option>
						<option value="1" <?php echo $opc1; ?> >Primero</option>
						<option value="2" <?php echo $opc2; ?> >Segundo</option>
						<option value="3" <?php echo $opc3; ?> >Tercero</option>
					</select>
				</div>
			</div>
		<?php
			$display="";
			if($datoReserva[0]->turno=='0' || $datoReserva[0]->hora=='' || $pesoLibre==0){
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
					<label >Peso Ocupado: <?php echo $pesoOcupado_Version[0]->ocupado; ?> Kg </label>
			</div>
		</div>
			<input type="hidden" id="reservaG" value="<?php echo $_POST['reserva']; ?>">
			<input type="hidden" id="version" value="<?php echo $pesoOcupado_Version[0]->version + 1; ?>">
			<input type="hidden" id="tipovuelo" value="<?php echo $tVuelo[0]->tipo_vc; ?>">
	</div>

	<div class="row">
		<div class="col-12 col-sm-6 col-md-3 col-lg-3 col-xl-3"  style="<?php echo $display; ?>">
			<div class="form-group">
				<label class="form-label" for="peso">Peso</label>
				<input class="form-control" type="number" name="peso" id="peso" value="<?php echo $pesoLibre; ?>" onkeypress="return isNumber(event)" onchange="validaPeso(this.value);">
			</div>
		</div>
			<div class="col-12 col-sm-6 col-md-3 col-lg-3 col-xl-3"  style="<?php echo $display; ?>">
				<div class="form-group">
					<label class="form-label" for="pax">PaX</label>
					<input class="form-control" type="number" name="pax" id="pax" value="<?php echo $paxLib; ?>" onkeypress="return isNumber(event)" >
				</div>
			</div>
		<div class="col-12 col-sm-6 col-md-3 col-lg-3 col-xl-3"  style="<?php echo $display; ?>">
			<div class="form-group">
				<label for="globo">Globo</label>
				<select class="selectpicker form-control" id="globo" onchange="validaGlobo(value);" name="globo" data-live-search="true">
					<option value='0'>Ninguno...</option>
					<?php
						foreach ($globos as $globo) {
							$sel ="";
							if($tVuelo[0]->tipo_vc==46){
								$tot = $con->consulta("count(id_temp) as total","temp_volar tv INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp"," fechavuelo_temp = '". $fecha ."' and ga.status<>0 AND turno_temp = ".$turno."  and globo_ga=".$globo->value );
								if($tot[0]->total>0){
									$sel="disabled";
								}
							}else{
								$pesoAguanta = $globo->peso_globo;

								/*Peso en Libras*/
								$pesoActual= $con->consulta("sum(peso_ga) as peso","temp_volar tv INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp ","tv.status=8 and ga.status<>0 and globo_ga = ".$globo->value . " and fechavuelo_temp ='".$fecha."' and ga.status<>0 AND turno_temp = ".$turno);
								//$pesoActualLib=($pesoActualLib[0]->peso* 0.453592);

								/*Peso en Kg*/
							/*	$pesoActualKg = $con->consulta("sum(kg_temp) as peso","temp_volar","status=8 and tipopeso_temp=1 and globo_temp = ".$globo->value . " and fechavuelo_temp ='".$fecha."' AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");*/
								$pesoActual=$pesoActual[0]->peso;
								$sumaPeso = $pesoActual + $pesoOcupado_Version[0]->ocupado +$pesoLibre ;
								if($sumaPeso>$pesoAguanta){
									$sel = "disabled";
									$globo->text.="(Sobre pasa el Peso)";
								}else{
									$aunSoporta =($pesoAguanta-$sumaPeso+$pesoLibre);
									$globo->text.="->(Aun soporta ". $aunSoporta ." kg)";

								}

							}
							echo "<option ". $sel ." value='".$globo->value."'>".$globo->text."</option>";
						}
					?>

				</select>
			</div>
		</div>
		<div class="col-12 col-sm-6 col-md-3 col-lg-3 col-xl-3"  style="<?php echo $display; ?>">
			<div class="form-group">
				<label class="form-label" for="piloto">Piloto</label>
				<select class="form-control" name="piloto" id="piloto">
				</select>
			</div>
		</div>
		<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12"  style="<?php echo $display; ?>">
			<div class="form-group">
				<label class="form-label" for="comentario">Comentario</label>
				<textarea id="comentario" name="comentario" class="form-control"></textarea>
			</div>
		</div>
		<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12"  style="<?php echo $display; ?>">
			<div class="form-group">
				<button class="btn btn-success" type="button" name="guardarGlobo" id="guardarGlobo" onclick="guardaGlobo();"> Guardar Globo</button>
			</div>
		</div>
	</div>
<?php } ?>
<table class="table DataTable">
	<thead>
		<tr>
			<th>Reserva</th>
			<th>Cliente</th>
			<th>Globo</th>
			<th>Peso</th>
			<th>Pax</th>
			<th>Piloto</th>
			<th>Fecha</th>
			<th>Hora</th>
			<th>Tipo de Vuelo</th>
			<th>Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach ($globosAsignados as $globosAsignado) { ?>
			<?php $infoGlobos = $con->consulta("reserva_ga,peso_ga, nombre_globo, CONCAT(IFNULL(nombre_usu,''), ' ', IFNULL(apellidop_usu,'')) as piloto,version_ga,pax_ga","globosasignados_volar ga INNER JOIN volar_usuarios on piloto_ga=id_usu INNER JOIN globos_volar on globo_ga = id_globo","ga.status<>0 and reserva_ga=".$globosAsignado->id_temp); ?>
			<?php if(sizeof($infoGlobos)){ ?>
				<?php foreach ($infoGlobos as $infoGlobo) { ?>
					<tr>
						<td><?php echo $infoGlobo->reserva_ga . "-". $infoGlobo->version_ga ; 	?></td>
						<td><?php echo $globosAsignado->nombre ; 	?></td>
						<td><?php echo $infoGlobo->nombre_globo ; 	?></td>
						<td><?php echo $infoGlobo->peso_ga ; 	?></td>
						<td><?php echo $infoGlobo->pax_ga ; 	?></td>
						<td><?php echo $infoGlobo->piloto ; 	?></td>
						<td><?php echo $globosAsignado->fecha ; 	?></td>
						<td><?php echo $globosAsignado->hora ; 	?></td>
						<td><?php echo $globosAsignado->nombre_extra ; 	?></td>
						<td>
							<i class="fa fa-trash fa-lg" style="color:red " title="Asignar Globos y Pilotos"  	onclick="eliminarGlobo(<?php echo $globosAsignado->id_temp; ?>,<?php echo $infoGlobo->version_ga; ?>)"  ></i>&nbsp;
								<i class="fa fa-user-o fa-lg" style="color:rgba(0, 150, 136, 0.7);margin-right: 5px" title="Asignar Globos y Pilotos"  	onclick="asignarGlobo(<?php echo $globosAsignado->id_temp; ?>)"  ></i>&nbsp;
						</td>
					</tr>
				<?php } ?>
			<?php } else{ ?>
				<tr>
					<td ><?php echo $globosAsignado->id_temp ?></td>
					<td><?php echo $globosAsignado->nombre ; 	?></td>
					<td data-order="ZZZZZZZZZZ">NA</td>
					<td data-order="ZZZZZZZZZZ">NA</td>
					<td data-order="ZZZZZZZZZZ">NA</td>
					<td>Na</td>
					<td><?php echo $globosAsignado->fecha ; 	?></td>
					<td><?php echo $globosAsignado->hora ; 	?></td>
					<td><?php echo $globosAsignado->nombre_extra ; 	?></td>
					<td>
						<i class="fa fa-user-o fa-lg" style="color:rgba(0, 150, 136, 0.7);margin-right: 5px" title="Asignar Globos y Pilotos"  	onclick="asignarGlobo(<?php echo $globosAsignado->id_temp; ?>)"  ></i>&nbsp;
					</td>
				</tr>
			<?php } ?>
		<?php } ?>
	</tbody>
</table>

<script type="text/javascript" src="vistas/reservas/js/index.js"></script>
<?php if(isset($_POST['reserva'])){ ?>
	<script type="text/javascript">
	function validaGlobo(globo){
		if(globo == 0){
			$("#piloto").html("<option> Selecciona un globo</option>");
			return false;
		}
			
		tipovuelo = "<?php  echo $tVuelo[0]->tipo_vc ?>";
		deHora = "<?php echo $deHora ?>";
		aHora = "<?php echo $aHora ?>";
		fecha = "<?php echo $fecha  ?>";
		turno = "<?php echo $turno  ?>";
		reserva = "<?php  echo $_POST['reserva'] ?>";
		if(tipovuelo==47){
			//47 compartido
			var1 = "contar(id_ga) as total";
			var2 = "globosasignados_volar ga unir temp_volar tv on id_temp = reserva_ga";
			var3 = "ga.status<>0 and tv.status<>0 YYY globo_ga="+globo+" YYY turno_temp = "+turno+" YYY fechavuelo_temp='"+fecha+"'";
			parametros = {var1:var1,var2:var2,var3:var3};
			$.ajax({
				data: parametros,
				dataType:"json",
				async:false,
				url:'controladores/query_json2.php',
				type:"POST",
				success: function(data){
					$.each( data, function( key, value ) {
						total=value.total;
					});
				},
				error:function(){
					alert("Error al validar Globos");
				}
			});
			if(total==0){
				getTodosPilotos(reserva,deHora,aHora,fecha,globo);
			}else{
				getUnicoPiloto(reserva,deHora,aHora,fecha,globo);
			}
		}else{
			// 46 es privado
				getPilotosPrivado(reserva,deHora,aHora,fecha,globo);
		}
	}
	function getPilotosPrivado(reserva,deHora,aHora,fecha,globo){
		var1 ="id_usu as value,concatenar(nombre_usu, ' ', esvacio(apellidop_usu,''),' ',esvacio(apellidom_usu,'')) as text";
		var2 ="volar_usuarios";
		var3 ="status<>0 YYY puesto_usu = 4 YYY id_usu not in ";
		var4 = "selecciona piloto_ga detabla temp_volar tv unir globosasignados_volar ga on id_temp=reserva_ga WHERE turno_temp= "+turno+" YYY tv.status=8 YYY fechavuelo_temp ='"+fecha+"'  YYY piloto_ga is not null YYY piloto_ga<>0 YYY ga.status<>0";
			parametros={var1:var1,var2:var2,var3:var3,var4:var4};
		//	$("#piloto").load("vistas/reservas/forms/pilotos.php",parametros);

		$("#piloto").empty().append("<option value=''>Selecciona un Piloto </option>");
		$.ajax({
				data: parametros,
				dataType:"json",
				url:'controladores/query_json2.php',
				type:"POST",
				success: function(data){
					$.each( data, function( key, value ) {
						text=value.text;
						val=value.value;
						$("#piloto").append("<option value='"+val+"' >"+text+"</option>");
					});
				},
				error:function(){
					alert("Error al cargar Pilotos PrivadoSSS");
				}
			});
	}
	function getTodosPilotos(reserva,deHora,aHora,fecha,globo){
			var1 = "id_usu as value,concatenar(nombre_usu, ' ', esvacio(apellidop_usu,''),' ',esvacio(apellidom_usu,'')) as text";
			var2 = "volar_usuarios";
			var3 = "status<>0 YYY puesto_usu = 4 YYY  id_usu not in ( selecciona piloto_ga from globosasignados_volar ga unir temp_volar tv ON ga.reserva_ga=tv.id_temp  WHERE  tv.status=8 YYY  ga.status<>0 AND fechavuelo_temp ='"+fecha+"' YYY turno_temp = "+turno+" )";
			parametros = {var1:var1,var2:var2,var3:var3};
			$("#piloto").empty().append("<option value='0'>Selecciona un piloto</option>");
			$.ajax({
				data: parametros,
				dataType:"json",
				url:'controladores/query_json2.php',
				type:"POST",
				success: function(data){
					$.each( data, function( key, value ) {
						text 	= value.text;
						val 	= value.value;

						$("#piloto").append("<option value='"+val+"' >"+text +"</option>");
					});
				},
				error:function(){
					alert("Error al cargar todos los Pilotos");
				}
			});
	}
	function getUnicoPiloto(reserva,deHora,aHora,fecha,globo){
		var1 = "id_usu as value,concatenar(nombre_usu, ' ', esvacio(apellidop_usu,''),' ',esvacio(apellidom_usu,'')) as text";
		var2 = "volar_usuarios";
		var3 = "status<>0  YYY puesto_usu = 4 YYY id_usu in(selecciona piloto_ga from globosasignados_volar ga unir  temp_volar tv on id_temp=reserva_ga Where globo_ga =" + globo + " YYY turno_temp = "+turno+" and fechavuelo_temp='"+fecha+"' and ga.status<>0)";
		parametros = {var1:var1,var2:var2,var3:var3};
		$("#piloto").empty().append("<option value='0'>Selecciona un piloto</option>");
		$.ajax({
				data: parametros,
				dataType:"json",
				url:'controladores/query_json2.php',
				type:"POST",
				success: function(data){
					$.each( data, function( key, value ) {
						text 	= value.text;
						val 	= value.value;

						$("#piloto").append("<option value='"+val+"' selected>"+text +"</option>");
					});
				},
				error:function(){
					alert("Error al cargar unico Piloto");
				}
			});
	}

		function cambiarhora(){
			$("button[id^='btnAsignarGlobo']").trigger("click");
		}
		var limitePeso = <?php echo $pesoLibre ?>;
		function validaPeso(valor){
			if(valor>limitePeso){
				$("#peso").focus();
				abrir_gritter("Advertencia","Sobrepasaste el peso","warning");
				$("#peso").val(limitePeso);
			}else{
				tipovuelo = "<?php  echo $tVuelo[0]->tipo_vc ?>";
				deHora = "<?php echo $deHora ?>";
				aHora = "<?php echo $aHora ?>";
				fecha = "<?php echo $fecha  ?>";
				reserva = "<?php  echo $_POST['reserva'] ?>";
				if(47==tipovuelo){
					//Compartido
					var1 = "concatenar (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value,peso_globo";
					var2 = "globos_volar";
					var3 = "status<>0  and peso_globo>=" + valor + " AND id_globo not  in";
					var4 = "selecciona globo_ga from temp_volar tv unir vueloscat_volar vv on tipo_temp = id_vc unir globosasignados_volar ga ON ga.reserva_ga = tv.id_temp WHERE tipo_vc = 46 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp = '"+fecha+"' and ga.status<>0 AND turno_temp="+turno;
					getGlobosCompartido(var1,var2,var3,var4,valor);
				}else{
					/*Privados*/
					var1 = "concatenar (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value";
					var2 = "globos_volar";
					var3 = "status<>0 and peso_globo>="+valor+ "  order by peso_globo asc";
					getGlobosPrivado(var1,var2,var3);
				}
			}
		}
		function getGlobosCompartido(var1,var2,var3,var4,valor){
			parametros = {var1:var1,var2:var2,var3:var3,var4:var4};
			$("#globo").empty().append("<option value=''>Selecciona un Globo </option>");
			$.ajax({
		      data: parametros,
		      dataType:"json",
		      url:'controladores/query_json2.php',
		      type:"POST",
		      success: function(data){
		        $.each( data, function( key, value ) {
						  text 	= value.text;
						  val 	= value.value;
							peso 	= value.peso_globo; // peso aguanta
							pesoOcupado = validaStatCompartidos(val); // peso ocupado
							pesoDisponible = peso- pesoOcupado - parseFloat(valor); //
							if(pesoDisponible<=0){
								sel = "disabled";
								textoDisponible = "Sin espacio ";
							}else{
								textoDisponible = "Disponible "+ (pesoDisponible + parseFloat(valor));
								sel ="";
							}

						  $("#globo").append("<option value='"+val+"' "+sel+">"+text+"("+ textoDisponible +")</option>");
						});
		      },
		      error:function(){
		      	alert("Error al cargar Globos Compartidos");
		      }
		    });
		}


		function validaStatCompartidos(globo){
			tipovuelo = "<?php  echo $tVuelo[0]->tipo_vc ?>";
			deHora = "<?php echo $deHora ?>";
			aHora = "<?php echo $aHora ?>";
			fecha = "<?php echo $fecha  ?>";
			reserva = "<?php  echo $_POST['reserva'] ?>";
			sel = "";
			var1 = "esvacio(sumar(peso_ga),0) as peso";
			var2 = "temp_volar tv unir globosasignados_volar ga ON ga.reserva_ga = tv.id_temp ";
			var3 = "tv.status=8 YYY ga.status<>0 YYY globo_ga = " +globo+" YYY fechavuelo_temp ='"+fecha+"' YYY turno_temp = "+turno;
			parametros = {var1:var1,var2:var2,var3:var3};
			$.ajax({
		      data: parametros,
		      dataType:"json",
					async:false,
		      url:'controladores/query_json2.php',
		      type:"POST",
		      success: function(data){
		        $.each( data, function( key, value ) {
						  total=value.peso;
							return total;
						});
		      },
		      error:function(){
		      	alert("Error al validar Globos");
		      }
		    });
				return total;
		}


		/*Info globos privados*/

			function getGlobosPrivado(var1,var2,var3){
				parametros = {var1:var1,var2:var2,var3:var3};
				$("#globo").empty().append("<option value=''>Selecciona un Globo </option>");
				var sel ="";
				$.ajax({
			      data: parametros,
			      dataType:"json",
						asyn:false,
			      url:'controladores/query_json2.php',
			      type:"POST",
			      success: function(data){
			        $.each( data, function( key, value ) {
							  text=value.text;
							  val=value.value;
								var sel = validaStatPrivados(val);
							  $("#globo").append("<option value='"+val+"' "+ sel +">"+text+"</option>");
							});
			      },
			      error:function(){
			      	alert("Error al cargar globos privados ");
			      }
			    });
			}
			function validaStatPrivados(globo){
				tipovuelo = "<?php  echo $tVuelo[0]->tipo_vc ?>";
				deHora = "<?php echo $deHora ?>";
				aHora = "<?php echo $aHora ?>";
				fecha = "<?php echo $fecha  ?>";
				reserva = "<?php  echo $_POST['reserva'] ?>";
				sel = "";
				var1 = "contar(id_temp) as total";
				var2 = "temp_volar tv unir globosasignados_volar ga ON ga.reserva_ga = tv.id_temp";
				var3 = "  fechavuelo_temp = '"+ fecha +"' YYY ga.status<>0 AND turno_temp="+turno+"  and globo_ga="+globo;
				parametros = {var1:var1,var2:var2,var3:var3};
				$.ajax({
			      data: parametros,
			      dataType:"json",
						async:false,
			      url:'controladores/query_json2.php',
			      type:"POST",
			      success: function(data){
			        $.each( data, function( key, value ) {
							  total=value.total;
								return total;
							});
			      },
			      error:function(){
			      	alert("Error al validar stat Globos");
			      }
			    });
					if(total>0)
						return "disabled";
					else
						return "";
			}


	</script>
<?php } ?>
<script type="text/javascript">

		function tables2(){
			$(".DataTable").DataTable().destroy();
				$(".DataTable").dataTable( {
					"pageLength": 50,
					"autoWidth": true,
					"scrollX": true,
							"order": [[ '2','asc' ]]
				} );
		}

				tables2();

</script>
