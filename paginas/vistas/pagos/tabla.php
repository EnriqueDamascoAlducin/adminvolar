<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "nombre_extra as tipoGasto, id_gasto as id,referencia_gasto as referencia,fecha_gasto as fecha";
	$tabla = "gastos_volar gv INNER JOIN extras_volar ev on tipo_gasto=id_extra  ";
	$filtro = "gv.status<>0 order by fecha_gasto desc limit 100";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	$gastos=$con->consulta($campos,$tabla,$filtro);	
?>
<table class=" table table-striped table-bordered table-hover" id="dataTable">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Referencia</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Tipo de Gasto</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Fecha de Gasto</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($gastos as $gasto) {
		?>
			<tr>
				<td><?php echo $gasto->referencia; ?></td>
				<td><?php echo $gasto->tipoGasto; ?></td>
				<td><?php echo $gasto->fecha; ?></td>
				<td>
					
					<!--========       Eliminar     ========= -->
					<?php if( in_array("VER", $permisos)){ ?>
						<i class="fa fa-eye fa-md" style="color:#0099CC" title="Ver" data-toggle="modal" data-target="#modal"  onclick="accionGastos('ver', <?php echo $gasto->id; ?>)" ></i>
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
        "order": [[ 2, "desc" ]]
		
	});
</script>