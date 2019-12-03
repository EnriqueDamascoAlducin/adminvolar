<?php
require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/vistas/reservas/pdfs/confirmacionEng.php';
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

$textoActual='Flight Confirmation Volar en Globo';
$correos=[array($datosReserva[0]->correo,$datosReserva[0]->nombre)];
$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
$asunto = "FLIGHT CONFIRMATION ";
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
              font-size: 10px;
            }
            @media (max-width: 576px){
              td{
                font-size:60%;
                width:30%
                max-width:30%;
                  table-layout: fixed;
              }
            }
          </style>
          <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
        </head>';
$cuerpo.=		'<body>';
$cuerpo.=			'<img src="https://www.volarenglobo.com.mx/admin1/sources/images/correos/confirmationHeader.jpeg" style="width:100%; max-width=100%;" alt="Confirmacion">';
$cuerpo.=			'<p>Hello!!! <b>'.$datosReserva[0]->nombre.'</b>. This is your flight confirmation. It’s not necessary to be printed! </p>';
$cuerpo.=				'<p><b>Registration and Payment:</b> Your flight date, you must get to our reception where our hostess will welcome you, make your registration and get the remaining payment. Remember to be on time at the appointment place. Our advice is to bring comfortable clothes, just as if you were on a picnic: cap, scarf, gloves, jacket, sunscreen, and camera.</p>';


$cuerpo.=			'<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">';
$cuerpo.=				'<table border="1">';
$cuerpo.=					'<thead>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<th class="tdtitulo" colspan="4">';
$cuerpo.=								'FLIGHT INFORMATION';
$cuerpo.=							'</th>';
$cuerpo.=						'</tr>';
$cuerpo.=					'</thead>';
$cuerpo.=					'<tbody>';


$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">REFERENCE:</td>';
$cuerpo.=							'<td >'.$reserva.'</td>';
$cuerpo.=							'<td colspan="2" ></td>';
$cuerpo.=						'</tr>';

$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">NAME: </td>';
$cuerpo.=							'<td >'.$datosReserva[0]->nombre.'</td>';
$cuerpo.=							'<td colspan="2"></td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">TELEPHONE</td>';
$cuerpo.=							'<td >'.$datosReserva[0]->telefonos.'</td>';
$cuerpo.=							'<td colspan="2"></td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">FLIGHT DATE</td>';
$cuerpo.=							'<td >'.convertirFecha($datosReserva[0]->fechavuelo).'</td>';
$cuerpo.=							'<td colspan="2" ></td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">FLIGHT</td>';
$cuerpo.=							'<td >'.utf8_encode($datosReserva[0]->tipoVuelo).'</td>';
$cuerpo.=							'<td colspan="2"></td>';
$cuerpo.=						'</tr>';

$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">ADULTS: </td>';
$cuerpo.=							'<td >'.$datosReserva[0]->pasajerosA.'</td>';
$cuerpo.=							'<td colspan="2"colspan="2">$ ';
$cuerpo.=									number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ), 2, '.', ',') ;
$cuerpo.=							'</td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">KIDS: </td>';
$cuerpo.=							'<td >'.$datosReserva[0]->pasajerosN.'</td>';
$cuerpo.=							'<td colspan="2"colspan="2">$ ';
$cuerpo.=									number_format(($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ;
$cuerpo.=							'</td>';
$cuerpo.=						'</tr>';

/*
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">PASAJEROS</td>';
$cuerpo.=							'<td >Adultos:'.$datosReserva[0]->pasajerosA.'<br>Ni&ntilde;os:'.$datosReserva[0]->pasajerosN .'</td>';
$cuerpo.=							'<td colspan="2"colspan="2">$ ';
$cuerpo.=									number_format(($datosReserva[0]->pasajerosA*$datosReserva[0]->precioA ) + ($datosReserva[0]->pasajerosN*$datosReserva[0]->precioN ), 2, '.', ',') ;
$cuerpo.=							'</td>';
$cuerpo.=						'</tr>';
*/


if($datosReserva[0]->motivo!=''){
  $cuerpo.=						'<tr>';
  $cuerpo.=							'<td class="tdtitulo">OCASSION: </td>';
  $cuerpo.=							'<td>'. $datosReserva[0]->motivo.'</td>';
  $cuerpo.=							'<td colspan="2"></td>';
  $cuerpo.=						'</tr>';
}
if($datosReserva[0]->comentario!=''){
  $cuerpo.=						'<tr>';
  $cuerpo.=							'<td class="tdtitulo">COMMENTS</td>';
  $cuerpo.=							'<td>'. $datosReserva[0]->comentario.'</td>';
  $cuerpo.=							'<td colspan="2"></td>';
  $cuerpo.=						'</tr>';
}



if($datosReserva[0]->hotel!=''){
  $cuerpo.=						'<tr>';
  $cuerpo.=							'<td class="tdseparador" colspan="4">HOTEL</td>';
  $cuerpo.=						'</tr>';
  $cuerpo.=						'<tr>';
  $cuerpo.=							'<td class="tdtitulo" colspan="4">'.$hotel.'<br>$ '. number_format(  $precioHabitacion, 2, '.', ',') .'</td>';
  $cuerpo.=						'</tr>';
  $cuerpo.=						'<tr>';
  $cuerpo.=							'<td class="tdtitulo" >ROOM</td>';
  $cuerpo.=							'<td >'.$nombreHabitacion.'</td>';
  $cuerpo.=							'<td ></td>';
  $cuerpo.=						'</tr>';
  $cuerpo.=						'<tr>';
  $cuerpo.=							'<td class="tdtitulo" >PRICE/NIGHT</td>';
  $cuerpo.=							'<td >'.$descripcionHospedaje.'</td>';
  $cuerpo.=							'<td >$ '.number_format(  $totalHabitacion, 2, '.', ',').'</td>';
  $cuerpo.=						'</tr>';

}
/*
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">VENDEDOR</td>';
$cuerpo.=							'<td >'.$vendedor[0].'</td>';
$cuerpo.=							'<td colspan="2"></td>';
$cuerpo.=						'</tr>';
*/
if($datosReserva[0]->otroscar1!=''){
  $cuerpo.=					'<tr>';
  $cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar1. '</td>';
  $cuerpo.=						'<td >$ '. number_format( $datosReserva[0]->precio1 , 2, '.', ','). '</td>';
$cuerpo.=							'<td colspan="2"></td>';
  $cuerpo.=					'</tr>';
}
if($datosReserva[0]->otroscar2!=''){
  $cuerpo.=					'<tr>';
  $cuerpo.=						'<td class="tdtitulo">'. $datosReserva[0]->otroscar2. '</td>';
  $cuerpo.=						'<td >$ '. number_format( $datosReserva[0]->precio2 , 2, '.', ','). '</td>';
$cuerpo.=							'<td colspan="2"></td>';
  $cuerpo.=					'</tr>';
}
if(sizeof($serviciosReserva)>0){
  $cuerpo.=					'<tr>';
  $cuerpo.=						'<td class="tdseparador" colspan="3">SERVICES</td>';
  $cuerpo.=					'</tr>';
  foreach ($serviciosReserva as $servicioReserva) {
    $cuerpo.=				'<tr>';
    $cuerpo.=					'<td class="tdtitulo">'. $servicioReserva->servicio .'</td>';
    if($servicioReserva->tipo==1){
      if ($servicioReserva->cantmax == 1){
        $totalReserva +=($totalPasajeros * $servicioReserva->precio );
        $cuerpo.=				'<td>'.$tPasajeros.'</td>';
        $cuerpo.=				'<td colspan="2">$ '.number_format(($totalPasajeros * $servicioReserva->precio ), 2, '.', ',').'</td>';
      }else{
        $totalReserva += $servicioReserva->precio ;
        $cuerpo.=				'<td></td>';
        $cuerpo.=				'<td colspan="2">$ '.number_format($servicioReserva->precio, 2, '.', ',').'</td>';
      }
    }else{
      $cuerpo.=				'<td>';
      $cuerpo.=					'INCLUDED';
      $cuerpo.=				'</td>';
      $cuerpo.=				'<td colspan="2"></td>';
    }
    $cuerpo.=				'</tr>';
  }
}
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtotal">SUBTOTAL</td>';
$cuerpo.=							'<td ></td>';
$cuerpo.=							'<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
$cuerpo.=						'</tr>';
if($datosReserva[0]->tdescuento!='' && $datosReserva[0]->cantdescuento>0) {
  if($datosReserva[0]->tdescuento==1){
    $totalDescuento = ($totalReserva * $datosReserva[0]->cantdescuento )/100;
  }else{
    $totalDescuento = $datosReserva[0]->cantdescuento;
  }
  $cuerpo.=					'<tr>';
  $cuerpo.=						'<td class="tddesc">DISCOUNT</td>';
  $cuerpo.=						'<td ></td>';
  $cuerpo.=						'<td colspan="2">';
  if($datosReserva[0]->tdescuento==1) {
    $cuerpo.=						 $datosReserva[0]->cantdescuento."% ($" .number_format($totalDescuento, 2, '.', ',').")";
  }else{
    $cuerpo.=						'$ '.$totalDescuento;
  }
  $cuerpo.=						'</td>';
  $cuerpo.=					'</tr>';
  $totalReserva-=$totalDescuento;
}
/*
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">CURRENT PAY</td>';
$cuerpo.=							'<td ></td>';
$cuerpo.=							'<td colspan="2">$ '.number_format($pagoInfo[0]->cantidad, 2, '.', ',').'</td>';
$cuerpo.=						'</tr>';*/
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtitulo">ADVANCE PAYMENT</td>';
$cuerpo.=							'<td ></td>';
$cuerpo.=							'<td colspan="2">$ '.number_format($totalPagos[0]->totalPagos, 2, '.', ',').'</td>';
$cuerpo.=						'</tr>';
                $totalReserva-=$totalPagos[0]->totalPagos;
$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdtotal">REMAINDER</td>';
$cuerpo.=							'<td ></td>';
$cuerpo.=							'<td colspan="2">$ '.number_format($totalReserva, 2, '.', ',') .'</td>';
$cuerpo.=						'</tr>';

$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="" colspan="4">From 6:00 a.m. we wait you at our reception, however this time will be <b>CONFIRMED ONE DAY BEFORE</b> your flight day according to the logistic of the day or weather conditions, please be aware as you will receive a call or message to confirm the schedule.</td>';
$cuerpo.=						'</tr>';

$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="" colspan="4">*All Our Prices are Expressed in Mexican Pesos.</td>';
$cuerpo.=						'</tr>';

$cuerpo.=						'<tr>';
$cuerpo.=							'<td class="tdseparador" colspan="4">Meeting Point:	</td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td  colspan="4"><h5><a href="https://www.google.com.mx/maps/place/VOLAR+EN+GLOBO/@19.6956647,-98.8269825,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.6956597!4d-98.8247938">Volar en Globo Reception.</a></h5></td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td  colspan="4"><b>Waze</b>: Globodromo Volar en Globo</td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
$cuerpo.=							'<td colspan="4">';
$cuerpo.=								'<ol type="1">
                          <li>Restrictions:</li>
                          <ul>
                            <li>Children under 4 years old.</li>
                            <li>If you have suffered a heart disease.</li>
                            <li>If you have had a recent surgery.</li>
                            <li>Injured column.</li>
                            <li>Pregnant women.</li>
                            <li>If you are intoxicated. (Alcohol or drugs)</li>
                            <li>It is not allowed to board with: luggage, sharps or firearms.</li>
                            <li>*People over 100 kg, must pay $25.00 per extra kilo.</li>
                          </ul>
                          <li>Weather restrictions:</li>
                          <ul>
                            <li>Winds over 20 km/hr.</li>
                            <li>Rain or electric storm</li>
                            <li>Fog excess </li>
                            <li><i>If your flight is cancelled because of weather conditions, the flight might be rescheduled on a period of one year or you might ask for the refund of the total paid.</i></li>
                          </ul>
                            <li>Change of flight date or cancellation:</li>
                          <ul>
                            <li>
                            If you can’t attend the appointment due to adverse circumstances, you must cancel and confirm the cancellation by phone call or message at least 36 hours in advance, so that you can reschedule your flight without charge. If the cancellation is made within 36 to 12 hours prior to the flight, it can be rescheduled with an additional charge to the total price of 35% for administration and operation expenses. If there is no cancellation or the passenger doesn’t arrive the flight date, he will lose the right to any refund.
                            </li>
                            <li>
                              If you need to postpone the flight, it is the passenger\'s responsibility to reschedule in a period not exceeding 12 months, otherwise the right to flight will be lost.
                            </li>
                            <li>
                            Remember to be on time at the appointment place so you don\'t miss your flight. Arriving late to the appointment schedule may cause an extra charge of 35% from the total.
                            </li>
                            <li>
                              The estimated flight time is up to one hour but if conditions do not allow it, the company leaves it to the pilot for consideration. There won’t be refund for flights lasting less than one hour.
                            </li>
                          </ul>
                        </ol>';
$cuerpo.=							'</td>';
$cuerpo.=						'</tr>';
$cuerpo.=						'<tr>';
  $cuerpo.=						'<td colspan="4">';
    $cuerpo.=           ' <a href="https://www.google.com/maps/place/VOLAR+EN+GLOBO/@19.6956647,-98.8269878,17z/data=!3m1!4b1!4m5!3m4!1s0x85d1f5725d683f25:0xff4f4587c24e2324!8m2!3d19.6956597!4d-98.8247938">
                          <button type="button" class="btn btn-info btn-lg" id="direccionvga" style="background:#aa66cc; width:100%; height:35px; color:white;">Address</button>
                        </a>
                        <hr>';
  $cuerpo.='</td>';
$cuerpo.='</tr>';
$cuerpo.=					'</tbody>';
$cuerpo.=				'</table>';
$cuerpo.=			'</div>';
$cuerpo.=			'<p style="font-size:14px">If you need any more information, please call your seller.</p>';
$cuerpo.=			'<b>'.$getVendedorInfo[0]->nombre.'</b><br>';
$cuerpo.=			'<i>'.$vendedor[1].'<br>'.$vendedor[2].'</i>';
$cuerpo.=		'</body>';
$cuerpo.=	'</html>';
//echo $cuerpo;
$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
require_once  $ruta;

?>
