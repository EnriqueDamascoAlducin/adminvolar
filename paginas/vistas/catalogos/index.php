<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	$permisos=[];
	$modulo=$_POST['id'];

  if(!isset($_SESSION['modulo']) || $_SESSION['modulo']!=$modulo){
    $_SESSION['modulo']=$modulo;
    $_SESSION['url']="vistas/catalogos/";
  }
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$subPermisos = $con->query("CALL permisosSubModulos($idUsu,$modulo)")->fetchALL (PDO::FETCH_OBJ);
	foreach ($subPermisos as $subPermiso) {
		$permisos[] = $subPermiso->nombre_sp;
	}
?>	
<div class="row">
<?php if(in_array("ESTADOS", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
  	<div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="estados"  onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'estados')">
  	  <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Procedencias.
  	</div>
  </div>
<?php } ?>
<?php if(in_array("MOTIVOS", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
    <div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="motivos"  onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'motivos')">
      <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Motivos.
    </div>
  </div>
<?php } ?>
<?php if(in_array("TIPOS VUELO", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
    <div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="tiposv" onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'tiposv')">
      <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Tipos de Vuelos.
    </div>
  </div>
<?php } ?>
<?php if(in_array("TARIFAS", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
    <div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="tarifas" onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'tarifas')">
      <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Tarifas.
    </div>
  </div>
<?php } ?>
<?php if(in_array("METODOS PAGO", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
    <div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="metodopago" onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'metodopago')">
      <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Metodos de Pago.
    </div>
  </div>
<?php } ?>
<?php if(in_array("CUENTAS VOLAR", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
    <div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="cuentasvolar" onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'cuentasvolar')">
      <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Cuentas de Banco
    </div>
  </div>
<?php } ?>
<?php if(in_array("TIPOS GASTOS", $permisos)){ ?>
  <div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-3">
    <div class="alert alert-info" data-toggle="modal" data-target="#modal" data-info="tipogastos" onclick="accionExtras('agregar', <?php echo $usuario->getIdUsu(); ?>,'tipogastos')">
      <strong><i class="fa fa-plus fa-md"></i></strong> Agregar Tipos de Gastos
    </div>
  </div>
<?php } ?>
</div>

<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" id="tablaUsuarios">
</div>
<input type="hidden" id="modulo" value="<?php echo $modulo; ?>">

<div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md" id="modalSize" role="dialog">
    <div class="modal-content ">
      <div class="modal-header">
        <h5 class="modal-title" id="tituloModal"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="cuerpoModal">
      	
      </div>
      <div class="modal-footer">
      	<div id="DivBtnModal">
	        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
	        
        </div>
      </div>
    </div>
  </div>
</div>


<script type="text/javascript" src="vistas/catalogos/js/index.js"></script>
