<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idUsu=$usuario->getIdUsu();
	$valores = "'".$_POST['fecha']."','".$_POST['tipo']."','".$_POST['cantidad']."','".$_POST['metodo']."','".$_POST['referencia']."','".$_POST['comentario']."',".$idUsu;
	$registrarEgreso = $con->insertar("gastos_volar","fecha_gasto,tipo_gasto,cantidad_gasto,metodo_gasto,referencia_gasto,comentario_gasto,idusu_gasto ",$valores);
	echo $registrarEgreso;
?>
