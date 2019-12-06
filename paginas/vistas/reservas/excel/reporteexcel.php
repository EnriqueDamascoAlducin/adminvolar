<?php
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	include_once 'consulta.php';

include '../../../../sources/PHPExcel/Classes/PHPExcel.php';
$objphp= new PHPExcel();
$gdImage = imagecreatefrompng('../../../../sources/images/icons/logo.png');//Logotipo
/*Datos Generales del archivo*/
$objphp->getProperties()
        ->setCreator("Volar en Globo")
        ->setLastModifiedBy("Volar en Globo")
        ->setTitle("Reporte de vuelos")
        ->setSubject("Reporte de Vuelos")
        ->setDescription("Reporte de Vuelos de Volar en Globo")
        ->setKeywords("vuelos reservas")
        ->setCategory("Vuelos");

include_once 'estilosExcel.php';
/*Informacion General*/
include_once 'datosGenerales.php';
/*Termina Información General de las reserva*/

/* Empiezan Globos asignados */
include_once 'globosAsignados.php';
/* Termina hoja de Globos asignados*/
/* Empiezan servicios */
include_once 'servicios.php';
/* Termina hoja de servicios*/



$objphp->setActiveSheetIndex(0);
$useragent=$_SERVER['HTTP_USER_AGENT'];
if( strpos( $useragent, "Android" ) !== false || strpos( $useragent, "Mobile" ) !== false || strpos( $useragent, "IPhone" ) !== false || strpos( $useragent, "iPhone" ) !== false || strpos( $useragent, "Phone" ) !== false || strpos( $useragent, "phone" ) !== false) {
    header('Content-Type: application/vnd.ms-excel');
    header('Content-Disposition: attachment;filename="VentasDevice.xls"');
    header('Cache-Control: max-age=0');

    $objWriter = PHPExcel_IOFactory::createWriter($objphp, 'Excel5');
    $objWriter->save('php://output');
}else{

	$objWriter = PHPExcel_IOFactory::createWriter($objphp, 'Excel5');
	header('Content-Disposition: attachment;filename="VentasDesktop.xls"');

	$objWriter->save('php://output');
}
exit;
?>
