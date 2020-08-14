<?php 
	$servicios = $con->consulta("nombre_servicio as nombre, id_servicio as id, precio_servicio as precio, img_servicio as imagen ","servicios_volar","status<>0");
?>
	<div class="row">
		<?php foreach ($servicios as $servicio) { ?>

		<div class="col-6 col-sm-3 col-md-3 col-lg-3 col-xl-2" >
			<div class="card" style="width: 100%;height: 10rem">
				<center>
					<img class="card-img-top" src="../sources/images/servicios/<?php echo $servicio->imagen; ?>" alt="Card image cap " style ="width: 25%;max-width: 25%;margin-top: 3% " >
				</center>
				<div class="card-body">
					<label class="card-title"><?php echo $servicio->nombre; ?></label>
					<p class="card-text" style="margin-top: -20px;"><?php echo $servicio->precio; ?> </p>
					<div class="row" style="position: absolute; bottom: 0;max-width: 90%">
						<?php if(!isset($ventas)){ ?>
						<button class="btn-danger btn-sm" style="max-width: 20%;" onclick="disminuir(<?php echo $servicio->id ?>)"><i class="fa fa-minus fa-sm" ></i></button>
						
						<input type="number" min="0" onblur="validarValor(this.id)" onkeypress="return isNumber(event);" name="cantidad_<?php echo $servicio->id; ?>" id="cantidad_<?php echo $servicio->id; ?>" style="max-width: 60%;border-color: black!important;border-width: 1px!important;border-style: ridge!important;" value="0" >
						<button style="max-width: 20%;" class="btn-info btn-sm" onclick="aumentar(<?php echo $servicio->id ?>)"><i class="fa fa-plus"></i></button>
						<?php } else{ 
								$parametros = $_POST['id'].','.$servicio->id.',@respuesta';
								$con->query("CALL getServiciosXVta(".$parametros.")");
								$respuesta = $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);
								echo $respuesta[0]->respuesta;
						?>


						<input type="number" min="0" onblur="validarValor(this.id)" onkeypress="return isNumber(event);" name="cantidad_<?php echo $servicio->id; ?>" id="cantidad_<?php echo $servicio->id; ?>" style="max-width: 60%;border-color: black!important;border-width: 1px!important;border-style: ridge!important;display:none;" value="<?php echo $respuesta[0]->respuesta; ?>" >
						<?php 
						} ?>
					</div>
				</div>
			</div>
		</div>
		<?php } ?>
	</div>
	