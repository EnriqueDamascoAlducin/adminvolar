<?php
@session_start();
if ( (isset( $_SESSION[ 'ULTIMA_ACTIVIDAD' ] ) || !isset( $_SESSION['max-tiempo'] ) || !isset($_SESSION['usuario'])) &&
( time() - $_SESSION[ 'ULTIMA_ACTIVIDAD' ] > $_SESSION['max-tiempo'] )  ) {

// Si ha pasado el tiempo sobre el limite destruye la session
header("Location: /admin/?s");
?>
	
<?php 
}
$_SESSION[ 'ULTIMA_ACTIVIDAD' ] = time();
?>