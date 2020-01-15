<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';

	$modulo= $_POST['modulo'];
	$campos= " (clasificacion_extra )as clasificacion, nombre_extra as nombre,id_extra as id ";
	$tabla = "extras_volar  ";
	$filtro = "status<>0";
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	/*
	Filtrar solo con permisos
	*/
	$extraFilter='';
	$noFilt = ['AGREGAR','EDITAR','ELIMINAR'];
	foreach ($permisos as $permiso) {
		$clasif='';
		if( !in_array($permiso, $noFilt) ){
			if($permiso=='MONEDAS'){
			$clasif='monedas';
			}elseif($permiso=='MOTIVOS'){
				$clasif='motivos';
			}elseif($permiso=='TIPOS VUELO'){
				$clasif='tiposv';
			}elseif($permiso=='METODOS PAGO'){
				$clasif='metodopago';
			}elseif($permiso=='CUENTAS BANCOS'){
				$clasif='cuentasvolar';
			}elseif($permiso=='TIPOS GASTOS'){
				$clasif='tipogastos';
			}elseif($permiso=='ESTADOS'){
				$clasif='estados';
			}else if($permiso!='EDITAR' && $permiso!='ELIMINAR'){
				$clasif = $permiso;
			}
			$permisosC[] = $clasif;
			$extraFilter .='"'. $clasif.'",';
		}
		
	}
	$filtro .= ' AND clasificacion_extra in('.$extraFilter.'"")';
	//echo "SELECT  $campos FROM $tabla FROM $filtro";
	$extras=$con->consulta($campos,$tabla,$filtro);
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Clasificación</th>

			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($extras as $extra) {
				if($extra->clasificacion=='estados'){
					$clasificacion='Procedencia';
				}elseif($extra->clasificacion=='motivos'){
					$clasificacion='Motivos';
				}elseif($extra->clasificacion=='tiposv'){
					$clasificacion='Tipos de Vuelos';
				}elseif($extra->clasificacion=='tarifas'){
					$clasificacion='Tarifas';
				}elseif($extra->clasificacion=='metodopago'){
					$clasificacion='Metodos de Pago';
				}elseif($extra->clasificacion=='cuentasvolar'){
					$clasificacion='Cuentas de Banco';
				}elseif($extra->clasificacion=='tipogastos'){
					$clasificacion='Tipos de Gastos';
				}elseif($extra->clasificacion=='monedas'){
					$clasificacion='Monedas';
				}else {
					$clasificacion = $extra->clasificacion;
				}

		?>
			<tr>
				<td><?php echo $extra->nombre; ?></td>
				<td><?php echo $clasificacion; ?></td>
				<td>
					<?php if( in_array("EDITAR", $permisos) && in_array($extra->clasificacion,$permisosC) ){ ?>
						<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar" data-toggle="modal" data-target="#modal"  onclick="accionExtras('editar', <?php echo $extra->id; ?>,'<?php echo $extra->clasificacion; ?>')"></i>
					<?php  } ?>
					<!--========       Eliminar     ========= -->
					<?php if( in_array("ELIMINAR", $permisos) && in_array($extra->clasificacion,$permisosC)){ ?>
						<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modal"  onclick="eliminarExtra( <?php echo $extra->id; ?>,'<?php echo $extra->nombre;  ?>')" ></i>
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
