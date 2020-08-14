<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$subPermisos = $con->consulta("nombre_sp as nombre, id_sp as id","subpermisos_volar","status<>0 AND permiso_sp=".$_POST['modulo']);
	$usuario= $_POST['usuario'];
?>
<style type="text/css">
	.checkpermiso {
		display: none;
	}
	.checkpermiso:checked + label   {
	    background-color: #00C851;
	}
</style>
<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" style="margin-left: -55px !important;">
	<div class="row">
		<?php foreach ($subPermisos as $subPermiso) { ?>
			<?php $check=""; ?>
			<?php
				$validarPermiso = $con->consulta("count(id_puv) as total","permisosusuarios_volar","status<>0 and idusu_puv = ". $usuario. " and idsp_puv=".$subPermiso->id);
				if($validarPermiso[0]->total>0){ $check="checked";}
			?>
			<div class="col-3 col-md-3 col-lg-3 col-sm-3 col-xl-3" style="height: 70px;vertical-align: middle;text-align:center;" >
				<input class="checkpermiso" type="checkbox"  id="permiso_<?php echo $subPermiso->id ?>" name="permiso_<?php echo $subPermiso->id ?>" onchange="guardarPermiso(<?php echo $subPermiso->id.','. $usuario ?>)" <?php echo $check; ?>>
				<label  class="badge" style="color:black;margin-left:5px;position:absolute;text-align:right" for="permiso_<?php echo $subPermiso->id ?>">
					<br>
					<center>
						<b><?php echo $subPermiso->nombre ?></b>
						<br>
						<b>&nbsp;</b>
					</center>
				</label>

			</div>
		<?php } ?>
	</div>
</div>
