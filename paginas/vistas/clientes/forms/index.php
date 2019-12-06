<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	if($_POST['id']!='' && $_POST['id']!='0' ){
		$cliente=$con->consulta("*","clientes_volar"," id_cliente=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$paises = $con->consulta("id_pais as value, CONCAT(nombre_pais,'(',IFNULL(isocode2_pais,''),')') as text","paises_volar"," status<>0");
	$opc1="";
	$opc2="";
	$cond1="";
	$cond2="";
	if(isset($cliente)){
		if($cliente[0]->tipo_cliente==1){
			$opc1="selected";
		}else if($cliente[0]->tipo_cliente==2){
			$opc2="selected";
		}
	}
	if(isset($cliente)){
		if($cliente[0]->condicion_cliente==1){
			$cond1="selected";
		}else if($cliente[0]->condicion_cliente==2){
			$cond2="selected";
		}
	}

?>
<form id="clienteForm" action="controladores/clientesController.php" method="post" >
	<?php if(isset($cliente)){ ?>
		<input type="hidden" name="id" value="<?php echo $_POST['id'] ?>" id="id">
		<input type="hidden" name="accion" value="editar">
	<?php }else{ ?>
		<input type="text" name="accion" value="agregar">
	<?php } ?>
	<fieldset>
		<legend>Datos de Facturación</legend>
		<div class="row">
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="rs"><span style="color:red">*</span>Razón Social</label>
					<input type="text" class="form-control" id="rs" name="rs" placeholder="Razón Social" required value="<?php if(isset($cliente)){echo $cliente[0]->rs_cliente;} ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="rfc"><span style="color:red">*</span>RFC</label>
					<input type="text" class="form-control" id="rfc" name="rfc" placeholder="RFC" required value="<?php if(isset($cliente)){echo $cliente[0]->rfc_cliente;} ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="tipo"><span style="color:red">*</span>Tipo de Cliente</label>
					<select class="selectpicker form-control" id="tipo" name="tipo" data-live-search="true"required placeholder="Tipo de Cliente" >
							<option value=''>Selecciona una Opcion...</option>
							<option value="1" <?php echo $opc1; ?>>Fisica</option>
							<option value="2" <?php echo $opc2; ?>>Moral</option>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="condicion"><span style="color:red">*</span>Condición Comercial</label>
					<select class="selectpicker form-control" id="condicion" name="condicion" required ata-live-search="true" placeholder="Condición Comercial">
							<option value=''>Selecciona una Opcion...</option>
							<option value="1" <?php echo $cond1; ?>>Crédito</option>
							<option value="2" <?php echo $cond2; ?>>Contado</option>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="dias"><span style="color:green">*</span>Días de Crédito</label>
					<input type="text" class="form-control" id="dias" name="dias" onkeypress="return isNumber(event)" placeholder="Días de Crédito" required value="<?php if(isset($cliente)){echo $cliente[0]->dias_cliente;}else{ echo 0; } ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="telefono"><span style="color:red">*</span>Teléfono</label>
					<input type="number" class="form-control" id="telefono" name="telefono" onkeypress="return isNumber(event)" placeholder="Teléfono" required value="<?php if(isset($cliente)){echo $cliente[0]->telefono_cliente;} ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="correo"><span style="color:red">*</span>Correo</label>
					<input type="email" class="form-control" id="correo" name="correo"  placeholder="Correo" required value="<?php if(isset($cliente)){echo $cliente[0]->correo_cliente;} ?>" >
				</div>
			</div>
		</div>
	</fieldset>
	<fieldset>
		<legend> Dirección Fiscal </legend>
		<div class="row">
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="calle"><span style="color:red">*</span>Calle</label>
					<input type="text" class="form-control" id="calle" name="calle" placeholder="Calle" required value="<?php if(isset($cliente)){echo $cliente[0]->calle_cliente;} ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="noint">No. Interior</label>
					<input type="text" class="form-control" id="noint" name="noint" placeholder="No. Interior" value="<?php if(isset($cliente)){echo $cliente[0]->noint_cliente;}else{ echo 'NA'; } ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="noext">No. Exterior</label>
					<input type="text" class="form-control" id="noext" name="noext" placeholder="No. Exterior" value="<?php if(isset($cliente)){echo $cliente[0]->noext_cliente;}else{ echo 'NA'; } ?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="colonia"><span style="color:red">*</span>Colonia</label>
					<input type="text" class="form-control" id="colonia" name="colonia" placeholder="Colonia" required value="<?php if(isset($cliente)){echo $cliente[0]->colonia_cliente;}?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group has-error">
					<label for="municipio"><span style="color:red">*</span>Municipio</label>
					<input type="text" class="form-control " id="municipio" name="municipio"  required placeholder="Municipio" value="<?php if(isset($cliente)){echo $cliente[0]->municipio_cliente;}?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="cp"><span style="color:red">*</span>Código Postal</label>
					<input type="text" class="form-control" id="cp" name="cp" placeholder="Código Postal"  required value="<?php if(isset($cliente)){echo $cliente[0]->cp_cliente;}?>" >
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="pais"><span style="color:red">*</span>País</label>
					<select class="selectpicker form-control" id="pais" name="pais" data-live-search="true" required placeholder="País">
							<option value=''>Selecciona una Opcion...</option>
							<?php
									foreach ($paises as $pais) {
										$sel = "";
										if(isset($cliente)){
											if($pais->value==$cliente[0]->pais_cliente){
												$sel='selected="selected"';
											}
										}elseif($pais->value == "138"){
											$sel='selected="selected"';
										}
										echo '<option value="'.$pais->value.'" '.$sel.' >'.$pais->text.'</option>';
									}
							?>
					</select>
				</div>
			</div>
			<div class="col-6 col-sm-4 col-md-4 col-lg-3  col-xl-3 ">
				<div class="form-group">
					<label for="estado"><span style="color:red">*</span>Estado</label>
					<select class="selectpicker form-control" id="estado" name="estado" data-live-search="true" required placeholder="Estado">
							<option value=''>Selecciona una Opcion...</option>
					</select>
				</div>
			</div>
		</div>
	</fieldset>

	<div class="col-12 col-sm-12 col-md-12 col-lg-12  col-xl-12 ">
		<button type="button" name="button" onclick="enviarForm();" class="btn btn-primary btn-lg">Enviar</button>
	</div>
</form>
<script type="text/javascript">
	estado = "";
	<?php if(isset($cliente[0]->estado_cliente)){ ?>
		estado = "<?php echo $cliente[0]->estado_cliente ?>";
	<?php } ?>
</script>
<script type="text/javascript" src="vistas/clientes/js/form1.js"></script>
