<?php 
    if($puesto == 3){ //Finanzas -> Contador
        $contadores = $con->consulta("correo_usu as correo , CONCAT(IFNULL(nombre_usu,''),' ',IFNULL(apellidop_usu,''),' ',IFNULL(apellidom_usu,'')) as nombre ","volar_usuarios","status<>0 and puesto_usu=3");
        $correos=[];
        foreach ($contadores as $contador) {
            $correos[]=array($contador->correo,$contador->nombre);
        }    
        $ruta=$_SERVER['DOCUMENT_ROOT'].'/admin1/sources/PHPMailer/mail.php';
        require_once  $ruta;

    
    }

?>