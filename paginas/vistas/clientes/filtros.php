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
			<label for="cond">Condiciones</label>
			<select class="form-control" name="cond" id="cond">
				<option value="">Selecciona una Opción </option>
				<option value="1">Crédito</option>
				<option value="2">Contado</option>
			</select>
		</div>
	</div>



	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 " >
		<button type="button" class="btn btn-info" onclick="cargarTabla()"><i class="fa fa-search" ></i></button>
		<?php
			if(in_array("REPORTES", $permisos)){
		?>
				<a id="imprimirReporte" download target="_NEW"> <button type="button" class="btn btn-success" onclick="imprimirReporte()"><i class="fa fa-file-excel-o "></i></button></a>
		<?php
			}
		?>
	</div>
</div>
