<?php 
    $select = "nombre_extra as metodo, id_extra as id";
    $from = "extras_volar";
    $where = " status<>0 AND clasificacion_extra='metodopago' ";
    if(isset($_GET['metodo']) && $_GET['metodo'] !='0'){
        $where .= ' AND id_extra = '. $_GET['metodo'];
    }
    $metodos = $con->consulta($select,$from,$where);
    $columna = "A";
    for($i = 1 ; $i<= sizeof($metodos); $i++){
        $columna++;
    }
    $preparedTotalPayments = $conexion->prepare("SELECT IFNULL(sum(cantidad_bp),'') as total FROM bitpagos_volar where status in(1,2,3) and idres_bp = ? and metodo_bp = ?  ");


    $fila=3;
    $titulo=1;
    $enc=2;
    $objphp->createSheet();
    $objphp->setActiveSheetIndex($pagina);
    $objphp->getActiveSheet()->setTitle('Formas de Pago');
    $objDrawing = new PHPExcel_Worksheet_MemoryDrawing();
    $objDrawing->setName('Logotipo');
    $objDrawing->setDescription('Logotipo');
    $objDrawing->setImageResource($gdImage);
    $objDrawing->setRenderingFunction(PHPExcel_Worksheet_MemoryDrawing::RENDERING_PNG);
    $objDrawing->setMimeType(PHPExcel_Worksheet_MemoryDrawing::MIMETYPE_DEFAULT);
    $objDrawing->setHeight(100);
    $objDrawing->setCoordinates('A1');
    $objDrawing->setWorksheet($objphp->getActiveSheet());
    if(sizeof($metodos)>5){
        $objphp->getActiveSheet()->getStyle('A1:'.$columna.'1')->applyFromArray($estiloTituloReporte);
    }else{
        $objphp->getActiveSheet()->getStyle('A1:'.$columna.'1')->applyFromArray($estiloTituloReporteSmall);
        
    }
    $objphp->getActiveSheet()->getRowDimension(1)->setRowHeight(100);
    $objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
    if(sizeof($metodos)>5){
        $objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Formas de Pago Volar en Globo');
    }else{
        $objphp->getActiveSheet()->setCellValue('B'.$titulo, "Reporte de Formas de Pago Volar en Globo");
        $objphp->getActiveSheet()->getStyle('B'.$titulo)->getAlignment()->setWrapText(true); 
    }
    $objphp->getActiveSheet()->mergeCells('B'.$titulo.':'.$columna.$titulo);
    $objphp->getActiveSheet()->setCellValue("A".$enc, "Reserva");
    $objphp->getActiveSheet()->getColumnDimension("A")->setWidth(20);
    $columna = "B";
    foreach ($metodos as $metodo) {
       
        $objphp->getActiveSheet()->setCellValue($columna.$enc, utf8_decode( $metodo->metodo) );
        $objphp->getActiveSheet()->getColumnDimension($columna)->setWidth(30);
        $columna++;
    }
    $columna = chr(ord($columna) - 1);
    $objphp->getActiveSheet()->getStyle('A'.$enc.':'.$columna.$enc)->applyFromArray($estiloTituloColumnas);
      
    
    
    foreach ($reservas as $reserva) {
        $columna = "B";
        $objphp->getActiveSheet()->setCellValue("A".$fila, $reserva->reserva );
        foreach ($metodos as $metodo) {
            $preparedTotalPayments->execute([$reserva->reserva,$metodo->id]);
            $sumaporpagos = $preparedTotalPayments->fetchALL (PDO::FETCH_OBJ);
            $objphp->getActiveSheet()->setCellValue($columna.$fila, $sumaporpagos[0]->total );
            $columna++;
        }
        $fila++;
    }
    
    $columna = chr(ord($columna) - 1);
    $fila--;
    $objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:".$columna.$fila);
    $lastFila = $fila;

    $fila++;
    $fila++;
    $fila++;
    $objphp->getActiveSheet()->setCellValue("A".$fila, 'Total' );
    $columna="B";
    foreach ($metodos as $metodo) {
        $objphp->getActiveSheet()->setCellValue($columna.$fila, '=sum('.$columna.'3:'.$columna.$lastFila.')' );
        $columna++;
    }
    $columna = chr(ord($columna) - 1);
    $objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A".$fila.":".$columna.$fila);
?>