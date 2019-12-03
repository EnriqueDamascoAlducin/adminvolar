<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';


	$permisos=[];
	$modulo=$_POST['id'];
	  if(!isset($_SESSION['modulo']) || $_SESSION['modulo']!=$modulo){
	    $_SESSION['modulo']=$modulo;
	    $_SESSION['url']="vistas/pilotos/";
	  }

	if($_SESSION['modulo']!=$modulo && isset($_SESSION['filtros'])){
		unset($_SESSION['filtros']);
	}
	$_SESSION['modulo'] = $modulo;
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}

?>
<?php
	require_once "filtros.php";
?>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="tabla">

</div>
<input type="hidden" id="modulo" value="<?php echo $modulo; ?>">
<div class="modal fade" id="modalReservas" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-lg " id="modalSize" role="dialog">
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
<script type="text/javascript" src="vistas/pilotos/js/index.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	cargarTabla();
});
</script>
