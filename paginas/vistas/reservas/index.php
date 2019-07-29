<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	

	$campos= "id_temp,CONCAT(ifnull(nombre_temp,''),' ',ifnull(apellidos_temp,'')) as nombre, mail_temp,CONCAT(ifnull(telfijo_temp,''),' / ',ifnull(telcelular_temp,'')) as telefonos, tv.status,CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as empleado ,fechavuelo_temp";
	$tabla = "temp_volar tv INNER JOIN volar_usuarios ve on tv.idusu_temp = ve.id_usu";
	$filtro = "tv.status<>0";
	$filtro .= " ORDER BY id_temp DESC limit 1000";
	$reservas=$con->consulta($campos,$tabla,$filtro);	
	$status= "Error de status";
	$classStatus="danger";
	$permisos=[];
	$modulo=$_POST['id'];
	$subPermisos = $con->query("CALL permisosSubModulos(1,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
?>	
<?php if(in_array("AGREGAR", $permisos)){ ?>
	<div class="alert alert-info" onclick="accionReserva('agregar', <?php echo $usuario->getIdUsu(); ?>)">
	  <strong><i class="fa fa-plus fa-md"></i></strong> Agregar.
	</div>
<?php } ?>
<?php
	require_once "filtros.php";
?>
<table class="DataTable table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;"># Reserva</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Empleado</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Correo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Telefonos Fijo/Celular</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Fecha de Vuelo</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Status</th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($reservas as $reserva) {
		?>
			<tr>
				<td><?php echo $reserva->id_temp; ?></td>
				<td><?php echo $reserva->nombre; ?></td>
				<td><?php echo $reserva->empleado; ?></td>
				<td><?php echo $reserva->mail_temp; ?></td>
				<td><?php echo $reserva->telefonos; ?></td>
				<td><?php echo $reserva->fechavuelo_temp; ?></td>
				<?php 
					if( $reserva->status ==4){
						$text="Confirmada";
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
						$class="warning";
					}else{
						$text="Error";
						$class="danger";
					}
				?>
				<td>
					<?php 
						echo '<div class="progress">
								  <div class="progress-bar bg-'.$class.'" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">'. $text .'</div>
								</div>';
					?>
				</td>
				<td>
					<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar"  onclick="accionReserva('editar', <?php echo $reserva->id_temp; ?>)"></i>
					<i class="fa fa-check-square-o fa-md" style="color:#aa66cc" title="Conciliar"  onclick="accionReserva('conciliar', <?php echo $reserva->id_temp; ?>)"></i>
					<i class="fa fa-money fa-md" style="color:#00C851" title="Agregar Pago" onclick="accionReserva('pagos', <?php echo $reserva->id_temp; ?>)"> </i>
					<i class="fa fa-file-text-o fa-md" style="color:#2BBBAD" title="Bitacora de Pagos"  onclick="accionReserva('bitacora', <?php echo $reserva->id_temp; ?>)"></i>
					<i class="fa fa-user-o fa-md" style="color:rgba(0, 150, 136, 0.7) " title="Asignar Pilotos"  onclick="accionReserva('pilotos', <?php echo $reserva->id_temp; ?>)"></i>
					<i class="fa fa-eye fa-md" style="color:#311b92 " title="Ver" onclick="accionReserva('ver', <?php echo $reserva->id_temp; ?>)" ></i>
					<i class="fa fa-expand fa-md" style="color:#311b92 " title="Cotización" onclick="accionReserva('cotizacion', <?php echo $reserva->id_temp; ?>)" ></i>
					<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" onclick="accionReserva('eliminar', <?php echo $reserva->id_temp; ?>)" ></i>
				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>


<script type="text/javascript" src="vistas/reservas/js/index.js"></script>