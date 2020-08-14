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

	url="vistas/clientes/tabla.php";
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
	$("#btnAgregar"+idA).focus();
	url="vistas/clientes/forms/";
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

	url= "vistas/clientes/reporteexcel.php" ;
	parametros="?fechaI="+fechaI+"&fechaF="+fechaF+"&empleado="+empleado+"&tipo="+tipo;

	direcion = url+parametros;
	$("#imprimirReporte").attr("href",direcion);
	$("#imprimirReporte").click();
}

function eliminarCliente(id,rs){
	$.ajax({
		url:'controladores/clientesController.php',
		data:{cliente:id,accion:'eliminar'},
		type:'post',
		success:function(response) {
			if(response=='Eliminado'){
				cargarTabla();
				abrir_gritter("Exito",rs+ " se elimino correctamente","success");
			}else{
					abrir_gritter("Error",rs+ " no se pudo eliminar","danger");
			}
		},
		error:function(){
			abrir_gritter("Error","Error","danger");
		}
	});
}
