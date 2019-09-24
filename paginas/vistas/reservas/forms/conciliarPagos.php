<?php 
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
	$pagos = $con->consulta("CONCAT(nombre_usu,' ',apellidop_usu) as usuario, referencia_bp as referencia, cantidad_bp as cantidad,fecha_bp as fecha, bp.status as stat,id_bp as id","bitpagos_volar bp INNER JOIN volar_usuarios vu  ON bp.idreg_bp=vu.id_usu","bp.status<>0 and idres_bp=".$reserva);
?>
<style type="text/css">
	
	@media (max-width: 576px){
		.tableTh{
			font-size: 50%;
		}
		.tableTd{
			font-size: 60%;
		}
	}
</style>

<div class="col-6 col-md-12 col-sm-12 col-md-12 col-xl-12">
<?php if(sizeof($pagos)>0){ ?>
	<table class="table "  id="DataTable" style="max-width: 100%;width: 100%;" >
		<thead>
			<th class="tableTh">Referencia</th>
			<th class="tableTh">Cantidad</th>
			<th class="tableTh">Fecha</th>
			<th class="tableTh">Acciones</th>
		</thead>
		<tbody>
			<?php
				foreach ($pagos as $pago) {
			?>
				<tr>
					<td class="tableTd">
						<?php echo trim($pago->referencia); ?>
					</td>
					<td class="tableTd">
						<?php echo trim($pago->cantidad); ?>
					</td>
					<td class="tableTd">
						<?php echo trim($pago->fecha); ?>
					</td>
					<td class="tableTd">
						<!-- 4 es cuando solo se ha agregado el pago y no ha sido conciliado -->
						<!-- 3 ya ha sido conciliado -->
						<!-- 2 enviado al cliente sin cupon -->
						<!-- 1 enviado al cliente con cupon -->

						<?php if($pago->stat == 4){ ?>
							<i class="fa fa-check-circle-o fa-lg" data-toggle="modal" style="color:#00C851" onclick="accionesPagos(<?php echo $pago->id ?>,'conciliar',<?php echo $reserva; ?>);" ></i>
						<?php }else if($pago->stat == 3){  ?>
							<i class="fa fa-spinner" style="color: #33b5e5"></i>
						<?php }else if($pago->stat == 2){  ?>
							<i class="fa fa-envelope fa-lg"  ></i>
						<?php }else if($pago->stat == 1){  ?>
							<i class="fa fa-gift fa-lg" ></i>
						<?php } ?>
						
					</td>
				</tr>

			<?php		
				}
			?>
		</tbody>
	</table>
	<script type="text/javascript">
		$("#DataTable").DataTable({
			"columnDefs": [
			    { "width": "5%", "targets": 0 }
			],
			"paging": false
		});
		function accionesPagos(pago,accion,reserva){
			$.ajax({
			url:'controladores/pagosController.php',
			method: "POST",
	  		data: {
	  			reserva:reserva,
	  			pago:pago,
	  			accion:accion
	  		},
	  		success:function(response){
	  			if(response.includes("ERROR"))
	  				abrir_gritter(response, "No puedes agregar mas pagos" ,"info");
	  			else
	  				abrir_gritter("Correcto", response ,"info");

	  			conciliarPago(reserva,cliente);
					
	  		},
	  		error:function(){
	  		
	          abrir_gritter("Error","Error desconocido" ,"danger");
	  		},
	  		statusCode: {
			    404: function() {
			     
	          abrir_gritter("Error","URL NO encontrada" ,"danger");
			    }
			  }
		});
		}
	</script>
<?php } ?>
</div>