<?php

	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';

	$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, IFNULL(hora_temp,'') as hora,IFNULL(globo_temp,'') as globo,IFNULL(piloto_temp,'') as piloto ,status, IFNULL(kg_temp,'0.0') as kg,IFNULL(tipopeso_temp,'1') as tipopeso,  tipo_temp as vuelo, fechavuelo_temp as fecha","temp_volar tv", "id_temp=".$_POST['reserva']);

	$tVuelo = $con->consulta("nombre_extra,tipo_vc","vueloscat_volar INNER JOIN extras_volar on tipo_vc = id_extra"," id_vc =" . $datoReserva[0]->vuelo);


	echo $tVuelo[0]->nombre_extra;

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

	 if($tVuelo[0]->tipo_vc==47){
		 /*Compartido*/
		 $campos = "CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value,peso_globo";
		 $tabla  = "globos_volar ";
		 $filtro = "status<>0 AND id_globo not  in(SELECT globo_temp from temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc WHERE tipo_vc = 46 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp = '". $datoReserva[0]->fecha ."' AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."') and peso_globo>=".$pesoTotal . " order by peso_globo asc" ;
		 $globos = $con->consulta($campos,$tabla,$filtro);
		 //echo  "SELECT $campos from $tabla WHERE $filtro";
	 }else{
		 	$globos = $con->consulta("CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value","globos_volar","status<>0 and peso_globo>=".$pesoTotal. "  order by peso_globo asc");
	 }


	 	$pilotos = $con->consulta("CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","status<>0 and puesto_usu = 4 and id_usu  in(SELECT piloto_temp from temp_volar WHERE id_temp=". $_POST['reserva'] .")");
?>
<div class="row">
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="hora">Hora de Vuelo</label>
			<input type="time" class="form-control"  onchange="cambiarhora()" id="hora" placeholder="Hora de Vuelo" value = "<?php echo $datoReserva[0]->hora; ?>">
		</div>
	</div>
	<?php
	$display="";
	if($datoReserva[0]->hora==''){
		$display = "display:none";
	} ?>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " style="<?php echo $display; ?>">
			<div class="form-group">
				<label for="globo">Globo</label>
				<select class="selectpicker form-control" id="globo" name="globo" data-live-search="true">
					<option value='0'>Todos...</option>
					<?php
						foreach ($globos as $globo) {
							$sel="";
							if($globo->value==$datoReserva[0]->globo){
								$sel="selected ";
							}else{
								if($tVuelo[0]->tipo_vc==46){
									$tot = $con->consulta("count(id_temp) as total","temp_volar"," fechavuelo_temp = '". $datoReserva[0]->fecha ."' AND hora_temp BETWEEN '". $deHora ."' AND  '". $aHora ."'  and globo_temp=".$globo->value );
									if($tot[0]->total>0){
										$sel="disabled";
									}
								}else{
									$pesoAguanta = $globo->peso_globo;

									/*Peso en Libras*/
									$pesoActualLib = $con->consulta("sum(kg_temp) as peso","temp_volar","status=8 and tipopeso_temp=2 and globo_temp = ".$globo->value . " and fechavuelo_temp ='".$datoReserva[0]->fecha."' AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");
									$pesoActualLib=($pesoActualLib[0]->peso* 0.453592);

									/*Peso en Kg*/
									$pesoActualKg = $con->consulta("sum(kg_temp) as peso","temp_volar","status=8 and tipopeso_temp=1 and globo_temp = ".$globo->value . " and fechavuelo_temp ='".$datoReserva[0]->fecha."' AND hora_temp BETWEEN '".$deHora."' AND '".$aHora."'");
									$pesoActualKg=$pesoActualKg[0]->peso;
									$sumaPeso = $pesoActualKg + $pesoActualLib +$pesoTotal;
									if($sumaPeso>$pesoAguanta){
										$sel = "disabled";
										$globo->text.="(Sobre pasa el Peso)";
									}else{
										$aunSoporta =($pesoAguanta+$pesoTotal-$sumaPeso);
										$globo->text.="->(Aun soporta ". $aunSoporta ." kg)";

									}
								}
							}
							echo "<option ". $sel ." value='".$globo->value."'>".$globo->text."</option>";
						}
					?>

				</select>
			</div>
		</div>

		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " style="<?php echo $display; ?>">
			<div class="form-group">
				<label for="piloto">Piloto</label>
				<select class="selectpicker form-control" id="piloto" name="piloto" data-live-search="true">
					<option value='0'>Todos...</option>
					<?php
						foreach ($pilotos as $piloto) {
							$sel="";
							if($piloto->value==$datoReserva[0]->piloto){
								$sel="selected";
							}
							echo "<option ". $sel ." value='".$piloto->value."'>".$piloto->text."</option>";
						}
					?>

				</select>
			</div>
		</div>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " style="margin-top:25px" style="<?php echo $display; ?>">
			<div class="form-group">
				<?php if($datoReserva[0]->tipopeso=='1'){ ?>
					<label >Peso: <?php echo $datoReserva[0]->kg; ?> Kg </label>
				<?php }else{ ?>
					<label>Peso: <?php echo ($datoReserva[0]->kg * 0.453592); ?> Kg</label>
				<?php } ?>
			</div>
		</div>
</div>
<script type="text/javascript">
	function cambiarhora(){
		$("button[id^='btnAsignarGlobo']").trigger("click");
	}
	<?php  if($tVuelo[0]->tipo_vc==46 ){ ?>
		$("#globo").change(function(){
			var globo = this.value;
			var dehora = '<?php echo $deHora ?>';
			var ahora = '<?php echo $aHora ?>';
			var fecha = '<?php echo $datoReserva[0]->fecha ?>';
			<?php if ($datoReserva[0]->piloto!=''){ ?>
				var piloto 	="<?php echo $datoReserva[0]->piloto ?>";
			<?php } else { ?>
				var piloto= "";
			<?php } ?>
			var reserva 	="<?php echo $_POST['reserva'] ?>";
			var1="id_usu as value,CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text";
			var2="volar_usuarios";
			var3="status<>0 and puesto_usu = 4 and id_usu not in ";
			var4 = "selecciona piloto_temp from temp_volar WHERE hora_temp BETWEEN '"+dehora+"' and '"+ ahora +"' and status=8 and fechavuelo_temp ='"+fecha+"'  and piloto_temp is not null and piloto_temp<>0 ";
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
					  attr="";
					  if(val==piloto){
					  	attr="selected";
					  }
					  $("#piloto").append("<option value='"+val+"' "+attr+">"+text+"</option>");
					});
	      },
	      error:function(){
	      	alert("Error al cargar habitación");
	      }
	    });
		});
	<?php } else{ ?>
		$("#globo").change(function(){
				var globo = this.value;
				var dehora = '<?php echo $deHora ?>';
				var ahora = '<?php echo $aHora ?>';
				var fecha = '<?php echo $datoReserva[0]->fecha ?>';
				<?php if ($datoReserva[0]->piloto!=''){ ?>
					var piloto 	="<?php echo $datoReserva[0]->piloto ?>";
				<?php } else { ?>
					var piloto= "";
				<?php } ?>
				var1 = "contar(id_temp) as existePiloto";
				var2 = "temp_volar";
				var3 = "globo_temp = "+globo+" and hora_temp entre '"+dehora+"' and  '"+ahora+"' and fechavuelo_temp='"+fecha+"'";
			//	abrir_gritter("a","select " + var1 + " from "+ var2+ " where " + var3, "info");
		    parametros={var1:var1,var2:var2,var3:var3};
				//$("#piloto").load("vistas/reservas/forms/pilotos.php",parametros);
				$.ajax({
					data: parametros,
					dataType:"json",
					url:'controladores/query_json2.php',
					type:"POST",
					success: function(data){
						$.each( data, function( key, value ) {
							existePiloto=value.existePiloto;
						//	alert(existePiloto);
							if(existePiloto==0){
								cargarTodosPilotos(globo,dehora,ahora,fecha,piloto);
							}else{
								cargarPilotoActual(globo,dehora,ahora,fecha,piloto);
							}
						});
					},
					error:function(){
						alert("Error al cargar habitación");
					}
				});
		});
		function cargarTodosPilotos(globo,dehora,ahora,fecha,piloto){
			var1 = "id_usu as value,CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text";
			var2 = "volar_usuarios";
			var3 = "status<>0 and puesto_usu = 4 AND  id_usu not in";
			var4 = "selecciona piloto_temp from  temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc WHERE tipo_vc = 46 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp ='"+fecha+"' AND hora_temp BETWEEN '"+dehora+"' AND '" + ahora+"'  and piloto_temp is not null and piloto_temp <> 0  ";
			var5 = " and id_usu not in ";
			var6 = "selecciona piloto_temp from  temp_volar tv INNER JOIN vueloscat_volar vv on tipo_temp = id_vc WHERE tipo_vc = 47 and vv.status<>0 and tv.status=8 AND  fechavuelo_temp ='"+fecha+"' AND hora_temp BETWEEN '"+dehora+"' AND '" + ahora+"'  and piloto_temp is not null and piloto_temp <> 0  and globo_temp<>"+globo;
		//	abrir_gritter("a","select " + var1 + " from "+ var2+ " where " + var3  + "("+var4+")", "info");
			parametros={var1:var1,var2:var2,var3:var3,var4:var4,var5:var5,var6:var6};
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
					  attr="";
					  if(val==piloto){
					  	attr="selected";
					  }
					  $("#piloto").append("<option value='"+val+"' "+attr+">"+text+"</option>");
					});
	      },
	      error:function(){
	      	alert("Error al cargar cargarTodosPilotos");
	      }
	    });
		}
		function cargarPilotoActual(globo,dehora,ahora,fecha,piloto){
			var1 = "id_usu as value,CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text";
			var2 = "volar_usuarios";
			var3 = "status<>0  and puesto_usu = 4 AND id_usu in ";
			var4 = "selecciona piloto_temp from  temp_volar where globo_temp ="+globo+"  and piloto_temp is not null and piloto_temp <> 0";
			parametros={var1:var1,var2:var2,var3:var3,var4:var4};
	  	$("#piloto").empty();
			$.ajax({
	      data: parametros,
	      dataType:"json",
	      url:'controladores/query_json2.php',
	      type:"POST",
	      success: function(data){
	        $.each( data, function( key, value ) {
					  text=value.text;
					  val=value.value;
					  attr="";
					  if(val==piloto){
					  	attr="selected";
					  }
					  $("#piloto").append("<option value='"+val+"' "+attr+">"+text+"</option>");
					});
	      },
	      error:function(){
	      	alert("Error al cargar cargarPilotoActual");
	      }
	    });
		}
	<?php } ?>



</script>
