<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$departamentos= $con->consulta("nombre_depto as nombre, id_depto as id","departamentos_volar","status=1 and id_depto=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();

?>
<div class="row"> 
	<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
		<div class="form-group">
			<label for="nombre">Departamento</label>
			<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre"  value="<?php if(isset($departamentos)){ echo $departamentos[0]->nombre; } ?>">
		</div>
	</div>
</div>


<script type="text/javascript" src="vistas/usuarios/js/form1.js"></script>
