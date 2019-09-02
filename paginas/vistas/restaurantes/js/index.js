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

	url="vistas/restaurantes/tabla.php";
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
	$("#cuerpoModal").html("Seguro que desea Eliminar  el Restaurant "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+id+'" class="btn btn-danger" onclick=\'confirmarEliminar('+id+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+id).focus();
	//confirmarEliminar(usuario,nombre)
}
function confirmarEliminar(id,nombre){
	$.ajax({
		url:'controladores/restaurantesController.php',
		method: "POST",
  		data: {id:id,accion:'cancelar'},
  		success:function(response){
  			if(response!=''){
  				abrir_gritter("Eliminado",  nombre + " Eliminado","warning");
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
		idA='0';
	}else{
		idA=id;
	}
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Registrar un Tipo de Vuelo  ");
	$("#cuerpoModal").html("");
	if(idA=='0')
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregar("","'+accion+'")\' >Agregar</button>');
	else	
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Actualizar</button>');
	
	$("#btnAgregar"+idA).focus();
	url="vistas/restaurantes/forms/";
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
	hotel=$("#hotel").val();
	estado=$("#estado").val();
	calle=$("#calle").val().trim();
	noint=$("#noint").val().trim();
	noext=$("#noext").val().trim();
	colonia=$("#colonia").val().trim();
	municipio=$("#municipio").val().trim();
	cp=$("#cp").val().trim();
	telefono=$("#telefono").val().trim();
	telefono2=$("#telefono2").val().trim();
	precioa=$("#precioa").val().trim();
	precion=$("#precion").val().trim();
	if(nombre==""){
		abrir_gritter("Error","Ingresa un Nombre","warning");
		return false;
	}
	if(precioa==""){
		abrir_gritter("Error","Ingresa un Precio de Adulto","warning");
		return false;
	}
	if(precion==""){
		abrir_gritter("Error","Ingresa un Precio de Niño","warning");
		return false;
	}
	
	parametros={
		nombre:nombre,
		hotel:hotel,
		estado:estado,
		calle:calle,
		noint:noint,
		noext:noext,
		colonia:colonia,
		municipio:municipio,
		cp:cp,
		telefono:telefono,
		telefono2:telefono2,
		precioa:precioa,
		precion:precion,
		accion: accion,
		id:id
	};
	$.ajax({
		url:'controladores/restaurantesController.php',
		method: "POST",
  		data: parametros,
  		success:function(response){
  			console.log(response);
  			if(response=='Agregado' || response=='Actualizado' ){
  				abrir_gritter(response,  " Restaurante " + response  ,"success");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al Modificar Restaurant"  ,"danger");
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