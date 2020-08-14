<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$hotel= $con->consulta("*","hoteles_volar"," id_hotel=". $_POST['id']);
	} 	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$estados = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='estados' ");

?>
<div class="row"> 
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="nombre">Nombre</label>
			<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre" value="<?php if(isset($hotel)){echo ($hotel[0]->nombre_hotel);} ?>" >
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="calle">Calle</label>
			<input type="text" class="form-control" id="calle" name="calle" placeholder="Calle" value="<?php if(isset($hotel)){echo utf8_encode($hotel[0]->calle_hotel);} ?>" >
		</div>
	</div>
	<div class="col-sm-2 col-lg-2 col-md-2 col-4 col-xl-2 ">
		<div class="form-group">
			<label for="noint">No. Int.</label>
			<input type="text"  class="form-control" id="noint" name="noint" placeholder="No. Interior" value="<?php if(isset($hotel)){echo $hotel[0]->noint_hotel;} ?>" >
		</div>
	</div>
	<div class="col-sm-2 col-lg-2 col-md-2 col-4 col-xl-2 ">
		<div class="form-group">
			<label for="noext">No. Ext.</label>
			<input type="text"  class="form-control" id="noext" name="noext" placeholder="No. Exterior" value="<?php if(isset($hotel)){echo $hotel[0]->noext_hotel;} ?>" >
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="colonia">Colonia</label>
			<input type="text" class="form-control" id="colonia" name="colonia" placeholder="Colonia" value="<?php if(isset($hotel)){echo ($hotel[0]->colonia_hotel);} ?>" >
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="municipio">Municipio</label>
			<input type="text" class="form-control" id="municipio" name="municipio" placeholder="Municipio" value="<?php if(isset($hotel)){echo ($hotel[0]->municipio_hotel);} ?>" >
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="estado">Estado</label>
			<select class="selectpicker form-control" id="estado" name="estado" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($estados as $estado) {
						$opcEstado="";
						if($estado->value == $hotel[0]->estado_hotel){
							$opcEstado="selected";
						}
						echo "<option value='".$estado->value."' ".$opcEstado.">".($estado->text)."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<div class="col-sm-2 col-lg-2 col-md-2 col-4 col-xl-2 ">
		<div class="form-group">
			<label for="cp">C.P.</label>
			<input type="text" class="form-control" id="cp" name="cp" placeholder="C.P." value="<?php if(isset($hotel)){echo $hotel[0]->cp_hotel;} ?>" >
		</div>
	</div>
	<div class="col-sm-5 col-lg-5 col-md-5 col-6 col-xl-5 ">
		<div class="form-group">
			<label for="telefono">Telefono</label>
			<input type="number" min="0" class="form-control" id="telefono" name="telefono" placeholder="Telefono"  value="<?php if(isset($hotel)){echo $hotel[0]->telefono_hotel;} ?>"  >
		</div>
	</div>
	<div class="col-sm-5 col-lg-5 col-md-5 col-6 col-xl-5 ">
		<div class="form-group">
			<label for="telefono2">Telefono 2</label>
			<input type="number" min="0" class="form-control" id="telefono2" name="telefono2" placeholder="Telefono"  value="<?php if(isset($hotel)){echo $hotel[0]->telefono2_hotel;} ?>"  >
		</div>
	</div>
</div>


