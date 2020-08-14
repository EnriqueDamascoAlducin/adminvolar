cargarTabla();
function accion(accion, id) {
	if(accion=="agregar"){
		agregar("",accion);
	}else if(accion=="editar"){
		agregar(id,accion);
	}
}
function cargarTabla(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	modulo = $("#modulo").val();
	cond = $("#cond").val();

	url="vistas/souvenirs/tabla.php";
	parametros={fechaI:fechaI,fechaF:fechaF,modulo:modulo,cond:cond};
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
function agregar(id,accion){
	if(id==''){
		idA=0;
	}else{
		idA=id;
	}
	cambiarTamanoModal("modalSize","lg","agregar");
	$("#btnAgregar"+idA).focus();
	url="vistas/souvenirs/forms/";
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

function imprimirReporte(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	nombre = $("#nombre").val();
	tipo = $("#tipog").val();

	url= "vistas/souvenirs/reporteexcel.php" ;
	parametros="?fechaI="+fechaI+"&fechaF="+fechaF+"&empleado="+empleado+"&tipo="+tipo;

	direcion = url+parametros;
	$("#imprimirReporte").attr("href",direcion);
	$("#imprimirReporte").click();
}

function eliminarSouvenir(id,souvenir){
	$.ajax({
		url:'controladores/souvenirsController.php',
		data:{souvenir:id,accion:'eliminar'},
		type:'post',
		success:function(response) {
			if(response=='Eliminado'){
				cargarTabla();
				abrir_gritter("Exito",souvenir+ " se elimino correctamente","success");
			}else{
					abrir_gritter("Error",souvenir+ " no se pudo eliminar","danger");
			}
		},
		error:function(){
			abrir_gritter("Error","Error","danger");
		}
	});
}


function enviarForm(){
	if(validarCampos()){
		formulario = $("#formulario");
		url = formulario.attr("action");
		type = formulario.attr("method");
		parametros = formulario.serialize();
		$.ajax({
			url:url,
			type:type,
			data:parametros,
			beforeSend:function(){
				abrir_gritter("Alerta","Registrando Souvenir","info");
			},
			success:function(respuesta){
				if(respuesta=="error"){
					abrir_gritter("Error","No se pudo registrar el souvenir","danger");
				}else{
					abrir_gritter("Exito","Se registro el souvenir "+ respuesta, "success");
				}
				accion("agregar","");
				cargarTabla();
			},
			error:function(jqXHR, textStatus, errorThrown){
				abrir_gritter("Error",textStatus,"danger");

			}
		});
	}
}
