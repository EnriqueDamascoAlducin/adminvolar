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
    $where1 =" where status in (1,2)  and  metodo_bp = ?  ";
    $where2 =" where status = 3  and  metodo_bp = ?  ";
    $where3 =" where status = 4   and  metodo_bp = ?  ";
    if(isset($_GET['fechaI']) && $_GET['fechaI']!='' ){
        $where1.= " and fecha_bp >='".$_GET['fechaI']."'";
        $where2.= " and fecha_bp >='".$_GET['fechaI']."'";
        $where3.= " and fecha_bp >='".$_GET['fechaI']."'";
    }
    if(isset($_GET['fechaF']) && $_GET['fechaF']!='' ){
        $where1.= " and fecha_bp <='".$_GET['fechaF']."'";
        $where2.= " and fecha_bp <='".$_GET['fechaF']."'";
        $where3.= " and fecha_bp <='".$_GET['fechaF']."'";
    }
    if($_GET['fechaI']=='' &&  $_GET['fechaF']==''  ){
        $where1 .= " and fecha_bp >= CURRENT_TIMESTAMP ";
        $where2 .= " and fecha_bp >= CURRENT_TIMESTAMP ";
        $where3 .= " and fecha_bp >= CURRENT_TIMESTAMP ";
    }
    $preparedTotalPaymentsConfirmed = $conexion->prepare("SELECT IFNULL(sum(cantidad_bp),'') as total FROM bitpagos_volar ".$where1);

    $preparedTotalPaymentsConciliated = $conexion->prepare("SELECT IFNULL(sum(cantidad_bp),'') as total FROM bitpagos_volar  ".$where2);
    $preparedTotalPaymentsWaiting = $conexion->prepare("SELECT IFNULL(sum(cantidad_bp),'') as total FROM bitpagos_volar   ".$where3);


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
    $objphp->getActiveSheet()->getStyle('A1:D1')->applyFromArray($estiloTituloReporteSmall);
    
    $objphp->getActiveSheet()->getRowDimension(1)->setRowHeight(100);
    $objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
    $objphp->getActiveSheet()->setCellValue('B'.$titulo, "Reporte de Formas de Pago Volar en Globo");
    $objphp->getActiveSheet()->getStyle('B'.$titulo)->getAlignment()->setWrapText(true); 
    
    $objphp->getActiveSheet()->mergeCells('B'.$titulo.':D'.$titulo);
    $objphp->getActiveSheet()->setCellValue("A".$enc, "Metodo");
    $objphp->getActiveSheet()->getColumnDimension("A")->setWidth(20);
    $objphp->getActiveSheet()->setCellValue("B".$enc, "Esperando Conciliación");
    $objphp->getActiveSheet()->getColumnDimension("B")->setWidth(25);
    $objphp->getActiveSheet()->setCellValue("C".$enc, "Conciliado");
    $objphp->getActiveSheet()->getColumnDimension("C")->setWidth(20);
    $objphp->getActiveSheet()->setCellValue("D".$enc, "Confirmado");
    $objphp->getActiveSheet()->getColumnDimension("D")->setWidth(20);
    $objphp->getActiveSheet()->getStyle('A'.$enc.':'.'D'.$enc)->applyFromArray($estiloTituloColumnas);
      
    
    
    foreach ($metodos as $metodo) {
        $objphp->getActiveSheet()->setCellValue("A".$fila, $metodo->metodo );
            $preparedTotalPaymentsWaiting->execute([$metodo->id]);
            $sumaporpagos = $preparedTotalPaymentsWaiting->fetchALL (PDO::FETCH_OBJ);
            $objphp->getActiveSheet()->setCellValue("B".$fila, $sumaporpagos[0]->total );


            $preparedTotalPaymentsConciliated->execute([$metodo->id]);
            $sumaporpagos = $preparedTotalPaymentsConciliated->fetchALL (PDO::FETCH_OBJ);
            $objphp->getActiveSheet()->setCellValue("C".$fila, $sumaporpagos[0]->total );

            $preparedTotalPaymentsConfirmed->execute([$metodo->id]);
            $sumaporpagos = $preparedTotalPaymentsConfirmed->fetchALL (PDO::FETCH_OBJ);
            $objphp->getActiveSheet()->setCellValue("D".$fila, $sumaporpagos[0]->total );
        $fila++;
    }
    $fila--;
    $objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A2:".'D'.$fila);
    $fila=$fila+4;
    $objphp->getActiveSheet()->setCellValue("A".$fila, 'Total');
    $objphp->getActiveSheet()->setCellValue("B".$fila, '=SUM(B2:B'.$fila.')');
    $objphp->getActiveSheet()->setCellValue("C".$fila, '=SUM(C2:C'.$fila.')');
    $objphp->getActiveSheet()->setCellValue("D".$fila, '=SUM(D2:D'.$fila.')');
    $objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A".$fila.":".'D'.$fila);
?>