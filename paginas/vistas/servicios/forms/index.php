<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$servicio= $con->consulta("nombre_servicio as nombre, cortesia_servicio,cantmax_servicio,id_servicio as id,img_servicio,precio_servicio","servicios_volar","id_servicio=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$cortesia0 ="";
	$cortesia1 ="";
	$cantmax0 ="";
	$cantmax1 ="";
	if(isset($servicio)){
		if($servicio[0]->cortesia_servicio==0){
			$cortesia0="selected";
		}else{
			$cortesia1="selected";
		}
		if($servicio[0]->cantmax_servicio==0){
			$cantmax0="selected";
		}else{
			$cantmax1="selected";
		}
	}
?>
<div class="row"> 
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="servicio">Servicio</label>
			<input type="text" class="form-control" id="servicio" name="servicio" placeholder="Servicio"  value="<?php if(isset($servicio)){echo $servicio[0]->nombre;} ?>">
		</div>
	</div>
	<?php
		if(isset($servicio)){
			echo "<input type='hidden' id='servicio' value='".$servicio[0]->id."'>";
		}
	?>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="precio">Precio</label>
			<input type="number" class="form-control" id="precio" name="precio" placeholder="Precio"  value="<?php if(isset($servicio)){echo $servicio[0]->precio_servicio;} ?>">
		</div>
	</div>
	

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="cortesia">Aplica Cortesia</label>
			<select class="selectpicker form-control" id="cortesia" name="cortesia" data-live-search="true">
				<option value='1' <?php echo $cortesia1; ?>>Si</option>
				<option value='0' <?php echo $cortesia0; ?>>No</option>
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-3 ">
		<div class="form-group">
			<label for="cantmax">Forma de Cobro</label>
			<select class="selectpicker form-control" id="cantmax" name="cantmax" data-live-search="true">
				<option value='1' <?php echo $cantmax1; ?>>Individual</option>
				<option value='0' <?php echo $cantmax0; ?>>En Conjunto</option>
			</select>
		</div>
	</div>

		<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
			<div class="form-group">
				<label for="imagen">
					<img src="../sources/images/servicios/<?php if(isset($servicio)){echo $servicio[0]->img_servicio;}else{ echo 'noimage.png'; } ?>" style="max-width: 100%">
				</label>
				<input type="file" class="form-control" id="imagen" name="imagen"  style="display: none" >
			</div>
		</div>
	
</div>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
<?php if($_POST['id']!=''){ ?>

	<button class="btn btn-info" onclick="agregarServicio();">Actualizar</button>
<?php }else{ ?>

	<button class="btn btn-success" onclick="agregarServicio();">Agregar</button>
<?php } ?>
</div>
<script type="text/javascript" src="vistas/usuarios/js/form1.js"></script>
