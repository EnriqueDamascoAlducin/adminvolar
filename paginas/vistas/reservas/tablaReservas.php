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
	$campos= "id_temp,CONCAT(ifnull(nombre_temp,''),' ',ifnull(apellidos_temp,'')) as nombre, mail_temp,CONCAT(ifnull(telfijo_temp,''),' / ',ifnull(telcelular_temp,'')) as telefonos, tv.status,CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as empleado,idusu_temp as idusu ,fechavuelo_temp,tipo_temp as tipo";
	$tabla = "temp_volar tv INNER JOIN volar_usuarios ve on tv.idusu_temp = ve.id_usu";
	$filtro = "tv.status<>0 ";
	if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
		$filtro.= " and fechavuelo_temp >='".$_POST['fechaI']."'";
	}
	if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
		$filtro.= " and fechavuelo_temp <='".$_POST['fechaF']."'";
	}
	/*
	if(isset($_POST['cliente']) && $_POST['cliente']!='0' ){
		$cliente = explode("-", $_POST['cliente']);

		$filtro.= " and nombre_temp like '%".$cliente[0]."%'";
		if(isset($cliente[1]) && $cliente[1]!="" && !empty($cliente[1])){

			$filtro.= " and apellidos_temp like '%".$cliente[0]."%'";
		}
	}
	*/
	if(isset($_POST['status']) && $_POST['status']!='0' ){
		$filtro.= " and tv.status = ".$_POST['status'];
	}
	if(isset($_POST['empleado']) && $_POST['empleado']!='0' ){
		$filtro.= " and idusu_temp = ".$_POST['empleado'];
	}
	if(isset($_POST['reserva']) && $_POST['reserva']!='' ){
		$filtro.= " and id_temp = ".$_POST['reserva'];
	}
	if(!in_array("GENERAL", $permisos)){
		$filtro.= " and idusu_temp=".$idUsu;
	}
	if($_POST['fechaI']=='' &&  $_POST['fechaF']=='' && $_POST['reserva']=='' ){
		$filtro .= " and fechavuelo_temp >= CURRENT_TIMESTAMP ";
	}
//	echo "SELECT $campos FROM $tabla WHERE $filtro";
	$filtro .= " ORDER BY id_temp DESC limit 300";
	$reservas=$con->consulta($campos,$tabla,$filtro);
	$cancelarSinCot= $con->query("UPDATE temp_volar set status= 0 where  register <=  CURRENT_TIMESTAMP - INTERVAL 1 DAY and status=2");
	$cancelar30Dias= $con->query("UPDATE temp_volar set status= 0 where register <=  CURRENT_TIMESTAMP - INTERVAL 30 DAY and status =3;");
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;"># Reserva</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>

			<?php if(in_array("GENERAL",$permisos)){ ?>
				<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Empleado</th>
			<?php } ?>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Correo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Telefonos Fijo/Celular</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Fecha de Vuelo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Tipo de Vuelo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Status</th>
			<th style="text-align: center;vertical-align: middle;max-width: 4%;width: 4% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($reservas as $reserva) {
		?>
			<tr>
				<td><?php echo $reserva->id_temp; ?></td>
				<td><?php echo explode(' ',$reserva->nombre)[0]; ?></td>
				<?php if(in_array("GENERAL",$permisos)){ ?>
						<?php $nombre = explode(' ',$reserva->empleado)[0]; ?>
					<td><?php echo $nombre .' '. substr(explode(' ',$reserva->empleado)[1],0,1) ; ?></td>
				<?php } ?>
				<td><?php echo $reserva->mail_temp; ?></td>
				<td><?php echo $reserva->telefonos; ?></td>
				<td><?php echo $reserva->fechavuelo_temp; ?></td>
				<?php $tipoVuelo = $con->consulta("nombre_extra","extras_volar INNER JOIN vueloscat_volar on id_extra=tipo_vc","id_vc = ".$reserva->tipo); ?>
				<td><?php echo $tipoVuelo[0]->nombre_extra; ?></td>
				<?php
					$color="";
					if( $reserva->status ==4){
						$text="Conciliado";
						$class="info";
					}else if($reserva->status==2){
						$text="Sin Cotización";
						$class="danger";
					}else if($reserva->status==3){
						$text="Pendiente de Pago";
						$class="warning";
					}else if($reserva->status==1){
						$text="Terminado";
						$class="success";
					}else if($reserva->status==5){
						$text="Esperando Autorización";
						$class="success";
					}else if($reserva->status==6){
						$text="C. por Reemplazo ";
						$class="";
						$color = "background-color:#9933CC;";
					}else if($reserva->status==7){
						$text="Pagado Total";
						$class="success";
					}else if($reserva->status==8){
						$text="Confirmado";
						$class="";
						$class="background-color:#00e676 ;";
					}else{
						$text="Error";
						$class="danger";
					}
				?>
				<td>
					<?php
						echo '<div class="progress">
						<div class="progress-bar bg-'.$class.'" role="progressbar" style="width: 100%;'.$color.'" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">'. $text .'</div>
								</div>';
					?>
				</td>
				<td>

					<!--========       EDITAR     ========= -->
					<?php if( (($idUsu==$reserva->idusu && in_array("EDITAR",$permisos)) || in_array("EDITAR GRAL",$permisos)) && ($reserva->status!=1  && $reserva->status!=6 )  ) { ?>
						<i class="fa fa-pencil-square fa-lg" style="color:#33b5e5" title="Editar"  onclick="accionReserva('editar', <?php echo $reserva->id_temp; ?>)"></i>&nbsp;
					<?php } ?>
					<!--========       VER     ========= -->
					<?php if(($idUsu==$reserva->idusu && in_array("VER",$permisos)) || in_array("VER GRAL",$permisos)) { ?>
						<i class="fa fa-eye fa-lg" style="color:#311b92 " title="Ver" onclick="accionReserva('ver', <?php echo $reserva->id_temp; ?>)" ></i>&nbsp;
					<?php } ?>
					<!--========       REPROGRAMACIONES     ========= -->
					<?php if(($idUsu==$reserva->idusu && in_array("REPROGRAMAR",$permisos)) || in_array("REPROGRAMAR GRAL",$permisos)) { ?>
						<i class="fa fa-clock-o fa-lg" style="color:#311b92 " data-toggle="modal" data-target="#modalReservas"  title="Reprogramar" onclick="reprogramar( <?php echo $reserva->id_temp; ?>,'<?php echo $reserva->nombre; ?>')" ></i>&nbsp;
					<?php } ?>

								<!--========       PAGOS     ========= -->
					<?php if(in_array("AGREGAR PAGO",$permisos) && $reserva->status!=6 && $reserva->status!=2){ ?>
						<i class="fa fa-money fa-lg" style="color:#00C851" title="Agregar Pago" data-toggle="modal" data-target="#modalReservas" onclick="agregarPago(<?php echo $reserva->id_temp; ?>,'<?php echo $reserva->nombre; ?>')"> </i>&nbsp;
					<?php } ?>
					<!--========       CONCILIAR     ========= -->
					<?php if( in_array("CONCILIAR",$permisos) && $reserva->status!=6 && $reserva->status!=2){ ?>
						<i class="fa fa-check-square-o fa-lg" style="color:#aa66cc" title="Conciliar" data-toggle="modal" data-target="#modalReservas"    onclick="conciliarPago(<?php echo $reserva->id_temp; ?>,'<?php echo $reserva->nombre; ?>')"></i>&nbsp;
					<?php } ?>
					<!--========       BITACORA     ========= -->
					<?php if((($idUsu==$reserva->idusu && in_array("BITACORA",$permisos)) || in_array("BITACORA GRA", $permisos)) && $reserva->status!=2){ ?>
					<i class="fa fa-file-text-o fa-md" style="color:#2BBBAD" title="Bitacora de Pagos" data-toggle="modal" data-target="#modalReservas"   onclick="verBitacora( <?php echo $reserva->id_temp; ?>)"></i>&nbsp;
					<?php } ?>
					<!--========      Mostrar Cotización     ========= -->
					<?php if(in_array("COTIZACION",$permisos) && $reserva->status!=2){ ?>
						<i class="fa fa-expand fa-lg" style="color:#311b92 " title="Cotización" data-toggle="modal" data-target="#modalReservas"  onclick="mostrarCotizacion(<?php echo $reserva->id_temp; ?>, 'ver')" ></i>&nbsp;
					<?php } ?>
					<!--========       Pago en SItio     ========= -->
					<?php if(in_array("PAGO SITIO",$permisos) && $reserva->status!=6 && $reserva->status!=2){ ?>
						<i class="fa fa-dollar fa-lg" style="color:#00C851" title="Agregar Pago" data-toggle="modal" data-target="#modalReservas"  onclick="agregarPagoSitio(<?php echo $reserva->id_temp; ?>,'<?php echo $reserva->nombre; ?>')"></i>&nbsp;
					<?php } ?>

					<!--========       PILOTOS     ========= -->
					<?php if(in_array("PILOTOS",$permisos)){ ?>
						<i class="fa fa-user-o fa-lg" style="color:rgba(0, 150, 136, 0.7) " title="Asignar Globos y Pilotos"  onclick="asignarGlobo(<?php echo $reserva->id_temp; ?>)" data-toggle="modal" data-target="#modalReservas" ></i>&nbsp;
					<?php } ?>
					<!--========       Confirmar Asistencia     ========= -->
					<?php if(in_array("ASISTENCIA",$permisos)   ){ ?>
						<i class="fa fa-street-view fa-lg" style="color:#311b92 " title="Confirmar Asistencia" data-toggle="modal" data-target="#modalReservas"  onclick="checkAsistencia(<?php echo $reserva->id_temp; ?>,'<?php echo $reserva->nombre; ?>')"></i>&nbsp;
					<?php } ?>
					<!--========       Eliminar     ========= -->
					<?php if( (($idUsu==$reserva->idusu && in_array("ELIMINAR",$permisos)) || in_array("ELIMINAR GRL",$permisos))  && ($reserva->status!=1 && $reserva->status!=7) ) { ?>
						<i class="fa fa-trash-o fa-lg" style="color:#ff4444" title="Eliminar" data-toggle="modal" data-target="#modalReservas"  onclick="eliminarReserva('vistas/reservas/', <?php echo $reserva->id_temp; ?>, <?php echo $modulo; ?>)" ></i>&nbsp;
					<?php } ?>
					<!--========       Comentario     ========= -->
					<?php if(($idUsu==$reserva->idusu && in_array("COMENTARIO",$permisos) ) || in_array("COMENTARIO GRAL",$permisos) ) { ?>
						<i class="fa fa-comments-o fa-lg" style="color:#311b92 " data-toggle="modal" data-target="#modalReservas"  title="Comentarios" onclick="comentario( <?php echo $reserva->id_temp; ?>,'<?php echo $reserva->nombre; ?>')" ></i>&nbsp;
					<?php } ?>

				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>
<script type="text/javascript">
	tables(5,"asc");
</script>
