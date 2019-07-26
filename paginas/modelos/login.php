<?php
	include_once'../beans/usuarioLoggeado.php';
	function createSession($usuario){
		global $usuarioLoggeado;
		$usuarioLoggeado->setIdUsu($usuario[0]->id_usu);
		return $usuarioLoggeado;
	}

?>