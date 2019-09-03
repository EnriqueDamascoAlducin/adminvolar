cargarTabla();
function acciones(accion, id) {
	if(accion=="agregar"){
		agregar("",accion);
	}else if(accion=="editar"){
		agregar(id,accion);
	}
}
function cargarTabla(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	modulo = $("#modulo").val();

	url="vistas/hoteles/tabla.php";
	parametros={fechaI:fechaI,fechaF:fechaF,empleado:empleado,nombre:nombre,modulo:modulo};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		beforeSend:function(){
			$("#tablaUsuarios").html("<img src='../sources/images/icons/cargando.gif'>");
  		},
  		success:function(response){

			$("#tablaUsuarios").html(response);	
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
function eliminar(id, nombre){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Eliminar  "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar  el Hotel "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+id+'" class="btn btn-danger" onclick=\'confirmarEliminar('+id+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+id).focus();
	//confirmarEliminar(usuario,nombre)
}
function confirmarEliminar(id,nombre){
	$.ajax({
		url:'controladores/hotelesController.php',
		method: "POST",
  		data: {id:id,accion:'cancelar'},
  		success:function(response){
  			if(response!=''){
  				abrir_gritter("Eliminado",   nombre,"warning");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al eliminar " + nombre,"danger");
  			}
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
	$("#cuerpoModal").html("");
}
function agregar(id,accion){
	if(id==''){
		idA=0;
	}else{
		idA=id;
	}
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Registrar un Hotel  ");
	$("#cuerpoModal").html("");
	if(idA==0)
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Agregar</button>');
	else	
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Actualizar</button>');
	
	$("#btnAgregar"+idA).focus();
	url="vistas/hoteles/forms/";
	parametros={id:id};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModal").html(response);	
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

function confirmarAgregar(id,accion){
	nombre=$("#nombre").val().trim();
	calle=$("#calle").val().trim();
	noint=$("#noint").val().trim();
	noext=$("#noext").val().trim();
	colonia=$("#colonia").val().trim();
	municipio=$("#municipio").val().trim();
	estado=$("#estado").val();
	cp=$("#cp").val().trim();
	telefono=$("#telefono").val().trim();
	telefono2=$("#telefono2").val().trim();
	if(nombre==""){
		abrir_gritter("Error","Ingresa un Nombre","warning");
		return false;
	}
	if(estado=="0"){
		abrir_gritter("Error","Ingresa un Estado","warning");
		return false;
	}
	if(calle==""){
		abrir_gritter("Error","Ingresa una Calle","warning");
		return false;
	}
	if(telefono==""){
		abrir_gritter("Error","Ingresa un Télefono","warning");
		return false;
	}
	parametros={
		nombre:nombre,
		calle:calle,
		noint:noint,
		noext:noext,
		colonia:colonia,
		municipio:municipio,
		estado:estado,
		cp:cp,
		telefono:telefono,
		telefono2:telefono2,
		accion:accion,
		id:id
	};
	$.ajax({
		url:'controladores/hotelesController.php',
		method: "POST",
  		data: parametros,
  		success:function(response){
  			console.log(response);
  			if(response=='Agregado' || response=='Actualizado' ){
  				abrir_gritter(response,  " Hotel " + response  ,"success");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al Modificar Hotel"  ,"danger");
  			}
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
	$("#cuerpoModal").html("");
	agregar(id,accion)
}
tables(1,"desc");

function habitaciones(id,nombre,habitacion){
	if(habitacion==''){
		$("button[id^='btn']").remove();
		$("#tituloModal").html("Registrar una Habitacion para " + nombre);
		$("#cuerpoModal").html("");
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregarHabitaciones('+id+',"'+nombre+'","agregar")\' >Agregar</button>');
	}else{
		$("button[id^='btn']").remove();
		$("#tituloModal").html("Registrar una Habitacion para " + nombre);
		$("#cuerpoModal").html("");
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregarHabitaciones('+id+',"'+nombre+'","editar")\' >Actualizar</button>');		
	}
	url="vistas/hoteles/forms/habitaciones.php";
	parametros={id:id,nombre:nombre,habitacion:habitacion};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModal").html(response);	
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
}function confirmarAgregarHabitaciones(id,hotel){
	nombre=$("#nombre").val().trim();
	precio=$("#precio").val();
	capacidad=$("#capacidad").val().trim();
	descripcion=$("#descripcion").val().trim();
	idHabitacion=$("#idHabitacion").val().trim();
	accion=$("#accion").val().trim();
	hotel=$("#hotel").val().trim();
	if(nombre==""){
		abrir_gritter("Error","Ingresa un Nombre","warning");
		return false;
	}
	if(precio=="0"){
		abrir_gritter("Error","Ingresa un Precio","warning");
		return false;
	}
	if(capacidad==""){
		abrir_gritter("Error","Ingresa la Capacidad","warning");
		return false;
	}
	if(descripcion==""){
		abrir_gritter("Error","Ingresa una Descripción","warning");
		return false;
	}
	parametros={
		nombre:nombre,
		precio:precio,
		capacidad:capacidad,
		descripcion:descripcion,
		idHabitacion:idHabitacion,
		hotel:hotel,
		accion:accion,
		id:id
	};
	$.ajax({
		url:'controladores/habitacionesController.php',
		method: "POST",
  		data: parametros,
  		success:function(response){
  			if(response=='Agregado' || response=='Actualizado' ){
  				abrir_gritter(response,  " Hotel " + response  ,"success");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al Modificar Hotel"  ,"danger");
  			}
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
	$("#cuerpoModal").html("");
	habitaciones(id,hotel,'')
}
function eliminarHabitacion(id,accion, nombre,hotel){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Eliminar  "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar  La Habitación de "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+id+'" class="btn btn-danger" onclick=\'confirmarEliminarHabitacion('+id+',"'+accion+'","'+nombre+'","'+hotel+'")\' >Confirmar</button>');
	$("#btnElimiar"+id).focus();
	//confirmarEliminar(usuario,nombre)
}
function confirmarEliminarHabitacion(id,accion,nombre,hotel){
	$.ajax({
		url:'controladores/habitacionesController.php',
		method: "POST",
  		data: {id:id,accion:'cancelar'},
  		success:function(response){
  			if(response!=''){
  				abrir_gritter("Eliminado",'Habitación ELiminada',"warning");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al eliminar Habitación","danger");
  			}
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
	$("#cuerpoModal").html("");
	habitaciones(hotel,nombre);
}
function modificarHabitacion(id,accion, nombre,hotel){
	$("#btnAgregar").removeClass("btn-success").addClass("btn-info").text("Actualizar");
	var1 = "nombre_habitacion as nombre, idhotel_habitacion as hotel,precio_habitacion as precio,capacidad_habitacion as capacidad,descripcion_habitacion as descripcion";
	var2 = "habitaciones_volar";
	var3 = "id_habitacion="+id;
	url="controladores/query_json.php";
    parametros={var1:var1,var2:var2,var3:var3};		
    $.ajax({
	      data: parametros,
	      dataType:"json",
	      url:url,
	      type:"POST",
	      success: function(data){	
	        $.each( data, function( key, value ) {
			  nombre=value.nombre;
			  hotel=value.hotel;
			  precio=value.precio;
			  capacidad=value.capacidad;
			  descripcion=value.descripcion;
			  $("#nombre").val(nombre);
			  $("#hotel").val(hotel);
			  $("#capacidad").val(capacidad);
			  $("#precio").val(precio);
			  $("#accion").val('editar');
			  $("#descripcion").val(descripcion);
			  $("#idHabitacion").val(id);
			});

	      },
	      error:function(){
	      	abrir_gritter("Error","Error al cargar habitación","danger");
	      }

	    });
}