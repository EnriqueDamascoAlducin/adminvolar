<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "id_venta as id, comentario_venta comentario,register as fecha ";
	$tabla = "ventas_volar  ";
	$filtro = "status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	$ventas=$con->consulta($campos,$tabla,$filtro);	
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Comentario</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Fecha</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($ventas as $venta) {
		?>
			<tr>
				<td><?php echo $venta->comentario; ?></td>
				<td><?php echo $venta->fecha; ?></td>
				<td>
					<?php if( in_array("EDITAR", $permisos)){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar" data-toggle="modal" data-target="#modal"  onclick="accionDeptos('editar', <?php echo $venta->id; ?>)"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modal"  onclick="eliminarGlobo( <?php echo $venta->id; ?>,'<?php echo $venta->comentario;  ?>')" ></i>
					<?php } ?>
				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>


<script type="text/javascript">
	tables();
</script>