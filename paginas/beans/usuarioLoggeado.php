<?php
	Class usuarioLoggeado{
		private $idUsu;
		private $nombreUsu;
		private $apellidopUsu;
		private $apellidomUsu;
		private $deptoUsu;
		private $puestoUsu;
		private $correoUsu;
		private $telefonoUsu;
		private $contrasenaUsu;
		private $usuarioUsu;
		private $nssUsu;
		private $sdUsu;
		private $sdiUsu;
		private $fiscalUsu;
		private $isrUsu;
		private $imssUsu;
		private $infonavitUsu;
		private $subsidioUsu;
		private $quincenalUsu;
		private $complementoUsu;
		private $faltaUsu;
		private $bancoUsu;
		private $cuentaUsu;
		private $register;
		private $status;
		function __construct(){
			//constructor
		}

		//Setters y Getters
		function setIdUsu($id){
			$this->idUsu = $id;
		}
		function getIdUsu(){
			return $this->idUsu ;
		}


		function setNombreUsu($nombreUsu){
			$this->nombreUsu = $nombreUsu;
		}
		function getNombreUsu(){
			return $this->nombreUsu ;
		}


		function setApellidopUsu($apellidopUsu){
			$this->apellidopUsu = $apellidopUsu;
		}
		function getApellidopUsu(){
			return $this->apellidopUsu ;
		}

		function setApellidomUsu($apellidomUsu){
			$this->apellidomUsu = $apellidomUsu;
		}
		function getApellidomUsu(){
			return $this->apellidomUsu ;
		}


		function setDeptoUsu($deptoUsu){
			$this->deptoUsu = $deptoUsu;
		}
		function getDeptoUsu(){
			return $this->deptoUsu ;
		}


		function setPuestoUsu($puestoUsu){
			$this->puestoUsu = $puestoUsu;
		}
		function getPuestoUsu(){
			return $this->puestoUsu ;
		}


		function setCorreoUsu($correoUsu){
			$this->correoUsu = $correoUsu;
		}
		
		function getCorreoUsu(){
			return $this->correoUsu ;
		}


		function setTelefonoUsu($telefonoUsu){
			$this->telefonoUsu = $telefonoUsu;
		}
		function getTelefonoUsu(){
			return $this->telefonoUsu ;
		}


		function setContrasenaUsu($contrasenaUsu){
			$this->contrasenaUsu = $contrasenaUsu;
		}
		function getContrasenaUsu(){
			return $this->contrasenaUsu ;
		}


		function setUsuarioUsu($usuarioUsu){
			$this->usuarioUsu = $usuarioUsu;
		}
		function getUsuarioUsu(){
			return $this->usuarioUsu ;
		}


		function setNssUsu($nssUsu){
			$this->nssUsu = $nssUsu;
		}
		function getNssUsu(){
			return $this->nssUsu ;
		}


		function setSdUsu($sdUsu){
			$this->sdUsu = $sdUsu;
		}
		function getSdUsu(){
			return $this->sdUsu ;
		}


		function setSdiUsu($sdiUsu){
			$this->sdiUsu = $sdiUsu;
		}
		function getSdiUsu(){
			return $this->sdiUsu ;
		}


		function setFiscalUsu($fiscalUsu){
			$this->fiscalUsu = $fiscalUsu;
		}
		function getFiscalUsu(){
			return $this->fiscalUsu ;
		}


		function setIsrUsu($isrUsu){
			$this->isrUsu = $isrUsu;
		}
		function getIsrUsu(){
			return $this->isrUsu ;
		}


		function setImssUsu($imssUsu){
			$this->imssUsu = $imssUsu;
		}
		function getImssUsu(){
			return $this->imssUsu ;
		}


		function setInfonavitUsu($infonavitUsu){
			$this->infonavitUsu = $infonavitUsu;
		}
		function getInfonavitUsu(){
			return $this->infonavitUsu ;
		}


		function setSubsidioUsu($subsidioUsu){
			$this->subsidioUsu = $subsidioUsu;
		}
		function getSubsidioUsu(){
			return $this->subsidioUsu ;
		}


		function setQuincenalUsu($quincenalUsu){
			$this->quincenalUsu = $quincenalUsu;
		}
		function getQuincenalUsu(){
			return $this->quincenalUsu ;
		}


		function setComplementoUsu($complementoUsu){
			$this->complementoUsu = $complementoUsu;
		}
		function getComplementoUsu(){
			return $this->complementoUsu ;
		}


		function setFaltaUsu($faltaUsu){
			$this->faltaUsu = $faltaUsu;
		}
		function getFaltaUsu(){
			return $this->faltaUsu ;
		}


		function setBancoUsu($bancoUsu){
			$this->bancoUsu = $bancoUsu;
		}
		function getBancoUsu(){
			return $this->bancoUsu ;
		}


		function setCuentaUsu($cuentaUsu){
			$this->cuentaUsu = $cuentaUsu;
		}
		function getCuentaUsu(){
			return $this->cuentaUsu ;
		}


		function setRegister($register){
			$this->register = $register;
		}
		function getRegister(){
			return $this->register ;
		}

		function setStatus($status){
			$this->status = $status;
		}
		function getStatus(){
			return $this->status ;
		}
	}
	$usuarioLoggeado = new usuarioLoggeado();
?>
