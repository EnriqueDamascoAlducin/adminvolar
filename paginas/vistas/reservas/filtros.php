<?php 
	
?>
<div class="row">
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="fechaI">Fecha de Inicio</label>
			<input type="date" class="form-control" id="fechaI" placeholder="Fecha de Inicio">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="fechaF">Fecha de Final</label>
			<input type="date" class="form-control" id="fechaF" placeholder="Fecha Final">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="cliente">Cliente</label>
			<select class="selectpicker form-control" id="cliente" name="cliente" data-live-search="true">
				<option value='0'>Todos...</option>
				
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="status">Estatus</label>
			<select class="selectpicker form-control" id="status" name="status" data-live-search="true">
				<option value='0'>Todos...</option>
				
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="empleado">Empleado</label>
			<select class="selectpicker form-control" id="empleado" name="empleado" data-live-search="true">
				<option value='0'>Todos...</option>
				
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="reserva"># de Reserva</label>
			<input type="number" class="form-control" id="reserva" placeholder="Fecha de Inicio">
		</div>
	</div>

	<div class="col-sm-3 col-lg-3 col-md-3 col-12 col-xl-2 ">
		<button type="button" class="btn btn-info"><i class="fa fa-search"></i></button>
		<?php 
			if(in_array("REPORTES", $permisos)){
		?>
				<button type="button" class="btn btn-success"><i class="fa fa-file-excel-o "></i></button>
		<?php
			}
		?>
	</div>
</div>

