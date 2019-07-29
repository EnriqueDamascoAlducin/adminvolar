<?php
	include_once $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/beans/reserva.php';
	function crearReserva($reservas){
		global $reserva;
		$reserva->setIdTemp($reservas[0]->id_temp);
		$reserva->setIdusuTemp($reservas[0]->idusu_temp);
		$reserva->setClaveTemp($reservas[0]->clave_temp);
		$reserva->setNombreTemp($reservas[0]->nombre_temp);
		$reserva->setApellidosTemp($reservas[0]->apellidos_temp);
		$reserva->setMailTemp($reservas[0]->mail_temp);
		$reserva->setTelfijoTemp($reservas[0]->telfijo_temp);
		$reserva->setTelcelularTemp($reservas[0]->telcelular_temp);
		$reserva->setProcedenciaTemp($reservas[0]->procedencia_temp);
		$reserva->setPasajerosaTemp($reservas[0]->pasajerosa_temp);
		$reserva->setPasajerosnTemp($reservas[0]->pasajerosn_temp);
		$reserva->setMotivoTemp($reservas[0]->motivo_temp);
		$reserva->setTipoTemp($reservas[0]->tipo_temp);
		$reserva->setFechavueloTemp($reservas[0]->fechavuelo_temp);
		$reserva->setTarifaTemp($reservas[0]->tarifa_temp);
		$reserva->setHotelTemp($reservas[0]->hotel_temp);
		$reserva->setHabitacionTemp($reservas[0]->habitacion_temp);
		$reserva->setCheckinTemp($reservas[0]->checkin_temp);
		$reserva->setCheckoutTemp($reservas[0]->checkout_temp);
		$reserva->setComentarioTemp($reservas[0]->comentario_temp);
		$reserva->setOtroscar1Temp($reservas[0]->otroscar1_temp);
		$reserva->setPrecio1Temp($reservas[0]->precio1_temp);
		$reserva->setOtroscar2Temp($reservas[0]->otroscar2_temp);
		$reserva->setPrecio2Temp($reservas[0]->precio2_temp);
		$reserva->setTdescuentoTemp($reservas[0]->tdescuento_temp);
		$reserva->setCantdescuentoTemp($reservas[0]->cantdescuento_temp);
		$reserva->setTotalTemp($reservas[0]->total_temp);
		$reserva->setPilotoTemp($reservas[0]->piloto_temp);
		$reserva->setKgTemp($reservas[0]->kg_temp);
		$reserva->setGloboTemp($reservas[0]->globo_temp);
		$reserva->setHoraTemp($reservas[0]->hora_temp);
		$reserva->setRegister($reservas[0]->register);
		$reserva->setStatus($reservas[0]->status);
		return $reserva;
	}

?>