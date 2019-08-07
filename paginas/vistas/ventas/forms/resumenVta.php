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
<table class="table" border="2" style="max-width: 100%;">
	<thead>
		<tr>
			<th colspan="4" style="text-align: center;">
				<?php echo $_POST['comentario'] ?>
			</th>
		</tr>
		<tr>
			<th  style="font-size: 75%">
				Nombre
			</th>
			<th  style="font-size: 75%">
				Cantidad
			</th>
			<th  style="font-size: 75%">
				Precio Unitario
			</th>
			<th  style="font-size: 75%">
				Precio Total
			</th>
		</tr>
	</thead>
	<tbody>
	<?php
	if(isset($_POST['serviciosId'])){
		for ($i=0; $i <sizeof($serviciosInfo) ; $i++) { 
		$servicio = $serviciosInfo[$i][0];
		$total+=($servicio->precio * $serviciosValor[$i]);
		$totalServicios+=$serviciosValor[$i];
	?>
		<tr>
			<td style="font-size: 75%"><?php echo ($servicio->nombre); ?></td>
			<td style="font-size: 75%"><?php echo ($serviciosValor[$i]); ?></td>
			<td style="font-size: 75%"><?php echo "$".number_format($servicio->precio, 2, '.', ','); ?></td>
			<td style="font-size: 75%"><?php echo "$".number_format(($servicio->precio * $serviciosValor[$i]), 2, '.', ','); ?></td>
		</tr>
	<?php
		}
	}
	if(isset($_POST['otroscar1']) && $_POST['otroscar1']!='' && isset($_POST['precio1']) && $_POST['precio1']!='' && $_POST['precio1']!='0'){
		$total+=$_POST['precio1'];
	?>
		<tr>
			<td style="font-size: 75%">
				<?php echo $_POST['otroscar1']; ?>
			</td>
			<td colspan="2">			
			</td>
			<td style="font-size: 75%">
				<?php echo "$".number_format( $_POST['precio1'], 2, '.', ',') ; ?>
			</td>
		</tr>
	<?php } 
	if(isset($_POST['otroscar2']) && $_POST['otroscar2']!='' && isset($_POST['precio2']) && $_POST['precio2']!='' && $_POST['precio2']!='0'){
		$total+=$_POST['precio2'];
	?>
		<tr>
			<td style="font-size: 75%">
				<?php echo $_POST['otroscar2']; ?>
			</td>
			
			<td colspan="2">			
			</td>
			<td style="font-size: 75%">
				<?php echo "$".number_format( $_POST['precio2'], 2, '.', ',') ; ?>
			</td>
		</tr>
	<?php } 
	if(isset($_POST['tipodesc']) && $_POST['tipodesc']!='' && isset($_POST['cantdesc']) && $_POST['cantdesc']!='' && $_POST['cantdesc']!='0'){
		if($_POST['tipodesc']==1){
			$totalDesc = $_POST['cantdesc'];
		}else if ($_POST['tipodesc']==2) {
			$totalDesc = ($total * $_POST['cantdesc'])/100;
		}
		$total-=$totalDesc;
	?>
		<tr>
			<td style="font-size: 75%">
				Descuento
			</td>
			
			<td colspan="2">			
			</td>
			<td style="font-size: 75%">
				<?php echo "$".number_format( $totalDesc, 2, '.', ',') ; ?>
			</td>
		</tr>
	<?php } ?>
	</tbody>
	<tfoot>
		<tr>
			<th style="text-align: right;font-size: 75%">
				Total
			</th>
			<th style="text-align: right;font-size: 75%">
				<?php echo $totalServicios; ?>
			</th>
			<th>
				
			</th>
			<th style="text-align: right;font-size: 75%">
				<?php echo "$ ".number_format($total, 2, '.', ','); ; ?>				
			</th>
		</tr>
	</tfoot>
</table>