<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';

	$modulo= $_POST['modulo'];
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	$permisos=[];
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
		
	$campos= " CONCAT (IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as piloto,id_usu as id, correo_usu";
	$tabla = " volar_usuarios ";
	$filtro = " status <> 0 and puesto_usu = 4 and id_usu in( ";
	$filtro .= " Select piloto_ga FROM  globosasignados_volar ga INNER JOIN temp_volar tv ON id_temp = reserva_ga ";
	$filtro .= " WHERE tv.status = 8 and ga.status<>0 ";
	/*---------Filtros--------------*/
	if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
		$filtro.= " and fechavuelo_temp >='".$_POST['fechaI']."'";
	}
	$_SESSION['filtros']['fechaI'] = $_POST['fechaI'];
	//////
	if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
		$filtro.= " and fechavuelo_temp <='".$_POST['fechaF']."'";
	}
	$_SESSION['filtros']['fechaF'] = $_POST['fechaF'];
	//////////

	if(in_array("GENERAL",$permisos)){
		if(isset($_POST['empleado']) && $_POST['empleado']!='0' ){
			$filtro.= " and piloto_ga = ".$_POST['empleado'];
		}
		$_SESSION['filtros']['empleado'] = $_POST['empleado'];
	}
	/////////
	if(isset($_POST['reserva']) && $_POST['reserva']!='' ){
		$filtro.= " and id_temp = ".$_POST['reserva'];
	}
	$_SESSION['filtros']['reserva'] = $_POST['reserva'];//////

	if($_POST['fechaI']=='' &&  $_POST['fechaF']=='' && $_POST['reserva']=='' ){
		$filtro .= " and fechavuelo_temp >= CURRENT_TIMESTAMP ";
	}
	/*--------------Termina Filtros -----------*/
		$filtro .= ') ';
		if(in_array("INDIVIDUAL",$permisos)){
			$filtro.= " AND id_usu = " . $idUsu;
		}
	$filtro .= " ORDER BY nombre_usu ASC, apellidop_usu asc";
//echo "SELECT $campos FROM $tabla WHERE $filtro";
// die();
	$pilotos=$con->consulta($campos,$tabla,$filtro);
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_piloto"><a onclick="ocultarFila('piloto')" style="color:red"> Piloto  </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_correo"><a onclick="ocultarFila('correo')" style="color:red">Correo </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_reserva"><a onclick="ocultarFila('reserva')" style="color:red">Reserva </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_pasajero"> <a onclick="ocultarFila('pasajero')" style="color:red"> Pasajero </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_fecha"><a onclick="ocultarFila('fecha')" style="color:red"> Fecha de Vuelo  </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_hora"><a onclick="ocultarFila('hora')" style="color:red"> Hora de Vuelo </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_pax"><a onclick="ocultarFila('pax')" style="color:red"> PAX </a></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;" id="th_globo"><a onclick="ocultarFila('globo')" style="color:red"> Globo </a> </th>
			<th style="text-align: center;vertical-align: middle;max-width: 4%;width: 4% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($pilotos as $piloto) {
				$campos = "nombre_globo as globo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as pasajero	,";
				$campos .= " id_temp as reserva, fechavuelo_temp as fechavuelo, hora_temp as hora, pax_ga as pax,version_ga as version";
				$tabla = "temp_volar tv INNER JOIN globosasignados_volar ga ON id_temp = reserva_ga INNER JOIN globos_volar gv ON globo_ga = id_globo ";

				$filtro = " gv.status <> 0 AND tv.status= 8 AND ga.status<>0 ";
					if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
						$filtro.= " and fechavuelo_temp >='".$_POST['fechaI']."'";
					}
					//////
					if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
						$filtro.= " and fechavuelo_temp <='".$_POST['fechaF']."'";
					}
					//////////

					if(in_array("GENERAL",$permisos)){
						if(isset($_POST['empleado']) && $_POST['empleado']!='0' ){
							$filtro.= " and piloto_ga = ".$_POST['empleado'];
						}
					}
					/////////
					if(isset($_POST['reserva']) && $_POST['reserva']!='' ){
						$filtro.= " and id_temp = ".$_POST['reserva'];
					}
					//////
					if($_POST['fechaI']=='' &&  $_POST['fechaF']=='' && $_POST['reserva']=='' ){
						$filtro .= " and fechavuelo_temp >= CURRENT_TIMESTAMP ";
					}

				$filtro .=" AND piloto_ga= ".$piloto->id;
				/*echo "SELECT $campos FROM $tabla WHERE $filtro";
				die();*/
				$infoAsignados = $con->consulta($campos,$tabla,$filtro);
				foreach ($infoAsignados as $infoAsignado) {
		?>
					<tr>
						<td id="td_piloto"><?php echo $piloto->piloto; ?></td>
						<td id="td_correo"><?php echo $piloto->correo_usu; ?></td>
						<td id="td_reserva"><?php echo $infoAsignado->reserva.'-'. $infoAsignado->version; ?></td>
						<td id="td_pasajero"><?php echo $infoAsignado->pasajero; ?></td>
						<td id="td_fecha"><?php echo $infoAsignado->fechavuelo ; ?></td>
						<td id="td_hora"><?php echo $infoAsignado->hora ?></td>
						<td id="td_pax"><?php echo $infoAsignado->pax ; ?></td>
						<td id="td_globo"><?php echo $infoAsignado->globo ; ?></td>
						<td>
							<!--========       EDITAR     ========= -->
							<?php if( in_array("CORREO",$permisos) && in_array("GENERAL",$permisos)) { ?>
								<i class="fa fa-envelope-o fa-lg" style="color:#33b5e5" title="Enviar Correo "  onclick="enviarCorreo(<?php echo $piloto->id ?>,<?php echo $infoAsignado->reserva ?>,<?php echo $infoAsignado->version ?> )"></i>&nbsp;
							<?php } ?>
						</td>
					</tr>
				<?php } ?>

		<?php
			}
		?>
	</tbody>

</table>
<script type="text/javascript">
	tables();
</script>
