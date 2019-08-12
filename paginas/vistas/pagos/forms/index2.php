<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$puestos = $con->consulta("nombre_puesto as nombre, id_puesto as id","puestos_volar","status<>0 and depto_puesto=".$_POST['id']);
	$depto=$_POST['id'];
	/*
		data-toggle="modal" data-target="#modal2" para hacer confimaciones
	*/
	$nombre=$_POST['nombre'];
?>
<div class="row">
	<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
		<div class="form-group">
			<label for="puesto">Puesto</label>
			<input type="text" class="form-control" id="puesto" placeholder="Puesto">
		</div>
	</div>
	<input type="hidden" id="idPuesto">
	<input type="hidden" id="depto" value="<?php echo $depto ?>">
</div>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
	<?php if(sizeof($puestos)>0){ ?>
		<table id="DataTable"class="table   table-striped table-bordered table-hover" >
			<thead>
				<tr>
					<th>Puesto</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
				<?php 
					foreach ($puestos as $puesto) {
						echo "<tr>";
							echo '<td>'.$puesto->nombre.'</td>';
							echo '<td><i class="fa fa-trash fa-lg" onclick= "accionesPuesto('. $puesto->id .',\'eliminarPuesto\',\''.$nombre.'\','.$depto.')" style="color:red"></i>
							<i class="fa fa-cog fa-lg" onclick="accionesPuesto('. $puesto->id .',\'actualizarPuesto\',\''.$nombre.'\','.$depto.')"   style="color:#33b5e5"></i></td>';
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