<?php
	$usuarios =$con->consulta("CONCAT(IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","status<>0");
	$departamentos= $con->consulta("nombre_depto as text, id_depto as value","departamentos_volar","status=1");
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


	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 " >
		<button type="button" class="btn btn-info" onclick="cargarTabla()"><i class="fa fa-search" ></i></button>
		<?php
			if(in_array("REPORTES", $permisos)){
		?>
				<a id="imprimirReporteVtas" download target="_NEW"> <button type="button" class="btn btn-success" onclick="imprimirReporteVentas()"><i class="fa fa-file-excel-o "></i></button></a>
		<?php
			}
		?>
	</div>
</div>
