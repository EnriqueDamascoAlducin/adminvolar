<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$globos= $con->consulta("nombre_globo as nombre, id_globo as id,placa_globo as placa,peso_globo as peso, maxpersonas_globo as maxpersonas,imagen_globo as imagen","globos_volar","status<>0 and id_globo=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();

?>
<form id="formulario" name="formulario" enctype="multipart/form-data" method="post"  accept="image/*">
	<?php 
	if(isset($_POST['id']) &&  $_POST['id'] !=''){
		echo "<input type='hidden' name='id' id='id' value='".$_POST['id']."'>";
		echo "<input type='hidden' name='accion' id='accion' value='editar'>";
	}else{
		echo "<input type='hidden' name='accion' id='accion' value='agregar'>";
	}
	?>
	<div class="row"> 
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="nombre">Alias</label>
				<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Alias"  value="<?php if(isset($globos)){ echo $globos[0]->nombre; } ?>">
			</div>
		</div>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="placa">Matricula</label>
				<input type="text" class="form-control" id="placa" name="placa" placeholder="Matricula"  value="<?php if(isset($globos)){ echo $globos[0]->placa; } ?>">
			</div>
		</div>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="peso">Peso Soportado</label>
				<input type="number" class="form-control" id="peso" name="peso" placeholder="Peso Soportado"  value="<?php if(isset($globos)){ echo $globos[0]->peso; } ?>">
			</div>
		</div>
		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
			<div class="form-group">
				<label for="maxpersonas">Max. de Pasajeros</label>
				<input type="number" class="form-control" id="maxpersonas" name="maxpersonas" placeholder="Max. de Pasajeros"  value="<?php if(isset($globos)){ echo $globos[0]->maxpersonas; } ?>">
			</div>
		</div>
		<center>
			<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-4 ">
				<div class="form-group">
					<label for="imagen">
						<img id="imgImagen" src="../sources/images/globos/<?php if(isset($globos)){echo $globos[0]->imagen;}else{ echo 'noimage.png'; } ?>" style="max-width: 100%"  class="rounded-circle">
					</label>
					<input type="file" class="form-control" id="imagen" name="imagen"  style="display: none" >
				</div>
			</div>
		</center>
	</div>
</form>

<script type="text/javascript">
	$("#imagen").on("change",function(e){
	
	var data = e.originalEvent.target.files[0];
    if(data.size<1258291){
		validarImagen(this);
	}else{
		abrir_gritter("Alerta","No puedes cargar un archivo mayor a un mega","warning");
		$(this).val('');
      	$('#imgImagen').attr('src', "../sources/images/globos/noimage.png");
		return false;
	}
});
function validarImagen(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    
    reader.onload = function(e) {
      $('#imgImagen').attr('src', e.target.result);
    }
    
    reader.readAsDataURL(input.files[0]);
  }
}
</script>