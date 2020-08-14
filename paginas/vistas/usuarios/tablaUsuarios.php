<?php 
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	

	$modulo= $_POST['modulo'];
	$campos= "CONCAT(IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as nombre, id_usu as id,IFNULL((SELECT nombre_depto from departamentos_volar where id_depto = vu.depto_usu),'No asignado') as depto,IFNULL((SELECT nombre_puesto from puestos_volar where id_puesto = vu.puesto_usu),'No asignado') as puesto, IFNULL(correo_usu,'') as correo";
	$tabla = "volar_usuarios vu ";
	$filtro = "vu.status<>0";
	if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
		$filtro.= " and register >='".$_POST['fechaI']."'";
	}
	if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
		$filtro.= " and register <='".$_POST['fechaF']."'";
	}
	if(isset($_POST['empleado']) && $_POST['empleado']!='0' ){
		$filtro.= " and id_usu = ".$_POST['empleado'];
	}
	if(isset($_POST['nombre']) && $_POST['nombre']!='' ){
		$filtro.= " and nombre_usu like '%".$_POST['nombre']."%'";
	}
	if(isset($_POST['depto']) && $_POST['depto']!='0' ){
		$filtro.= " and depto_usu =".$_POST['depto'];
	}
	//echo "SELECT $campos FROM $tabla WHERE $filtro";
	$usuarios=$con->consulta($campos,$tabla,$filtro);	

	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Correo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Departamento</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Puesto</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($usuarios as $usuarios) {
		?>
			<tr>
				<td><?php echo $usuarios->nombre; ?></td>
				<td><?php echo $usuarios->correo; ?></td>
				<td><?php echo $usuarios->depto; ?></td>
				<td><?php echo $usuarios->puesto; ?></td>
				<td>
					<?php if( in_array("EDITAR", $permisos)){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar"  onclick="accionusuarios('editar', <?php echo $usuarios->id; ?>)"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modal"  onclick="eliminarusuarios( <?php echo $usuarios->id; ?>,'<?php echo $usuarios->nombre;  ?>')" ></i>
					<?php } ?>
					<?php if( in_array("PERMISOS", $permisos)){ ?>
						<i class="fa fa-th-list fa-md" style="color:#aa66cc" title="Dar Permisos"  onclick="accionusuarios('permisos', <?php echo $usuarios->id; ?>)"></i>
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