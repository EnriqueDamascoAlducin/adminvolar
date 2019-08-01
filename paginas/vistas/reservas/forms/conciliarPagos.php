<?php 
	/*	Requeridos	*/
	require  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin/paginas/controladores/fin_session.php';
	/*	Requeridos	*/
	$reserva=$_POST['reserva'];
	$pagos = $con->consulta("CONCAT(nombre_usu,' ',apellidop_usu) as usuario, referencia_bp as referencia, cantidad_bp as cantidad,fecha_bp as fecha, bp.status as stat,id_bp as id","bitpagos_volar bp INNER JOIN volar_usuarios vu  ON bp.idreg_bp=vu.id_usu","bp.status<>0 and idres_bp=".$reserva);
?>
<?php if(sizeof($pagos)>0){ ?>
	<table class="table dataTable" style="width: 100%;">
		<thead>
			<th>Usuario</th>
			<th>Referencia</th>
			<th>Cantidad</th>
			<th>Fecha</th>
			<th>Acciones</th>
		</thead>
		<tbody>
			<?php
				foreach ($pagos as $pago) {
			?>
				<tr>
					<td>
						<?php echo $pago->usuario; ?>
					</td>
					<td>
						<?php echo $pago->referencia; ?>
					</td>
					<td>
						<?php echo $pago->cantidad; ?>
					</td>
					<td>
						<?php echo $pago->fecha; ?>
					</td>
					<td>
						<!-- 4 es cuando solo se ha agregado el pago y no ha sido conciliado -->
						<!-- 3 ya ha sido conciliado -->
						<!-- 2 enviado al cliente sin cupon -->
						<!-- 1 enviado al cliente con cupon -->

						<?php if($pago->stat == 4){ ?>
							<i class="fa fa-check-circle-o fa-lg" data-toggle="modal" style="color:#00C851" onclick="accionesPagos(<?php echo $pago->id ?>,'conciliar',<?php echo $reserva; ?>);" >
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
		tables();

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