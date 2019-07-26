<?php
	session_start();
	if(isset($_SESSION['idUsu'])){
		print_r($_SESSION);	
	}else{
		header("Location: ../");
	}
?>