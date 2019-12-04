<?php
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';

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
	              font-size: 12px;
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
	if(isset($_POST['piloto'])){
		//Cuando es por piloto
		/*Información de Piloto */
		$campos = "CONCAT (IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as piloto,id_usu as id, correo_usu";
		$tabla = "volar_usuarios";
		$filtro = "id_usu = ".$_POST['piloto'];
		$infoPiloto  = $con->consulta($campos,$tabla,$filtro);
		$correousu = $infoPiloto[0]->correo_usu;
		$nombreusu = $infoPiloto[0]->piloto;
		$arreglo[0] =$correousu;
		$arreglo[1] = $nombreusu;
		$correos =  array($arreglo );
		/*Termina información de Piloto */

		/*Información de reserva*/
		$campos = "nombre_globo as globo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as pasajero	,";
		$campos.= " id_temp as reserva, fechavuelo_temp as fechavuelo, hora_temp as hora, pax_ga as pax,version_ga as version";
		$tabla = "temp_volar tv INNER JOIN globosasignados_volar ga ON id_temp = reserva_ga INNER JOIN globos_volar gv ON globo_ga = id_globo ";
		$filtro = "ga.status <> 0 AND piloto_ga = ".$_POST['piloto']." AND reserva_ga=".$_POST['reserva']." AND version_ga=".$_POST['version'];
		$reservaInfo = $con->consulta($campos,$tabla,$filtro);

		/*Termina información de reserva*/
		$asunto = "Globo Asignado";


		$cuerpo .= "<b>".$infoPiloto[0]->piloto."</b>";
		$cuerpo .= "<hr>";
		$cuerpo .= "Se te ha asignado el siguiente vuelo:";
		$cuerpo .= "<table>";
		$cuerpo .= "<tr>";
		$cuerpo .=	"<th>Reserva</th><td>".$reservaInfo[0]->reserva."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Pasajero</th><td>".$reservaInfo[0]->pasajero."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Fecha de Vuelo</th><td>".$reservaInfo[0]->fechavuelo."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Hora</th><td>".$reservaInfo[0]->hora."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Pasajeros</th><td>".$reservaInfo[0]->pax."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "</table>";
/*
		$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
		require_once  $ruta;
*/
	}


	$cuerpo .= "</body>";
	echo $cuerpo;
?>
