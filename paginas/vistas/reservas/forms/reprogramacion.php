<?php
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
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

<div class="row">


	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="motivo">Motivo</label>
			<select class="selectpicker form-control" id="motivo" name="motivo" data-live-search="true">
					<option value='1'   >Solicitado por Cliente</option>
					<option value='2'   >Solicitado por la Empresa</option>
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="fechavuelo">Fecha de Vuelo</label>
			<input type="date" class="form-control" id="fechavuelo" value="">
		</div>
	</div>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="motivo">Aplica Cargo Adicional?</label>
				<select class="selectpicker form-control" id="motivo" name="motivo" data-live-search="true">
						<option value='0'   >0</option>
					<?php for ($i=0; $i <=35 ; $i+5) { ?>
						<option value='<?php echo $i; ?>'   ><?php echo $i .'%'; ?></option>
						// code...
				 <?php	} ?>
				</select>
			</div>
		</div>


</div>

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
		$("#fechavuelo").attr("min",fecha)
</script>
