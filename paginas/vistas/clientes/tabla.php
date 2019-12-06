<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "id_cliente, rs_cliente as rs, rfc_cliente as rfc, telefono_cliente as telefono, calle_cliente as calle, IFNULL(noint_cliente,'') as noint, IFNULL(noext_cliente,'') as noext , colonia_cliente as colonia, nombre_estado as estado, nombre_pais as pais, IFNULL(cp_cliente,'') as cp, IFNULL(municipio_cliente,'') as municipio";
	$tabla = " clientes_volar cv INNER JOIN paises_volar pv ON pais_cliente = id_pais INNER JOIN estados_volar ON id_estado = estado_cliente ";
	$filtro = "cv.status<>0 ";

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
	$clientes=$con->consulta($campos,$tabla,$filtro);
?>
<table class=" table table-striped table-bordered table-hover" id="dataTable">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">No. Cliente</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Razón Social/Nombre</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Teléfono</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Dirección</th>

			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($clientes as $cliente) {
		?>
			<tr>
				<td><?php echo $cliente->id_cliente; ?></td>
				<td><?php echo $cliente->rs; ?></td>
				<td><?php echo $cliente->telefono; ?></td>
				<td>
					<?php
					echo $cliente->calle. " ". $cliente->noint. ", ".  $cliente->noext . " " .$cliente->colonia. " ". $cliente->estado . ", ".$cliente->pais ;
					?>
				</td>
				<td>
					<?php if( in_array("EDITAR", $permisos) ){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar"  onclick="accion('editar','<?php echo $cliente->id_cliente; ?>')"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos) ){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar"   onclick="eliminarCliente( <?php echo $cliente->id_cliente; ?>,'<?php echo $cliente->rs;  ?>')" ></i>
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
