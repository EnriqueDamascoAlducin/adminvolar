<?php 
	
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
	if($_POST['id']!=''){
		$vuelo= $con->consulta("*","vueloscat_volar"," id_vc=". $_POST['id']);
	}
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
	$tipos = $con->consulta("nombre_extra as text, id_extra as value","extras_volar","status<>0 and clasificacion_extra='tiposv' ");

?>
<div class="row"> 
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="nombre">Nombre</label>
			<input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre" value="<?php if(isset($vuelo)){echo $vuelo[0]->nombre_vc;} ?>" >
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="tipo">Tipo de Vuelo</label>
			<select class="selectpicker form-control" id="tipo" name="tipo" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($tipos as $tipo) {
						$opcTipo="";
						if($tipo->value == $vuelo[0]->tipo_vc){
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
			<label for="precioa">Precio Adultos</label>
			<input type="number" min="0" class="form-control" id="precioa" name="precioa" placeholder="Precio Adulto"  value="<?php if(isset($vuelo)){echo $vuelo[0]->precioa_vc;} ?>"  >
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="precion">Precio Niños</label>
			<input type="number" min="0" class="form-control" id="precion" name="precion" placeholder="Precio Niño"  value="<?php if(isset($vuelo)){echo $vuelo[0]->precion_vc;} ?>"  >
		</div>
	</div>
</div>


