<?php
	include_once $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/beans/usuarioLoggeado.php';
	$usuarioAct = new usuarioLoggeado();
	function crearUsuarioBean($usuario){
		global $usuarioAct;
		$usuarioAct->setIdUsu($usuario[0]->id_usu);
		$usuarioAct->setNombreUsu($usuario[0]->nombre_usu);
		$usuarioAct->setApellidopUsu($usuario[0]->apellidop_usu);
		$usuarioAct->setApellidomUsu($usuario[0]->apellidom_usu);
		$usuarioAct->setDeptoUsu($usuario[0]->depto_usu);
		$usuarioAct->setPuestoUsu($usuario[0]->puesto_usu);
		$usuarioAct->setCorreoUsu($usuario[0]->correo_usu);
		$usuarioAct->setTelefonoUsu($usuario[0]->telefono_usu);
		$usuarioAct->setContrasenaUsu($usuario[0]->contrasena_usu);
		$usuarioAct->setUsuarioUsu($usuario[0]->usuario_usu);
		$usuarioAct->setNssUsu($usuario[0]->nss_usu);
		$usuarioAct->setSdUsu($usuario[0]->sd_usu);
		$usuarioAct->setSdiUsu($usuario[0]->sdi_usu);
		$usuarioAct->setFiscalUsu($usuario[0]->fiscal_usu);
		$usuarioAct->setIsrUsu($usuario[0]->isr_usu);
		$usuarioAct->setImssUsu($usuario[0]->imss_usu);
		$usuarioAct->setInfonavitUsu($usuario[0]->infonavit_usu);
		$usuarioAct->setSubsidioUsu($usuario[0]->subsidio_usu);
		$usuarioAct->setQuincenalUsu($usuario[0]->quincenal_usu);
		$usuarioAct->setComplementoUsu($usuario[0]->complemento_usu);
		$usuarioAct->setFaltaUsu($usuario[0]->falta_usu);
		$usuarioAct->setBancoUsu($usuario[0]->banco_usu);
		$usuarioAct->setCuentaUsu($usuario[0]->cuenta_usu);
		$usuarioAct->setRegister($usuario[0]->register);
		$usuarioAct->setStatus($usuario[0]->status);
		return $usuarioAct;
	}

?>