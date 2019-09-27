<?php
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
	$metodos = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='metodopago' ");
	$cuentas = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='cuentasvolar' and id_extra=83");
	$total = $con->consulta(" SUM(cantidad_bp) as pagado, total_temp as cotizado","bitpagos_volar bitp INNER JOIN temp_volar t on idres_bp = id_temp"," bitp.status in (1,2) and idres_bp=".$reserva);
	$pagos = $con->consulta("CONCAT(nombre_usu,' ',apellidop_usu) as usuario, referencia_bp as referencia, cantidad_bp as cantidad,fecha_bp as fecha, bp.status as stat,id_bp as id","bitpagos_volar bp INNER JOIN volar_usuarios vu  ON bp.idreg_bp=vu.id_usu","bp.status<>0 and idres_bp=".$reserva);
?>
<div class="row">
  <div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="referencia">Total Pagado: <?php echo '$ '.number_format($total[0]->pagado, 2, '.', ','); ?></label>
		</div>
	</div>
	  <div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="referencia">Cotizado: <?php echo '$ '.number_format($total[0]->cotizado, 2, '.', ','); ?></label>
			</div>
		</div>
</div>
<div class="row">
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="metodo">Metodo</label>
			<select class="selectpicker form-control" id="metodo" name="metodo" data-live-search="true">
				<?php
					foreach ($metodos as $metodo) {
						echo "<option value='".$metodo->value."' >".$metodo->text."</option>";
					}
				?>

			</select>
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="banco">Banco</label>
			<select class="selectpicker form-control" id="banco" name="banco" data-live-search="true">
				<?php
					foreach ($cuentas as $cuenta) {
						echo "<option selected value='".$cuenta->value."'>".$cuenta->text."</option>";
					}
				?>

			</select>
		</div>
	</div>

	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " style="display:none">
		<div class="form-group">
			<label for="referencia">Referencia</label>
			<input type="hidden"  class="form-control" id="referencia" placeholder="Referencia" value="Pago en Sitio">
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="cantidad">Cantidad</label>
			<input type="number" class="form-control" id="cantidad" placeholder="Cantidad" value="<?php echo $total[0]->cotizado -  $total[0]->pagado  ?>">
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " style="display:none">
		<div class="form-group">
			<label for="fecha">Fecha de Pago</label>
			<input type="date" readonly class="form-control" id="fecha" placeholder="Fecha de Pago">
		</div>
	</div>
</div>
<?php if(sizeof($pagos)>0){ ?>

	<script type="text/javascript">
		$("#DataTable").DataTable();

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
		var mes = currentDate.getMonth()+1; //Be careful! January is 0 not 1
		var year = currentDate.getFullYear();

		if(dia < 10){
			dia = "0"+dia;
		}

		if(mes < 10){
			mes = "0"+mes;
		}
		var fecha = year + "-" + (mes) + "-" + (dia);
		$("#fecha").val(fecha)
</script>
