<?php

require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/pdfs/confirmacionEsp.php';
if(isset($_SESSION['usuario'])){
      $usuario= unserialize((base64_decode($_SESSION['usuario'])));
  }

  $totalReserva=0.0;
  $totalReserva+=$totalVuelo;
  $totalReserva +=$datosReserva[0]->precio1;
  $totalReserva +=$datosReserva[0]->precio2;
  if(isset($datosReserva[0]->habitacion) && $datosReserva[0]->habitacion!=''){
   $totalReserva+=$totalHabitacion;
  }
?>
<?php
/// Datos de Correo
//$getVendedorInfo[0]->nombre

$textoActual='Confirmación Volar en Globo';
$correos=[array($datosReserva[0]->correo,$datosReserva[0]->nombre)];
$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
$asunto = "Confirmación de Vuelo: ". $reserva;
$cuerpo='<!DOCTYPE html>
      <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
          <link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
          <style type="text/css">

            #direccionvga{
              background:#aa66cc;
              width:100%;
              height:35px;
              color:white;

            }
            #direccionvga:hover{
              background:#9933CC;

            }
            .tdtitulo{
              background: #7986cb ;
              text-align: center;
              vertical-align: middle;
              color: white;
            }
            .tdseparador{
              background: #2BBBAD ;
              text-align: center;
              vertical-align: middle;
              color: white;
            }
            .tdtotal{
              background: #9933CC ;
              text-align: center;
              vertical-align: middle;
              color: white;
            }
            .tddesc{
              background: #c51162 ;
              text-align: center;
              vertical-align: middle;
              color: white;
            }
            td,th{
              max-height: 5px!important;
            }
            @media (max-width: 576px){
              td{
                font-size:75%;
                width:30%
                max-width:30%;
                table-layout: fixed;
              }
            }
          </style>
          <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        </head>';
$cuerpo.=   '<body>';
$cuerpo.=     '<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/confirmacionHeader.jpeg" style="width:100%; max-width=100%;" alt="Confirmacion">';
$cuerpo.=     '<p>';
$cuerpo.=       'Hola!!! <b>'.$datosReserva[0]->nombre.'</b>. Envío confirmación de vuelo, no olvides llevarla contigo el día de tu vuelo (No es necesario imprimirla). </p>';
$cuerpo.=       '<p><b>Registro y Pago:</b> El día de tu vuelo deberás presentarte con nuestro anfitrión en la recepción para que registre tu asistencia y te reciba el pago del restante. Recuerda estar a tiempo en el lugar de la cita para no retrasar tu vuelo ni el de los demás. Te aconsejamos traer ropa cómoda, tal como si fueras a un día de campo: gorra, bufanda, guantes, bloqueador solar, cámara fotográfica o de video.</p>';


$cuerpo.=     '<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">';
$cuerpo.=       '<table border="1">';
$cuerpo.=         '<thead>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<th class="tdtitulo" colspan="4">';
$cuerpo.=               'RESERVA No.'. $reserva;
$cuerpo.=             '</th>';
$cuerpo.=           '</tr>';
$cuerpo.=         '</thead>';
$cuerpo.=         '<tbody>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">FECHA DE VUELO</td>';
$cuerpo.=             '<td >'.convertirFecha($datosReserva[0]->fechavuelo).'</td>';
$cuerpo.=             '<td colspan="2" ></td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">NOMBRE</td>';
$cuerpo.=             '<td >'.$datosReserva[0]->nombre.'</td>';
$cuerpo.=             '<td colspan="2"></td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">TELÉFONOS</td>';
$cuerpo.=             '<td >'.$datosReserva[0]->telefonos.'</td>';
$cuerpo.=             '<td colspan="2"></td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">TIPO DE VUELO</td>';
$cuerpo.=             '<td >'.utf8_encode($datosReserva[0]->tipoVuelo).'</td>';
$cuerpo.=             '<td colspan="2"></td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">PASAJEROS</td>';
$cuerpo.=             '<td >Adultos:'.$datosReserva[0]->pasajerosA.'<br>Ni&ntilde;os:'.$datosReserva[0]->pasajerosN .'</td>';
$cuerpo.=             '<td colspan="2"colspan="2">$ ';
$cuerpo.=                 number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ;
$cuerpo.=             '</td>';
$cuerpo.=           '</tr>';
if($datosReserva[0]->comentario!=''){
  $cuerpo.=           '<tr>';
  $cuerpo.=             '<td class="tdtitulo">COMENTARIO</td>';
  $cuerpo.=             '<td>'. $datosReserva[0]->comentario.'</td>';
  $cuerpo.=             '<td colspan="2"></td>';
  $cuerpo.=           '</tr>';
}
if($datosReserva[0]->motivo!=''){
  $cuerpo.=           '<tr>';
  $cuerpo.=             '<td class="tdtitulo">MOTIVO</td>';
  $cuerpo.=             '<td>'. $datosReserva[0]->motivo.'</td>';
  $cuerpo.=             '<td colspan="2"></td>';
  $cuerpo.=           '</tr>';
}



if($datosReserva[0]->hotel!=''){
  $cuerpo.=           '<tr>';
  $cuerpo.=             '<td class="tdseparador" colspan="4">HOTEL</td>';
  $cuerpo.=           '</tr>';
  $cuerpo.=           '<tr>';
  $cuerpo.=             '<td class="tdtitulo" colspan="4">'.$hotel.'<br>$ '. number_format(  $precioHabitacion, 2, '.', ',') .'</td>';
  $cuerpo.=           '</tr>';
  $cuerpo.=           '<tr>';
  $cuerpo.=             '<td class="tdtitulo" >HABITACIÓN</td>';
  $cuerpo.=             '<td >'.$nombreHabitacion.'</td>';
  $cuerpo.=             '<td ></td>';
  $cuerpo.=           '</tr>';
  $cuerpo.=           '<tr>';
  $cuerpo.=             '<td class="tdtitulo" >PRECIO/NOCHE</td>';
  $cuerpo.=             '<td >'.$descripcionHospedaje.'</td>';
  $cuerpo.=             '<td >$ '.number_format(  $totalHabitacion, 2, '.', ',').'</td>';
  $cuerpo.=           '</tr>';

}
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">VENDEDOR</td>';
$cuerpo.=             '<td >'.$vendedor[0].'</td>';
$cuerpo.=             '<td colspan="2"></td>';
$cuerpo.=           '</tr>';
if($datosReserva[0]->otroscar1!=''){
  $cuerpo.=         '<tr>';
  $cuerpo.=           '<td class="tdtitulo">'. $datosReserva[0]->otroscar1. '</td>';
  $cuerpo.=           '<td >$ '. number_format( $datosReserva[0]->precio1 , 2, '.', ','). '</td>';
$cuerpo.=             '<td colspan="2"></td>';
  $cuerpo.=         '</tr>';
}
if($datosReserva[0]->otroscar2!=''){
  $cuerpo.=         '<tr>';
  $cuerpo.=           '<td class="tdtitulo">'. $datosReserva[0]->otroscar2. '</td>';
  $cuerpo.=           '<td >$ '. number_format( $datosReserva[0]->precio2 , 2, '.', ','). '</td>';
$cuerpo.=             '<td colspan="2"></td>';
  $cuerpo.=         '</tr>';
}
if(sizeof($serviciosReserva)>0){
  $cuerpo.=         '<tr>';
  $cuerpo.=           '<td class="tdseparador" colspan="3">SERVICIOS SOLICITADOS  </td>';
  $cuerpo.=         '</tr>';
  foreach ($serviciosReserva as $servicioReserva) {
    $cuerpo.=       '<tr>';
    $cuerpo.=         '<td class="tdtitulo">'. $servicioReserva->servicio .'</td>';
    if($servicioReserva->tipo==1){
      if ($servicioReserva->cantmax == 1){
        $totalReserva +=($totalPasajeros * $servicioReserva->precio );
        $cuerpo.=       '<td>'.$tPasajeros.'</td>';
        $cuerpo.=       '<td colspan="2">$ '.number_format(($totalPasajeros * $servicioReserva->precio ), 2, '.', ',').'</td>';
      }else{
        $totalReserva += $servicioReserva->precio ;
        $cuerpo.=       '<td></td>';
        $cuerpo.=       '<td colspan="2">$ '.number_format($servicioReserva->precio, 2, '.', ',').'</td>';
      }
    }else{
      $cuerpo.=       '<td>';
      $cuerpo.=         'Cortesia';
      $cuerpo.=       '<td>';
      $cuerpo.=       '<td colspan="2"></td>';
    }
    $cuerpo.=       '</tr>';
  }
}
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtotal">SUBTOTAL</td>';
$cuerpo.=             '<td ></td>';
$cuerpo.=             '<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
$cuerpo.=           '</tr>';
if($datosReserva[0]->tdescuento!='' && $datosReserva[0]->cantdescuento>0) {
  if($datosReserva[0]->tdescuento==1){
    $totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
  }else{
    $totalDescuento = $datosReserva[0]->cantdescuento;
  }
  $cuerpo.=         '<tr>';
  $cuerpo.=           '<td class="tddesc">DESCUENTO</td>';
  $cuerpo.=           '<td ></td>';
  $cuerpo.=           '<td colspan="2">';
  if($datosReserva[0]->tdescuento==1) {
    $cuerpo.=            $datosReserva[0]->cantdescuento."% ($" .number_format($totalDescuento, 2, '.', ',').")";
  }else{
    $cuerpo.=           '$'.$totalDescuento;
  }
  $cuerpo.=           '</td>';
  $cuerpo.=         '</tr>';
  $totalReserva-=$totalDescuento;
}

if(sizeof($movimientosExtras)>0){ 
  foreach ($movimientosExtras as $movimientoExtra) { 
    $cuerpo.='<tr >';
    $cuerpo.= '<td class="tdtitulo">'.$movimientoExtra->motivo_ce .'</td>';
    $cuerpo.= '<td></td>';
    if($movimientoExtra->tipo_ce==1){
      $cuerpo.= '<td>$ '.$movimientoExtra->cantidad_ce.'</td>';
      $totalReserva+=$movimientoExtra->cantidad_ce;
    }else{
      $cuerpo.= '<td>-$ '.$movimientoExtra->cantidad_ce.'</td>';
      $totalReserva-=$movimientoExtra->cantidad_ce; 
    }
    $cuerpo.='</tr>';
  } 
}
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">ANTICIPO</td>';
$cuerpo.=             '<td ></td>';
$cuerpo.=             '<td colspan="2">$ '.number_format($pagoInfo[0]->cantidad, 2, '.', ',').'</td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtitulo">ANTICIPO TOTAL</td>';
$cuerpo.=             '<td ></td>';
$cuerpo.=             '<td colspan="2">$ '.number_format($totalPagos[0]->totalPagos, 2, '.', ',').'</td>';
$cuerpo.=           '</tr>';
                $totalReserva-=$totalPagos[0]->totalPagos;
$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdtotal">TOTAL</td>';
$cuerpo.=             '<td ></td>';
$cuerpo.=             '<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
$cuerpo.=           '</tr>';

$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="" colspan="4">A partir de 6:00 AM los esperamos en nuestra recepción, sin embargo esta hora sera CONFIRMADA UN DIA ANTES de acuerdo a la logística de operación del día o a las condiciones meteorológicas, te pido estés al tanto ya que recibirás una llamada para confirmar horario</td>';
$cuerpo.=           '</tr>';

$cuerpo.=           '<tr>';
$cuerpo.=             '<td class="tdseparador" colspan="4">PUNTO DE REUNION:  </td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td  colspan="4"><a href="https://www.google.com/maps/place//data=!4m2!3m1!1s0x85d1c03008c08e6d:0x2cd1a4cc8c3f3d5c?utm_source=mstt_1&utm_medium=mstt_2">
Recepción Volar en Globo, Aventura y Publicidad SA de CV. Esquina Francisco Villa con Carretera Libre Mexico- Tulancingo (132) C.P. 55850 (Puedes dar clic aqui para abrir la ubicación en maps).</a></td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>';
$cuerpo.=             '<td colspan="4">';
$cuerpo.=               '<ol type="1">
                      <li>Qué incluye tu vuelo:</li>
                      <ul>
                        <li>Tiempo de vuelo de 45 minutos aproximadamente.</li>
                        <li>Coffee Break.</li>
                        <li>Transporte local durante toda la actividad (Teotihuacan).</li>
                        <li>Seguro de Viajero.</li>
                        <li>Certificado personalizado.</li>
                        <li>Brindis tradicional con vino blanco espumoso durante o después del vuelo dependiendo del tipo de vuelo contratado.</li>
                      </ul>
                      <li>Restricciones:</li>
                      <ul>
                        <li>Ni&ntilde;os menores a 4 a&ntilde;os.</li>
                        <li>Si ha padecido del corazón.</li>
                        <li>Si tiene una cirugia reciente.</li>
                        <li>Problemas de la columna.</li>
                        <li>Mujeres embarazadas.</li>
                        <li>No se puede abordar en estado inconveniente.</li>
                        <li>No se permiten abordar con: equipaje, armas punzocortantes o de fuego.</li>
                      </ul>
                      <li>Restricciones para los vuelos:</li>
                      <ul>
                        <li>Cuando las condiciones climatológicas no lo permita (Vientos mayor a 20 Km.).</li>
                        <li>Lluvia y/o tormenta eléctrica.</li>
                        <li>Exceso de neblina.</li>
                        <li>En caso de alguna de estas causas se reprogramara el vuelo en acuerdo mutuo.</li>
                      </ul>
                        <li>Cambio de fecha de vuelo o cancelaciones:</li>
                      <ul>
                        <li>
                          En caso de no poder asistir a la cita por circunstancias adversas e imprevistas, deberá cancelar y confirmar la cancelación vía telefónica con al menos 36 horas de anticipación para que se te haga una reprogramación de tu vuelo sin cargo alguno, si la cancelación se hace dentro del periodo de las 36 a 12 horas previo a la realización del vuelo, se podrá reprogramar el vuelo con un cargo adicional al precio total del 35% por gastos de administración y operación. Si no existe cancelación y confirmación de cancelación o no se presentara el pasajero perderá el derecho a reembolso alguno.
                        </li>
                        <li>
                          En caso de que se requiera reprogramar un vuelo; es responsabilidad del pasajero reprogramar en un período no mayor a 12 meses de lo contrario se perderá el derecho al vuelo.
                        </li>
                        <li>
                          Recuerda estar a tiempo en el lugar de la cita para no perder tu vuelo y/o generar cargos adicionales.
                        </li>
                        <li>
                          El tiempo estimado de vuelo es hasta de una hora pero si las condiciones no lo permiten, la empresa lo deja a consideración del piloto. Así que no habrá reembolso alguno por vuelos con duración menor a una hora.
                        </li>
                      </ul>
                    </ol>';
$cuerpo.=             '</td>';
$cuerpo.=           '</tr>';
$cuerpo.=           '<tr>
                  <td colspan="4" class="tdseparador">Direccion y Como Llegar:</td>
                </tr>';
$cuerpo.=           '<tr>';
  $cuerpo.=           '<td colspan="4">';
    $cuerpo.=           'Tomar Insurgentes Norte hacia México-Pachuca autopista 85D,  en cuanto llegues a las casetas de peaje  tomar las del lado derecho con dirección a Pirámides – Tulancingo autopista 132D, sigue los señalamientos hacia Pirámides Tulancingo, ahí pagaras una caseta, seguir sobre la autopista hasta pasar una gasolinera del lado derecho (aproximadamente 17 Km), tomar la desviación hacia Pirámides y continuar hasta la desviación a Tulancingo Libre, continuar sobre esta carretera, 5 Km adelante a tu mano izquierda vas a encontrar una Estación de Policía Federal, un poco más adelante encontraras una salida a mano izquierda antes del puente, debes girar a la izquierda nuevamente y allí 200 metros adelante encontraras ';
    $cuerpo.=           '<a href="https://www.google.com/maps/place/VOLAR+EN+GLOBO/@19.6956647,-98.8269878,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.6956597!4d-98.8247938">';
    $cuerpo.=           'Volar en Globo.';
    $cuerpo.=           '</a>';
    $cuerpo.=           '<hr>
                        <a href="https://www.google.com/maps/place/VOLAR+EN+GLOBO/@19.6956647,-98.8269878,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.6956597!4d-98.8247938">
                          <button type="button" class="btn btn-info btn-lg" id="direccionvga" style="background:#aa66cc; width:100%; height:35px; color:white;">Ver Dirección</button>
                        </a>
                        <hr>
                        <a href="https://volarenglobo.com.mx/Politicas_de_Pago_devoluciones.pdf">
                          Politicas de Pago y Devoluciones
                        </a>
                        <hr>
                        Sin más por el momento quedo a sus órdenes para cualquier duda o aclaración respecto al servicio contratado.';
  $cuerpo.='</td>';
$cuerpo.='</tr>';
$cuerpo.=         '</tbody>';
$cuerpo.=       '</table>';
$cuerpo.=     '</div>';
if($_POST['accion']=='regalo'){
  $cuerpo.=   '<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/cupon-descuento-volar-en-globo.jpg" style="width:100%;max-width:100%">';
}
$cuerpo.=     '<p style="font-size:14px">Para más información por favor comunícate con tu vendedor</p>';
$cuerpo.=     '<b>'.$getVendedorInfo[0]->nombre.'</b><br>';
$cuerpo.=     '<i>'.$vendedor[1].'<br>'.$vendedor[2].'</i>';
$cuerpo.=   '</body>';
$cuerpo.= '</html>';
//echo $cuerpo;
$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
require_once  $ruta;

?>
