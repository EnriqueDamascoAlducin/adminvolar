<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	

	$campos= "CONCAT(IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as nombre, id_usu as id";
	$tabla="volar_usuarios";
	$filtro = "status<>0";
	$filtro .= " ORDER BY id DESC limit 1000";
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
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;"></th>
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1%;">Nombre</th>
			
			<th style="text-align: center;vertical-align: middle;max-width: 1%;width: 1% !important;">Acciones</th>
		</tr>
	</thead>
	<tbody>
		<?php
			foreach ($reservas as $reserva) {
		?>
			<tr>
				<td></td>
				<td><?php echo $reserva->nombre; ?></td>
				
				<td>
					<i class="fa fa-pencil-square fa-md" style="color:#33b5e5" title="Editar"  onclick="accionReserva('editar', <?php echo $reserva->id; ?>)"></i>
					<i class="fa fa-check-square-o fa-md" style="color:#aa66cc" title="Conciliar"  onclick="accionReserva('conciliar', <?php echo $reserva->id; ?>)"></i>
					<i class="fa fa-money fa-md" style="color:#00C851" title="Agregar Pago" onclick="accionReserva('pagos', <?php echo $reserva->id; ?>)"> </i>
					<i class="fa fa-file-text-o fa-md" style="color:#2BBBAD" title="Bitacora de Pagos"  onclick="accionReserva('bitacora', <?php echo $reserva->id; ?>)"></i>
					<i class="fa fa-user-o fa-md" style="color:rgba(0, 150, 136, 0.7) " title="Asignar Pilotos"  onclick="accionReserva('pilotos', <?php echo $reserva->id; ?>)"></i>
					<i class="fa fa-eye fa-md" style="color:#311b92 " title="Ver" onclick="accionReserva('ver', <?php echo $reserva->id; ?>)" ></i>
					<i class="fa fa-expand fa-md" style="color:#311b92 " title="Cotización" data-toggle="modal" data-target="#cotizacion"  onclick="mostrarCotizacion(<?php echo $reserva->id; ?>, 'ver')" ></i>
					<i class="fa fa-trash-o fa-md" style="color:#ff4444" title="Eliminar" onclick="accionReserva('eliminar', <?php echo $reserva->id; ?>)" ></i>
				</td>
			</tr>

		<?php
			}
		?>
	</tbody>

</table>

<div class="modal fade" id="cotizacion" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md" role="dialog">
    <div class="modal-content ">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Enviar Cotización</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="cuerpoCotizacion">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript" src="vistas/reservas/js/index.js"></script>