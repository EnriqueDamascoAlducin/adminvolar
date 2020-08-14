<?php
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
$campos =" CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,'') ) as vendedor, comentario_gasto as comentario , fecha_gasto as fecha, IFNULL((Select nombre_extra from extras_volar WHERE id_extra = tipo_gasto),'')as tipo, metodo_gasto as metodo, referencia_gasto as referencia,cantidad_gasto as cantidad";
$tablas = "gastos_volar gv INNER JOIN volar_usuarios ON  idusu_gasto = id_usu ";
$filtro="gv.status <>0 ";

if(isset($_GET['fechaI']) && $_GET['fechaI']!='' ){
	$filtro.= " and fecha_gasto >='".$_GET['fechaI']."'";
}
if(isset($_GET['fechaF']) && $_GET['fechaF']!='' ){
	$filtro.= " and fecha_gasto <='".$_POST['fechaF']."'";
}
if(isset($_GET['empleado']) && $_GET['empleado']!='0' ){
	$filtro.= " and idusu_gasto = ".$_GET['empleado'];
}
if(isset($_GET['tipo']) && $_GET['tipo']!='0' ){
	$filtro.= " and tipo_gasto =".$_GET['tipo'];
}
$fila=3;
$titulo=1;
$enc=2;
$con->query("SET NAMES UTF8");
$repGastos=$con->consulta($campos,$tablas,$filtro);
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


$objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Gastos de Volar en Globo');
$objphp->getActiveSheet()->mergeCells('B'.$titulo.':G'.$titulo);
$objphp->getActiveSheet()->getStyle('A'.$enc.':G'.$enc)->applyFromArray($estiloTituloColumnas);

$objphp->getActiveSheet()->setCellValue('A'.$enc, 'Fecha');
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('B'.$enc, 'Usuario');
$objphp->getActiveSheet()->getColumnDimension('B')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('C'.$enc, 'Tipo');
$objphp->getActiveSheet()->getColumnDimension('C')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('D'.$enc, 'Metodo');
$objphp->getActiveSheet()->getColumnDimension('D')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('E'.$enc, 'Referencia ');
$objphp->getActiveSheet()->getColumnDimension('E')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('F'.$enc, 'Cantidad');
$objphp->getActiveSheet()->getColumnDimension('F')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('G'.$enc, 'Comentario');
$objphp->getActiveSheet()->getColumnDimension('G')->setWidth(55);
foreach ($repGastos as $repGasto) {

	$objphp->getActiveSheet()->setCellValue('A'.$fila, $repGasto->fecha );
	$objphp->getActiveSheet()->setCellValue('B'.$fila, $repGasto->vendedor );
	$objphp->getActiveSheet()->setCellValue('C'.$fila, $repGasto->tipo );
	if($repGasto->metodo=='1'){
		$objphp->getActiveSheet()->setCellValue('D'.$fila, "Efectivo");
	}elseif($repGasto->metodo=='2'){
		$objphp->getActiveSheet()->setCellValue('D'.$fila, "T. Crédito");
	}else{
			$objphp->getActiveSheet()->setCellValue('D'.$fila, "Ambos");
	}
	$objphp->getActiveSheet()->setCellValue('E'.$fila, $repGasto->referencia);
	$objphp->getActiveSheet()->setCellValue('F'.$fila, $repGasto->cantidad);
	$objphp->getActiveSheet()->setCellValue('G'.$fila, $repGasto->comentario);
	$fila++;
}

$fila--;
$objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:G".$fila);
$useragent=$_SERVER['HTTP_USER_AGENT'];
if( strpos( $useragent, "Android" ) !== false || strpos( $useragent, "Mobile" ) !== false || strpos( $useragent, "IPhone" ) !== false || strpos( $useragent, "iPhone" ) !== false || strpos( $useragent, "Phone" ) !== false || strpos( $useragent, "phone" ) !== false) {
    header('Content-Type: application/vnd.ms-excel');
    header('Content-Disposition: attachment;filename="pagos.xls"');
    header('Cache-Control: max-age=0');

    $objWriter = PHPExcel_IOFactory::createWriter($objphp, 'Excel5');
    $objWriter->save('php://output');
}else{

	$objWriter = PHPExcel_IOFactory::createWriter($objphp, 'Excel5');
	header('Content-Disposition: attachment;filename="pagos.xls"');

	$objWriter->save('php://output');
}
exit;
?>
