<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$suma = $con->consulta("SUM(cantidad_bp) as suma","bitpagos_volar","status in (1,2) and idres_bp=".$_POST['reserva']);

	$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, total_temp","temp_volar","id_temp=".$_POST['reserva']);
?>
<button data-dismiss="modal"  type="button" id="btnConfirmarAsistencia<?php  echo $_POST['reserva']; ?>" class="btn btn-warning" onclick="ConfirmarAsistencia(<?php  echo $_POST['reserva']; ?>,'<?php echo $datoReserva[0]->nombre; ?>','no-show' );" >No Show</button>
<?php if($datoReserva[0]->total_temp==$suma[0]->suma){ ?>
	<button data-dismiss="modal"  type="button" id="btnConfirmarAsistencia<?php  echo $_POST['reserva']; ?>" class="btn btn-success" onclick="ConfirmarAsistencia(<?php  echo $_POST['reserva']; ?>,'<?php echo $datoReserva[0]->nombre; ?>','asistencia' );" >Confirmar</button>
<?php }else{ ?>
	<button data-dismiss="modal"  type="button" id="btnConfirmarAsistencia<?php  echo $_POST['reserva']; ?>" class="btn btn-primary" onclick="ConfirmarAsistencia(<?php  echo $_POST['reserva']; ?>,'<?php echo $datoReserva[0]->nombre; ?>','cpc' );" >Enviar a CPC</button>

<?php } ?>
