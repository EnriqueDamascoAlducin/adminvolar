<?php

  require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
  $reserva=1414;
  $tablas = "temp_volar t INNER JOIN vueloscat_volar vc ON  t.tipo_temp = vc.id_vc INNER JOIN descuentos_volar descu ON  t.id_temp=descu.reserva_desc";
  $datosReserva = $con->consulta("IFNULL(pasajerosa_temp,'0') as pasajerosa, IFNULL(pasajerosn_temp,'0') as pasajerosn,nombre_vc as vuelo, IFNULL(precioa_vc,'0') AS precioa, IFNULL(precion_vc,'0') as precion , tipo_temp as vuelo ,fechavuelo_temp as fechavuelo, IFNULL(hotel_temp,'') as hotel, IFNULL(habitacion_temp,'') as habitacion, IFNULL(checkin_temp,'') as checkin, IFNULL(checkout_temp,'') as checkout,IFNULL(otroscar1_temp,'') AS otroscar1, IFNULL(precio1_temp,'') as precio1,IFNULL(otroscar2_temp,'') AS otroscar2, IFNULL(precio2_temp,'') as precio2, IFNULL(tdescuento_temp,'') as tdescuento, IFNULL(cantdescuento_temp,'0') as cantdescuento,IFNULL(pesoextra_temp,'0') as pesoextra ,IFNULL(SUM(descuento_desc),'0') as descuentos, IFNULL(motivo_desc,'') as motivoDes, id_Temp as reserva ", $tablas, "id_temp = " .$reserva);
  $totalReserva = 0;
  $totalReserva += ($datosReserva[0]->pasajerosa * $datosReserva[0]->precioa);
  $totalReserva += ($datosReserva[0]->pasajerosn * $datosReserva[0]->precion);
  if($datosReserva[0]->precio1!=0){
      $totalReserva += $datosReserva[0]->precio1;
  }
  if($datosReserva[0]->precio2!=0){
      $totalReserva += $datosReserva[0]->precio2;
  }

  /* SUMAR LOS SERVICIOS*/


  if($datosReserva[0]->tdescuento!=''){
    if($datosReserva[0]->tdescuento==1){
      $totalReserva-= ($datosReserva[0]->cantdescuento * $totalReserva)/100;
    }else{
      $totalReserva-=$datosReserva[0]->cantdescuento;
    }
  }

  /* Agregar precio sobre peso extra */
  $totalReserva += $datosReserva[0]->pesoextra;


  /* Restar descuentos extras*/
  if($datosReserva[0]->descuentos!=0){
    $totalReserva-=$datosReserva[0]->descuentos;
  }
  echo $totalReserva;
  /* */
?>
