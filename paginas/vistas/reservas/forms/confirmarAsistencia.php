<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	

	$globos = $con->consulta("nombre_globo as text, id_globo as value","globos_volar","status<>0");
	$pilotos = $con->consulta("CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, idusu as value","volar_usuarios","status<>0 and puesto = 4");
?>

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="hora">Hora de Vuelo</label>
			<input type="time" class="form-control" id="hora" placeholder="Hora de Vuelo">
		</div>
	</div>

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="piloto">Piloto</label>
			<select class="selectpicker form-control" id="piloto" name="piloto" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($pilotos as $piloto) {
						echo "<option value='".$piloto->value."'>".$piloto->text."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="globo">globos</label>
			<select class="selectpicker form-control" id="globo" name="globo" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($globos as $globo) {
						echo "<option value='".$globo->value."'>".$globo->text."</option>";
					}
				?>
				
			</select>
		</div>
	</div>