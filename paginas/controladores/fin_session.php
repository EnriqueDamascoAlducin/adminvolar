<?php
@session_start();
if ( isset( $_SESSION[ 'ULTIMA_ACTIVIDAD' ] ) && 
( time() - $_SESSION[ 'ULTIMA_ACTIVIDAD' ] > $_SESSION['max-tiempo'] ) || !isset($_SESSION['usuario'])) {

// Si ha pasado el tiempo sobre el limite destruye la session
?>
	<script type="text/javascript">
		
		abrir_gritter("Error","Se ha terminado tu Sesión","danger");
		setTimeout(function(){
			window.location.replace("../");
		},3000);
		
	</script>
<?php
}
$_SESSION[ 'ULTIMA_ACTIVIDAD' ] = time();

?>