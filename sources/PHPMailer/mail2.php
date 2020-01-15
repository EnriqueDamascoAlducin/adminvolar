<?php 

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'PHPMailer/Exception.php';
require 'PHPMailer/PHPMailer.php';
require 'PHPMailer/SMTP.php';
////////////////////////Datos Confirguracion del Correo/////////////////
$mail = new PHPMailer(true);
try {
    $mail = new PHPMailer();  // create a new object
    /*
    $mail->Host = 'a2plcpnl0253.prod.iad2.secureserver.net';
    $mail->Port = 465; 
    $mail->Username = 'enriquealducin@siswebs.com.mx';  
    $mail->Password = 'Portero1';
    */
    
    $mail->Host = 'mail.volarenglobo.com.mx';
    $mail->Port = 465; 
    $mail->Username = 'enriquealducin@volarenglobo.com.mx';  
    $mail->Password = 'VolarenGlobo1.';
    //Recipients
    if(isset($_SESSION['usuario'])){
        $usuario= unserialize((base64_decode($_SESSION['usuario'])));
        $correoActual = $usuario->getCorreoUsu();
        $usuarioActual = $usuario->getNombreUsu(). " " .$usuario->getApellidopUsu(). " ". $usuario->getApellidomUsu();
    }else{
        $correoActual = 'enriquealducin@volarenglobo.com.mx';  
        $usuarioActual = 'Volar en Globo';  
    }
    $mail->setFrom(trim($correoActual), $usuarioActual);    
    $mail->isHTML(true);   


    foreach ($mailsToSend as $mailToSend) {
        $usr = "";
        $correos = $mailToSend['correos'];
        $cuerpo = $mailToSend['body'];
        $asunto = $mailToSend['asunto'];
        foreach ($correos as $correo) {
            $mail->addAddress(trim($correo[0]), $correo[1]);
            $usr.= $correo[1];
        }
        $mail->Subject = $asunto;
        $mail->Body    = $cuerpo;
        $mail->CharSet = 'UTF-8';
        if(!$mail->send()) {
            echo $error = 'Mail error: '.$mail->ErrorInfo; 
            echo $cuerpo;
        } else {
            echo "Correo Enviado a $usr <br>";
        } 
        $mail->clearAddresses();
        $mail->clearAttachments();
    }
    
    
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
////////////////////////Datos Confirguracion del Correo/////////////////

?>