<?php

	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*Datos Generales de la reserva*/
	$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, IFNULL(hora_temp,'') as hora,IFNULL(globo_temp,'') as globo,IFNULL(piloto_temp,'') as piloto ,status, IFNULL(kg_temp,'0.0') as kg,IFNULL(tipopeso_temp,'1') as tipopeso,  tipo_temp as vuelo, fechavuelo_temp as fecha, IFNULL(pasajerosa_temp,0) as pasajerosa ,IFNULL(pasajerosn_temp,0) as pasajerosn ","temp_volar tv", "id_temp=".$_POST['reserva']);
	/* Consulta de tipo de vuelo */
	$tVuelo = $con->consulta("nombre_extra,tipo_vc","vueloscat_volar INNER JOIN extras_volar on tipo_vc = id_extra"," id_vc =" . $datoReserva[0]->vuelo);
	/* Consulta de peso ocupado */
	$pesoOcupado_Version = $con->consulta("IFNULL(sum(peso_ga),0) as ocupado,IFNULL(max(version_ga),0) as version","globosasignados_volar","status<>0 and reserva_ga =".$_POST['reserva']);
	echo "<h2>". $datoReserva[0]->nombre ."</h2>";
	echo "<h4>(".$_POST['reserva'].'-' .utf8_decode($tVuelo[0]->nombre_extra).")</h4>";
	echo "<h3> PAX: ". ($datoReserva[0]->pasajerosa + $datoReserva[0]->pasajerosn) ."</h3>";
	/* Establecer rango de horario en que se usa el filtro */
	$horaVuelo = $datoReserva[0]->hora;
  	$deHora = strtotime($horaVuelo.' - 60 minute');
	$deHora= date('H:i:s', $deHora);
  	$aHora = strtotime($horaVuelo.' + 60 minute');
	$aHora= date('H:i:s', $aHora);

	 if($datoReserva[0]->tipopeso=='1'){
		 $pesoTotal =$datoReserva[0]->kg;
	 }else{
		 $pesoTotal=($datoReserva[0]->kg * 0.453592);
	 }
	 $pesoLibre = $pesoTotal - $pesoOcupado_Version[0]->ocupado;
	 /*Consulta de Globos Dependiendo del tipo de vuelo */
	 if($tVuelo[0]->tipo_vc==47){
		 /*Compartido*/
		 $campos = "CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value,peso_globo";
		 $tabla  = "globos_volar ";
		 $filtro = "status<>0 AND id_globo not  in(SELECT globo_ga from temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp WHERE tipo_vc = 46 and ga.status<>0 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp = '". $datoReserva[0]->fecha ."' AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."') and peso_globo>=".$pesoTotal ;
		 $globos = $con->consulta($campos,$tabla,$filtro);
		 //echo  "SELECT $campos from $tabla WHERE $filtro";
	 }else{
		 /*46 privado*/
		 	$globos = $con->consulta("CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value","globos_volar","status<>0 and peso_globo>=".$pesoLibre. "  order by peso_globo asc");
	 }

	 	$globosAsignados = $con->consulta("tipo_temp as tipo,fechavuelo_temp as fecha, hora_temp as hora ,reserva_ga,peso_ga, nombre_globo, CONCAT(IFNULL(nombre_usu,''), ' ', IFNULL(apellidop_usu,'')) as piloto,version_ga","globosasignados_volar ga INNER JOIN volar_usuarios on piloto_ga=id_usu INNER JOIN globos_volar on globo_ga = id_globo INNER JOIN temp_volar tv on tv.id_temp = ga.reserva_ga","ga.status<>0 and tv.status<>0 and  fechavuelo_temp = '". $datoReserva[0]->fecha ."'");


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
				<label >Peso Ocupado: <?php echo $pesoOcupado_Version[0]->ocupado; ?> Kg </label>
		</div>
	</div>
		<input type="hidden" id="reservaG" value="<?php echo $_POST['reserva']; ?>">
		<input type="hidden" id="version" value="<?php echo $pesoOcupado_Version[0]->version + 1; ?>">
		<input type="hidden" id="tipovuelo" value="<?php echo $tVuelo[0]->tipo_vc; ?>">
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
			<select class="selectpicker form-control" id="globo" onchange="validaGlobo(value);" name="globo" data-live-search="true">
				<option value='0'>Ninguno...</option>
				<?php
					foreach ($globos as $globo) {
						$sel ="";
						if($tVuelo[0]->tipo_vc==46){
							$tot = $con->consulta("count(id_temp) as total","temp_volar tv INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp"," fechavuelo_temp = '". $datoReserva[0]->fecha ."' and ga.status<>0 AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."'  and globo_ga=".$globo->value );
							if($tot[0]->total>0){
								$sel="disabled";
							}
						}else{
							$pesoAguanta = $globo->peso_globo;

							/*Peso en Libras*/
							$pesoActual= $con->consulta("sum(peso_ga) as peso","temp_volar tv INNER JOIN globosasignados_volar ga ON ga.reserva_ga = tv.id_temp ","tv.status=8 and ga.status<>0 and globo_ga = ".$globo->value . " and fechavuelo_temp ='".$datoReserva[0]->fecha."' and ga.status<>0 AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");
							//$pesoActualLib=($pesoActualLib[0]->peso* 0.453592);

							/*Peso en Kg*/
						/*	$pesoActualKg = $con->consulta("sum(kg_temp) as peso","temp_volar","status=8 and tipopeso_temp=1 and globo_temp = ".$globo->value . " and fechavuelo_temp ='".$datoReserva[0]->fecha."' AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");*/
							$pesoActual=$pesoActual[0]->peso;
							$sumaPeso = $pesoActual + $pesoOcupado[0]->ocupado +$pesoLibre ;
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
	<div class="col-12 col-sm-6 col-md-4 col-lg-4 col-xl-4"  style="<?php echo $display; ?>">
		<div class="form-group">
			<label class="form-label" for="piloto">Piloto</label>
			<select class="form-control" name="piloto" id="piloto">
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
			<th>Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php foreach ($globosAsignados as $globosAsignado) { ?>
			<tr>
				<td><?php echo $globosAsignado->reserva_ga . "-". $globosAsignado->version_ga ; 	?></td>
				<td><?php echo $globosAsignado->nombre_globo ; 	?></td>
				<td><?php echo $globosAsignado->peso_ga ; 	?></td>
				<td><?php echo $globosAsignado->piloto ; 	?></td>
				<td><?php echo $globosAsignado->fecha ; 	?></td>
				<td><?php echo $globosAsignado->hora ; 	?></td>
				<?php $tipoV = $con->consulta("nombre_extra","extras_volar ev INNER JOIN vueloscat_volar vv on id_extra=tipo_vc","id_vc=".$globosAsignado->tipo); ?>
				<td><?php echo $tipoV[0]->nombre_extra ; 	?></td>
				<td>
					<i class="fa fa-user-o fa-lg" style="color:rgba(0, 150, 136, 0.7);margin-right: 5px" title="Asignar Globos y Pilotos"  	onclick="asignarGlobo(<?php echo $globosAsignado->reserva_ga; ?>)"  ></i>&nbsp;
					<i class="fa fa-trash fa-lg" style="color:red " title="Asignar Globos y Pilotos"  	onclick="eliminarGlobo(<?php echo $globosAsignado->reserva_ga; ?>,<?php echo $globosAsignado->version_ga; ?>)"  ></i>&nbsp;
				</td>
			</tr>
		<?php } ?>
	</tbody>
</table>

<script type="text/javascript" src="vistas/reservas/js/index.js"></script>
<script type="text/javascript">
function validaGlobo(globo){
	tipovuelo = "<?php  echo $tVuelo[0]->tipo_vc ?>";
	deHora = "<?php echo $deHora ?>";
	aHora = "<?php echo $aHora ?>";
	fecha = "<?php echo $datoReserva[0]->fecha  ?>";
	reserva = "<?php  echo $_POST['reserva'] ?>";
	if(tipovuelo==47){
		//47 compartido
		var1 = "contar(id_ga) as total";
		var2 = "globosasignados_volar ga unir temp_volar tv on id_temp = reserva_ga";
		var3 = "ga.status<>0 and tv.status<>0 YYY globo_ga="+globo+" YYY hora_temp entre '" + deHora + "' YYY '"+aHora+"' YYY fechavuelo_temp='"+fecha+"'";
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
	var4 = "selecciona piloto_ga detabla temp_volar tv unir globosasignados_volar ga on id_temp=reserva_ga WHERE hora_temp entre '"+deHora+"' YYY '"+ aHora +"' YYY tv.status=8 YYY fechavuelo_temp ='"+fecha+"'  YYY piloto_ga is not null YYY piloto_ga<>0 YYY ga.status<>0";
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
		var3 = "status<>0 YYY puesto_usu = 4 YYY  id_usu not in ";
		var4 =" selecciona piloto_ga from globosasignados_volar ga unir temp_volar tv  unir vueloscat_volar vv on tipo_temp = id_vc WHERE tipo_vc = 46 YYY vv.status<>0 YYY tv.status=8 YYY  fechavuelo_temp ='"+fecha+"' YYY hora_temp entre '"+deHora+"' YYY '" + aHora+"'  YYY piloto_ga is not null YYY piloto_ga <> 0 YYY ga.status<>0  ";

		var5 = " YYY id_usu not in ";
		var6 = "selecciona piloto_temp detabla  temp_volar tv unir vueloscat_volar vv on tipo_temp = id_vc WHERE tipo_vc = 47 YYY vv.status<>0 YYY tv.status=8 YYY  fechavuelo_temp ='"+fecha+"' YYY hora_temp entre '"+deHora+"' YYY '" + aHora+"'  YYY piloto_temp is not null and piloto_temp <> 0  and globo_temp<>"+globo;
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
	var3 = "status<>0  YYY puesto_usu = 4 YYY id_usu in(selecciona piloto_ga from globosasignados_volar ga unir  temp_volar tv on id_temp=reserva_ga Where globo_ga =" + globo + " YYY hora_temp entre '" + deHora + "' AND '"+aHora+"' and fechavuelo_temp='"+fecha+"' and ga.status<>0)";
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
			fecha = "<?php echo $datoReserva[0]->fecha  ?>";
			reserva = "<?php  echo $_POST['reserva'] ?>";
			if(47==tipovuelo){
				//Compartido
				var1 = "concatenar (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value,peso_globo";
				var2 = "globos_volar";
				var3 = "status<>0  and peso_globo>=" + valor + " AND id_globo not  in";
				var4 = "selecciona globo_ga from temp_volar tv unir vueloscat_volar vv on tipo_temp = id_vc unir globosasignados_volar ga ON ga.reserva_ga = tv.id_temp WHERE tipo_vc = 46 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp = '"+fecha+"' and ga.status<>0 AND hora_temp entre '"+ deHora +"' AND  '"+ aHora +"'";
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
		fecha = "<?php echo $datoReserva[0]->fecha  ?>";
		reserva = "<?php  echo $_POST['reserva'] ?>";
		sel = "";
		var1 = "esvacio(sumar(peso_ga),0) as peso";
		var2 = "temp_volar tv unir globosasignados_volar ga ON ga.reserva_ga = tv.id_temp ";
		var3 = "tv.status=8 YYY ga.status<>0 YYY globo_ga = " +globo+" YYY fechavuelo_temp ='"+fecha+"' YYY hora_temp entre '"+deHora+"' YYY '"+ aHora +"'";
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
			fecha = "<?php echo $datoReserva[0]->fecha  ?>";
			reserva = "<?php  echo $_POST['reserva'] ?>";
			sel = "";
			var1 = "contar(id_temp) as total";
			var2 = "temp_volar tv unir globosasignados_volar ga ON ga.reserva_ga = tv.id_temp";
			var3 = "  fechavuelo_temp = '"+ fecha +"' YYY ga.status<>0 AND hora_temp entre '"+deHora+"' YYY  '"+ aHora + "'  and globo_ga="+globo;
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


	tables();

</script>
