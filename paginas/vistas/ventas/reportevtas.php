<?php
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
$filtro="vv.status <>0 ";
$campos =" CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,'') ) as vendedor, comentario_venta as comentario ,
	otroscar1_venta as otros1, precio1_venta as precio1,otroscar2_venta as otros2, precio2_venta as precio2,
	pagoefectivo_venta as efectivo, pagotarjeta_venta as tarjeta, total_venta as total, fechavta_venta as fecha ";
if(isset($_GET['fechaI']) && $_GET['fechaI']!='' ){
	$filtro.= " and fechavta_venta>='". $_GET['fechaI'] . "' ";
}
if(isset($_GET['fechaF']) && $_GET['fechaF']!='' ){
	$filtro.= " and fechavta_venta<='". $_GET['fechaF'] . "' ";
}
if($_GET['fechaF']!='' &&  $_GET['fechaI']!=''){
	$filtro .=' and fechavta_venta=CURRENT_DATE ';
}
$fila=3;
$titulo=1;
$enc=2;
$con->query("SET NAMES UTF8");
$ventas=$con->consulta($campos,"ventas_volar vv join volar_usuarios  vu on vv.idusu_venta=vu.id_usu ",$filtro);
include '../../../sources/PHPExcel/Classes/PHPExcel.php';
$objphp= new PHPExcel();

$gdImage = imagecreatefrompng('../../../sources/images/icons/logo.png');//Logotipo
$objphp->getProperties()
        ->setCreator("Volar en Globo")
        ->setLastModifiedBy("Volar en Globo")
        ->setTitle("Reporte de Ventas")
        ->setSubject("Reporte de Ventas")
        ->setDescription("Reporte de Ventas de Volar en Globo")
        ->setKeywords("vuelos reservas")
        ->setCategory("Vuelos");
$objphp->setActiveSheetIndex(0);
$objphp->getActiveSheet()->setTitle('Reporte de Ventas');
////////// Para dibujar el logo


	$objDrawing = new PHPExcel_Worksheet_MemoryDrawing();
	$objDrawing->setName('Logotipo');
	$objDrawing->setDescription('Logotipo');
	$objDrawing->setImageResource($gdImage);
	$objDrawing->setRenderingFunction(PHPExcel_Worksheet_MemoryDrawing::RENDERING_PNG);
	$objDrawing->setMimeType(PHPExcel_Worksheet_MemoryDrawing::MIMETYPE_DEFAULT);
	$objDrawing->setHeight(100);
	$objDrawing->setCoordinates('B1');
	$objDrawing->setWorksheet($objphp->getActiveSheet());
////////////Dibujar el log

/////////////////     Estilos de las celdas (titulos y contenido)
$estiloTituloReporte = array(
    	'font' => array(
			'name'      => 'Arial',
			'bold'      => true,
			'italic'    => false,
			'strike'    => false,
			'size' =>25
    	),
    	'fill' => array(
			'type'  => PHPExcel_Style_Fill::FILL_SOLID
		),
    	'borders' => array(
			'allborders' => array(
				'style' => PHPExcel_Style_Border::BORDER_NONE
			)
    	),
    	'alignment' => array(
			'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
    	)
	);

	$estiloTituloColumnas = array(
    	'font' => array(
			'name'  => 'Arial',
			'bold'  => true,
			'size' =>10,
			'color' => array('rgb' => 'FFFFFF')
    	),
    	'fill' => array(
			'type' => PHPExcel_Style_Fill::FILL_SOLID,
			'color' => array('rgb' => '538DD5')
    	),
    	'borders' => array(
			'allborders' => array(
				'style' => PHPExcel_Style_Border::BORDER_THIN
			)
    	),
    	'alignment' =>  array(
			'horizontal'=> PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			'vertical'  => PHPExcel_Style_Alignment::VERTICAL_CENTER
    	)
	);

	$estiloInformacion = new PHPExcel_Style();
	$estiloInformacion->applyFromArray( array(
    	'font' => array(
			'name'  => 'Arial',
			'color' => array('rgb' => '000000')
	    ),
    	'fill' => array(
			'type'  => PHPExcel_Style_Fill::FILL_SOLID
		),
    	'borders' => array(
			'allborders' => array(
				'style' => PHPExcel_Style_Border::BORDER_THIN
			)
    	),
		'alignment' =>  array(
			'horizontal'=> PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			'vertical'  => PHPExcel_Style_Alignment::VERTICAL_CENTER
    	)
	));


/////////////////     Estilos de las celdas (titulos y contenido)



$objphp->getActiveSheet()->getStyle('A1:Q1')->applyFromArray($estiloTituloReporte);
$objphp->getActiveSheet()->getRowDimension(1)->setRowHeight(100);
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
//$objphp->getActiveSheet()->setCellValue('B'.$titulo,'Reporte de Vuelos de Volar en Globo');


$objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Ventas de Volar en Globo');
$objphp->getActiveSheet()->mergeCells('B'.$titulo.':J'.$titulo);
$objphp->getActiveSheet()->getStyle('A'.$enc.':J'.$enc)->applyFromArray($estiloTituloColumnas);

$objphp->getActiveSheet()->setCellValue('A'.$enc, 'Fecha');
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('B'.$enc, 'Cargos Extra 1');
$objphp->getActiveSheet()->getColumnDimension('B')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('C'.$enc, 'Precio');
$objphp->getActiveSheet()->getColumnDimension('C')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('D'.$enc, 'Cargos Extra 2');
$objphp->getActiveSheet()->getColumnDimension('D')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('E'.$enc, 'Precio ');
$objphp->getActiveSheet()->getColumnDimension('E')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('F'.$enc, 'Pagado en Efectivo');
$objphp->getActiveSheet()->getColumnDimension('F')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('G'.$enc, 'Pagado en Tarjeta');
$objphp->getActiveSheet()->getColumnDimension('G')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('H'.$enc, 'Total');
$objphp->getActiveSheet()->getColumnDimension('H')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('I'.$enc, utf8_encode('Vendedor'));
$objphp->getActiveSheet()->getColumnDimension('I')->setWidth(30);
$objphp->getActiveSheet()->setCellValue('J'.$enc, 'Comentario');
$objphp->getActiveSheet()->getColumnDimension('J')->setWidth(50);
foreach ($ventas as $venta) {

	$objphp->getActiveSheet()->setCellValue('A'.$fila, $venta->fecha );
	$objphp->getActiveSheet()->setCellValue('B'.$fila, ($venta->otros1) );
	$objphp->getActiveSheet()->setCellValue('C'.$fila, ($venta->precio1) );
	$objphp->getActiveSheet()->setCellValue('D'.$fila, $venta->otros2 );
	$objphp->getActiveSheet()->setCellValue('E'.$fila, $venta->precio2);
	$objphp->getActiveSheet()->setCellValue('F'.$fila, $venta->efectivo);
	$objphp->getActiveSheet()->setCellValue('G'.$fila, ( $venta->tarjeta) );
	$objphp->getActiveSheet()->setCellValue('H'.$fila, $venta->total );
	$objphp->getActiveSheet()->setCellValue('I'.$fila, $venta->vendedor );
	$objphp->getActiveSheet()->setCellValue('J'.$fila, ($venta->comentario) );

$fila++;
}
$fila--;
$objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:J".$fila);

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
