<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "clave_souvenir,nombre_souvenir,id_souvenir,precio_souvenir";
	$tabla = " souvenirs_volar";
	$filtro = "status<>0 ";

	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
		$filtro.= " and fecha_gasto >='".$_POST['fechaI']."'";
	}
	if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
		$filtro.= " and fecha_gasto <='".$_POST['fechaF']."'";
	}
	if(isset($_POST['cond']) && $_POST['cond']!='' ){
		$filtro.= " and condicion_cliente = ".$_POST['cond'];
	}
	//echo "SELECT $campos FROM $tabla WHERE $filtro"; die();
	$souvenirs=$con->consulta($campos,$tabla,$filtro);
?>
<table class=" table table-striped table-bordered table-hover" id="dataTable">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Clave</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Precio</th>

			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($souvenirs as $souvenir) {
		?>
			<tr>
				<td><?php echo $souvenir->clave_souvenir; ?></td>
				<td><?php echo $souvenir->nombre_souvenir; ?></td>
				<td><?php echo $souvenir->precio_souvenir; ?></td>
				<td>
					<?php if( in_array("EDITAR", $permisos) ){ ?>
						<i class="fa fa-pencil-square fa-md"  data-toggle="modal" data-target="#modal" style="color:#33b5e5" title="Editar"  onclick="accion('editar','<?php echo $souvenir->id_souvenir; ?>')"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos) ){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar"   onclick="eliminarSouvenir( <?php echo $souvenir->id_souvenir; ?>,'<?php echo $souvenir->nombre_souvenir;  ?>')" ></i>
					<?php } ?>
				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>


<script type="text/javascript">
	$("#dataTable").DataTable().destroy();
	$("#dataTable").DataTable({
		"autoWidth": true,
		"scrollX": true,
		"searching": true,
		"lengthChange":true,
        "order": [[ 0, "asc" ]]

	});
</script>
