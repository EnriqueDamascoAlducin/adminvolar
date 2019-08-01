<?php 
	
	$pagoData = $con->consulta("referencia_bp as referencia, cantidad_bp as cantidad,IFNULL((SELECT nombre_extra from extras_volar WHERE id_extra=metodo_bp),'') as metodo,IFNULL((SELECT nombre_extra from extras_volar WHERE id_extra=banco_bp),'') as banco,fecha_bp as fecha, idres_bp as reserva","bitpagos_volar","id_bp=".$pago);
	$contadores = $con->consulta("correo_usu as correo , CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as nombre ","volar_usuarios","status<>0 and puesto_usu=3");
	$correos=[];
	foreach ($contadores as $contador) {
		$correos[]=array($contador->correo,$contador->nombre);
	}


	print_r($correos);
	$getVendedorInfo = $con->consulta("correo_usu as correo , CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as nombre, telefono_usu as telefono"," volar_usuarios vu INNER JOIN temp_volar tv ON tv.idusu_temp=vu.id_usu ","id_temp=".$pagoData[0]->reserva);
	$vendedor =[$getVendedorInfo[0]->nombre,$getVendedorInfo[0]->correo, $getVendedorInfo[0]->telefono];
	$asunto = "Solicitud de Cotización de la Reserva ". $pagoData[0]->reserva;
	$cuerpo='<!DOCTYPE html>
				<html>
					<head>

						<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
						<style type="text/css">
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
						</style>
						<script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
					</head>';
	$cuerpo.=		'<body>';
	

	$cuerpo.=			'<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">';
	$cuerpo.=				'<table border="1">';
	$cuerpo.=					'<thead>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<th class="tdtitulo" colspan="2">';
	$cuerpo.=								'Solicitud de Conciliación de Reserva:'. $pagoData[0]->reserva;
	$cuerpo.=							'</th>';
	$cuerpo.=						'</tr>';
	$cuerpo.=					'</thead>';
	$cuerpo.=					'<tbody>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Metodo</td>';
	$cuerpo.=							'<td >'. $pagoData[0]->metodo.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Banco</td>';
	$cuerpo.=							'<td >'. $pagoData[0]->banco.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Cantidad</td>';
	$cuerpo.=							'<td >'. $pagoData[0]->cantidad.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Referencia</td>';
	$cuerpo.=							'<td >'. $pagoData[0]->referencia.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<td class="tdtitulo">Fecha de pago</td>';
	$cuerpo.=							'<td >'. $pagoData[0]->fecha.'</td>';
	$cuerpo.=						'</tr>';
	$cuerpo.=						'<tr>';
	$cuerpo.=							'<a href="https://www.siswebs.com.mx/admin/"><td class="tdtitulo" colspan="2x">Da click Aqui para conciliar</td></a>';
	$cuerpo.=						'</tr>';
	$cuerpo.=					'</tbody>';
	$cuerpo.=				'</table>';
	$cuerpo.=			'</div>';
	$cuerpo.=		'</body>';
	$cuerpo.=	'</html>';
		//echo $cuerpo;
	$ruta=$_SERVER['DOCUMENT_ROOT'].'/admin/sources/PHPMailer/mail.php';
	require_once  $ruta;
?>
