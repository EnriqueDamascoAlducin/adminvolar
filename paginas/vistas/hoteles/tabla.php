<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "id_hotel as id,nombre_hotel as nombre, CONCAT(IFNULL(calle_hotel,''), ' ',IFNULL(noint_hotel,''), ' ',IFNULL(noext_hotel,''), ' ',IFNULL(colonia_hotel,'')) as direccion, CONCAT(IFNULL(telefono_hotel,''),'/',IFNULL(telefono2_hotel,'')) as telefonos, IFNULL(correo_hotel,'') as correo";
	$tabla = " hoteles_volar ";
	$filtro = " status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	$hoteles=$con->consulta($campos,$tabla,$filtro);	
?>
<table class=" table table-striped table-bordered table-hover  DataTable" id="">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Dirección</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Telefonos</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Correo</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($hoteles as $hotel) {
		?>
			<tr>
				<td><?php echo utf8_encode($hotel->nombre); ?></td>
				<td><?php echo utf8_encode($hotel->direccion); ?></td>
				<td><?php echo $hotel->telefonos; ?></td>
				<td><?php echo $hotel->correo; ?></td>
				<td>
					
					<!--========       Eliminar     ========= -->
					
					<?php if( in_array("EDITAR", $permisos)){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar" data-toggle="modal" data-target="#modal"  onclick="acciones('editar', <?php echo $hotel->id; ?>)"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modal"  onclick="eliminar( <?php echo $hotel->id; ?>,'<?php echo utf8_encode($hotel->nombre);  ?>')" ></i>
					<?php } ?>
				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>


<script type="text/javascript">
	
tables(1,"asc");
</script>