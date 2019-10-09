cargarTabla();
function accionVtas(accion, id) {
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

	url="vistas/ventas/tabla.php";/**/
	parametros={fechaI:fechaI,fechaF:fechaF,modulo:modulo};
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
	parametros={id:id};
	if(accion=='ver'){
		parametros={id:id,accion:accion};
	}
	url="vistas/ventas/forms/";
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

function tables(){
	$(".DataTable").DataTable().destroy();
		$(".DataTable").dataTable( {
			"pageLength": 50,

	        "order": [[ '2','asc' ]]
		} );
}


function imprimirReporteVentas(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();

	url= "vistas/ventas/reportevtas.php" ;
	parametros="?fechaI="+fechaI+"&fechaF="+fechaF;

	direcion = url+parametros;
	$("#imprimirReporteVtas").attr("href",direcion);
	$("#imprimirReporteVtas").click();
}
