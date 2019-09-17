<?php
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';	
$filtro="tv.status <>0 and tv.idusu_temp=vu.id_usu ";
$campos =" id_temp as reserva,CONCAT(ifnull(nombre_usu,''),' ', ifnull(apellidop_usu,''),' ',ifnull(apellidom_usu,'')) as vendedor,
    CONCAT(ifnull(nombre_temp,''),' ',ifnull(apellidos_temp,'')) as cliente,
    mail_temp as correo,
    CONCAT( ifnull(telfijo_temp,''),' / ',ifnull(telcelular_temp,'') )as telefono,
    ifnull((SELECT nombre_extra from extras_volar where id_extra=procedencia_temp),'') as procedencia,
    ifnull(pasajerosa_temp,'')as adultos,
    ifnull(pasajerosn_temp,'')as ninos,
     ifnull((SELECT nombre_extra from extras_volar where id_extra=motivo_temp),'') as motivo,
    ifnull((SELECT nombre_vc from vueloscat_volar where id_vc=tipo_temp),'') as tipo,
    ifnull(fechavuelo_temp,'') as fechavuelo,
    ifnull((SELECT nombre_hotel from hoteles_volar where id_hotel=hotel_temp),'') as hotel,
    ifnull((SELECT nombre_habitacion from habitaciones_volar where id_habitacion=habitacion_temp),'') as habitacion,
    ifnull(total_temp,'0') as cotizado,
    ifnull((SELECT CONCAT(ifnull(nombre_usu,''),' ', ifnull(apellidop_usu,''),' ',ifnull(apellidom_usu,'')) from volar_usuarios where id_usu=piloto_temp),'') as piloto,
    ifnull((SELECT nombre_globo from globos_volar where id_globo=globo_temp),'') as globo,
    ifnull(kg_temp,'NA') as peso, tv.status,ifnull(total_temp,0) as total, IFNULL((SELECT SUM(cantidad_bp) from bitpagos_volar where idres_bp = id_temp and status in (1,3)  ),0) as pagos";
if(isset($_GET['fechaI']) && $_GET['fechaI']!='' ){
	$filtro.= " and fechavuelo_temp >='".$_GET['fechaI']."'";
}
if(isset($_GET['fechaF']) && $_GET['fechaF']!='' ){
	$filtro.= " and fechavuelo_temp <='".$_GET['fechaF']."'";
}
/*
if(isset($_GET['cliente']) && $_GET['cliente']!='0' ){
	$cliente = explode("-", $_GET['cliente']);

	$filtro.= " and nombre_temp like '%".$cliente[0]."%'";
	if(isset($cliente[1]) && $cliente[1]!="" && !empty($cliente[1])){

		$filtro.= " and apellidos_temp like '%".$cliente[0]."%'";
	}
}
*/
if(isset($_GET['status']) && $_GET['status']!='0' ){
	$filtro.= " and tv.status = ".$_GET['status'];
}
if(isset($_GET['empleado']) && $_GET['empleado']!='0' ){
	$filtro.= " and idusu_temp = ".$_GET['empleado'];
}
if(isset($_GET['reserva']) && $_GET['reserva']!='' ){
	$filtro.= " and id_temp = ".$_GET['reserva'];
}
$fila=3;
$titulo=1;
$enc=2;
$con->query("SET NAMES UTF8");
$reservas=$con->consulta($campos,"volar_usuarios vu, temp_volar tv",$filtro);
include '../../../sources/PHPExcel/Classes/PHPExcel.php';
$objphp= new PHPExcel();

$gdImage = imagecreatefrompng('../../../sources/images/icons/logo.png');//Logotipo
$objphp->getProperties()
        ->setCreator("Volar en Globo")
        ->setLastModifiedBy("Volar en Globo")
        ->setTitle("Reporte de vuelos")
        ->setSubject("Reporte de Vuelos")
        ->setDescription("Reporte de Vuelos de Volar en Globo")
        ->setKeywords("vuelos reservas")
        ->setCategory("Vuelos");
$objphp->setActiveSheetIndex(0);
$objphp->getActiveSheet()->setTitle('Reporte General');
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


$objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Reservas de Volar en Globo');
$objphp->getActiveSheet()->mergeCells('B'.$titulo.':T'.$titulo);
$objphp->getActiveSheet()->getStyle('A'.$enc.':T'.$enc)->applyFromArray($estiloTituloColumnas);

$objphp->getActiveSheet()->setCellValue('A'.$enc, 'Reserva');
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('B'.$enc, 'Nombre');
$objphp->getActiveSheet()->getColumnDimension('B')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('C'.$enc, 'Vendedor');
$objphp->getActiveSheet()->getColumnDimension('C')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('D'.$enc, 'Correo');
$objphp->getActiveSheet()->getColumnDimension('D')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('E'.$enc, 'Telefonos Fijo/Celular');
$objphp->getActiveSheet()->getColumnDimension('E')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('F'.$enc, 'Fecha de Vuelo');
$objphp->getActiveSheet()->getColumnDimension('F')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('G'.$enc, 'Procedencia');
$objphp->getActiveSheet()->getColumnDimension('G')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('H'.$enc, 'P. Adultos');
$objphp->getActiveSheet()->getColumnDimension('H')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('I'.$enc, utf8_encode('P. Niños'));
$objphp->getActiveSheet()->getColumnDimension('I')->setWidth(22);
$objphp->getActiveSheet()->setCellValue('J'.$enc, 'Motivo');
$objphp->getActiveSheet()->getColumnDimension('J')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('K'.$enc, 'Tipo');
$objphp->getActiveSheet()->getColumnDimension('K')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('L'.$enc, 'Hotel');
$objphp->getActiveSheet()->getColumnDimension('L')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('M'.$enc, utf8_encode('Habitación'));
$objphp->getActiveSheet()->getColumnDimension('M')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('N'.$enc, 'Cotizado');
$objphp->getActiveSheet()->getColumnDimension('N')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('O'.$enc, 'Globo');
$objphp->getActiveSheet()->getColumnDimension('O')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('P'.$enc, 'Peso (kg)');
$objphp->getActiveSheet()->getColumnDimension('P')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('Q'.$enc, 'Status');
$objphp->getActiveSheet()->getColumnDimension('Q')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('R'.$enc, 'Total');
$objphp->getActiveSheet()->getColumnDimension('R')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('S'.$enc, 'Pagado');
$objphp->getActiveSheet()->getColumnDimension('S')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('T'.$enc, 'CPP');
$objphp->getActiveSheet()->getColumnDimension('T')->setWidth(25);
foreach ($reservas as $reserva) {

$objphp->getActiveSheet()->setCellValue('A'.$fila, $reserva->reserva );
$objphp->getActiveSheet()->setCellValue('B'.$fila, ($reserva->cliente) );
$objphp->getActiveSheet()->setCellValue('C'.$fila, ($reserva->vendedor) );
$objphp->getActiveSheet()->setCellValue('D'.$fila, $reserva->correo );
$objphp->getActiveSheet()->setCellValue('E'.$fila, $reserva->telefono);
$objphp->getActiveSheet()->setCellValue('F'.$fila, $reserva->fechavuelo);
$objphp->getActiveSheet()->setCellValue('G'.$fila, utf8_decode( $reserva->procedencia) );
$objphp->getActiveSheet()->setCellValue('H'.$fila, $reserva->adultos );
$objphp->getActiveSheet()->setCellValue('I'.$fila, $reserva->ninos );
$objphp->getActiveSheet()->setCellValue('J'.$fila, ($reserva->motivo) );
$objphp->getActiveSheet()->setCellValue('K'.$fila, ($reserva->tipo) );
$objphp->getActiveSheet()->setCellValue('L'.$fila, ($reserva->hotel) );
$objphp->getActiveSheet()->setCellValue('M'.$fila, ($reserva->habitacion) );
$objphp->getActiveSheet()->setCellValue('N'.$fila, $reserva->cotizado );
$objphp->getActiveSheet()->setCellValue('O'.$fila, ($reserva->globo) );
$objphp->getActiveSheet()->setCellValue('P'.$fila, $reserva->peso );
						
if( $reserva->status ==4){
	$text="Conciliada";
	$class="#33b5e5";
}else if($reserva->status==2){
	$text="Sin Cotización";
	$class="#ff4444";
}else if($reserva->status==3){
	$text="Pendiente de Pago";
	$class="#ffbb33";
}else if($reserva->status==1){
	$text="Terminado";
	$class="#00C851";
}else if($reserva->status==5){
	$text="Esperando Autorización";
	$class="#00C851";
}else if($reserva->status==6){
	$text="C. por Reemplazo ";
	$class="#ffbb33";
}else if($reserva->status==7){
	$text="Pagado Total";
	$class="#00C851";
}else if($reserva->status==8){
	$text="Confirmada";
	$class="#00e676";
}else{
	$text="Otro";
	$class="#ff4444";
}
$objphp->getActiveSheet()->setCellValue('Q'.$fila,( $text) );
$objphp->getActiveSheet()->setCellValue('R'.$fila, $reserva->total );
$objphp->getActiveSheet()->setCellValue('S'.$fila, $reserva->pagos );
$objphp->getActiveSheet()->setCellValue('T'.$fila, "=R".$fila."-S".$fila );
$fila++;
}
$fila--;
$objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:T".$fila);

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
