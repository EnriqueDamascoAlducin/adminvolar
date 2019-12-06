<?php
	$usuarios =$con->consulta("CONCAT(IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","status<>0 and depto_usu = 4 ");
	$tipos= $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='tipogastos'");
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
			<label for="empleado">Empleados</label>
			<select class="selectpicker form-control" id="empleado" name="empleado" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($usuarios as $usuario) {
						echo "<option value='".$usuario->value."'>".$usuario->text."</option>";
					}
				?>

			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="tipog">Tipos</label>
			<select class="selectpicker form-control" id="tipog" name="tipog" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($tipos as $tipo) {
						echo "<option value='".$tipo->value."'>".$tipo->text."</option>";
					}
				?>

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
