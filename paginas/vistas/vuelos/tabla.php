<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "nombre_vc,nombre_extra,precioa_vc,precion_vc";
	$tabla = " vueloscat_volar vcv INNER JOIN extras_volar on tipo_vc = id_extra ";
	$filtro = " vcv.status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	$vuelos=$con->consulta($campos,$tabla,$filtro);	
?>
<table class=" table table-striped table-bordered table-hover" id="dataTable">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Tipo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Precio Adulto</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Precio Niño</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($vuelos as $vuelo) {
		?>
			<tr>
				<td><?php echo $vuelo->nombre_vc; ?></td>
				<td><?php echo $vuelo->nombre_extra; ?></td>
				<td><?php echo $vuelo->precioa_vc; ?></td>
				<td><?php echo $vuelo->precion_vc; ?></td>
				<td>
					
					<!--========       Eliminar     ========= -->
					
					<?php if( in_array("EDITAR", $permisos)){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar"  onclick="accionusuarios('editar', <?php echo $usuarios->id; ?>)"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modal"  onclick="eliminarusuarios( <?php echo $usuarios->id; ?>,'<?php echo $usuarios->nombre;  ?>')" ></i>
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
	$("#dataTable").DataTable();
</script>