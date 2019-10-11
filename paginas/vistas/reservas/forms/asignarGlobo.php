<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';

	$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, IFNULL(hora_temp,'') as hora,IFNULL(globo_temp,'') as globo,IFNULL(piloto_temp,'') as piloto ,status, IFNULL(kg_temp,'0.0') as kg,IFNULL(tipopeso_temp,'1') as tipopeso,  tipo_temp as vuelo, fechavuelo_temp as fecha","temp_volar tv", "id_temp=".$_POST['reserva']);

	$tVuelo = $con->consulta("tipo_vc","vueloscat_volar"," id_vc =" . $datoReserva[0]->vuelo);

	$globos = $con->consulta("CONCAT (nombre_globo,'(',peso_globo,' kg)') as text, id_globo as value","globos_volar","status<>0 and peso_globo>".$datoReserva[0]->kg . "  order by peso_globo asc");


	$pilotos = $con->consulta("CONCAT(nombre_usu, ' ', IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as text, id_usu as value","volar_usuarios","status<>0 and puesto_usu = 4 ");

	if($tVuelo[0]->tipo_vc==46){
		echo "Privado";
		echo $exacta = ($datoReserva[0]->hora);
		echo "<br>";
		echo $diff =strtotime("00:05");echo "<br>";
		echo $min = strtotime($exacta - $diff);echo "<br>";
		echo $max = strtotime($exacta + $diff);echo "<br>";
	 echo	(date('h:m',$));
	}else{
		echo "Compartido";
	}
?>
<div class="row">
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="hora">Hora de Vuelo</label>
			<input type="time" class="form-control" id="hora" placeholder="Hora de Vuelo" value = "<?php echo $datoReserva[0]->hora; ?>">
		</div>
	</div>

	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="piloto">Piloto</label>
			<select class="selectpicker form-control" id="piloto" name="piloto" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($pilotos as $piloto) {
						$sel="";
						if($piloto->value==$datoReserva[0]->piloto){
							$sel="selected";
						}
						echo "<option ". $sel ." value='".$piloto->value."'>".$piloto->text."</option>";
					}
				?>

			</select>
		</div>
	</div>
	<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 ">
		<div class="form-group">
			<label for="globo">Globo</label>
			<select class="selectpicker form-control" id="globo" name="globo" data-live-search="true">
				<option value='0'>Todos...</option>
				<?php
					foreach ($globos as $globo) {
						$sel="";
						if($globo->value==$datoReserva[0]->globo){
							$sel="selected disabled";
						}else{
							$tot = $con->consulta("count(id_temp) as total","temp_volar","globo_temp=".$globo->value." ");
							if($tot[0]->total>0){
								$sel="disabled";
							}
						}
						echo "<option ". $sel ." value='".$globo->value."'>".$globo->text."</option>";
					}
				?>

			</select>
		</div>
	</div>

		<div class="col-sm-6 col-lg-6 col-md-6 col-6 col-xl-6 " style="margin-top:25px">
			<div class="form-group">
				<?php if($datoReserva[0]->tipopeso=='1'){ ?>
					<label >Peso: <?php echo $datoReserva[0]->kg; ?> Kg </label>
				<?php }else{ ?>
					<label>Peso: <?php echo ($datoReserva[0]->kg * 0.453592); ?> Kg</label>
				<?php } ?>
			</div>
		</div>
</div>
