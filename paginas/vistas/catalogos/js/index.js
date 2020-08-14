cargarTabla();
function accionExtras(accion, id, tipo) {
	if(accion=="agregar"){
		agregar("",accion,tipo);
	}else if(accion=="editar"){
		agregar(id,accion,tipo);
	}
}
function cargarTabla(){
	/*fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	*/
	modulo = $("#modulo").val();

	url="vistas/catalogos/tabla.php";/*fechaI:fechaI,fechaF:fechaF,empleado:empleado,nombre:nombre,*/
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

function eliminarExtra(extra, nombre){
	$("button[id^='btn']").remove();
	$("#tituloModal").html("Eliminar  "+ nombre);
	$("#cuerpoModal").html("Seguro que desea Eliminar  el globo "+ nombre + "?");
	$("#DivBtnModal").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+extra+'" class="btn btn-danger" onclick=\'confirmarEliminar('+extra+',"'+nombre+'")\' >Confirmar</button>');
	$("#btnElimiar"+extra).focus();
	//confirmarEliminar(usuario,nombre)
}

function confirmarEliminar(elemento,nombre){
	$.ajax({
		url:'controladores/catalogosController.php',
		method: "POST",
  		data: {elemento:elemento,accion:'cancelar'},
  		success:function(response){
  			if(response!=''){
  				abrir_gritter("Eliminado", response,"warning");
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
	cargarTabla();
	$("#cuerpoModal").html("");
}
function confirmarAgregar(elemento,accion){
	nombre=$("#nombre").val().trim();
	tipo = $("#clasificacion").val();
	if(nombre==""){
		abrir_gritter("Error","Ingresa un nombre","warning");
		return false;
	}
	var parametros = new FormData($("#formulario")[0]);
	$.ajax({
		url:'controladores/catalogosController.php',
		method: "POST",
		contentType:false,
		processData:false,
  		data: parametros,
  		success:function(response){
  			if(response=='Agregado' || response=='Actualizado' ){
  				abrir_gritter("Correcto",  " Catalogo "+response  ,"success");
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
	agregar('',accion,tipo);
}
function agregar(id,accion,tipo){
	if(id==''){
		idA=0;
	}else{
		idA=id;
	}
	if("editar"==accion){

		$("#tituloModal").html("Editar ");
	}else{

		$("#tituloModal").html("Agregar ");
	}

	$("button[id^='btn']").remove();
	$("#cuerpoModal").html("");
	if(idA==0)
		$("#DivBtnModal").append('<button autofocus type="button" id="btnAgregar" class="btn btn-success" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Agregar</button>');
	else
		$("#DivBtnModal").append('<button autofocus type="button" id="btnAgregar" class="btn btn-info" onclick=\'confirmarAgregar('+idA+',"'+accion+'")\' >Actualizar</button>');

	$("#btnAgregar"+idA).focus();
	url="vistas/catalogos/forms/";
	parametros={id:id,tipo:tipo};
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

function tables(filas,forma){
	$(".DataTable").DataTable().destroy();
	$(".DataTable").DataTable({
		"autoWidth": true,
		"scrollX": true,
		"searching": true,
		"lengthChange":true,
        "order": [[ filas, forma ]]

	});
}
