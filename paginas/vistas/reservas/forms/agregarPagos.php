<?php 
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
	$metodos = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='metodopago'");
	$cuentas = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='cuentasvolar'");

	$pagos = $con->consulta("CONCAT(nombre_usu,' ',apellidop_usu) as usuario, referencia_bp as referencia, cantidad_bp as cantidad,fecha_bp as fecha, bp.status as stat,id_bp as id","bitpagos_volar bp INNER JOIN volar_usuarios vu  ON bp.idreg_bp=vu.id_usu","bp.status<>0 and idres_bp=".$reserva);
?>
<div class="row">
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="metodo">Metodo</label>
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
			<input type="number" class="form-control" id="cantidad" placeholder="Cantidad">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="fecha">Fecha de Pago</label>
			<input type="date" class="form-control" id="fecha" placeholder="Fecha de Pago">
		</div>
	</div>
</div>
<?php if(sizeof($pagos)>0){ ?>
	<table class="table dataTable" style="width: 100%;">
		<thead>
			<th>Usuario</th>
			<th>Referencia</th>
			<th>Cantidad</th>
			<th>Fecha</th>
			<th>Acciones</th>
		</thead>
		<tbody>
			<?php
				foreach ($pagos as $pago) {
			?>
				<tr>
					<td>
						<?php echo $pago->usuario; ?>
					</td>
					<td>
						<?php echo $pago->referencia; ?>
					</td>
					<td>
						<?php echo $pago->cantidad; ?>
					</td>
					<td>
						<?php echo $pago->fecha; ?>
					</td>
					<td>
						<!-- 4 es cuando solo se ha agregado el pago y no ha sido conciliado -->
						<!-- 3 ya ha sido conciliado -->
						<!-- 2 enviado al cliente sin cupon -->
						<!-- 1 enviado al cliente con cupon -->

						<?php if($pago->stat == 4){ ?>
							<i class="fa fa-trash fa-lg"  style="color:red" onclick="accionesPagos(<?php echo $pago->id ?>,'cancelar',<?php echo $reserva; ?>);" title="Enviar con Regalo"  >
						<?php }else if($pago->stat == 3){  ?>
							<i class="fa fa-envelope-o fa-lg" data-toggle="modal" onclick="accionesPagos(<?php echo $pago->id ?>,'simple',<?php echo $reserva; ?>);" data-target="#modalReservas1" ></i>
							<i class="fa fa-gift fa-lg" title="Enviar con Regalo" data-toggle="modal" style="color:#33b5e5" onclick="accionesPagos(<?php echo $pago->id ?>,'regalo',<?php echo $reserva; ?>);" data-target="#modalReservas1" ></i>
						<?php }else if($pago->stat == 2){  ?>
							<i class="fa fa-envelope fa-lg" title="Enviado con Regalo"  ></i>
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
		tables();

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
<script type="text/javascript">
		date = new Date();
		var primerDia = new Date(date.getFullYear(), date.getMonth(), 1);
		var ultimoDia = new Date(date.getFullYear(), date.getMonth() + 1, 0);
	 
		var currentDate = new Date();
		var wrong="";
		var dia = currentDate.getDate();
		var mes = currentDate.getMonth(); //Be careful! January is 0 not 1
		var year = currentDate.getFullYear();
		dia++;
		if(dia>ultimoDia.getDate()){
			dia=1;
			mes++;
		}
		mes++;
		if(dia < 10){
			dia = "0"+dia;
		}

		if(mes < 10){
			mes = "0"+mes;
		}
		var fecha = year + "-" + (mes) + "-" + (dia);
		$("#fecha").attr("max",fecha)
</script>