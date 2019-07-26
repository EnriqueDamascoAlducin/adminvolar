<?php
	date_default_timezone_set("America/Mexico_City");
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	session_start();
	if(isset($_SESSION['usuario'])){
		$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	}else{
		header("Location: ../");
	}
	$date = date('d/m/Y ', time());
?>
<!DOCTYPE html>
<html>
<head>
	<title>Volar en GLobo</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!--===============================================================================================-->  
	<link rel="icon" type="image/png" href="../sources/images/icons/logo.png"/>
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/vendor/bootstrap/css/bootstrap.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/fonts/iconic/css/material-design-iconic-font.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/vendor/animate/animate.css">
	<!--===============================================================================================-->  
	<link rel="stylesheet" type="text/css" href="../sources/vendor/css-hamburgers/hamburgers.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/vendor/animsition/css/animsition.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/vendor/select2/select2.min.css">
	<!--===============================================================================================-->  
	<link rel="stylesheet" type="text/css" href="../sources/vendor/daterangepicker/daterangepicker.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/css/util.css">
	<link rel="stylesheet" type="text/css" href="../sources/css/main.css">
	<link rel="stylesheet" type="text/css" href="../sources/css/index.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="../sources/gritter/css/jquery.gritter.css">
	<link rel="stylesheet" type="text/css" href="../sources/gritter/css/clase.css">
	<!--===============================================================================================-->



</head>
<body>
<div id="divContenedor">
	<table id="tabHeader">
		<tr>
			<td class="tdPrimero"><?php echo $usuario->getNombreUsu(). " <span class='text-center'> " .$usuario->getApellidopUsu(). " " .$usuario->getApellidomUsu() ."</span>"; ?></td>
			<td class="tdcentral " style="background-color: #FFFF00;" ><?PHP echo $date ?> </td>
			<td class="tdcentral " style="background-color: #FF6633;" ></td>
			<td class="tdcentral " style="background-color: #FF0000;" ></td>
			<td class="tdcentral " style="background-color: #660000;" ></td>
			<td class="tdPrimero" style="text-align: center;"><i class="fa fa-sign-out fa-lg" aria-hidden="true"></i>Salir</td>
		</tr>
	</table>
	<div id="menuIzq">
		

	</div>







	<table id="tabFooter">
		<tr>
			<td class="tdPrimero"></td>
			<td class="tdcentral " style="background-color: #FFFF00;" > </td>
			<td class="tdcentral " style="background-color: #FF6633;" ></td>
			<td class="tdcentral " style="background-color: #FF0000;" ></td>
			<td class="tdcentral " style="background-color: #660000;" ></td>
			<td class="tdPrimero" style="text-align: center;"><i class="fa fa-sign-out fa-lg" aria-hidden="true"></i>Salir</td>
		</tr>
	</table>

</div>

<!-- ================= Scripts=================   -->
	<!--===============================================================================================-->
	  <script src="sources/vendor/jquery/jquery-3.2.1.min.js"></script>
	<!--===============================================================================================-->
	  <script src="sources/vendor/animsition/js/animsition.min.js"></script>
	<!--===============================================================================================-->
	  <script src="sources/vendor/bootstrap/js/popper.js"></script>
	  <script src="sources/vendor/bootstrap/js/bootstrap.min.js"></script>
	<!--===============================================================================================-->
	  <script src="sources/vendor/select2/select2.min.js"></script>
	<!--===============================================================================================-->
	  <script src="sources/vendor/daterangepicker/moment.min.js"></script>
	  <script src="sources/vendor/daterangepicker/daterangepicker.js"></script>
	<!--===============================================================================================-->
	  <script src="sources/vendor/countdowntime/countdowntime.js"></script>
	<!--===============================================================================================-->
	  <script src="sources/js/main.js"></script>

	<!--===============================================================================================-->
	  <script src="sources/gritter/js/jquery.gritter.js"></script>

	  <script type="text/javascript" src="sources/js/index.js"></script>
</body>
</html>

