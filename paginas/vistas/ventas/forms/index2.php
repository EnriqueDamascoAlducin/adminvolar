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
						<button class="btn-info btn-sm" style="max-width: 20%;" onclick="disminuir(<?php echo $servicio->id ?>)"><i class="fa fa-minus fa-sm" ></i></button>
						<input type="number" onblur="validarValor(this.id)" onkeypress="return isNumber(event,this);" name="cantidad_<?php echo $servicio->id; ?>" id="cantidad_<?php echo $servicio->id; ?>" style="max-width: 60%;border-color: black!important;border-width: 1px!important;border-style: ridge!important;" value="0">
						<button style="max-width: 20%;" class="btn-info btn-sm" onclick="aumentar(<?php echo $servicio->id ?>)"><i class="fa fa-plus"></i></button>
					</div>
				</div>
			</div>
		</div>
		<?php } ?>
	</div>
<script type="text/javascript">
	function validarValor(id){
		if($("#"+id).val().trim()==''){
			$("#"+id).val(0);
		}
	}
	function aumentar(id){
		var valActual = ($("#cantidad_"+id).val());
		if(valActual==''){
			valActual=0;
		}
		var nuevoValor = parseInt(valActual)+1;
		$("#cantidad_"+id).val(nuevoValor);
	}
	function disminuir(id){
		var valActual = $("#cantidad_"+id).val();
		if(valActual==''){
			valActual=0;
		}
		var nuevoValor = parseInt(valActual)-1;
		if(nuevoValor<0){
			$("#cantidad_"+id).val(0);
			abrir_gritter("Advertencia","No puedes poner un valor menor a 0","warning");
		}else{
			$("#cantidad_"+id).val(nuevoValor);
		}
	}
	function isNumber(event,este){
		var iKeyCode = (event.which) ? event.which : event.keyCode

        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
	}
</script>