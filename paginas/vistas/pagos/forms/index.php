<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$gasto= $con->consulta("fecha_gasto,tipo_gasto,cantidad_gasto,metodo_gasto,referencia_gasto,comentario_gasto","gastos_volar"," id_gasto=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$tipos = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='tipogastos' ");
	$opc1="";
	$opc2="";
	$opc3="";
	if(isset($gasto)){
		if($gasto[0]->metodo_gasto==1){
			$opc1="selected";
		}else if($gasto[0]->metodo_gasto==2){
			$opc2="selected";
		}elseif($gasto[0]->metodo_gasto==3){
			$opc3 ="selected";
		}
	}

?>
<div class="row"> 
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="fecha">Fecha de Gasto</label>
			<input type="date" class="form-control" id="fecha" name="fecha" placeholder="Fecha" value="<?php if(isset($gasto)){echo $gasto[0]->fecha_gasto;} ?>" >
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="tipo">Tipo de Gasto</label>
			<select class="selectpicker form-control" id="tipo" name="tipo" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($tipos as $tipo) {
						$opcTipo="";
						if($tipo->value == $gasto[0]->tipo_gasto){
							$opcTipo="selected";
						}
						echo "<option value='".$tipo->value."' ".$opcTipo.">".$tipo->text."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="cantidad">Cantidad</label>
			<input type="number" min="0" class="form-control" id="cantidad" name="cantidad" placeholder="Cantidad"  value="<?php if(isset($gasto)){echo $gasto[0]->cantidad_gasto;} ?>"  >
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="metodo">Pagado con</label>
			<select class="selectpicker form-control" id="metodo" name="metodo" data-live-search="true">
				<option value='0'>Todos...</option>
				<option value="1" <?php echo $opc1; ?>>Efectivo</option>
				<option value="2" <?php echo $opc2; ?>>T. Credito</option>
				<option value="3" <?php echo $opc3; ?>>Ambos</option>
			</select>
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="referencia">Referencia</label>
			<input type="text" class="form-control" id="referencia" name="referencia" placeholder="Referencia"   value="<?php if(isset($gasto)){echo $gasto[0]->referencia_gasto;} ?>">
		</div>
	</div>
	<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
		<div class="form-group">
			<label for="comentario">Comentario</label>
			<textarea  class="form-control" id="comentario" name="comentario"><?php if(isset($gasto)){echo $gasto[0]->comentario_gasto;} ?></textarea>
		</div>
	</div>
</div>


<script type="text/javascript" src="vistas/usuarios/js/form1.js"></script>
