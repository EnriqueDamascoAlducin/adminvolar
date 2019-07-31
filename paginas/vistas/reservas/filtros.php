<?php 
	$empleados = $con->consulta("CONCAT( IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","id_usu in (Select DISTINCT(idusu_temp) from temp_volar where status<>0) and status<>0 ");
	$reservas = $con->consulta("DISTINCT(status) as status","temp_volar","status<>0");
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
	<!--
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="cliente">Cliente</label>
			<select class="selectpicker form-control" id="cliente" name="cliente" data-live-search="true">
				<option value='0'>Todos...</option>
				
			</select>
		</div>
	</div>
	-->
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="status">Estatus</label>
			<select class="selectpicker form-control" id="status" name="status" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php 
					foreach ($reservas as $reserva) {
						
					
						if( $reserva->status ==4){
							$text="Confirmada";
							$class="#33b5e5";
						}else if($reserva->status==2){
							$text="Sin Cotización";
							$class="#ff4444";
						}else if($reserva->status==3){
							$text="Pendiente de Pago";
							$class="#ffbb33";
						}else if($reserva->status==1){
							$text="Terminado";
							$class="#00C851";
						}else if($reserva->status==5){
							$text="Esperando Autorización";
							$class="#00C851";
						}else if($reserva->status==6){
							$text="C. por Reemplazo ";
							$class="#ffbb33";
						}else{
							$text="Otro";
							$class="#ff4444";
						}
						echo "<option value='".$reserva->status."' style='color:".$class."' > <label class='badge badge-warning'>".$text."</label></option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<?php if(in_array("GENERAL",$permisos)){ ?>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="empleado">Empleado</label>
			<select class="selectpicker form-control" id="empleado" name="empleado" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($empleados as $empleado) {
						echo "<option value='".$empleado->value."'>".$empleado->text."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<?php } ?>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="reserva"># de Reserva</label>
			<input type="number" class="form-control" id="reserva" placeholder="Fecha de Inicio">
		</div>
	</div>

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 " >
		<button type="button" class="btn btn-info" onclick="cargarTablaReservas()"><i class="fa fa-search" ></i></button>
		<?php 
			if(in_array("REPORTES", $permisos)){
		?>
				<a id="imprimirReporte" download target="_NEW"> <button type="button" class="btn btn-success" onclick="imprimirReporte()"><i class="fa fa-file-excel-o "></i></button></a>
		<?php
			}
		?>
	</div>
</div>

