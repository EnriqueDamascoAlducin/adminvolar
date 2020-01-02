<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	if($_POST['id']!='' && $_POST['id']!='0' ){
		$souvenir=$con->consulta("*","souvenirs_volar"," id_souvenir=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$opc1="";
	$opc2="";
	if(isset($souvenir )){
		if($souvenir[0]->tipo_souvenir==1){
			//souvenir
			$opc1="selected";
		}else if($souvenir[0]->tipo_souvenir==2){
			//foto
			$opc2="selected";
		}
	}

?>
<form id="formulario" action="controladores/souvenirsController.php" method="post" >
	<?php if(isset($souvenir)){ ?>
		<input type="hidden" name="id" value="<?php echo $_POST['id'] ?>" id="id">
		<input type="hidden" name="accion" value="editar">
	<?php }else{ ?>
		<input type="hidden" name="accion" value="agregar">
	<?php } ?>
	<fieldset>
		<div class="row">
			<div class="col-12 col-sm-6 col-md-6 col-lg-6  col-xl-6 ">
				<div class="form-group">
					<label for="clave"><span style="color:red">*</span>Clave</label>
					<input type="text" class="form-control" id="clave" name="clave" placeholder="Clave" required value="<?php if(isset($souvenir)){echo $souvenir[0]->clave_souvenir;} ?>" >
				</div>
			</div>
			<div class="col-12 col-sm-6 col-md-6 col-lg-6  col-xl-6 ">
				<div class="form-group">
					<label for="nombre"><span style="color:red">*</span>Nombre</label>
					<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre" required value="<?php if(isset($souvenir)){echo $souvenir[0]->nombre_souvenir;} ?>" >
				</div>
			</div>
			<div class="col-12 col-sm-6 col-md-6 col-lg-6  col-xl-6 ">
				<div class="form-group">
					<label for="precio"><span style="color:red">*</span>Precio</label>
					<input type="number" class="form-control" id="precio" name="precio" placeholder="Precio" onkeypress="return isNumber(event)" required value="<?php if(isset($souvenir)){echo $souvenir[0]->precio_souvenir;} ?>" >
				</div>
			</div>
			<div class="col-12 col-sm-6 col-md-6 col-lg-6  col-xl-6 ">
				<div class="form-group">
					<label for="precio"><span style="color:red">*</span>Tipo</label>
					<select class="form-control" name="tipo" placeholder="Tipo" id="tipo">
						<option value="1" <?php echo $opc1; ?>>Souvenir</option>
						<option value="2" <?php echo $opc2; ?>>Foto</option>
					</select>
				</div>
			</div>
		</div>
	</fieldset>

	<div class="col-12 col-sm-12 col-md-12 col-lg-12  col-xl-12 ">
		<button type="button" name="button" onclick="enviarForm();" class="btn btn-primary btn-lg">Enviar</button>
	</div>
</form>
