<?php
	require  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/modelos/login.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/conexion.php';
	require_once  $_SERVER['DOCUMENT_ROOT'].'/admin1/paginas/controladores/fin_session.php';
  $accion = $_POST['acciones'];
  $reserva = $_POST['reserva'];

  $cargos = $con->consulta("motivo_ce,cantidad_ce,comentario_ce,status,id_ce as id","cargosextras_volar","status<>0 and reserva_ce=".$reserva." and tipo_ce=1");
  $descuentos = $con->consulta("motivo_ce,cantidad_ce,comentario_ce,status,id_ce as id","cargosextras_volar","status<>0 and reserva_ce=".$reserva." and tipo_ce=2");
  $permisos = $_SESSION['permisos'];
?>
<input type="hidden" id="reservaCar" name="reserva" value="<?php echo $_POST['reserva']; ?>">
<input type="hidden" id="nombre" name="nombre" value="<?php echo $_POST['nombre']; ?>">
<input type="hidden" id="acciones" name="acciones" value="<?php echo $_POST['acciones']; ?>">
 <ul class="nav nav-tabs" role="tablist">
   <?php if($accion==1 || $accion == 3) { ?>
     <li class="nav-item" >
       <a class="nav-link diseno active" data-toggle="tab" href="#registro">Registrar Cargo</a>
     </li>
   <?php } ?>
   <?php if($accion==1 || $accion == 2) { ?>
     <li class="nav-item" >
       <a class="nav-link diseno <?php if($accion!=1){ echo 'active'; } ?>" data-toggle="tab" href="#descuento">Realizar Descuento</a>
     </li>
   <?php } ?>
 </ul>


 <div class="tab-content">

   <?php if($accion==1 || $accion == 3) { ?>
     <div id="registro" class="container tab-pane active">
       <div class="row">
         <div class="col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
           <div class="form-group">
             <label for="motivoCar">Motivo</label>
             <input class="form-control" type="text" name="motivoCar" id="motivoCar" value="" placeholder="Motivo">
           </div>
         </div>
         <div class="col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
           <div class="form-group">
             <label for="cantidadCar">Cantidad</label>
             <input class="form-control" type="number" onkeypress="return isNumber(event)" name="cantidadCar" id="cantidadCar" value="0" placeholder="Cantidad ($)">
           </div>
         </div>

   			<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
   				<div class="form-group">
   					<label for="comentarioCar">Comentario</label>
   					<textarea name="comentarioCar" id="comentarioCar" rows="3" style="resize:none;border-style:double;width:100% ;max-width:100%"></textarea>
   				</div>
   			</div>
				<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" style="margin-top:4%">
					<button type="button" class="btn btn-success" id="btnCargos"><i class="fa fa-plus fa-lg"> </i>
						Cargo
					</button>
				</div>
        </div>
     <?php if( sizeof($cargos)>0 ){ ?>
       <table class="table">
         <thead>
           <tr>
             <th colspan="4" style="text-align:center">Cargos Extras</th>
           </tr>
           <tr>
             <th style="text-align:center">Motivo</th>
             <th style="text-align:center">Cantidad</th>
             <th style="text-align:center">Comentario</th>
             <th style="text-align:center">Acciones</th>
           </tr>
         </thead>
         <tbody>
           <?php
              foreach ($cargos as $cargo) {
                echo "<tr>";
                  echo "<td>".$cargo->motivo_ce."</td>";
                  echo "<td>$ ".number_format($cargo->cantidad_ce, 2, '.', ',')."</td>";
                  echo "<td>".$cargo->comentario_ce."</td>";
                  if($cargo->status==2 && in_array("CONCILIAR MOVIMIENTO",$permisos)){
                    echo "<td>
                      <i class='fa fa-check-square fa-lg' style='color:green' data-dismiss='modal' onclick='conciliarMovimiento(".$cargo->id.",\"cargo\",1)'></i>
                      <i class='fa fa-trash fa-lg' style='color:red' data-dismiss='modal' onclick='conciliarMovimiento(".$cargo->id.",\"cargo\",0)'></i> </td>";
                  }elseif($cargo->status==1){
                    echo "<td><i class='fa fa-envelope-o fa-lg' data-dismiss='modal' onclick='enviarCorreoMovimiento(".$cargo->id.",".$reserva.")' ></i></td>";
                  }else{
                    echo "<td><i class='fa fa-check-square fa-lg' ></i></td>";
                  }
                echo "</tr>";
              }
            ?>
         </tbody>
       </table>
     <?php } ?>
   </div>
   <?php } ?>
  <?php if($accion==1 || $accion == 2) { ?>
   <div id="descuento" class="container tab-pane  <?php if($accion!=1){ echo 'active'; } ?>">
     <div class="row">
			 <div class="col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
         <div class="form-group">
           <label for="motivoDesc">Motivo</label>
           <input class="form-control" type="text" name="motivoDesc" id="motivoDesc" value="" placeholder="Motivo">
         </div>
       </div>
       <div class="col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
         <div class="form-group">
           <label for="cantidadDesc">Cantidad</label>
           <input class="form-control" type="number" onkeypress="return isNumber(event)" name="cantidadDesc" id="cantidadDesc" value="0" placeholder="Cantidad ($)">
         </div>
       </div>
      <div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
        <div class="form-group">
          <label for="comentarioDesc">Comentario</label>
          <textarea name="comentarioDesc" id="comentarioDesc" rows="3" style="resize:none;border-style:double;width:100% ;max-width:100%"></textarea>
        </div>
      </div>

			<div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12" style="margin-top:4%">
				<button type="button" class="btn btn-info" id="btnDescuentos"><i class="fa fa-plus fa-lg"></i>
					Descuento
				</button>
			</div>

      </div>
      <?php if( sizeof($descuentos)>0 ){ ?>
        <table class="table">
          <thead>
            <tr>
              <th colspan="4" style="text-align:center">Descuentos</th>
            </tr>
            <tr>
              <th style="text-align:center">Motivo</th>
              <th style="text-align:center">Cantidad</th>
              <th style="text-align:center">Comentario</th>
              <th style="text-align:center">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <?php
               foreach ($descuentos as $descuento) {
                 echo "<tr>";
                   echo "<td>".$descuento->motivo_ce."</td>";
                   echo "<td>$ ".number_format($descuento->cantidad_ce, 2, '.', ',')."</td>";
                   echo "<td>".$descuento->comentario_ce."</td>";
                   if($descuento->status==2 && in_array("CONCILIAR MOVIMIENTO",$permisos)){
                     echo "<td>
                       <i class='fa fa-check-square fa-lg' style='color:green' data-dismiss='modal' onclick='conciliarMovimiento(".$descuento->id.",\"desc\",1)'></i>
                       <i class='fa fa-trash fa-lg' style='color:red' data-dismiss='modal' onclick='conciliarMovimiento(".$descuento->id.",\"desc\",0)'></i> </td>";
                   }elseif($descuento->status==1){
                     echo "<td><i class='fa fa-envelope-o fa-lg' data-dismiss='modal' onclick='enviarCorreoMovimiento(".$cargo->id.",".$reserva.")' ></i></td>";
                   }else{
                     echo "<td><i class='fa fa-check-square fa-lg' ></i></td>";
                   }
                 echo "</tr>";
               }
             ?>
          </tbody>
        </table>
      <?php } ?>
   </div>

 <?php } ?>
</div>

<script type="text/javascript">
  $("#btnCargos").on("click",function(){
    confirmarAgregarExtras();
  });
  $("#btnDescuentos").on("click",function(){
    confirmarDescuento();
  });
</script>
