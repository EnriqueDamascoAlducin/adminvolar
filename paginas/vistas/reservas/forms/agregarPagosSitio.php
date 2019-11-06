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
	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
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

	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
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

	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 " style="display:none" id="divComision">
		<div class="form-group">
			<label for="comision">Comisión %</label>
			<input type="number" class="form-control" onchange="modificarPrecio()" id="comision" placeholder="%" value="0">
		</div>
	</div>

	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 " id="divCupon" style="display:none" >
		<div class="form-group">
			<label for="cupon">Aplica Cupón?</label>
			<select class="form-control" name="cupon" id="cupon">
				<option value="">No</option>
				<option value="1">5% en Efectivo</option>
				<option value="2">10% en Souvenirs</option>
			</select>
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 " style="display:none">
		<div class="form-group">
			<label for="referencia">Referencia</label>
			<input type="hidden"  class="form-control" id="referencia" placeholder="Referencia" value="Pago en Sitio">
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
		<div class="form-group">
			<label for="cantidad">Cantidad</label>
			<input type="number" class="form-control" id="cantidad" onchange="modificarPrecio()" placeholder="Cantidad" value="<?php echo 	$total[0]->cotizado -  $total[0]->pagado  ;?>">
		</div>
	</div>

	<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 " style="display:none">
		<div class="form-group">
			<label for="fecha">Fecha de Pago</label>
			<input type="date" readonly class="form-control" id="fecha" placeholder="Fecha de Pago">
		</div>
	</div>
	<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
		<label >Total  por Pagar: <span id="spanCant">$ <?php echo 	number_format($total[0]->cotizado -  $total[0]->pagado  , 2, '.', ',') ;?></span></label>
	</div>
</div>
<script type="text/javascript">
	var precioRestante  =  <?php echo ($total[0]->cotizado -  $total[0]->pagado ) ?>;
	$("#cupon").on("change",function(){
		modificarPrecio();
	});

	$("#comision").on("change",function(){
		modificarPrecio();
	});
	$("#metodo").on("change",function(){
		$("#comision").val(0);
		$("#divComision").hide();
		$("#cupon").val('');
		$("#divCupon").hide();
		$("#cantidad").removeAttr("disabled").val(precioRestante);
		if($(this).val()==98){
			$("#divComision").show();
			$("#comision").val(4);
		}else if($(this).val()==60){
			$("#divCupon").show();
		}
				modificarPrecio();
	});
	function modificarPrecio(){
		metodo = $("#metodo").val();
		cupon = 	$("#cupon").val();
		if(cupon!=''){
			$("#spanCant").html(" $ "+new Intl.NumberFormat().format(precioRestante ));
			if(metodo==98){
				var comision = $("#comision").val();
				if(comision==''){
					comision=0;
				}
				var cantidad = $("#cantidad").val();
				if(cantidad==''){
					cantidad = 0;
				}
				nuevoValor = parseInt(cantidad) + ((parseInt(cantidad) * parseInt(comision))/100);
				$("#spanCant").html("$ "+new Intl.NumberFormat().format(nuevoValor  ));
			}else if(metodo==60){
				if(cupon==""){
					$("#cantidad").val(precioRestante).prop("disabled",false);
				}else if(cupon==1){
						regreso = (precioRestante*.05);
						$("#cantidad").val(precioRestante-regreso).prop("disabled","disabled");
						$("#spanCant").html("$ "+new Intl.NumberFormat().format(precioRestante  )+".<br>Regresar $ "+new Intl.NumberFormat().format(parseInt(regreso) ) +"<br> Cobrar:  $ "+new Intl.NumberFormat().format(precioRestante-regreso  ));
				}else if(cupon==2){
						$("#cantidad").val(precioRestante).prop("disabled","disabled");
						regreso = (precioRestante*.1);
						$("#spanCant").html("$ "+new Intl.NumberFormat().format(precioRestante )+".<br>Vale por  $ "+new Intl.NumberFormat().format(regreso ));
				}
			}
		}
	}

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
