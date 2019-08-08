cargarTabla();
function accionGastos(accion, id) {
	if(accion=="agregar"){
		agregar("",accion);
	}else if(accion=="ver"){
		agregar(id,accion);
	}
}
function cargarTabla(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	modulo = $("#modulo").val();

	url="vistas/pagos/tabla.php";
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
function confirmarAgregar(id,accion){
	fecha=$("#fecha").val().trim();
	tipo=$("#tipo").val();
	cantidad=$("#cantidad").val().trim();
	metodo=$("#metodo").val();
	referencia=$("#referencia").val().trim();
	comentario=$("#comentario").val().trim();
	if(fecha==""){
		abrir_gritter("Error","Ingresa una Fecha","warning");
		return false;
	}
	if(tipo=="0"){
		abrir_gritter("Error","Ingresa un Tipo de Gasto","warning");
		return false;
	}
	if(cantidad==""){
		abrir_gritter("Error","Ingresa una cantidad","warning");
		return false;
	}
	if(metodo=="0"){
		abrir_gritter("Error","Ingresa un Metodo de Pago","warning");
		return false;
	}
	if(referencia==""){
		abrir_gritter("Error","Ingresa una Referencia","warning");
		return false;
	}
	if(comentario==""){
		abrir_gritter("Error","Ingresa un Comentario","warning");
		return false;
	}
	parametros={
		fecha:fecha,
		tipo:tipo,
		cantidad:cantidad,
		metodo:metodo,
		referencia:referencia,
		comentario:comentario
	};
	$.ajax({
		url:'controladores/gastosController.php',
		method: "POST",
  		data: parametros,
  		success:function(response){
  				abrir_gritter("Eliminado",  response  ,"success");
  			if(response=='Agregado' || response=='Actualizado' ){
  				abrir_gritter("Eliminado",  " Departamento "  ,"success");
				cargarTabla();
  			}else{
  				abrir_gritter("Error","Error al eliminar el Departamento"  ,"danger");
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
function agregar(id,accion){
	if(id==''){
		idA=0;
	}else{
		idA=id;
	}
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Registrar un Gasto  ");
	$("#cuerpoModal").html("");
	if(idA==0)
		$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Agregar</button>');
	//else	
		//$("#DivBtnModal").append('<button autofocus   type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Actualizar</button>');
	
	$("#btnAgregar"+idA).focus();
	url="vistas/pagos/forms/";
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