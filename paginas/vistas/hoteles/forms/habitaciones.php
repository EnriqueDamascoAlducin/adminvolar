<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$habitaciones = $con->consulta("nombre_habitacion as nombre, id_habitacion as id,precio_habitacion as precio","habitaciones_volar","status<>0 and idhotel_habitacion=".$_POST['id']);
	$hotel=$_POST['id'];
	$nombre=$_POST['nombre'];
	if($_POST['habitacion']!=''){
		$habitacionAct = $con->consulta("nombre_habitacion as nombre, id_habitacion as id,precio_habitacion as precio","habitaciones_volar","status<>0 and id_habitacion=".$_POST['habitacion']);

	}
	/*
		data-toggle="modal" data-target="#modal2" para hacer confimaciones
	*/
?>
<div class="row">
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="nombre">Nombre</label>
			<input type="text" class="form-control" id="nombre"  name ="nombre" placeholder="Nombre">
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="precio">Precio</label>
			<input type="number" class="form-control" id="precio" onkeypress="return isNumber(event)" name ="precio" placeholder="Precio">
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="capacidad">Capacidad</label>
			<input type="number" class="form-control" onkeypress="return isNumberPositiveInt(event);" id="capacidad"  name ="capacidad" placeholder="Capacidad de Personas">
		</div>
	</div>
	<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
		<div class="form-group">
			<label for="descripcion">Descripción</label>
			<textarea class="form-group" id="descripcion" name="descripcion" style="border-color: black;border-width: 1px;border-style: dotted; ;width: 100%"  ></textarea>
		</div>
	</div>
	<input type="hidden" id="idHabitacion" value="">
	<input type="hidden" id="hotel" value="<?php echo $hotel; ?>">
	<input type="hidden" id="accion" value="agregar">
</div>
	
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
	<?php if(sizeof($habitaciones)>0){ ?>
		<table id="DataTable"class="table   table-striped table-bordered table-hover" >
			<thead>
				<tr>
					<th>Habitación</th>
					<th>Precio</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
				<?php 
					foreach ($habitaciones as $habitacion) {
						echo "<tr>";
							echo '<td>'.$habitacion->nombre.'</td>';
							echo '<td>'.$habitacion->precio.'</td>';
							echo '<td><i class="fa fa-trash fa-lg" onclick= "eliminarHabitacion('. $habitacion->id .',\'eliminarPuesto\',\''.$nombre.'\','.$hotel.')" style="color:red"></i>
							<i class="fa fa-cog fa-lg" onclick="modificarHabitacion('. $habitacion->id .',\'actualizarPuesto\',\''.$nombre.'\','.$hotel.')"   style="color:#33b5e5"></i></td>';
						echo "</tr>";
					}
				?>
			</tbody>
		</table>
	<?php } ?>
</div>


<script type="text/javascript">

	$("#DataTable").DataTable();
</script>