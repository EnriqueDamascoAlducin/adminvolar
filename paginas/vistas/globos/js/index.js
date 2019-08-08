cargarTabla();
function accionDeptos(accion, id) {
	if(accion=="agregar"){
		agregar("",accion);
	}else if(accion=="editar"){
		agregar(id,accion);
	}
}
function cargarTabla(){
	/*fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	*/	
	modulo = $("#modulo").val();
	
	url="vistas/globos/tabla.php";/*fechaI:fechaI,fechaF:fechaF,empleado:empleado,nombre:nombre,*/
	parametros={modulo:modulo};
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

function eliminarGlobo(globo, nombre){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Eliminar  "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar  el globo "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+globo+'" class="btn btn-danger" onclick=\'confirmarEliminar('+globo+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+globo).focus();
	//confirmarEliminar(usuario,nombre)
}

function confirmarEliminar(globo,nombre){
	$.ajax({
		url:'controladores/globosController.php',
		method: "POST",
  		data: {globo:globo,accion:'cancelar'},
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
function confirmarAgregar(globo,accion){
	nombre=$("#nombre").val().trim();
	placa=$("#placa").val().trim();
	peso=$("#peso").val().trim();
	if(nombre==""){
		abrir_gritter("Error","Ingresa un nombre","warning");
		return false;
	}
	if(placa==""){
		abrir_gritter("Error","Ingresa una placa","warning");
		return false;
	}
	if(peso==""){
		abrir_gritter("Error","Ingresa un peso","warning");
		return false;
	}
	var parametros = new FormData($("#formulario")[0]);
	$.ajax({
		url:'controladores/globosController.php',
		method: "POST",
		contentType:false,
		processData:false,
  		data: parametros,
  		success:function(response){
  			if(response=='Agregado' || response=='Actualizado' ){
  				abrir_gritter("Correcto",  " Globo "+response  ,"success");
  			}else{
  				abrir_gritter("Error",response  ,"danger");
  			}
			cargarTabla();
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
	if("editar"==accion){

		$("#tituloModal").html("Agregar Globo");
	}else{

		$("#tituloModal").html("Editar Globo");
	}

	$("button[id^='btn']").remove();
	$("#cuerpoModal").html("");
	if(idA==0)
		$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Agregar</button>');
	else	
		$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Actualizar</button>');
	
	$("#btnAgregar"+idA).focus();
	url="vistas/globos/forms/";
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
