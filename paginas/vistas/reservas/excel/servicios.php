<?php
$camposerv = "nombre_servicio as servicio,id_servicio as id";
$tablaseerv = "servicios_volar";
$filtroserv ="id_servicio in(select DISTINCT(idservi_sv) AS servicio  from servicios_vuelo_temp svt INNER JOIN temp_volar tv  on id_temp = idtemp_sv where svt.status <>0 and tv.status not in (0,6) ";

if(isset($_GET['fechaI']) && $_GET['fechaI']!='' ){
	$filtroserv.= " and fechavuelo_temp >='".$_GET['fechaI']."'";
}
if(isset($_GET['fechaF']) && $_GET['fechaF']!='' ){
	$filtroserv.= " and fechavuelo_temp <='".$_GET['fechaF']."'";
}
if(isset($_GET['status']) && $_GET['status']!='0' ){
	$filtroserv.= " and tv.status = ".$_GET['status'];
}
if(isset($_GET['empleado']) && $_GET['empleado']!='0' ){
	$filtroserv.= " and idusu_temp = ".$_GET['empleado'];
}
if(isset($_GET['reserva']) && $_GET['reserva']!='' ){
	$filtroserv.= " and id_temp = ".$_GET['reserva'];
}
$filtroserv .= " ) and status<>0";
$servicios = $con->consulta($camposerv,$tablaseerv,$filtroserv) ;
/* 2 es cortesia 1 es pagado */
$stmtServ = $conexion->prepare("SELECT cantidad_sv,tipo_sv FROM servicios_vuelo_temp where status <>0  and idtemp_sv = ? and idservi_sv = ? ");
$stmtPag = $conexion->prepare("SELECT cantidad_sv FROM servicios_vuelo_temp where status <>0 and tipo_sv = 2 and idtemp_sv = ? and idservi_sv = ? ");


$col = "B";
$fila=3;
$titulo=1;
$enc=2;

$objphp->createSheet();
$objphp->setActiveSheetIndex(2);
$objphp->getActiveSheet()->setTitle('Servicios por Reserva');

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

$objphp->getActiveSheet()->setCellValue("A".$enc, "Reserva");
$objphp->getActiveSheet()->getColumnDimension("A")->setWidth(20);
foreach ($servicios as $servicio) {

  $objphp->getActiveSheet()->setCellValue($col.$enc, utf8_decode( $servicio->servicio) );
  $objphp->getActiveSheet()->getColumnDimension($col)->setWidth(30);
  $col++;
}
$col--;
$objphp->getActiveSheet()->setCellValue('B'.$titulo, 'Reporte de Servicios de Volar en Globo');
$objphp->getActiveSheet()->mergeCells('B'.$titulo.':'.$col.$titulo);
$objphp->getActiveSheet()->getStyle('A'.$enc.':'.$col.$enc)->applyFromArray($estiloTituloColumnas);
foreach ($reservas as $reserva) {
  $col = "B";
  $objphp->getActiveSheet()->setCellValue("A".$fila, $reserva->reserva );
  foreach ($servicios as $servicio) {
    $stmtServ->execute([$reserva->reserva,$servicio->id]);
    $cantidades = $stmtServ->fetchALL (PDO::FETCH_OBJ);
    $texto = "";
    if(sizeof($cantidades)>0){
      if($cantidades[0]->tipo_sv==1){

          if($cantidades[0]->cantidad_sv==0){
            $text = 1;
          }else{
            $texto = $cantidades[0]->cantidad_sv;
          }
      }else{
        if($cantidades[0]->cantidad_sv==0){
          $texto = 1 . "x Cortesia";
        }else{
          $texto = $cantidades[0]->cantidad_sv . "x Cortesia";
        }

      }
    }else{
      $text = '0';
    }
    $objphp->getActiveSheet()->setCellValue($col.$fila, $texto );
    $col++;
  }

  $fila++;
}

$col--;
$fila--;
$objphp->getActiveSheet()->setSharedStyle($estiloInformacion, "A3:".$col.$fila);

?>
