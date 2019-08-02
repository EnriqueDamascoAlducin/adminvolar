cargarTabla();
function accionusuarios(accion, id) {
	if(accion=="agregar"){
		agregar("",accion);
	}else if(accion=="editar"){
		agregar(id,accion);
	}else if(accion='permisos'){
		asignarPermisos(id);
	}
}
function cargarTabla(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	depto = $("#depto").val();
	modulo = $("#modulo").val();

	url="vistas/usuarios/tablaUsuarios.php";
	parametros={fechaI:fechaI,fechaF:fechaF,empleado:empleado,nombre:nombre,modulo:modulo,depto:depto};
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
function imprimirReporte(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	modulo = $("#modulo").val();

	url= "vistas/usuarios/reporteexcel.php" ;
	parametros="?fechaI="+fechaI+"&fechaF="+fechaF+"&empleado="+empleado+"&nombre="+nombre;
	
	direcion = url+parametros;
	$("#imprimirReporte").attr("href",direcion);
	$("#imprimirReporte").click();
}

function eliminarusuarios(usuario, nombre){
	$("button[id^='btnElimiar']").remove();
	$("#tituloModal").html("Eliminar a "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar a "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+usuario+'" class="btn btn-danger" onclick=\'confirmarEliminar('+usuario+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+usuario).focus();
	//confirmarEliminar(usuario,nombre)
}

function confirmarEliminar(usuario,nombre){
	$.ajax({
		url:'controladores/usuariosController.php',
		method: "POST",
  		data: {usuario:usuario,accion:'cancelar'},
  		success:function(response){
  			if(response=='ok'){
  				abrir_gritter("Eliminado",  nombre+" Eliminado ","warning");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al eliminar a usuario","danger");
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
}
function agregar(id,accion){
	url="vistas/usuarios/forms/";
	parametros={id:id};
	if(accion=="ver"){
		parametros={id:id,accion:accion};
	}
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
function asignarPermisos(id){
	url="vistas/usuarios/forms/index2.php";
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