<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';
	if(isset($_POST['serviciosId'])){	
		$serviciosId =($_POST['serviciosId']);
		$serviciosValor =($_POST['serviciosValor']);
		$serviciosInfo = [];
		for ($i=0; $i < sizeof($serviciosId); $i++) { 
			$servicioInfo= $con->query("CALL getServicioInfo(".explode('_',$serviciosId[$i])[1].")")->fetchALL (PDO::FETCH_OBJ);
			array_push($serviciosInfo, $servicioInfo);
		}
	}
	$total=0.0;
	$totalServicios=0;
?>
	<?php
	if(isset($_POST['serviciosId'])){
		for ($i=0; $i <sizeof($serviciosInfo) ; $i++) { 
		$servicio = $serviciosInfo[$i][0];
		$total+=($servicio->precio * $serviciosValor[$i]);
		$totalServicios+=$serviciosValor[$i];
	
		}
	}
	if(isset($_POST['otroscar1']) && $_POST['otroscar1']!='' && isset($_POST['precio1']) && $_POST['precio1']!='' && $_POST['precio1']!='0'){
		$total+=$_POST['precio1'];
	} 
	if(isset($_POST['otroscar2']) && $_POST['otroscar2']!='' && isset($_POST['precio2']) && $_POST['precio2']!='' && $_POST['precio2']!='0'){
		$total+=$_POST['precio2'];
	} 
	if(isset($_POST['tipodesc']) && $_POST['tipodesc']!='' && isset($_POST['cantdesc']) && $_POST['cantdesc']!='' && $_POST['cantdesc']!='0'){
		if($_POST['tipodesc']==1){
			$totalDesc = $_POST['cantdesc'];
		}else if ($_POST['tipodesc']==2) {
			$totalDesc = ($total * $_POST['cantdesc'])/100;
		}
		$total-=$totalDesc;
	} 
	echo "$ ".number_format($total, 2, '.', ','); ; ?>	