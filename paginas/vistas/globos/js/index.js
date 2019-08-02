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
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	modulo = $("#modulo").val();

	url="vistas/deptos/tabla.php";
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

function eliminarDepto(depto, nombre){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Eliminar  "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar  "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+depto+'" class="btn btn-danger" onclick=\'confirmarEliminar('+depto+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+depto).focus();
	//confirmarEliminar(usuario,nombre)
}
function confirmarAgregarPuesto(depto,nombre){
	nombre=$("#puesto").val();
	puesto=$("#idPuesto").val().trim();
	depto=$("#depto").val().trim();
	accion = "registrarPuesto";
	url='controladores/deptosController.php';
	parametros={
		nombre:nombre,
		puesto:puesto,
		depto:depto,
		accion:accion
	};
	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
  			if(response!="Error"){
  				abrir_gritter("Exito",response,"info");
  			}else{
  				abrir_gritter("Error",response,"warning");
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
	agregarPuestos(depto,nombre);
}
function agregarPuestos(depto,nombre){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Agregar Nuevo Puesto  a "+nombre);
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnAgregar'+depto+'" class="btn btn-info" onclick=\'confirmarAgregarPuesto('+depto+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnAgregar"+depto).focus();
	url="vistas/deptos/forms/index2.php";
	parametros={id:depto,nombre:nombre};
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
	//confirmarEliminar(usuario,nombre)
}

function confirmarEliminar(depto,nombre){
	$.ajax({
		url:'controladores/deptosController.php',
		method: "POST",
  		data: {depto:depto,accion:'cancelar'},
  		success:function(response){
  			if(response!=''){
  				abrir_gritter("Eliminado",  nombre + " " + response,"warning");
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

function accionesPuesto(puesto,accion,nombre,depto){

	parametros={puesto:puesto,accion:accion};
	$.ajax({
		url:'controladores/deptosController.php',
		method: "POST",
  		data: parametros,
  		success:function(response){
  			if(response.includes("|")){
  				puesto = response.split("|");
  				$("#idPuesto").val(puesto[1]);
  				$("#puesto").val(puesto[0]);
  				alert(puesto[0]);
  			}else{
  				abrir_gritter("Eliminado",  response ,"warning");
				agregarPuestos(depto,nombre);
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
function confirmarAgregar(depto,accion){
	nombre=$("#nombre").val().trim();
	if(nombre==""){
		abrir_gritter("Error","Ingresa un nombre","warning");
		return false;
	}
	$.ajax({
		url:'controladores/deptosController.php',
		method: "POST",
  		data: {depto:depto,nombre:nombre,accion:accion},
  		success:function(response){
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
}
function agregar(id,accion){
	if(id==''){
		idA=0;
	}else{
		idA=id;
	}
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Registrar Nueva Area  ");
	$("#cuerpoModal").html("");
	if(idA==0)
		$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Agregar</button>');
	else	
		$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Actualizar</button>');
	
	$("#btnAgregar"+idA).focus();
	url="vistas/deptos/forms/";
	parametros={id:id};
	if(accion=="ver"){
		parametros={id:id,accion:accion};
	}
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
tables();