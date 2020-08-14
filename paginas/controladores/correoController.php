<?php
    if($tipoCorreo == 'Cargos'){
        $asunto = "Solicitud de Conciliación de Movimiento de la Reserva ". $reserva;
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
        $cuerpo.=								'Solicitud de Conciliación de Movimiento de Reserva:'. $reserva;
        $cuerpo.=							'</th>';
        $cuerpo.=						'</tr>';
        $cuerpo.=					'</thead>';
        $cuerpo.=					'<tbody>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo">Tipo</td>';
        $cuerpo.=							'<td >'. $tipo.'</td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo">Motivo</td>';
        $cuerpo.=							'<td >'. $motivo.'</td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo">Cantidad</td>';
        $cuerpo.=							'<td >'. $cantidad.'</td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo">Comentario</td>';
        $cuerpo.=							'<td >'. $comentario.'</td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo" colspan="2x"><a href="https://volarenglobo.com.mx/admin1/">Da click Aqui para conciliar</a></td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=					'</tbody>';
        $cuerpo.=				'</table>';
        $cuerpo.=			'</div>';
        $cuerpo.=		'</body>';
        $cuerpo.=	'</html>';
        $puesto = 3; //Para mandar a los contadores
        include_once 'correoXpuesto.php';
    }elseif($tipoCorreo == 'CargoConciliado'){
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
        $cuerpo.=								$encabezado;
        $cuerpo.=							'</th>';
        $cuerpo.=						'</tr>';
        $cuerpo.=					'</thead>';
        $cuerpo.=					'<tbody>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo" colspan="2">'.$texto.'</td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=						'<tr>';
        $cuerpo.=							'<td class="tdtitulo" colspan="2x"><a href="https://volarenglobo.com.mx/admin1/">'.$texto_a.'</a></td>';
        $cuerpo.=						'</tr>';
        $cuerpo.=					'</tbody>';
        $cuerpo.=				'</table>';
        $cuerpo.=			'</div>';
        $cuerpo.=		'</body>';
        $cuerpo.=	'</html>';
        $ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
        require_once  $ruta;
    }
?>