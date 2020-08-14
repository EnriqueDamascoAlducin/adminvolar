<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "nombre_depto as nombre, id_depto as id";
	$tabla = "departamentos_volar  ";
	$filtro = "status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	$deptos=$con->consulta($campos,$tabla,$filtro);	
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($deptos as $depto) {
		?>
			<tr>
				<td><?php echo $depto->nombre; ?></td>
				<td>
					<?php if( in_array("EDITAR", $permisos)){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar" data-toggle="modal" data-target="#modal"  onclick="accionDeptos('editar', <?php echo $depto->id; ?>)"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modal"  onclick="eliminarDepto( <?php echo $depto->id; ?>,'<?php echo $depto->nombre;  ?>')" ></i>
					<?php } ?>
					<?php if( in_array("PUESTOS", $permisos)){ ?>
						<i class="fa fa-th-list fa-md" style="color:#aa66cc" title="PUESTOS" data-toggle="modal" data-target="#modal"  onclick="agregarPuestos(<?php echo $depto->id; ?>,'<?php echo $depto->nombre ?>')"></i>
					<?php } ?>
				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>


<script type="text/javascript">
	tables(0,"asc");
</script>