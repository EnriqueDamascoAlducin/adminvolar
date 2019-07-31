<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	
	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$puestos = $con->consulta("nombre_puesto as nombre, id_puesto ","puestos_volar","status<>0 and depto_puesto=".$_POST['id']);
	$idUsu=$_POST['id'];

	
?>
	<?php if(sizeof($puestos)>0){ ?>
		<table class="table DataTable" >
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
							echo '<td><i class="fa fa-trash fa-lg" data-toggle="modal" data-target="#modal2"  style="color:red"></i></td>';
						echo "</tr>";
					}
				?>
			</tbody>
		</table>
	<?php } ?>




<script type="text/javascript">
	tables();
</script>