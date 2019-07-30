<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	

	
	$permisos=[];
	$modulo=$_POST['id'];
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
?>	
<?php if(in_array("AGREGAR", $permisos)){ ?>
	<div class="alert alert-info" onclick="accionReserva('agregar', <?php echo $idUsu; ?>)">
	  <strong><i class="fa fa-plus fa-md"></i></strong> Agregar.
	</div>
<?php } ?>
<?php
	require_once "filtros.php";
?>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="tablaReservas">
	<?php //require_once 'tablaReservas.php'; ?>
</div>
<input type="hidden" id="modulo" value="<?php echo $modulo; ?>">
<div class="modal fade" id="modalReservas" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md" role="dialog">
    <div class="modal-content ">
      <div class="modal-header">
        <h5 class="modal-title" id="tituloModalReservas"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="cuerpoModalReservas">
      	
      </div>
      <div class="modal-footer">
      	<div id="divBtnModalReservas">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
	        
        </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript" src="vistas/reservas/js/index.js"></script>