cargarTabla();
function accionDeptos(accion, id) {
	if(accion=="agregar"){
		agregar("",accion);
	}else if(accion=="editar"){
		agregar(id,accion);
	}else if(accion='puestos'){
		agregarPuestos(id);
	}
}
function cargarTabla(){
	preciomin = $("#preciomin").val();
	preciomax = $("#preciomax").val();
	modulo = $("#modulo").val();

	url="vistas/servicios/tabla.php";
	parametros={preciomin:preciomin,preciomax:preciomax,modulo:modulo};
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

function eliminarServicio(servicio, nombre){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Eliminar  "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar  "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+servicio+'" class="btn btn-danger" onclick=\'confirmarEliminar('+servicio+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+servicio).focus();
	//confirmarEliminar(usuario,nombre)
}

function confirmarEliminar(servicio,nombre){
	$.ajax({
		url:'controladores/serviciosController.php',
		method: "POST",
  		data: {servicio:servicio,accion:'cancelar'},
  		success:function(response){
  			if(response!=''){
  				abrir_gritter("Eliminado",  response,"warning");
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
	url="vistas/servicios/forms/";
	parametros={id:id};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#contenedor").html(response);	
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
tables();