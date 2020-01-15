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

	$monedas = $con->consulta("nombre_extra as nombre, abrev_extra as cantidad, id_extra as id","extras_volar","clasificacion_extra ='monedas' and status<>0");
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
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
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

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 " style="display:none" id="divComision">
		<div class="form-group">
			<label for="comision">Comisión %</label>
			<input type="number" class="form-control" onchange="modificarPrecio()" id="comision" placeholder="%" value="0">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 " id="divCupon" style="display:none" >
		<div class="form-group">
			<label for="cupon">Aplica Cupón?</label>
			<select class="form-control" name="cupon" id="cupon">
				<option value="">No</option>
				<option value="1">5% en Efectivo</option>
				<option value="2">10% en Souvenirs</option>
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 " style="display:none">
		<div class="form-group">
			<label for="referencia">Referencia</label>
			<input type="hidden"  class="form-control" id="referencia" placeholder="Referencia" value="Pago en Sitio">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
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
<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
	<div class="form-group">
		<label id="conversion">Peso Mexicano</label>
	</div>
</div>

	<input type="number" class="form-control" id="cantidad2"  placeholder="Cantidad" value="<?php echo 	$total[0]->cotizado -  $total[0]->pagado  ;?>" style="display: none">
<script type="text/javascript">
	
	var precioRestante  =  <?php echo ($total[0]->cotizado -  $total[0]->pagado ) ?>;
	var precioRestanteOriginal  =  <?php echo ($total[0]->cotizado -  $total[0]->pagado ) ?>;
	$("#moneda").change(function(){
			var valor = $("#moneda	option:selected").text().split("$");
			var nombre = valor[0];
			var valor = valor[1];
			$("#conversion").html(" " + parseFloat(valor)+ " Pesos Mexicanos equivale a 1 " + nombre.replace('(',"") );
			precioRestante =parseFloat(precioRestanteOriginal / parseFloat(valor)) ;
			precioRestante2 = parseFloat(precioRestanteOriginal / parseFloat(valor).toFixed(2)).toFixed(2) ;
			$("#cantidad").val(precioRestante2).removeAttr("disabled");
			$("#cantidad2").val(precioRestante).removeAttr("disabled");
			$("#cupon").val('');
	});

	function confirmaragregarPagoSitio(reserva,cliente){
		metodo=$("#metodo").val();
		banco=$("#banco").val();
		referencia=$("#referencia").val().trim();
		cantidad=$("#cantidad2").val().trim();
		fecha=$("#fecha").val().trim();
		comision=$("#comision").val().trim();
		cupon=$("#cupon").val();
		moneda=$("#moneda").val();
		var monedaInfo = $("#moneda	option:selected").text().split("$");
		monedaPrecio =  parseFloat(monedaInfo[1]).toFixed(2);
		if(cantidad=="" ){
			abrir_gritter("Advertencia","Debe Capturar una cantidad","warning");
			return false;
		}
		cantidad = parseFloat(cantidad * monedaPrecio);
		datos={
				reserva:reserva,
				metodo:metodo,
				banco:banco,
				referencia:referencia,
				cantidad:cantidad,
				comision:comision,
				fecha:fecha,
				cupon:cupon,
				moneda:moneda,
				monedaPrecio:monedaPrecio,
				accion:'registrarPagoSitio'
		};
		$.ajax({
			url:'controladores/pagosController.php',
			method: "POST",
			data: datos,
			success:function(response){

				if(response.includes("ERROR"))
					abrir_gritter(response, "No puedes agregar mas pagos" ,"warning");
				else
					abrir_gritter("Correcto", response ,"info");
				cargarTablaReservas();
				agregarPagoSitio(reserva,cliente);

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

			cambiarTamanoModal("modalSize","lg",'resetear');
	}
</script>
<script type="text/javascript">
	var precioRestante  =  <?php echo ($total[0]->cotizado -  $total[0]->pagado ) ?>;
	var precioRestanteOriginal  =  <?php echo ($total[0]->cotizado -  $total[0]->pagado ) ?>;
	$("#cantidad").change(function(){
		var moneda = $("#moneda	option:selected").text().split("$");
		var nombre = moneda[0];
		var valor = parseFloat(moneda[1]).toFixed(2);
		var cantidad =parseFloat(this.value).toFixed(2);
		var nuevoValor = 0;
		nuevoValor = ( cantidad*  valor);
		$("#conversion").html(cantidad + " "+ nombre.replace("(","") + " equivale a " +parseFloat(nuevoValor).toFixed(2)  +" Pesos Mexicanos ");
	});

	$("#cupon").on("change",function(){
		modificarPrecio();
	});

	$("#comision").on("change",function(){
		modificarPrecio();
	});
	$("#metodo").on("change",function(){
		$("#conversion").html("");
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
		cantidad = 	$("#cantidad").val();
		$("#cantidad2").val(cantidad);
			$("#spanCant").html(" $ "+new Intl.NumberFormat().format(cantidad ));
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
					$("#cantidad").prop("disabled",false);
					$("#cantidad2").prop("disabled",false);
				}else if(cupon==1){
						regreso = (precioRestante*.05);
						$("#cantidad").val(precioRestante-regreso).prop("disabled","disabled");
						$("#cantidad2").val(precioRestante-regreso).prop("disabled","disabled");
						$("#spanCant").html("$ "+new Intl.NumberFormat().format(precioRestante  )+".<br>Regresar $ "+new Intl.NumberFormat().format(parseInt(regreso) ) +"<br> Cobrar:  $ "+new Intl.NumberFormat().format(precioRestante-regreso  ));
				}else if(cupon==2){
						$("#cantidad").val(precioRestante).prop("disabled","disabled");
						$("#cantidad2").val(precioRestante).prop("disabled","disabled");
						regreso = (precioRestante*.1);
						$("#spanCant").html("$ "+new Intl.NumberFormat().format(precioRestante )+".<br>Vale por  $ "+new Intl.NumberFormat().format(regreso ));
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
