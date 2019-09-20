<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	$usuario= unserialize((base64_decode($_SESSION['usuario'])));
	$idAct = $usuario->getIdUsu();
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
	//echo "$ ".number_format($total, 2, '.', ',');
	if($_POST['pagotarjeta']==''){
		$pagotarjeta=0;
	}else{
		$pagotarjeta=$_POST['pagotarjeta'];
	}
	if($_POST['pagoefectivo']==''){
		$pagoefectivo=0;
	}else{
		$pagoefectivo=$_POST['pagoefectivo'];
	}
	$totalPagado = $pagotarjeta+$pagoefectivo;
	if($totalPagado>$total){
		echo 'No puedes agregar un pago mayor';
	}else if($totalPagado<$total){
		echo "Falta por pagar";
	}else if($totalPagado==$total){
		$comentario = "'".$_POST['comentario']."'";
		$otroscar1 = $_POST['otroscar1'];
		$precio1 = $_POST['precio1'];
		$otroscar2 = $_POST['otroscar2'];
		$precio2 = $_POST['precio2'];
		$tipodesc = $_POST['tipodesc'];
		$cantdesc = $_POST['cantdesc'];
		$pagoefectivo = $_POST['pagoefectivo'];
		$pagotarjeta = $_POST['pagotarjeta'];
		if($otroscar1==''){
			$otroscar1="null";
		}else{
			$otroscar1="'".$otroscar1."'";
		}
		if($otroscar2==''){
			$otroscar2="null";
		}else{
			$otroscar2="'".$otroscar2."'";
		}
		if($precio1==''){
			$precio1="null";
		}
		if($precio2==''){
			$precio2="null";
		}
		if($tipodesc==''){
			$tipodesc="null";
		}
		if($cantdesc=='' || $cantdesc==0){
			$cantdesc="null";
		}
		if($pagoefectivo=='' || $pagoefectivo==0){
			$pagoefectivo="null";
		}
		if($pagotarjeta=='' || $pagotarjeta==0){
			$pagotarjeta="null";
		}
		$valores = $idAct.','.$comentario.','.$otroscar1.','.$precio1.','.$otroscar2.','.$precio2.','.$tipodesc.','.$cantdesc.','.$pagoefectivo.','.$pagotarjeta.','.$total;
		$registroPago = $con->query("CALL registroVenta(".$valores.",@LID)");
		$respuesta = $con->query("SELECT @LID as lid")->fetchALL (PDO::FETCH_OBJ);
		$venta = $respuesta[0]->lid;

		if(isset($_POST['serviciosId'])){
			$serviciosId =($_POST['serviciosId']);
			$serviciosValor =($_POST['serviciosValor']);
			$serviciosInfo = [];
			for ($i=0; $i < sizeof($serviciosId); $i++) {
				$valores = explode("_",$serviciosId[$i])[1].','.$venta.','.$serviciosValor[$i].',@respuesta';
				$servicioInfo= $con->query("CALL registrarServicioVta(".$valores.")");
				$respuesta= $con->query("SELECT @respuesta as respuesta")->fetchALL (PDO::FETCH_OBJ);

			}
				echo $respuesta[0]->respuesta;
		}
	}
	?>
