<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$modulo= $_POST['modulo'];
	$campos= "id_venta as id, comentario_venta comentario,fechavta_venta as fecha,total_venta as total ";
	$tabla = "ventas_volar  ";
	$filtro = "status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
		$filtro.= " and fechavta_venta>='". $_POST['fechaI'] . "' ";
	}
	if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
		$filtro.= " and fechavta_venta<='". $_POST['fechaF'] . "' ";
	}
	if($_POST['fechaF']=='' &&  $_POST['fechaI']==''){
		$filtro .=' and fechavta_venta=CURRENT_DATE ';
	}
/*	for($x = 'A'; $x < 'ZZ'; $x++)
    echo $x, ' ';*/
	//echo "SELECT $campos FROM $tabla WHERE $filtro";
	$ventas=$con->consulta($campos,$tabla,$filtro);
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Comentario</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Total</th>
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
				<td><?php echo $venta->total; ?></td>
				<td><?php echo explode(" ", $venta->fecha)[0]; ?></td>
				<td>
					<?php if( in_array("VER", $permisos)){ ?>
						<i class="fa fa-eye fa-md" style="color:#33b5e5" title="Editar"   onclick="accionVtas('editar', <?php echo $venta->id?>)"></i>
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
	tables(0,"asc");
</script>
