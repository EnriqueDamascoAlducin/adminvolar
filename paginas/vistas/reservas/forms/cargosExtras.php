<?php
  $accion = $_POST['acciones'];
?>

 <ul class="nav nav-tabs" role="tablist">
   <?php if($accion==1 || $accion == 3) { ?>
     <li class="nav-item" onclick="cambiarOpcion(1)">
       <a class="nav-link active" data-toggle="tab" href="#registro">Registrar Cargo</a>
     </li>
   <?php } ?>
   <?php if($accion==1 || $accion == 2) { ?>
     <li class="nav-item" onclick="cambiarOpcion(2)">
       <a class="nav-link <?php if($accion!=1){ echo 'active'; } ?>" data-toggle="tab" href="#descuento">Realizar Descuento</a>
     </li>
   <?php } ?>
 </ul>


 <div class="tab-content">

   <?php if($accion==1 || $accion == 3) { ?>
     <div id="registro" class="container tab-pane active">
       <div class="row">
         <div class="col-5 col-sm-5 col-md-5 col-lg-5 col-xl-5">
           <div class="form-group">
             <label for="motivoCar">Motivo</label>
             <input class="form-control" type="text" name="motivoCar" id="motivoCar" value="" placeholder="Motivo">
           </div>
         </div>
         <div class="col-5 col-sm-5 col-md-5 col-lg-5 col-xl-5">
           <div class="form-group">
             <label for="cantidadCar">Cantidad</label>
             <input class="form-control" type="number" onkeypress="return isNumber(event)" name="cantidadCar" id="cantidadCar" value="0" placeholder="Cantidad ($)">
           </div>
         </div>
         <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2" style="margin-top:4%">
           <button type="button" class="btn btn-success" id="btnCargos"><i class="fa fa-plus fa-lg"></i>
           </button>
         </div>

   			<div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
   				<div class="form-group">
   					<label for="comentario">Comentario</label>
   					<textarea name="comentario" id="comentario" rows="3" style="resize:none;border-style:double;width:100% ;max-width:100%"></textarea>
   				</div>
   			</div>
        </div>
     </div>
   <?php } ?>
  <?php if($accion==1 || $accion == 2) { ?>
   <div id="descuento" class="container tab-pane  <?php if($accion!=1){ echo 'active'; } ?>">
     <div class="row">
       <div class="col-5 col-sm-5 col-md-5 col-lg-5 col-xl-5">
         <div class="form-group">
           <label for="motivoDesc">Motivo</label>
           <input class="form-control" type="text" name="motivoCar" id="motivoCar" value="" placeholder="Motivo">
         </div>
       </div>
       <div class="col-5 col-sm-5 col-md-5 col-lg-5 col-xl-5">
         <div class="form-group">
           <label for="cantidadDesc">Cantidad</label>
           <input class="form-control" type="number" onkeypress="return isNumber(event)" name="cantidadDesc" id="cantidadDesc" value="0" placeholder="Cantidad ($)">
         </div>
       </div>
       <div class="col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2" style="margin-top:4%">
         <button type="button" class="btn btn-success" id="btnDescuentos"><i class="fa fa-plus fa-lg"></i>
         </button>
       </div>

      <div class="col-sm-12 col-lg-12 col-md-12 col-12 col-xl-12 ">
        <div class="form-group">
          <label for="comentarioDesc">Comentario</label>
          <textarea name="comentarioDesc" id="comentarioDesc" rows="3" style="resize:none;border-style:double;width:100% ;max-width:100%"></textarea>
        </div>
      </div>
      </div>
   </div>
 <?php } ?>
</div>
