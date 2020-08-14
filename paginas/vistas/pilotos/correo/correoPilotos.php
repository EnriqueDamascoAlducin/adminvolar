<?php
	$reserva = $_POST['reserva'];
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	function getHTMLHead(){
		$head='<!DOCTYPE html>
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
		            #tablaAsignado td,th{
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
							<script src=https://code.jquery.com/jquery-3.4.1.min.js"  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="  crossorigin="anonymous"></script>
		          <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
		        </head>
					<body>';
					return $head;
	}
	function enviarAlerta($body){
		global $con;
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$correoUsu=$usuario->getCorreoUsu();
		$nombreUsu=$usuario->getNombreUsu();
		$asignador = array($correoUsu , $nombreUsu);


		$asunto = "Globo Asignado";
		$cuerpo = getHTMLHead();
		$cuerpo .= $body;
		$cuerpo .="</body>";
		$correos =[$asignador];

		$respuesta=  array('body' => $cuerpo ,'correos' => $correos ,'asunto' => $asunto );
		return $respuesta;
	}

	function sendAllMail($mailsToSend){
		$mailsToSend = $mailsToSend;
		$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail2.php';
		require_once  $ruta;
	}
	function enviarCorreoPiloto	($datos,$piloto,$correoPiloto ){
		/*  ----- Información de Piloto -----  */
		global $con;
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$correoUsu=$usuario->getCorreoUsu();
		$nombreUsu=$usuario->getNombreUsu();
		//$vendedor = array($correoUsu , $nombreUsu); //Quien mando los vuelos

		$correousu = $correoPiloto;
		$nombreusu = $piloto;
		$arreglo[0] =$correousu;
		$arreglo[1] = $nombreusu;
		$correos =  array($arreglo );
		$reservas = $datos[0];
		$pasajero = $datos[1];
		$fechavuelo = $datos[2];
		$hora = $datos[3];
		$pax = $datos[4];
		$globo = $datos[5];
		$turno = $datos[6];
		$motivo = $datos[7];
		$comentario = $datos[8];
		$peso = $datos[9];
		///Formar cuerpo de html
		$asunto = "Globo Asignado";
		$cuerpo = getHTMLHead();
		$tabla 	="<h3>".$piloto."</h3>";
		$tabla .= "<p>Se te ha asignado una reserva con la siguiente informaci&oacute;n: </p>";
		$tabla .= "<table class='table' border ='1'>";
		$tabla .=	"<tr>";
		$tabla .=		"<th>Reserva</th>";
			for ($i=0; $i < sizeof($reservas) ; $i++) { 
				$tabla .="<td>".$reservas[$i]."</td>";
			}
		$tabla .=	"</tr>";


		$tabla .=	"<tr>";
		$tabla .=		"<th>Globo</th>";
			for ($i=0; $i < sizeof($globo) ; $i++) { 
				$tabla .="<td>".$globo[$i]."</td>";
			}
		$tabla .=	"</tr>";

		$tabla .=	"<tr>";
		$tabla .=		"<th>Pasajero</th>";
			for ($i=0; $i < sizeof($pasajero) ; $i++) { 
				$tabla .="<td>".$pasajero[$i]."</td>";
			}
		$tabla .=	"</tr>";


		$tabla .=	"<tr>";
		$tabla .=		"<th>Fecha de vuelo</th>";
			for ($i=0; $i < sizeof($fechavuelo) ; $i++) { 
				$tabla .="<td>".$fechavuelo[$i]."</td>";
			}
		$tabla .=	"</tr>";


		$tabla .=	"<tr>";
		$tabla .=		"<th>Turno</th>";
			for ($i=0; $i < sizeof($turno) ; $i++) { 
				$tabla .="<td>".$turno[$i]."</td>";
			}
		$tabla .=	"</tr>";

		$tabla .=	"<tr>";
		$tabla .=		"<th>Hora</th>";
			for ($i=0; $i < sizeof($hora) ; $i++) { 
				$tabla .="<td>".$hora[$i]."</td>";
			}
		$tabla .=	"</tr>";


		$tabla .=	"<tr>";
		$tabla .=		"<th>Pasajeros</th>";
			for ($i=0; $i < sizeof($pax) ; $i++) { 
				$tabla .="<td>".$pax[$i]."</td>";
			}
		$tabla .=	"</tr>";
		$tabla .=	"<tr>";
		$tabla .=		"<th>Peso</th>";
			for ($i=0; $i < sizeof($peso) ; $i++) { 
				$tabla .="<td>". $peso[$i]." Kg</td>";
			}
		$tabla .=	"</tr>";

		$tabla .=	"<tr>";
		$tabla .=		"<th>Motivo</th>";
			for ($i=0; $i < sizeof($motivo) ; $i++) { 
				$tabla .="<td>".$motivo[$i]."</td>";
			}
		$tabla .=	"</tr>";

		$tabla .=	"<tr>";
				$tabla .="<td >Comentario</td>";
			for ($i=0; $i < sizeof($comentario) ; $i++) { 
				$tabla .="<td >".$comentario[$i]."</td>";
			}
		$tabla .=	"</tr>";
		$tabla .= "</table>";
		$cuerpo .= $tabla;
		$cuerpo .= "</body>";
		$cuerpo .= "</html>";


		$respuesta = [];
		// $ruta=$_SERVER['DOCUMENT_ROOT'].'/adminTest/sources/PHPMailer/mail.php';
		// require_once  $ruta;
		$respuesta=  array('admin' => $tabla , 'body' => $cuerpo ,'correos' => $correos ,'asunto' => $asunto );
		return $respuesta;
	}
	function enviarCorreo($piloto,$reserva,$version){
		/*  ----- Información de Piloto -----  */
		global $con;
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
		$correoUsu=$usuario->getCorreoUsu();
		$nombreUsu=$usuario->getNombreUsu();
		$vendedor = array($nombreUsu , $correoUsu);
		$campos = "CONCAT (IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as piloto,id_usu as id, correo_usu";
		$tabla = "volar_usuarios";
		$filtro = "id_usu = ".$piloto;
		$infoPiloto  = $con->consulta($campos,$tabla,$filtro);
		$correousu = $infoPiloto[0]->correo_usu;
		$nombreusu = $infoPiloto[0]->piloto;
		$arreglo[0] =$correousu;
		$arreglo[1] = $nombreusu;
		$correos =  array($arreglo,$vendedor );
		/*Termina información de Piloto */

		/*Información de reserva*/
		$campos = "nombre_globo as globo, CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as pasajero	,";
		$campos.= " id_temp as reserva, fechavuelo_temp as fechavuelo, hora_temp as hora, pax_ga as pax,version_ga as version, turno_temp as turno";
		$tabla = "temp_volar tv INNER JOIN globosasignados_volar ga ON id_temp = reserva_ga INNER JOIN globos_volar gv ON globo_ga = id_globo ";
		$filtro = "ga.status <> 0 AND piloto_ga = ".$piloto." AND reserva_ga=".$reserva." AND version_ga=".$version;
		$reservaInfo = $con->consulta($campos,$tabla,$filtro);

		/*Termina información de reserva*/
		$asunto = "Globo Asignado";

		$cuerpo = getHTMLHead();
		$cuerpo .= "<h5>".$infoPiloto[0]->piloto."</h5>";
		$cuerpo .= "<hr>";
		$cuerpo .= "Se te ha asignado el siguiente vuelo:";
		$cuerpo .= "<table class='table' border='2' id='tablaAsignado'>";
		$cuerpo .= "<tr>";
		$cuerpo .=	"<th>Reserva</th><td>".$reservaInfo[0]->reserva."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
		$cuerpo .=	"<th>Globo</th><td>".$reservaInfo[0]->globo."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Pasajero</th><td>".$reservaInfo[0]->pasajero."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Fecha de Vuelo</th><td>".$reservaInfo[0]->fechavuelo."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Turno</th><td>".$reservaInfo[0]->turno."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Hora</th><td>".$reservaInfo[0]->hora."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "<tr>";
			$cuerpo .=	"<th>Pasajeros</th><td>".$reservaInfo[0]->pax."</td>";
		$cuerpo .= "</tr>";
		$cuerpo .= "</table>";
		$cuerpo .= "</body>";

		$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
		require_once  $ruta;

	}
	if(isset($_POST['piloto']) && isset($_POST['version'])){
		//Cuando es por piloto
		enviarCorreo($_POST['piloto'],$_POST['reserva'],$_POST['version']);
	}else{
		$campos= "DISTINCT(id_usu) as id, CONCAT (IFNULL(nombre_usu,''),' ', IFNULL(apellidop_usu,''),' ', IFNULL(apellidom_usu,'')) as piloto, correo_usu as correo";
		$tabla = " volar_usuarios ";
		$filtro = " status <> 0 and puesto_usu = 4 and id_usu in( ";
		$filtro .= " Select piloto_ga FROM  globosasignados_volar ga INNER JOIN temp_volar tv ON id_temp = reserva_ga ";
		$filtro .= " WHERE tv.status = 8 and ga.status<>0 ";
		/*---------Filtros--------------*/
		if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
			$filtro.= " and fechavuelo_temp >='".$_POST['fechaI']."'";
		}
		//////
		if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
			$filtro.= " and fechavuelo_temp <='".$_POST['fechaF']."'";
		}
		//////////
		if(isset($_POST['piloto']) && $_POST['piloto']!='0' ){
			$filtro.= " and piloto_ga = ".$_POST['piloto'];
		}
		/////////
		if(isset($_POST['reserva']) && $_POST['reserva']!='' ){
			$filtro.= " and id_temp = ".$_POST['reserva'];
		}

		if($_POST['fechaI']=='' &&  $_POST['fechaF']=='' && $_POST['reserva']=='' ){
			$filtro .= " and fechavuelo_temp >= CURRENT_TIMESTAMP ";
		}
		/*--------------Termina Filtros -----------*/
			$filtro .= ') ';
		$filtro .= " ORDER BY nombre_usu ASC, apellidop_usu asc";
	// echo "SELECT $campos FROM $tabla WHERE $filtro";
	// die();
		$tablaBody ="";
		$mailsToSend = [];
		$cont = 0;
		$pilotos=$con->consulta($campos,$tabla,$filtro);
		foreach ($pilotos as $piloto) {
			$campos = " CONCAT(IFNULL(nombre_temp,''),' ', IFNULL(apellidos_temp,'')) as pasajero	,";
			$campos .= " id_temp as reserva, fechavuelo_temp as fechavuelo, hora_temp as hora, pax_ga as pax,version_ga as version, nombre_globo as globo,turno_temp as turno, IFNULL((select nombre_extra From extras_volar where id_extra = motivo_temp ),'NA') as motivo,comentario_ga,peso_ga  ";
			$tabla = "temp_volar tv INNER JOIN globosasignados_volar ga ON id_temp = reserva_ga INNER JOIN globos_volar ON id_globo = globo_ga  ";
			$filtro = "  tv.status= 8 AND ga.status<>0 ";
				if(isset($_POST['fechaI']) && $_POST['fechaI']!='' ){
					$filtro.= " and fechavuelo_temp >='".$_POST['fechaI']."'";
				}
				if(isset($_POST['fechaF']) && $_POST['fechaF']!='' ){
					$filtro.= " and fechavuelo_temp <='".$_POST['fechaF']."'";
				}
				if(isset($_POST['empleado']) && $_POST['empleado']!='0' ){
					$filtro.= " and piloto_ga = ".$_POST['empleado'];
				}
				if(isset($_POST['reserva']) && $_POST['reserva']!='' ){
					$filtro.= " and id_temp = ".$_POST['reserva'];
				}
				if($_POST['fechaI']=='' &&  $_POST['fechaF']=='' && $_POST['reserva']=='' ){
					$filtro .= " and fechavuelo_temp >= CURRENT_TIMESTAMP ";
				}
			$filtro .=" AND piloto_ga= ".$piloto->id;
			// echo "SELECT $campos FROM $tabla WHERE $filtro";
			// die();
			$infoAsignados = $con->consulta($campos,$tabla,$filtro);
			$reservas 	= [];
			$pasajero 	= [];
			$fechavuelo = [];
			$hora 		= [];
			$pax   		= [];
			$globo   	= [];
			$turno   	= [];
			$motivo   	= [];
			$comentario	= [];
			$peso	= [];
			foreach ($infoAsignados as $globoAsignado) {
				$reservas[]=	($globoAsignado->reserva)."."; 
				$pasajero[]=	($globoAsignado->pasajero)."."; 
				$fechavuelo[]=	($globoAsignado->fechavuelo)."."; 
				$hora[]=	($globoAsignado->hora)."."; 
				$pax[]=	($globoAsignado->pax)."."; 
				$globo[]=	($globoAsignado->globo)."."; 
				$turno[]=	($globoAsignado->turno)."."; 
				$motivo[]=	($globoAsignado->motivo)."."; 
				$comentario[]=	($globoAsignado->comentario_ga)."."; 
				$peso[]=	($globoAsignado->peso_ga); 
			}
			$datos = [$reservas,$pasajero,$fechavuelo,$hora,$pax,$globo,$turno,$motivo,$comentario,$peso];
			$mailsToSend[]= enviarCorreoPiloto($datos,$piloto->piloto,$piloto->correo);
			$tablaBody.= $mailsToSend[$cont]['admin'];
			$cont++;
		}

		$mailsToSend[] =enviarAlerta($tablaBody);
		sendAllMail($mailsToSend);		//print_r($mailsToSend);
	}

?>
