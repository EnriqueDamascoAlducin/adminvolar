<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$modulos = $con->consulta("id_per,nombre_per,img_per ","permisos_volar","status<>0 ORDER BY nombre_per ASC");
	$idUsu=$_POST['id'];

	
?>
<div class=" row" style="margin-top: 5%;">
	<?php foreach ($modulos as $modulo) { ?>
		<div class="card" style="width: 18rem;margin: 10px;">
			<center>
	  			<img class="card-img-top" src="../sources/images/modulos/<?php echo $modulo->img_per; ?>" alt="Card image cap " style ="width: 25%;max-width: 25%;margin-top: 3% " >
	  		</center>
	  		<div class="card-body">
	    		<h5 class="card-title"><?php echo $modulo->nombre_per ?></h5>
	    		<p class="card-text">Asignar Permisos para <?php echo $modulo->nombre_per ?> </p>
	    		<a href="#" class="btn btn-primary" data-toggle="modal" data-target="#modal"  onclick="verPermisos(<?php echo $idUsu .','.$modulo->id_per ?>)" 	>Asignar</a>
	  		</div>
		</div>
	<?php } ?>
</div>

<div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-md" role="dialog">
    <div class="modal-content ">
      <div class="modal-header">
        <h5 class="modal-title" id="tituloModal">Asignar Permisos</h5>
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
<script type="text/javascript" src="vistas/usuarios/js/index2.js"></script>