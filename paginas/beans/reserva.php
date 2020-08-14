<?php
	Class Reserva{
		private $idTemp;
		private $idusuTemp;
		private $claveTemp;
		private $nombreTemp;
		private $apellidosTemp;
		private $mailTemp;
		private $telfijoTemp;
		private $telcelularTemp;
		private $procedenciaTemp;
		private $pasajerosaTemp;
		private $pasajerosnTemp;
		private $motivoTemp;
		private $tipoTemp;
		private $fechavueloTemp;
		private $tarifaTemp;
		private $hotelTemp;
		private $habitacionTemp;
		private $checkinTemp;
		private $checkoutTemp;
		private $comentarioTemp;
		private $otroscar1Temp;
		private $precio1Temp;
		private $otroscar2Temp;
		private $precio2Temp;
		private $tdescuentoTemp;
		private $cantdescuentoTemp;
		private $totalTemp;
		private $pilotoTemp;
		private $kgTemp;
		private $globoTemp;
		private $horaTemp;
		private $idiomaTemp;
		private $comentarioIntTemp;
		private $register;
		private $status;
		function Reserva(){
			//constructor
		}
		//Setters y Getters

		function setIdTemp($idTemp){
			$this->idTemp=$idTemp;
		}
		function getIdTemp(){
			return $this->idTemp;
		}
		//////////
		function setIdusuTemp($idusuTemp){
			$this->idusuTemp=$idusuTemp;
		}
		function getIdusuTemp(){
			return $this->idusuTemp;
		}

		///////////
		function setClaveTemp($claveTemp){
			$this->claveTemp=$claveTemp;
		}
		function getClaveTemp(){
			return $this->claveTemp;
		}

		///////////
		function setNombreTemp($nombreTemp){
			$this->nombreTemp=$nombreTemp;
		}
		function getNombreTemp(){
			return $this->nombreTemp;
		}


		///////////
		function setApellidosTemp($apellidosTemp){
			$this->apellidosTemp=$apellidosTemp;
		}
		function getApellidosTemp(){
			return $this->apellidosTemp;
		}

		///////////
		function setMailTemp($mailTemp){
			$this->mailTemp=$mailTemp;
		}
		function getMailTemp(){
			return $this->mailTemp;
		}
		///////////
		function setTelfijoTemp($telfijoTemp){
			$this->telfijoTemp=$telfijoTemp;
		}
		function getTelfijoTemp(){
			return $this->telfijoTemp;
		}
		///////////
		function setTelcelularTemp($telcelularTemp){
			$this->telcelularTemp=$telcelularTemp;
		}
		function getTelcelularTemp(){
			return $this->telcelularTemp;
		}
		///////////
		function setProcedenciaTemp($procedenciaTemp){
			$this->procedenciaTemp=$procedenciaTemp;
		}
		function getProcedenciaTemp(){
			return $this->procedenciaTemp;
		}
		///////////
		function setPasajerosaTemp($pasajerosaTemp){
			$this->pasajerosaTemp=$pasajerosaTemp;
		}
		function getPasajerosaTemp(){
			return $this->pasajerosaTemp;
		}
		///////////
		function setPasajerosnTemp($pasajerosnTemp){
			$this->pasajerosnTemp=$pasajerosnTemp;
		}
		function getPasajerosnTemp(){
			return $this->pasajerosnTemp;
		}
		///////////
		function setMotivoTemp($motivoTemp){
			$this->motivoTemp=$motivoTemp;
		}
		function getMotivoTemp(){
			return $this->motivoTemp;
		}
		///////////
		function setTipoTemp($tipoTemp){
			$this->tipoTemp=$tipoTemp;
		}
		function getTipoTemp(){
			return $this->tipoTemp;
		}
		///////////
		function setFechavueloTemp($fechavueloTemp){
			$this->fechavueloTemp=$fechavueloTemp;
		}
		function getFechavueloTemp(){
			return $this->fechavueloTemp;
		}
		///////////
		function setTarifaTemp($tarifaTemp){
			$this->tarifaTemp=$tarifaTemp;
		}
		function getTarifaTemp(){
			return $this->tarifaTemp;
		}
		///////////
		function setHotelTemp($hotelTemp){
			$this->hotelTemp=$hotelTemp;
		}
		function getHotelTemp(){
			return $this->hotelTemp;
		}
		///////////
		function setHabitacionTemp($habitacionTemp){
			$this->habitacionTemp=$habitacionTemp;
		}
		function getHabitacionTemp(){
			return $this->habitacionTemp;
		}

		///////////
		function setCheckinTemp($checkinTemp){
			$this->checkinTemp=$checkinTemp;
		}
		function getCheckinTemp(){
			return $this->checkinTemp;
		}
		///////////
		function setCheckoutTemp($checkoutTemp){
			$this->checkoutTemp=$checkoutTemp;
		}
		function getCheckoutTemp(){
			return $this->checkoutTemp;
		}

		///////////
		function setComentarioTemp($comentarioTemp){
			$this->comentarioTemp=$comentarioTemp;
		}
		function getComentarioTemp(){
			return $this->comentarioTemp;
		}
		///////////
		function setOtroscar1Temp($otroscar1Temp){
			$this->otroscar1Temp=$otroscar1Temp;
		}
		function getOtroscar1Temp(){
			return $this->otroscar1Temp;
		}
		///////////
		function setPrecio1Temp($precio1Temp){
			$this->precio1Temp=$precio1Temp;
		}
		function getPrecio1Temp(){
			return $this->precio1Temp;
		}
		///////////
		function setOtroscar2Temp($otroscar2Temp){
			$this->otroscar2Temp=$otroscar2Temp;
		}
		function getOtroscar2Temp(){
			return $this->otroscar2Temp;
		}
		///////////
		function setPrecio2Temp($precio2Temp){
			$this->precio2Temp=$precio2Temp;
		}
		function getPrecio2Temp(){
			return $this->precio2Temp;
		}
		///////////
		function setTdescuentoTemp($tdescuentoTemp){
			$this->tdescuentoTemp=$tdescuentoTemp;
		}
		function getTdescuentoTemp(){
			return $this->tdescuentoTemp;
		}
		///////////
		function setCantdescuentoTemp($cantdescuentoTemp){
			$this->cantdescuentoTemp=$cantdescuentoTemp;
		}
		function getCantdescuentoTemp(){
			return $this->cantdescuentoTemp;
		}
		///////////
		function setTotalTemp($totalTemp){
			$this->totalTemp=$totalTemp;
		}
		function getTotalTemp(){
			return $this->totalTemp;
		}
		///////////
		function setPilotoTemp($pilotoTemp){
			$this->pilotoTemp=$pilotoTemp;
		}
		function getPilotoTemp(){
			return $this->pilotoTemp;
		}
		///////////
		function setKgTemp($kgTemp){
			$this->kgTemp=$kgTemp;
		}
		function getKgTemp(){
			return $this->kgTemp;
		}
		///////////
		function setGloboTemp($globoTemp){
			$this->globoTemp=$globoTemp;
		}
		function getGloboTemp(){
			return $this->globoTemp;
		}
		///////////
		function setHoraTemp($horaTemp){
			$this->horaTemp=$horaTemp;
		}
		function getHoraTemp(){
			return $this->horaTemp;
		}
		///////////
		function setRegister($register){
			$this->register=$register;
		}
		function getRegister(){
			return $this->register;
		}
		///////////
		function setComentarioIntTemp($comentarioIntTemp){
			$this->comentarioIntTemp=$comentarioIntTemp;
		}
		function getComentarioIntTemp(){
			return $this->comentarioIntTemp;
		}
		///////////
		function setStatus($status){
			$this->status=$status;
		}
		function getStatus(){
			return $this->status;
		}

		///////////
		function setIdiomaTemp($idiomaTemp){
			$this->idiomaTemp=$idiomaTemp;
		}
		function getIdiomaTemp(){
			return $this->idiomaTemp;
		}

	}
	$reserva = new Reserva();
?>
