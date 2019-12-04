
function cargarTabla(){
	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	empleado = $("#empleado").val();
	reserva = $("#reserva").val();
	modulo = $("#modulo").val();
	url="vistas/pilotos/tabla.php";
	parametros={fechaI:fechaI,fechaF:fechaF,empleado:empleado,reserva:reserva,modulo:modulo};
	$.ajax({
		url:url,
		method: "POST",
			data: parametros,
			beforeSend:function(){
				$("#cargarTablaReservas").html("<img src='../sources/images/icons/cargando.gif'>");
			},
			success:function(response){

				$("#tabla").html(response);
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

function ocultarFila (nombre){
	$("th[id='th_"+nombre+"']").hide();
	$("td[id='td_"+nombre+"']").hide();
}
function tables(){
	$(".DataTable").DataTable().destroy();
		$(".DataTable").dataTable( {
			"pageLength": 50,
			"autoWidth": true,
			"scrollX": true,
	        "order": [[ '0','asc' ]]
		} );
}
function enviarCorreo(piloto,reserva,version){
	if(piloto == 0 && reserva== 0 && version ==0){
			parametros ={
				fechaI : $("#fechaI").val(),
				fechaF : $("#fechaF").val(),
				piloto : $("#empleado").val(),
				reserva: $("#reserva").val()
			};
	}else{
		parametros={
			piloto:piloto,
			reserva:reserva,
			version:version
		};
	}
	$.ajax({
		url:'vistas/pilotos/correo/correoPilotos.php',
		data:parametros,
		type:'POST',
		beforeSend:function(){
			abrir_gritter("Espera","Enviando Correo","info");
		},
		success:function(respuesta){
			if(respuesta.includes("error"))
				abrir_gritter("Error","No se pudo mandar el correo" + respuesta,"danger");
			else
				abrir_gritter("Correcto",respuesta,"success");
		},
		error:function(error,text,code){
			abrir_gritter("Error","Error "+ code,"danger");
		}
	});
}
