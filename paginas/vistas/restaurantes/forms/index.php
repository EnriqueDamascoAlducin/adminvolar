<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$restaurant= $con->consulta("*","restaurantes_volar"," id_restaurant=". $_POST['id']);
	} 	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$estados = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='estados' ");
	$hoteles = $con->consulta("nombre_hotel as text, id_hotel as value","hoteles_volar","status<>0 ");
	$cont=0;
?>
<div class="row"> 
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="nombre">Nombre</label>
			<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre" value="<?php if(isset($restaurant)){echo ($restaurant[0]->nombre_restaurant);} ?>" >
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " id="divHotel">
		<div class="form-group">
			<label for="hotel">Es de un Hotel?</label>
			<select class="selectpicker form-control" id="hotel" name="hotel" data-live-search="true">
				<option value='0'>No</option>
				<?php
					foreach ($hoteles as $hotel) {
						$opcHotel="";
						if($hotel->value == $restaurant[0]->hotel_restaurant){
							$opcHotel="selected";$cont++;
						}
						echo "<option value='".$hotel->value."' ".$opcHotel.">".($hotel->text)."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
</div>
<div class="row" id="divDatos" style="display: <?php if($cont>0){echo 'none'; } ?>"> 
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="calle">Calle</label>
			<input type="text" class="form-control" id="calle" name="calle" placeholder="Calle" value="<?php if(isset($restaurant)){echo ($restaurant[0]->calle_restaurant);} ?>" >
		</div>
	</div>
	<div class="col-sm-2 col-lg-2 col-md-2 col-4 col-xl-2 ">
		<div class="form-group">
			<label for="noint">No. Int.</label>
			<input type="text"  class="form-control" id="noint" name="noint" placeholder="No. Interior" value="<?php if(isset($restaurant)){echo $restaurant[0]->noint_restaurant;} ?>" >
		</div>
	</div>
	<div class="col-sm-2 col-lg-2 col-md-2 col-4 col-xl-2 ">
		<div class="form-group">
			<label for="noext">No. Ext.</label>
			<input type="text"  class="form-control" id="noext" name="noext" placeholder="No. Exterior" value="<?php if(isset($restaurant)){echo $restaurant[0]->noext_restaurant;} ?>" >
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="colonia">Colonia</label>
			<input type="text" class="form-control" id="colonia" name="colonia" placeholder="Colonia" value="<?php if(isset($restaurant)){echo ($restaurant[0]->colonia_restaurant);} ?>" >
		</div>
	</div>
	<div class="col-sm-4 col-lg-4 col-md-4 col-6 col-xl-4 ">
		<div class="form-group">
			<label for="municipio">Municipio</label>
			<input type="text" class="form-control" id="municipio" name="municipio" placeholder="Municipio" value="<?php if(isset($restaurant)){echo ($restaurant[0]->municipio_restaurant);} ?>" >
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
						if($estado->value == $restaurant[0]->estado_restaurant){
							$opcEstado="selected";
						}
						echo "<option value='".$estado->value."' ".$opcEstado.">".($estado->text)."</option>";
					}
				?>
				
			</select>
		</div>
	</div>
	<div class="col-sm-3 col-lg-3 col-md-3 col-4 col-xl-3 ">
		<div class="form-group">
			<label for="cp">C.P.</label>
			<input type="text" class="form-control" id="cp" name="cp" placeholder="C.P." value="<?php if(isset($restaurant)){echo $restaurant[0]->cp_restaurant;} ?>" >
		</div>
	</div>
	<div class="col-sm-5 col-lg-5 col-md-5 col-6 col-xl-5 ">
		<div class="form-group">
			<label for="telefono">Telefono</label>
			<input type="number" min="0" class="form-control" id="telefono" name="telefono" placeholder="Telefono"  value="<?php if(isset($restaurant)){echo $restaurant[0]->telefono_restaurant;} ?>"  >
		</div>
	</div>
	<div class="col-sm-5 col-lg-5 col-md-5 col-6 col-xl-5 ">
		<div class="form-group">
			<label for="telefono2">Telefono 2</label>
			<input type="number" min="0" class="form-control" id="telefono2" name="telefono2" placeholder="Telefono"  value="<?php if(isset($restaurant)){echo $restaurant[0]->telefono2_restaurant;} ?>"  >
		</div>
	</div>
</div>
<div class="row">

	<div class="col-sm-5 col-lg-5 col-md-5 col-6 col-xl-5 ">
		<div class="form-group">
			<label for="precion">Precio Niño</label>
			<input type="number" min="0" class="form-control" id="precion" name="precion" placeholder="Precio Niño"  value="<?php if(isset($restaurant)){echo $restaurant[0]->precion_restaurant;} ?>"  >
		</div>
	</div>
	<div class="col-sm-5 col-lg-5 col-md-5 col-6 col-xl-5 ">
		<div class="form-group">
			<label for="precioa">Precio Adulto</label>
			<input type="number" min="0" class="form-control" id="precioa" name="precioa" placeholder="Precio Adulto"  value="<?php if(isset($restaurant)){echo $restaurant[0]->precioa_restaurant;} ?>"  >
		</div>
	</div>
</div>


<script type="text/javascript" src="vistas/restaurantes/js/form1.js"></script>