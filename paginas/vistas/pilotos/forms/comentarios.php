<?php
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
	$com = $con->consulta("IFNULL(comentarioint_temp,'') as comentario","temp_volar","id_temp=".$reserva);
	?>

<div class="row">
		<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
			<div class="form-group">
				<label for="comentario">Comentario</label>
				<textarea name="comentario" id="comentario" rows="3" style="resize:none;border-style:double;width:100% ;max-width:100%"><?php echo $com[0]->comentario; ?></textarea>
			</div>
		</div>
</div>
