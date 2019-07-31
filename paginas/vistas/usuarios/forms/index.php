<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	
	$departamentos= $con->consulta("nombre_depto as text, id_depto as value","departamentos_volar","status=1");

	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	if(isset($_POST['id']) && $_POST['id']!="" ){
		$usuarioMod = $con->query("CALL getUsuarioInfo(".$_POST['id'].")")->fetchALL (PDO::FETCH_OBJ);
		$usuarioBean = crearUsuarioBean($usuarioMod);
	}
?>
<div class="row"> 
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="nombre">Nombre</label>
			<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre"  value="<?php if(isset($usuarioBean)){ echo $usuarioBean->getNombreUsu(); } ?>">
		</div>
	</div>

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="apellidop">Apellido Paterno</label>
			<input type="text" class="form-control" id="apellidop" name="apellidop" placeholder="Apellido Paterno" value="<?php if(isset($usuarioBean)){ echo $usuarioBean->getApellidopUsu(); } ?>">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="apellidom">Apellido Materno</label>
			<input type="text" class="form-control" id="apellidom" name="apellidom" placeholder="Apellido Materno" value="<?php if(isset($usuarioBean)){ echo $usuarioBean->getApellidomUsu(); } ?>">
		</div>
	</div>

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="depto">Departamentos</label>
			<select class="selectpicker form-control" id="depto" name="depto" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($departamentos as $depto) {
						$sel="";
						if(isset($usuarioBean) && $depto->value==$usuarioBean->getDeptoUsu()){
							$sel="selected";
						}
							echo "<option value='".$depto->value."' ".$sel.">".$depto->text."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="puesto">Puesto</label>
			<select class="selectpicker form-control" id="puesto" name="puesto" data-live-search="true">
				<option value='0'>Todos...</option>
				
			</select>
		</div>
	</div>

	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="correo">Correo</label>
			<input type="text" class="form-control" id="correo" name="correo" placeholder="Correo" value="<?php if(isset($usuarioBean)){ echo $usuarioBean->getCorreoUsu(); } ?>">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="telefono">Telefono</label>
			<input type="text" class="form-control" id="telefono" name="telefono" placeholder="Telefono" value="<?php if(isset($usuarioBean)){ echo $usuarioBean->getTelefonoUsu(); } ?>">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="usuario">Usuario</label>
			<input type="text" class="form-control" id="usuario" name="usuario" placeholder="Usuario" value="<?php if(isset($usuarioBean)){ echo $usuarioBean->getUsuarioUsu(); } ?>">
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-6 col-xl-2 ">
		<div class="form-group">
			<label for="contrasena">Contraseña</label>
			<input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Contraseña"  value="">
		</div>
	</div>

	<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
		<center>
			<?php
				if(isset($usuarioBean)){
			?>
				<button class="btn btn-info" type="button" onclick="guardarUsuario('<?php if(isset($usuarioBean)){ echo $usuarioBean->getIdUsu(); } ?>')">Actualizar</button>
			<?php }else{ ?>
				<button class="btn btn-success" type="button" onclick="guardarUsuario('')">Agregar</button>
			<?php } ?> 
		</center>
	</div>
</div>


<script type="text/javascript" src="vistas/usuarios/js/form1.js"></script>
<script type="text/javascript">
	puesto=""
	<?php
		if(isset($usuarioBean)){
	?>		
			cargarPuestos()
			puesto = '<?php echo $usuarioBean->getPuestoUsu(); ?>';
	<?php		
		}
	?>
</script>