<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$catalogo= $con->consulta("nombre_extra as nombre, id_extra as id,abrev_extra as abrev","extras_volar","status<>0 and id_extra=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();

?>
<form id="formulario" name="formulario" enctype="multipart/form-data" method="post"  accept="image/*">
	<input type="hidden" name="clasificacion" id="clasificacion" value="<?php echo $_POST['tipo']; ?>">
	<?php

	if(isset($_POST['id']) &&  $_POST['id'] !=''){
		echo "<input type='hidden' name='id' id='id' value='".$_POST['id']."'>";
		echo "<input type='hidden' name='accion' id='accion' value='editar'>";
	}else{
		echo "<input type='hidden' name='accion' id='accion' value='agregar'>";
	}
	?>
	<div class="row"> 
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="nombre">Nombre</label>
				<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre"  value="<?php if(isset($catalogo)){ echo $catalogo[0]->nombre; } ?>">
			</div>
		</div>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="abrev">Abreviación</label>
				<input type="text" class="form-control" id="abrev" name="abrev" placeholder="Abreviación"  value="<?php if(isset($catalogo)){ echo $catalogo[0]->abrev; } ?>">
			</div>
		</div>
	</div>
</form>

