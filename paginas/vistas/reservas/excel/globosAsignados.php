<?php
/* Consulta Preparada */
$conexion = $con->getConexion();
$stmt = $conexion->prepare("SELECT version_ga as version,nombre_globo as globo, peso_ga as peso, pax_ga as pax, CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as piloto  FROM  globosasignados_volar ga INNER JOIN volar_usuarios uv ON piloto_ga = id_usu INNER JOIN globos_volar gb ON id_globo=globo_ga WHERE ga.status<>0 AND reserva_ga = ?");
$fila=3;
$titulo=1;
$enc=2;

$objphp->createSheet();
$objphp->setActiveSheetIndex($pagina);
$objphp->getActiveSheet()->setTitle('Globos Asignados por Reserva ');

$objDrawing = new PHPExcel_Worksheet_MemoryDrawing();
$objDrawing->setName('Logotipo');
$objDrawing->setDescription('Logotipo');
$objDrawing->setImageResource($gdImage);
$objDrawing->setRenderingFunction(PHPExcel_Worksheet_MemoryDrawing::RENDERING_PNG);
$objDrawing->setMimeType(PHPExcel_Worksheet_MemoryDrawing::MIMETYPE_DEFAULT);
$objDrawing->setHeight(100);
$objDrawing->setCoordinates('A1');
$objDrawing->setWorksheet($objphp->getActiveSheet());
$objphp->getActiveSheet()->getStyle('A1:G1')->applyFromArray($estiloTituloReporte);
$objphp->getActiveSheet()->getRowDimension(1)->setRowHeight(100);
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(25);
//$objphp->getActiveSheet()->setCellValue('B'.$titulo,'Reporte de Vuelos de Volar en Globo');


$objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Asignaciones de Volar en Globo');
$objphp->getActiveSheet()->mergeCells('B'.$titulo.':H'.$titulo);
$objphp->getActiveSheet()->getStyle('A'.$enc.':H'.$enc)->applyFromArray($estiloTituloColumnas);


$objphp->getActiveSheet()->setCellValue('A'.$enc, 'Reserva');
$objphp->getActiveSheet()->getColumnDimension('A')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('B'.$enc, 'Pasajero');
$objphp->getActiveSheet()->getColumnDimension('B')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('C'.$enc, 'Piloto');
$objphp->getActiveSheet()->getColumnDimension('C')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('D'.$enc, 'Fecha');
$objphp->getActiveSheet()->getColumnDimension('D')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('E'.$enc, 'Hora');
$objphp->getActiveSheet()->getColumnDimension('E')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('F'.$enc, 'PaX');
$objphp->getActiveSheet()->getColumnDimension('F')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('G'.$enc, 'Globo');
$objphp->getActiveSheet()->getColumnDimension('G')->setWidth(20);
$objphp->getActiveSheet()->setCellValue('H'.$enc, 'Turno');
$objphp->getActiveSheet()->getColumnDimension('H')->setWidth(20);

foreach ($reservas as $reserva) {

  $stmt->execute([$reserva->reserva]);
  $resultados = $stmt->fetchALL (PDO::FETCH_OBJ);
  foreach ($resultados as $resultado) {
    $objphp->getActiveSheet()->setCellValue('A'.$fila, $reserva->reserva);
    $objphp->getActiveSheet()->getColumnDimension('A')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('B'.$fila, $reserva->cliente);
    $objphp->getActiveSheet()->getColumnDimension('B')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('C'.$fila, $resultado->piloto);
    $objphp->getActiveSheet()->getColumnDimension('C')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('D'.$fila, $reserva->fechavuelo);
    $objphp->getActiveSheet()->getColumnDimension('D')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('E'.$fila, $reserva->hora);
    $objphp->getActiveSheet()->getColumnDimension('E')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('F'.$fila, $resultado->pax);
    $objphp->getActiveSheet()->getColumnDimension('F')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('G'.$fila,  $resultado->globo);
    $objphp->getActiveSheet()->getColumnDimension('G')->setWidth(20);
    $objphp->getActiveSheet()->setCellValue('H'.$fila, $reserva->turno);
    $fila++;
  }
}

$fila--;
$objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:G".$fila);
?>
