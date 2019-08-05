<?php
@session_start();

	if(isset($_SESSION['usuario']) && isset($_SESSION['max-tiempo']) && isset($_SESSION['ULTIMA_ACTIVIDAD']) && (time() - $_SESSION[ 'ULTIMA_ACTIVIDAD' ] < $_SESSION['max-tiempo'])){
		$_SESSION[ 'ULTIMA_ACTIVIDAD' ] = time();
	}else{

?>
	<script type="text/javascript">
		location.replace("/admin/?s");

	</script>
<?php
	exit();
	}
?>