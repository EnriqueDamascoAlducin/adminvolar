<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$ventas= $con->consulta("nombre_globo as nombre, id_globo as id,placa_globo as placa,peso_globo as peso, maxpersonas_globo as maxpersonas,imagen_globo as imagen","ventas_volar","status<>0 and id_venta=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();

?>
<form id="formulario" name="formulario" enctype="multipart/form-data" method="post"  accept="image/*">
	<?php 
	if(isset($_POST['id']) &&  $_POST['id'] !=''){
		echo "<input type='hidden' name='id' id='id' value='".$_POST['id']."'>";
		echo "<input type='hidden' name='accion' id='accion' value='editar'>";
	}else{
		echo "<input type='hidden' name='accion' id='accion' value='agregar'>";
	}
	?>
	<div class="row"> 
		<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
			<div class="form-group">
			    <label for="comentario">Comentario</label>
			   	<textarea class="form-control" id="comentario" rows="3"><?php if(isset($ventas)){ echo $ventas[0]->comentario_venta; } ?></textarea>
			</div>
		</div>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
			<div class="form-group">
				<label for="otroscar1">Otros Cargos</label>
				<input type="text" class="form-control" id="otroscar1" name="otroscar1" placeholder="Otros Cargos"  value="<?php if(isset($ventas)){ echo $ventas[0]->otroscar1_venta; } ?>">
			</div>
		</div>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
			<div class="form-group">
				<label for="precio1">Precio</label>
				<input type="text" class="form-control" id="precio1" name="precio1" placeholder="Precio"  value="<?php if(isset($ventas)){ echo $ventas[0]->precio1_venta; } ?>">
			</div>
		</div>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
			<div class="form-group">
				<label for="otroscar2">Otros Cargos</label>
				<input type="text" class="form-control" id="otroscar2" name="otroscar2" placeholder="Otros Cargos"  value="<?php if(isset($ventas)){ echo $ventas[0]->otroscar2_venta; } ?>">
			</div>
		</div>
		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
			<div class="form-group">
				<label for="precio2">Precio</label>
				<input type="text" class="form-control" id="precio2" name="precio2" placeholder="Precio"  value="<?php if(isset($ventas)){ echo $ventas[0]->precio2_venta; } ?>">
			</div>
		</div>
		
	</div>
</form>

<script type="text/javascript" src="vistas/ventas/js/form1.js"></script>
