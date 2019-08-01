<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "nombre_servicio as nombre, id_servicio as id";
	$tabla = "servicios_volar  ";
	$filtro = "status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	if(isset($_POST['preciomin']) && $_POST['preciomin']!='' ){
		$filtro.= " and precio_servicio>=".$_POST['preciomin'];
	}
	if(isset($_POST['preciomax']) && $_POST['preciomax']!=''){
		$filtro.= " and precio_servicio<=".$_POST['preciomax'];
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
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar"   onclick="accionDeptos('editar', <?php echo $depto->id; ?>)"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar"   onclick="eliminarServicio( <?php echo $depto->id; ?>,'<?php echo $depto->nombre;  ?>')" ></i>
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