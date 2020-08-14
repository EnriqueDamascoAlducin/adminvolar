<?php
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
	$metodos = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='metodopago'");
	$cuentas = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='cuentasvolar'");

	$pagos = $con->consulta("CONCAT(nombre_usu,' ',apellidop_usu) as usuario, referencia_bp as referencia, cantidad_bp as cantidad,fecha_bp as fecha, bp.status as stat,id_bp as id,banco_bp","bitpagos_volar bp INNER JOIN volar_usuarios vu  ON bp.idreg_bp=vu.id_usu","bp.status<>0 and idres_bp=".$reserva);
	$peso = $con->consulta("kg_temp,tipopeso_temp","temp_volar","id_temp=".$reserva);
	$total = $con->consulta(" SUM(cantidad_bp) as pagado, total_temp as cotizado","bitpagos_volar bitp INNER JOIN temp_volar t on idres_bp = id_temp"," bitp.status in (1,2) and idres_bp=".$reserva);
	$monedas = $con->consulta("nombre_extra as nombre, abrev_extra as cantidad, id_extra as id","extras_volar","clasificacion_extra ='monedas' and status<>0");
?>
<style type="text/css">

	@media (max-width: 576px){
		.tableTh{
			font-size: 60%;
		}
		.tableTd{
			font-size: 55%;
		}
	}
</style>
<ul class="nav nav-tabs" role="tablist">
    <li class="nav-item" onclick="cambiarOpcion(1)">
      <a class="nav-link active" data-toggle="tab" href="#registro">Registrar Pago</a>
    </li>
</ul>

  <!-- Tab panes -->
  <div class="tab-content">
    <div id="registro" class="container tab-pane active"><br>
			<div class="row">
			  <div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
					<div class="form-group">
						<label for="referencia">Total Pagado: <?php echo '$ '.number_format($total[0]->pagado, 2, '.', ','); ?></label>
					</div>
				</div>
			  <div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
					<div class="form-group">
						<label for="referencia">Cotizado: <?php echo '$ '.number_format($total[0]->cotizado, 2, '.', ','); ?></label>
					</div>
				</div>
					<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
						<div class="form-group">
							<label for="referencia">Por Pagar: <?php echo '$ '.number_format( $total[0]->cotizado -$total[0]->pagado, 2, '.', ',');  ?></label>
						</div>
					</div>
			</div>
			<div class="row">
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="moneda">Moneda</label>
						<select class="selectpicker form-control" id="moneda" name="moneda" data-live-search="true">
							<?php
								foreach ($monedas as $moneda) {
									echo "<option value='".$moneda->id."'>".$moneda->nombre."($ ".number_format(  $moneda->cantidad, 2, '.', ',').")</option>";
								}
							?>
						</select>
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="metodo">Método</label>
						<select class="selectpicker form-control" id="metodo" name="metodo" data-live-search="true">
							<option value='0'>Todos...</option>
							<?php
								foreach ($metodos as $metodo) {
									echo "<option value='".$metodo->value."'>".$metodo->text."</option>";
								}
							?>

						</select>
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="banco">Banco</label>
						<select class="selectpicker form-control" id="banco" name="banco" data-live-search="true">
							<option value='0'>Todos...</option>
							<?php
								foreach ($cuentas as $cuenta) {
									echo "<option value='".$cuenta->value."'>".$cuenta->text."</option>";
								}
							?>
						</select>
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="referencia">Referencia</label>
						<input type="text" class="form-control" id="referencia" placeholder="Referencia">
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="cantidad">Cantidad</label>
						<input type="number" class="form-control" id="cantidad" placeholder="Cantidad" value="0">
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 " style="display: none;">
					<div class="form-group">
						<label for="cantidad2">Cantidad</label>
						<input type="number" class="form-control" id="cantidad2" placeholder="Cantidad" value="0">
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="fecha">Fecha de Pago</label>
						<input type="date" class="form-control" id="fecha" placeholder="Fecha de Pago">
					</div>
				</div>
				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="peso">Peso</label>
						<?php if($peso[0]->kg_temp>0){ ?>
							<input type="number" class="form-control" id="peso" name="peso" min="0" placeholder="Peso" value="<?php echo $peso[0]->kg_temp; ?>">
						<?php } else{ ?>
							<input type="number" class="form-control" id="peso" name="peso" min="0" placeholder="Peso" value="">
						<?php } ?>

					</div>
				</div>

				<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
					<div class="form-group">
						<label for="tipopeso">Peso en</label>
						<select class="selectpicker form-control" id="tipopeso" name="tipopeso" data-live-search="true">
							<?php
								$kg="";$lbs="";
								if($peso[0]->tipopeso_temp==1){$kg="selected";}else{$lbs="selected";} ?>
								<option value='1' <?php echo $kg; ?>  >Kilogramos</option>
								<option value='2' <?php echo $lbs; ?>  >Libras</option>
						</select>
					</div>
				</div>

			</div>

			<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
				<div class="form-group">
					<label id="conversion">Peso Mexicano</label>
				</div>
			</div>
			<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12">
				<?php if(sizeof($pagos)>0){ ?>
				<table class="table "  id="DataTable" style="max-width: 100%;width: 100%;" >
					<thead>
						<!--<th>Usuario</th>-->
						<th  class="tableTh">Referencia</th>
						<th class="tableTh">Cantidad</th>
						<th class="tableTh">Fecha</th>
						<th class="tableTh">Acciones</th>
					</thead>
					<tbody>
						<?php
							foreach ($pagos as $pago) {
						?>
							<tr>
								<!--<td>
									<?php echo $pago->usuario; ?>
								</td>-->
								<td  class="tableTd">
									<?php echo $pago->referencia; ?>
								</td>
								<td  class="tableTd">
									<?php echo $pago->cantidad; ?>
								</td>
								<td  class="tableTd">
									<?php echo $pago->fecha; ?>
								</td>
								<td  class="tableTd">
									<!-- 4 es cuando solo se ha agregado el pago y no ha sido conciliado -->
									<!-- 3 ya ha sido conciliado -->
									<!-- 2 enviado al cliente sin cupon -->
									<!-- 1 enviado al cliente con cupon -->

									<?php if($pago->stat == 4){ ?>
										<i class="fa fa-trash fa-lg"  style="color:red" onclick="accionesPagos(<?php echo $pago->id ?>,'cancelar',<?php echo $reserva; ?>);" title="Enviar con Regalo"  ></i>
									<?php }else if($pago->stat == 3){  ?>
										<i class="fa fa-envelope-o fa-lg" data-toggle="modal" onclick="accionesPagos(<?php echo $pago->id ?>,'simple',<?php echo $reserva; ?>);" data-target="#modalReservas1" ></i>

									<?php }else if($pago->stat == 2){  ?>
											<?php if($pago->banco_bp==83){ ?>
												<i class="fa fa-home fa-lg" title="Pagado en Sitio" ></i>
												<i class="fa fa-envelope-o fa-lg" data-toggle="modal" onclick="accionesPagos(<?php echo $pago->id ?>,'simple',<?php echo $reserva; ?>);" data-target="#modalReservas1" ></i>

											<?php }else{ ?>
												<i class="fa fa-gift fa-lg" title="Enviar con Regalo" data-toggle="modal" style="color:#33b5e5" onclick="accionesPagos(<?php echo $pago->id ?>,'regalo',<?php echo $reserva; ?>);" data-target="#modalReservas1" ></i>
											<?php } ?>
									<?php }else if($pago->stat == 1){  ?>
												<i class="fa fa-gift fa-lg" title="Enviado con Regalo" ></i>
									<?php } ?>

								</td>
							</tr>

						<?php
							}
						?>
					</tbody>
				</table>
				<script type="text/javascript">
					$("#DataTable").DataTable({
						"columnDefs": [
						    { "width": "5%", "targets": 0 }
						],
						"paging": false
					});

					function accionesPagos(pago,accion,reserva){
						$.ajax({
						url:'controladores/pagosController.php',
						method: "POST",
				  		data: {
				  			reserva:reserva,
				  			pago:pago,
				  			accion:accion
				  		},
				  		success:function(response){
				  			if(response.includes("ERROR"))
				  				abrir_gritter(response, "No puedes agregar mas pagos" ,"info");
				  			else
				  				abrir_gritter("Correcto", response ,"info");

				  			agregarPago(reserva,cliente);

				  		},
				  		error:function(){

				          abrir_gritter("Error","Error desconocido" ,"danger");
				  		},
				  		statusCode: {
						    404: function() {

				          abrir_gritter("Error","URL NO encontrada" ,"danger");
						    }
						  }
					});
					}
				</script>
			<?php } ?>
			</div>
  	</div>

</div>
<input id="opcion" value="1" type="hidden">

<script type="text/javascript">
	function cambiarOpcion(valor){
		$("#opcion").val(valor);
	}
	$("#moneda").change(function(){
			var valor = $("#moneda	option:selected").text().split("$");
			var nombre = valor[0];
			var valor = valor[1];
			$("#cantidad").val('');
			$("#conversion").html(" " + parseFloat(valor)+ " Pesos Mexicanos equivale a 1 " + nombre.replace('(',"") );
	});
	$("#cantidad").change(function(){
		var moneda = $("#moneda	option:selected").text().split("$");
		var nombre = moneda[0];
		var valor = parseFloat(moneda[1]).toFixed(2);
		var cantidad =parseFloat(this.value).toFixed(2);
		var cantidad2 =parseFloat(this.value);
		var nuevoValor = 0;
		nuevoValor = ( cantidad*  valor);
		$("#conversion").html(cantidad + " "+ nombre.replace("(","") + " equivale a " +parseFloat(nuevoValor).toFixed(2)  +" Pesos Mexicanos ");
	});
	date = new Date();
	var primerDia = new Date(date.getFullYear(), date.getMonth(), 1);
	var ultimoDia = new Date(date.getFullYear(), date.getMonth() + 1, 0);

	var currentDate = new Date();
	var wrong="";
	var dia = currentDate.getDate();
	var mes = currentDate.getMonth()+1; //Be careful! January is 0 not 1
	var year = currentDate.getFullYear();

	if(dia < 10){
		dia = "0"+dia;
	}

	if(mes < 10){
		mes = "0"+mes;
	}
	var fecha = year + "-" + (mes) + "-" + (dia);
	$("#fecha").attr("max",fecha)
</script>
