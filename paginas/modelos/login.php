<?php
	include_once $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/beans/usuarioLoggeado.php';
	function crearUsuarioBean($usuario){
		global $usuarioLoggeado;
		$usuarioLoggeado->setIdUsu($usuario[0]->id_usu);
		$usuarioLoggeado->setNombreUsu($usuario[0]->nombre_usu);
		$usuarioLoggeado->setApellidopUsu($usuario[0]->apellidop_usu);
		$usuarioLoggeado->setApellidomUsu($usuario[0]->apellidom_usu);
		$usuarioLoggeado->setDeptoUsu($usuario[0]->depto_usu);
		$usuarioLoggeado->setPuestoUsu($usuario[0]->puesto_usu);
		$usuarioLoggeado->setCorreoUsu($usuario[0]->correo_usu);
		$usuarioLoggeado->setTelefonoUsu($usuario[0]->telefono_usu);
		$usuarioLoggeado->setContrasenaUsu($usuario[0]->contrasena_usu);
		$usuarioLoggeado->setUsuarioUsu($usuario[0]->usuario_usu);
		$usuarioLoggeado->setNssUsu($usuario[0]->nss_usu);
		$usuarioLoggeado->setSdUsu($usuario[0]->sd_usu);
		$usuarioLoggeado->setSdiUsu($usuario[0]->sdi_usu);
		$usuarioLoggeado->setFiscalUsu($usuario[0]->fiscal_usu);
		$usuarioLoggeado->setIsrUsu($usuario[0]->isr_usu);
		$usuarioLoggeado->setImssUsu($usuario[0]->imss_usu);
		$usuarioLoggeado->setInfonavitUsu($usuario[0]->infonavit_usu);
		$usuarioLoggeado->setSubsidioUsu($usuario[0]->subsidio_usu);
		$usuarioLoggeado->setQuincenalUsu($usuario[0]->quincenal_usu);
		$usuarioLoggeado->setComplementoUsu($usuario[0]->complemento_usu);
		$usuarioLoggeado->setFaltaUsu($usuario[0]->falta_usu);
		$usuarioLoggeado->setBancoUsu($usuario[0]->banco_usu);
		$usuarioLoggeado->setCuentaUsu($usuario[0]->cuenta_usu);
		$usuarioLoggeado->setRegister($usuario[0]->register);
		$usuarioLoggeado->setStatus($usuario[0]->status);
		return $usuarioLoggeado;
	}

?>