<?php
	$empleados = $con->consulta("CONCAT( IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","id_usu in (Select DISTINCT(idusu_temp) from temp_volar where status<>0) and status<>0 ");

?>
<div class="row">
	<?php if ($idUsu==1){?>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
			<div class="form-group">
				<label for="fechaI">Fecha de Inicio</label>
				<input type="date" class="form-control" id="fechaI" placeholder="Fecha de Inicio" value="<?php if(isset($_SESSION['filtros']['fechaI'])){echo $_SESSION['filtros']['fechaI']  ;} ?>">
			</div>
		</div>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
			<div class="form-group">
				<label for="fechaF">Fecha de Final</label>
				<input type="date" class="form-control" id="fechaF" placeholder="Fecha Final" value="<?php if(isset($_SESSION['filtros']['fechaF'])){echo $_SESSION['filtros']['fechaF']  ;} ?>">
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
							$sel="";
							if($empleado->value==$idUsu){
								$sel = "selected";
							}
							if(isset($_SESSION['filtros']['empleado']) && $_SESSION['filtros']['empleado'] == $empleado->value ){
								$sel = "selected";
							}
							echo "<option value='".$empleado->value."' ". $sel .">".$empleado->text."</option>";
						}
					?>

				</select>
			</div>
		</div>
		<?php } ?>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
			<div class="form-group">
				<label for="reserva"># de Reserva</label>
				<input type="number" class="form-control" id="reserva" placeholder="# de Reserva" value="<?php if(isset($_SESSION['filtros']['reserva'])){echo $_SESSION['filtros']['reserva']  ;} ?>">
			</div>
		</div>
	<?php } ?>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 " >
		<button type="button" class="btn btn-info" onclick="cargarTabla()"><i class="fa fa-search" ></i></button>

		<?php
			if(in_array("CORREO", $permisos)){
		?>
				<button type="button" class="btn btn-primary" onclick="asignarGlobos()"><i class="fa fa-envelope-o fa-lg "></i></button>
		<?php
			}
		?>
	</div>
</div>
