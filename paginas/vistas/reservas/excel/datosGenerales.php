<?php


$fila=3;
$titulo=1;
$enc=2;
$objphp->setActiveSheetIndex($pagina);
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
$objphp->getActiveSheet()->getStyle('A1:Q1')->applyFromArray($estiloTituloReporte);
$objphp->getActiveSheet()->getRowDimension(1)->setRowHeight(100);
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
//$objphp->getActiveSheet()->setCellValue('B'.$titulo,'Reporte de Vuelos de Volar en Globo');


$objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Reservas de Volar en Globo');
$objphp->getActiveSheet()->mergeCells('B'.$titulo.':R'.$titulo);
$objphp->getActiveSheet()->getStyle('A'.$enc.':R'.$enc)->applyFromArray($estiloTituloColumnas);
/*Encabezado*/
$objphp->getActiveSheet()->setCellValue('A'.$enc, 'Reserva');
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('B'.$enc, 'Cliente');
$objphp->getActiveSheet()->getColumnDimension('B')->setWidth(35);
$objphp->getActiveSheet()->setCellValue('C'.$enc, 'Vendedor');
$objphp->getActiveSheet()->getColumnDimension('C')->setWidth(35);
$objphp->getActiveSheet()->setCellValue('D'.$enc, 'Correo');
$objphp->getActiveSheet()->getColumnDimension('D')->setWidth(35);
$objphp->getActiveSheet()->setCellValue('E'.$enc, 'Telefonos');
$objphp->getActiveSheet()->getColumnDimension('E')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('F'.$enc, 'Fecha de Vuelo');
$objphp->getActiveSheet()->getColumnDimension('F')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('G'.$enc, 'Procedencia');
$objphp->getActiveSheet()->getColumnDimension('G')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('H'.$enc, 'P. Adultos');
$objphp->getActiveSheet()->getColumnDimension('H')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('I'.$enc, ('P. Niños'));
$objphp->getActiveSheet()->getColumnDimension('I')->setWidth(22);
$objphp->getActiveSheet()->setCellValue('J'.$enc, 'Motivo');
$objphp->getActiveSheet()->getColumnDimension('J')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('K'.$enc, 'Tipo');
$objphp->getActiveSheet()->getColumnDimension('K')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('L'.$enc, 'Peso (kg)');
$objphp->getActiveSheet()->getColumnDimension('L')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('M'.$enc, 'Descuento');
$objphp->getActiveSheet()->getColumnDimension('M')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('N'.$enc, 'Total');
$objphp->getActiveSheet()->getColumnDimension('N')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('O'.$enc, 'Pagado');
$objphp->getActiveSheet()->getColumnDimension('O')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('P'.$enc, 'Restante');
$objphp->getActiveSheet()->getColumnDimension('P')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('Q'.$enc, 'Status');
$objphp->getActiveSheet()->getColumnDimension('Q')->setWidth(25);
$objphp->getActiveSheet()->setCellValue('R'.$enc, 'Comentarios Interno');
$objphp->getActiveSheet()->getColumnDimension('R')->setWidth(80);
foreach ($reservas as $reserva) {

	$objphp->getActiveSheet()->setCellValue('A'.$fila, $reserva->reserva );
	$objphp->getActiveSheet()->setCellValue('B'.$fila, ($reserva->cliente) );
	$objphp->getActiveSheet()->setCellValue('C'.$fila, ($reserva->vendedor) );
	$objphp->getActiveSheet()->setCellValue('D'.$fila, $reserva->correo );
	$objphp->getActiveSheet()->setCellValue('E'.$fila, $reserva->telefonos);
	$objphp->getActiveSheet()->setCellValue('F'.$fila, $reserva->fechavuelo);
	$objphp->getActiveSheet()->setCellValue('G'.$fila, utf8_decode( $reserva->procedencia) );
	$objphp->getActiveSheet()->setCellValue('H'.$fila, $reserva->adultos );
	$objphp->getActiveSheet()->setCellValue('I'.$fila, $reserva->ninos );
	$objphp->getActiveSheet()->setCellValue('J'.$fila, utf8_encode($reserva->motivo) );
	$objphp->getActiveSheet()->setCellValue('K'.$fila, ($reserva->tipo) );
	if($reserva->tipopeso=='1'){
		$objphp->getActiveSheet()->setCellValue('L'.$fila, ($reserva->peso) . "Kg" );
	}elseif($reserva->tipopeso=='2'){
		$objphp->getActiveSheet()->setCellValue('L'.$fila, ($reserva->peso* 0.453592) . "Kg" );
	}else{
		$objphp->getActiveSheet()->setCellValue('L'.$fila, "N/A" );
	}

	if($reserva->tdescuento=='2'){ //Pesos
		$objphp->getActiveSheet()->setCellValue('M'.$fila, ("$ ".$reserva->descuento)  );
	}elseif($reserva->tdescuento=='1'){
		$objphp->getActiveSheet()->setCellValue('M'.$fila, ($reserva->descuento) . "%" );
	}else{
		$objphp->getActiveSheet()->setCellValue('M'.$fila, "N/A" );
	}
	$objphp->getActiveSheet()->setCellValue('N'.$fila, $reserva->cotizado );
	$objphp->getActiveSheet()->setCellValue('O'.$fila, ($reserva->pagado) );
	$objphp->getActiveSheet()->setCellValue('P'.$fila, ($reserva->cotizado-$reserva->pagado) );

	if( $reserva->status ==4){
		$text="Conciliada";
	}else if($reserva->status==2){
		$text="Sin Cotización";
	}else if($reserva->status==3){
		$text="Pendiente de Pago";
	}else if($reserva->status==1){
		$text="Terminado";
	}else if($reserva->status==5){
		$text="Esperando Autorización";
	}else if($reserva->status==6){
		$text="C. por Reemplazo ";
	}else if($reserva->status==7){
		$text="Pagado Total";
	}else if($reserva->status==8){
		$text="Confirmada";
	}else if($reserva->status==9){
		$text="CxC";
	}else if($reserva->status==9){
		$text="No Show";
	}else{
		$text="Otro";
	}
	$objphp->getActiveSheet()->setCellValue('Q'.$fila,( $text) );
	$comentarioint ="";
	if(strlen($reserva->comentariosint)>30){
		$compare = true;
			$start = 0;
			$end = 35;
		while($compare){
			$comentarioint.= substr($reserva->comentariosint,$start,$end) . "\n";
											$start= $start +35;
											$end = $end + 35;
			if(strlen($reserva->comentariosint)<=$end){
				$compare = false;
				//$comentarioint.= substr($reserva->comentariosint,$end,strlen($reserva->comentariosint));
			}else{

			}
		}
	}else{
		$comentarioint = $reserva->comentariosint;
	}
	$objphp->getActiveSheet()->setCellValue('R'.$fila,utf8_encode( $comentarioint) );
	$objphp->getActiveSheet()->getStyle('R'.$fila)->getAlignment()->setWrapText(true);
		/*   Set altura de la fila */
		$objphp->getActiveSheet()->getRowDimension($fila)->setRowHeight(-1);
	$fila++;
}
$fila--;
$objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:R".$fila);


?>
