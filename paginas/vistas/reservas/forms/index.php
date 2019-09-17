<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	include_once $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/reserva.php';	
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$bloqueado="";
	if(isset($_POST['accion'])){
		$bloqueado = "bloqueado";
		$actId = $_POST['id'];
		$getReservaData = $con->query("CALL getReservaData(".$actId.")")->fetchALL (PDO::FETCH_OBJ);
		$reserva = crearReserva($getReservaData);
	}
	$procedencias = $con->consulta("id_extra,nombre_extra","extras_volar","status <> 0 and clasificacion_extra='estados'");
	$motivos = $con->consulta("id_extra,nombre_extra","extras_volar","status <> 0 and clasificacion_extra='motivos'");
	$clasificacionesTipoV = $con->consulta("nombre_extra,id_extra","extras_volar","status<>0 and id_extra in (Select DISTINCT (tipo_vc) FROM vueloscat_volar where status <> 0 )");
	$hoteles= $con->consulta("id_hotel,nombre_hotel","hoteles_volar","status<>0");
	$servicios = $con->consulta("*","servicios_volar","status<>0"); 
	$id = $_POST['id'];
	if(!isset($_POST['accion'])){
		if($id==""){
			$registrarNuevo= $con->query("CALL registrarReserva(".$usuario->getIdUsu().",@LID);");
		}else{
			$remplazarReserva = $con->query("CALL remplazarReserva(".$id.",".$usuario->getIdUsu().", @LID);");
		}
		$oldId = $id;
		$consultaNuevo = $con->query("Select @LID as id")->fetchALL (PDO::FETCH_OBJ);
		$actId=$consultaNuevo[0]->id;
		$getReservaData = $con->query("CALL getReservaData(".$actId.")")->fetchALL (PDO::FETCH_OBJ);
		$reserva = crearReserva($getReservaData);
		if($id!=""){
			$remplazarServiciosReservas = $con->query("CALL remplazarServiciosReservas($actId, $oldId)");
		}
	}
?>
<style type="text/css">
	<?php 
		if($bloqueado=="bloqueado"){
	?>
			input{
				pointer-events:none;
			}
			select{
				pointer-events:none;
			}

			textarea{
				pointer-events:none;
			}

			button{
				display: none;
			}
			.btn{
				display: none;
			}
	<?php
		}
	?>
	input:hover{
		box-sizing:  border-box;
		border-color: #0091ea !important;
		border-width: 1px !important;
	}
	select:hover{
		box-sizing:  border-box;
		border-color: #0091ea !important;
		border-width: 1px !important;
	}
	textarea:hover{
		box-sizing:  border-box;
		border-color: #0091ea !important;
		border-width: 1px !important;
	}
	
	input[type="checkbox"] {
	    display: none;
	}
	input[name^="cortesia"]:checked + label   #imgChecked {
	     display:block;
	}
	input[name^="precio_"]:checked + label #imgChecked  {
	    display:block;
	}
	#imgChecked{
		display: none;
	}
</style>
<div class="row" style="text-align: center;">
	<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12">
		<label style="text-align: center;"><B>Captura una Nueva Cotización <i><?php echo $actId; ?></i></B></label>
	</div>
</div>
<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" style="background-color:#3674B2 ">
	<i style="color:white">Datos Generales</i>
</div>
<div class="row">
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="nombre"><b>Nombre</b></label>
		    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre" value="<?php echo $reserva->getNombreTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="apellidos"><b>Apellidos</b></label>
		    <input type="text" class="form-control" id="apellidos" name="apellidos" placeholder="Apellidos" value="<?php echo $reserva->getApellidosTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="mail"><b>Email</b></label>
		    <input type="mail" class="form-control" id="mail" name="mail" placeholder="Correo" value="<?php echo $reserva->getMailTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="apellidos"><b>Contacto 1</b></label>
		    <input type="number" min="0"  class="form-control" id="telcelular" name="telcelular" placeholder="Contacto 1" value="<?php echo $reserva->getTelcelularTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="telfijo"><b>Contacto 2</b></label>
		    <input type="number" min="0"  class="form-control" id="telfijo" name="telfijo" placeholder="Contacto 2" value="<?php echo $reserva->getTelfijoTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group ">
	      	<label for="procedencia"><b>Procedencia</b></label>
	      	<select id="procedencia" name="procedencia" class="form-control">
	        	<option selected value="">Procedencia</option>
	        	<?php 
	        		foreach ($procedencias as $procedencia) {
	        			$sel="";
	        			if($reserva->getNombreTemp() == $procedencia->id_extra ){
	        				$sel="selected";
	        			}
	        	?>
	        		<option value="<?php echo $procedencia->id_extra; ?>" <?php echo $sel; ?> > <?php echo $procedencia->nombre_extra; ?></option>
	        	<?php
	        		}
	        	?>
	      	</select>
	    </div>
	</div>

	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="pasajerosa"><b>Adultos</b></label>
		    <input type="number" min="0"  class="form-control" id="pasajerosa" name="pasajerosa" placeholder="Pasajeros Adultos" value="<?php echo $reserva->getPasajerosaTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="pasajerosn"><b>Niños</b></label>
		    <input type="number" min="0"  class="form-control" id="pasajerosn" name="pasajerosn" placeholder="Pasajeros Niños" value="<?php echo $reserva->getPasajerosnTemp(); ?>">
	  	</div>
	</div>

	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group ">
	      	<label for="motivo" ><b>Motivo</b></label>
	      	<select id="motivo" name="motivo" class="form-control">
	        	<option selected value="">Motivo</option>
	        	<?php 
	        		foreach ($motivos as $motivo) {
	        			$sel="";
	        			if($reserva->getMotivoTemp() == $motivo->id_extra ){
	        				$sel="selected";
	        			}
	        	?>
	        		<option value="<?php echo $motivo->id_extra; ?>" <?php echo $sel; ?>><?php echo $motivo->nombre_extra; ?></option>
	        	<?php
	        		}
	        	?>
	      	</select>
	    </div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group ">
	      	<label for="tipo" ><b>Tipo de Vuelo</b></label>
	      	<select id="tipo" name="tipo" class="form-control">
	        	<option selected value="">Tipo de Vuelo</option>
	        	<?php 
	        		foreach ($clasificacionesTipoV as $clasificacionTipoV) { 
	        	?>
	        		<optgroup label="<?php echo $clasificacionTipoV->nombre_extra ?>">
		        		<?php $tiposV = $con->consulta("nombre_vc,id_vc","vueloscat_volar","status<>0 and tipo_vc=". $clasificacionTipoV->id_extra); ?>
		        		<?php 
		        			foreach ($tiposV as $tipoV) {
		        				$sel="";
			        			if($reserva->getTipoTemp() == $tipoV->id_vc ){
			        				$sel="selected";
			        			}
		        		?>
		        			<option value = "<?php echo $tipoV->id_vc ?>" <?php echo $sel; ?>><?php echo $tipoV->nombre_vc ?></option>
		        		<?php
			        		}
			        	?>
		        	</optgroup>
	        	<?php 
	        		} 
	        	?>
	      	</select>
	    </div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" >
		<div class="form-group">
		    <label for="fechavuelo"><b>Fecha de Vuelo</b></label>
		    <input type="date"   class="form-control" id="fechavuelo" name="fechavuelo" value="<?php echo $reserva->getFechavueloTemp(); ?>">
	  	</div>
	</div>
</div>
<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" style="background-color: #3674B2">
	<i style="color:white">Hospedaje</i>
</div>
<div class="row">
	
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group ">
	      	<label for="hotel" ><b>Hotel</b></label>
	      	<select id="hotel" name="hotel" class="form-control">
	        	<option selected value="">Hotel</option>
	        	<?php
	        		foreach ($hoteles as $hotel) {
	        			$sel="";
	        			if($reserva->getHotelTemp() == $hotel->id_hotel){
	        				$sel="selected";
	        			}
	        	?>
	        		<option value="<?php echo $hotel->id_hotel ?>" <?php echo $sel; ?> ><?php echo $hotel->nombre_hotel ?></option>
	        	<?php
	        		}
	        	?>
	      	</select>
	    </div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group ">
	      	<label for="habitacion" ><b>Habitación</b></label>
	      	<select id="habitacion" name="habitacion" class="form-control">
	        	<option selected value="">Habitación</option>
	      	</select>
	    </div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group">
		    <label for="checkin"><b>Check In</b></label>
		    <input type="date"   class="form-control" id="checkin" name="checkin" placeholder="CheckIn"  value="<?php echo $reserva->getCheckinTemp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group">
		    <label for="checkout"><b>Check Out</b></label>
		    <input type="date"   class="form-control" id="checkout" name="checkout" placeholder="CheckOut" value="<?php echo $reserva->getCheckoutTemp(); ?>">
	  	</div>
	</div>
</div>

<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" style="background-color: #3674B2 ">
	<i style="color:white">Servicios</i>
</div>

<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" >
<div class="row">
<?php
	foreach ($servicios as $servicio) {
		$precio = "";
		$cortesia = "";
		$getPrecio = $con->query("CALL getServiciosReservas($actId,1,$servicio->id_servicio)")->fetchALL (PDO::FETCH_OBJ);
		$getCortesia = $con->query("CALL getServiciosReservas($actId,2,$servicio->id_servicio)")->fetchALL (PDO::FETCH_OBJ);
		
		if(sizeof($getPrecio)>0){
			$precio = "checked";
		}
		if(sizeof($getCortesia)>0){
			$cortesia = "checked";
		}
		//precio es 2 y de cortesia es 1
?>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-2" style="border-style: groove;height: 150px;max-height: 150px;" >
		<div class="row" style="height: 100%;max-height: 100%;">
			<div class="col-7 col-md-6 col-lg-6 col-sm-6 col-xl-6" style="border-style: groove;margin-left: -5px">


				<input type="checkbox" name="precio_<?php echo $servicio->id_servicio; ?>" onchange ="validar_servicio(this,<?php  echo $servicio->cantmax_servicio; ?>)" id="precio_<?php echo $servicio->id_servicio; ?>" <?php echo $precio ?>>
				<label for="precio_<?php echo $servicio->id_servicio; ?>" style="margin-left: -25px;position: absolute;float: left">
					<figure class="figure">
					  	<img src="../sources/images/servicios/<?php echo $servicio->img_servicio; ?>" class="figure-img img-fluid rounded" alt="<?php echo $servicio->nombre_servicio; ?>" style="max-height: 50px;height: 50px;width: 50%; max-width: 50%;">
					  	<img src="../sources/images/icons/check2.png" class="figure-img img-fluid rounded" alt="<?php echo $servicio->nombre_servicio; ?>" id="imgChecked" style="max-height: 70px;height: 70px;width: 66%; max-width: 65%;position: absolute;margin-top: -15px">
					  	<figcaption class="figure-caption" style="margin-top: -2px;width: 50%; max-width: 50%;text-align: center;">
					  		<label>
					  			<small class="label"  style="color:black;z-index: -1;text-align: center;">
					  			<?php 
					  				$servis = explode(" ", $servicio->nombre_servicio); 
					  				foreach ($servis as $servi) {
					  					if(strlen($servi)>2){
						  					echo substr($servi, 0, 11).'<br>';
						  				}else{
						  					echo $servi;
						  				}
					  				}
						  			echo '('.number_format($servicio->precio_servicio, 2, '.', ',').')';
					  			?>
					  				
					  		</small> 
					  	</label>
					  	</figcaption>
					</figure>
				</label>
			</div>
			<div class="col-5 col-md-6 col-lg-6 col-sm-6 col-xl-6" style="border-style: groove; vertical-align: middle;z-index: 2">
				<input type="checkbox" onchange ="validar_servicio(this,<?php  echo $servicio->cantmax_servicio; ?>)"  name="cortesia_<?php echo $servicio->id_servicio; ?>" id="cortesia_<?php echo $servicio->id_servicio; ?>" <?php echo $cortesia; ?>>
				<label for="cortesia_<?php echo $servicio->id_servicio; ?>" class="badge" style="color:black;margin-left: -25px;position: absolute;float: left"><b>Cortesia</b>
					<img src="../sources/images/icons/check2.png" class="figure-img img-fluid rounded" alt="<?php echo $servicio->nombre_servicio; ?>" id="imgChecked" style="max-height: 50px;height: 50px;width: 50%; max-width: 50%;position: absolute;">
				</label>
				
				
			</div>
		</div>
	</div>
<?php
	} 
?>
</div>
</div>
<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" style="background-color: #3674B2 ">
	<i style="color:white">Otros</i>
</div>
<div class="row">
	<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" >
		<div class="form-group">
		    <label for="comentario"><b>Comentarios</b></label>
		    <textarea class="form-control" id="comentario" name="comentario" rows="3" ><?php echo $reserva->getComentarioTemp(); ?></textarea>
	  	</div>
	 </div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group">
		    <label for="otroscar1"><b>Otros Cargos</b></label>
		    <input type="text"   class="form-control" id="otroscar1" name="otroscar1" placeholder="Otros Cargos" value="<?php echo $reserva->getOtroscar1Temp(); ?>">
	  	</div>
	</div>

	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group">
		    <label for="precio1"><b>Precio</b></label>
		    <input type="number" min="0"  class="form-control" id="precio1" name="precio1" placeholder="Precio" value="<?php echo $reserva->getPrecio1Temp(); ?>">
	  	</div>
	</div>
	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group">
		    <label for="otroscar2"><b>Otros Cargos</b></label>
		    <input type="text"   class="form-control" id="otroscar2" name="otroscar2" placeholder="Otros Cargos"  value="<?php echo $reserva->getOtroscar2Temp(); ?>">
	  	</div>
	</div>

	<div class="col-6 col-md-3 col-sm-3 col-md-3 col-xl-3" >
		<div class="form-group">
		    <label for="precio2"><b>Precio</b></label>
		    <input type="number" min="0"  class="form-control" id="precio2" name="precio2" placeholder="Precio"  value="<?php echo $reserva->getPrecio2Temp(); ?>">
	  	</div>
	</div>
</div>

<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" style="background-color: #3674B2 ">
	<i style="color:white">Descuentos</i>
</div>
<div class="row">

	<div class="col-6 col-md-6 col-sm-6 col-md-6 col-xl-6" >
		<div class="form-group ">
			<?php 
				$por = "";
				$pes = "";
				if($reserva->getTdescuentoTemp()==1){
					$por="selected";
				}else if($reserva->getTdescuentoTemp()==2){
					$pes="selected";
				}
			?>
	      	<label for="tdescuento" ><b>Tipo de Descuento</b></label>
	      	<select id="tdescuento" name="tdescuento" class="form-control">
	        	<option selected value="">Tipo de Descuento</option>
	        	<option  value="1" <?php echo $por; ?>>Porcentaje</option>
	        	<option  value="2" <?php echo $pes; ?>>Pesos</option>
	      	</select>
	    </div>
	</div>
	<div class="col-6 col-md-6 col-sm-6 col-md-6 col-xl-6" >
		<div class="form-group">
		    <label for="cantdescuento"><b>Descuento</b></label>
		    <input type="number" min="0"  class="form-control" id="cantdescuento" name="cantdescuento" placeholder="Descuento"  value="<?php echo $reserva->getCantdescuentoTemp(); ?>">
	  	</div>
	</div>
</div>
<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" style="background-color: #3674B2 ">
	<i style="color:white">Cotizar </i>
</div>
<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12" >
	<div class="container" style="margin-top: 8px;">
		<?php if($_POST['id']==""){ ?>	
			<button class="btn btn-success" type="button"  data-toggle="modal" data-target="#cotizacion"  onclick="mostrarCotizacion(<?php echo $actId; ?>, 'enviar')">Enviar Cotización</button>
		<?php }else{ ?>
			<button class="btn btn-primary" type="button"   data-toggle="modal" data-target="#cotizacion" onclick="mostrarCotizacion(<?php echo $actId; ?>, 'reenviar')">Reenviar Cotización</button>
		<?php } ?>
	</div>
</div>

<!-- Modal -->
<div class="modal fade" id="cotizacion" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg" role="dialog">
    <div class="modal-content ">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Enviar Cotización</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="cuerpoCotizacion">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary"  data-dismiss="modal" id="ConfirmarCotizacion">Confirmar</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
	var idAct = <?php echo $actId ?>; 
	var habitacion = "<?php echo $reserva->getHabitacionTemp(); ?>";


</script>
<script type="text/javascript" src="vistas/reservas/js/form1.js"></script>
<script type="text/javascript">
	<?php
		if($reserva->getHotelTemp()!=""){
	?>
		cargarHabitaciones();
	<?php
		}
	?>
</script>