<?php

  require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
  require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
  require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
  /*	Requeridos	*/
  $reserva=$_POST['reserva'];
  $pagos = $con->consulta("CONCAT(nombre_usu,' ',apellidop_usu) as usuario, IFNULL((Select CONCAT(nombre_usu,' ',apellidop_usu) from volar_usuarios where id_usu=bp.idconc_bp ),'') as concilia ,referencia_bp as referencia, cantidad_bp as cantidad,fecha_bp as fecha, bp.status as stat,id_bp as id","bitpagos_volar bp INNER JOIN volar_usuarios vu  ON bp.idreg_bp=vu.id_usu","bp.status<>0 and idres_bp=".$reserva);
	$total = $con->consulta(" SUM(cantidad_bp) as pagado, total_temp as cotizado","bitpagos_volar bitp INNER JOIN temp_volar t on idres_bp = id_temp"," bitp.status in (1,2) and idres_bp=".$reserva);
?>

<style type="text/css">

	@media (max-width: 576px){
		.tableTh{
			font-size: 60%;
		}
		.tableTd{
			font-size: 55%;
		}
    .tdHidden{
      display: none;
    }
	}
</style>

<div class="row">
  <div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
		<div class="form-group">
			<label for="referencia">Total Pagado: <?php echo '$ '.number_format($total[0]->pagado, 2, '.', ','); ?></label>
		</div>
	</div>
  <div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
		<div class="form-group">
			<label for="referencia">Cotizado: <?php echo '$ '.number_format($total[0]->cotizado, 2, '.', ','); ?></label>
		</div>
	</div>
		<div class="col-sm-4 col-lg-4 col-md-4 col-4 col-xl-4 ">
			<div class="form-group">
				<label for="referencia">Por Pagar: <?php echo '$ '.number_format( $total[0]->cotizado -$total[0]->pagado, 2, '.', ',');  ?></label>
			</div>
		</div>
</div>
<div class="col-12 col-md-12 col-sm-12 col-md-12 col-xl-12">
<?php if(sizeof($pagos)>0){ ?>
	<table class="table "  id="DataTable" style="max-width: 100%;width: 100%;" >
		<thead>
			<th class="tdHidden">Usuario</th>
  		<th class="tdHidden">Conciliado por</th>
			<th  class="tableTh">Referencia</th>
			<th class="tableTh">Cantidad</th>
			<th class="tableTh">Fecha</th>
			<th class="tableTh">Acciones</th>
		</thead>
		<tbody>
			<?php
				foreach ($pagos as $pago) {
			?>
				<tr>
					<td class="tdHidden">
						<?php echo $pago->usuario; ?>
					</td>
  					<td class="tdHidden">
  						<?php echo $pago->concilia; ?>
  					</td>
					<td  class="tableTd">
						<?php echo $pago->referencia; ?>
					</td>
					<td  class="tableTd">
						<?php echo $pago->cantidad; ?>
					</td>
					<td  class="tableTd">
						<?php echo $pago->fecha; ?>
					</td>
					<td  class="tableTd">
						<!-- 4 es cuando solo se ha agregado el pago y no ha sido conciliado -->
						<!-- 3 ya ha sido conciliado -->
						<!-- 2 enviado al cliente sin cupon -->
						<!-- 1 enviado al cliente con cupon -->

						<?php if($pago->stat == 4){ ?>
							<i class="fa fa-trash fa-lg"  style="color:red"  title="No ha sido Conciliado"  ></i>
						<?php }else if($pago->stat == 3){  ?>
							<i class="fa fa-envelope-o fa-lg" title="Por enviar Confirmación" ></i>

						<?php }else if($pago->stat == 2){  ?>
								<?php if($pago->referencia=='Pago en Sitio'){ ?>
									<i class="fa fa-home fa-lg" title="Pagado en Sitio" ></i>
								<?php }else{ ?>
                  <i class="fa fa-gift fa-lg" title="Se envio Confirmación"  style="color:#33b5e5"  ></i>
								<?php } ?>
						<?php }else if($pago->stat == 1){  ?>
							<i class="fa fa-gift fa-lg" title="Se envio Cupón" ></i>
						<?php } ?>

					</td>
				</tr>

			<?php
				}
			?>
		</tbody>
	</table>

	</script>
<?php } ?>
</div>
