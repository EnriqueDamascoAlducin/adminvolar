<?php

	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';

	$datoReserva = $con->consulta("CONCAT(IFNULL(nombre_temp,''),' ',IFNULL(apellidos_temp,'')) as nombre, IFNULL(hora_temp,'') as hora,IFNULL(globo_temp,'') as globo,IFNULL(piloto_temp,'') as piloto ,status,IFNULL(kg_temp,'') as kg","temp_volar","id_temp=".$_POST['reserva']);
?>
<?php if($datoReserva[0]->status==7){ ?>
	<button data-dismiss="modal"  type="button" id="btnConfirmarAsistencia<?php  echo $_POST['reserva']; ?>" class="btn btn-success" onclick="ConfirmarAsistencia(<?php  echo $_POST['reserva']; ?>,'<?php echo $datoReserva[0]->nombre; ?>','asistencia' );" >Confirmar</button>
<?php }else{ ?>
<h3>Debe haber completado el pago</h3>
<?php } ?>
