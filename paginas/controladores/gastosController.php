<?php

	include_once 'conexion.php';
	include_once 'fin_session.php';
	$valores = "'".$_POST['fecha']."','".$_POST['tipo']."','".$_POST['cantidad']."','".$_POST['metodo']."','".$_POST['referencia']."','".$_POST['comentario']."'";
	$registrarEgreso = $con->insertar("gastos_volar","fecha_gasto,tipo_gasto,cantidad_gasto,metodo_gasto,referencia_gasto,comentario_gasto",$valores);
	echo $registrarEgreso;
?>