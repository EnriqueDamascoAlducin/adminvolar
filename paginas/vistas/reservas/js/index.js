
function accionReserva(accion, id) {
	if(accion=="agregar"){
		agregarReserva("",accion);
	}else if(accion=="editar"){
		agregarReserva(id,accion);
	}else if(accion=="ver"){
		agregarReserva(id,accion);
	}
}

function cargarTablaReservas(){

	fechaI = $("#fechaI").val();
	fechaF = $("#fechaF").val();
	cliente = $("#cliente").val();
	status = $("#status").val();
	empleado = $("#empleado").val();
	reserva = $("#reserva").val();
	modulo = $("#modulo").val();

	url="vistas/reservas/tablaReservas.php";
	parametros={fechaI:fechaI,fechaF:fechaF,cliente:cliente,status:status,empleado:empleado,reserva:reserva,modulo:modulo};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		beforeSend:function(){

			$("#cargarTablaReservas").html("<img src='../sources/images/icons/cargando.gif'>");
  		},
  		success:function(response){

			$("#tablaReservas").html(response);
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
	cliente = $("#cliente").val();
	status = $("#status").val();
	empleado = $("#empleado").val();
	reserva = $("#reserva").val();
	modulo = $("#modulo").val();
	metodo = $("#metodo").val();
	abrir_gritter("Espere","Generando Reporte...","info");
	url= "vistas/reservas/excel/reporteexcel.php" ;
	parametros="?fechaI="+fechaI+"&fechaF="+fechaF+"&cliente="+cliente+"&status="+status+"&empleado="+empleado+"&reserva="+reserva+"&metodo="+metodo;

	direcion = url+parametros;
	$("#imprimirReporte").attr("href",direcion);
	$("#imprimirReporte").click();
}
function eliminarReserva(url,reserva,idModulo){
	$("button[id^='btn']").remove();
	$("#cuerpoModalReservas").html("Desea Eliminar la Reserva "+ reserva);
	$("#tituloModalReservas").html("Eliminar Reserva "+ reserva);
	$("#divBtnModalReservas").append('<button autofocus  data-dismiss="modal" type="button" id="btnElimiar'+reserva+'" class="btn btn-danger" onclick=\'confirmarEliminar('+reserva+',"'+url+'", '+idModulo+');\' >Confirmar</button>');
	$("#btnElimiar"+reserva).focus();
}

function confirmarEliminar(reserva,url,idModulo){
	$.ajax({
		url:'controladores/reservaController.php',
		method: "POST",
  		data: {reserva:reserva,accion:'cancelar'},
  		success:function(response){
  			if(response=='ok'){
  				abrir_gritter("Eliminada","Reserva Eliminada " + reserva,"warning");
				cargarTablaReservas();
  			}else{

  				abrir_gritter("Error","Error al eliminar a reserva " + response,"danger");
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

function confirmarAgregarPago(reserva,cliente){
	error = 0;
	metodo=$("#metodo").val().trim();
	banco=$("#banco").val().trim();
	referencia=$("#referencia").val().trim();
	cantidad=$("#cantidad").val().trim();
	fecha=$("#fecha").val().trim();
	peso=$("#peso").val();
	tipopeso=$("#tipopeso").val();
	moneda=$("#moneda").val();
	var monedaInfo = $("#moneda	option:selected").text().split("$");
	monedaPrecio =  parseFloat(monedaInfo[1]).toFixed(2);
	cantidad = parseFloat(cantidad * monedaPrecio).toFixed(2);

	if(metodo!=0 ){
		if(metodo=="0"){
			abrir_gritter("Advertencia","Debe Capturar un metodo","warning");
			error++;
		}
		if(banco=="0"){
			abrir_gritter("Advertencia","Debe Capturar un banco","warning");
			error++;
		}
		if(referencia==""){
			abrir_gritter("Advertencia","Debe Capturar una referencia","warning");
			error++;
		}
		if(cantidad=="" ){
			abrir_gritter("Advertencia","Debe Capturar una cantidad","warning");
			error++;
		}
		if(fecha==""){
			abrir_gritter("Advertencia","Debe Capturar una fecha","warning");
			error++;
		}
		datos={
  			reserva:reserva,
  			metodo:metodo,
				banco:banco,
				referencia:referencia,
				cantidad:cantidad,
				fecha:fecha,
				peso:peso,
				tipopeso:tipopeso,
				moneda:moneda,
				monedaPrecio:monedaPrecio,
  			accion:'registrarPago'
		};
	}else{
		abrir_gritter("Advertencia","Solo se modificará el peso.","info");
		datos={
				peso:peso,
  			reserva:reserva,
				tipopeso:tipopeso,
				accion:'registrarPago'
		};
	}

	if (error>0)
		return false;
	$.ajax({
		url:'controladores/pagosController.php',
		method: "POST",
  		data: datos,
  		success:function(response){
  			if(response.includes("ERROR"))
  				abrir_gritter(response, "No se puede realizar esta acción" ,"warning");
  			else
  				abrir_gritter("Correcto", response ,"info");

  			agregarPago(reserva,cliente);

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
	cambiarTamanoModal("modalSize","lg",'resetear');
}
function agregarPago(reserva,cliente){

	$("button[id^='btn']").remove();
	$("#cuerpoModalReservas").html("Agregar Pago para "+ cliente);
	$("#tituloModalReservas").html("Agregar Pago para "+ cliente);
	cambiarTamanoModal("modalSize","lg",'agregar');
	$("#divBtnModalReservas").append('<button autofocus   type="button" id="btnAgregarPago'+reserva+'" class="btn btn-success" onclick="confirmarAgregarPago('+reserva+',\''+cliente+'\');" >Confirmar</button>');
	$("#btnPago"+reserva).focus();
	url="vistas/reservas/forms/agregarPagos.php";
	parametros={reserva:reserva};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModalReservas").html(response);
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

function agregarPagoSitio(reserva,cliente){

	cambiarTamanoModal("modalSize","lg",'agregar');
	$("button[id^='btn']").remove();
	$("#cuerpoModalReservas").html("Agregar Pago para "+ cliente);
	$("#tituloModalReservas").html("Agregar Pago para "+ cliente);
	$("#divBtnModalReservas").append('<button autofocus   type="button" id="btnAgregarPago'+reserva+'" class="btn btn-success" onclick="confirmaragregarPagoSitio('+reserva+',\''+cliente+'\');" >Confirmar</button>');
	$("#btnPago"+reserva).focus();
	url="vistas/reservas/forms/agregarPagosSitio.php";
	parametros={reserva:reserva};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModalReservas").html(response);
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

function confirmaragregarPagoSitio(reserva,cliente){
	metodo=$("#metodo").val();
	banco=$("#banco").val();
	referencia=$("#referencia").val().trim();
	cantidad=$("#cantidad").val().trim();
	fecha=$("#fecha").val().trim();
	comision=$("#comision").val().trim();
	cupon=$("#cupon").val();
	moneda=$("#moneda").val();
	var monedaInfo = $("#moneda	option:selected").text().split("$");
	monedaPrecio =  parseFloat(monedaInfo[1]).toFixed(2);
	if(cantidad=="" ){
		abrir_gritter("Advertencia","Debe Capturar una cantidad","warning");
		return false;
	}
	cantidad = parseFloat(cantidad * monedaPrecio);
	datos={
			reserva:reserva,
			metodo:metodo,
			banco:banco,
			referencia:referencia,
			cantidad:cantidad,
			comision:comision,
			fecha:fecha,
			cupon:cupon,
			moneda:moneda,
			monedaPrecio:monedaPrecio,
			accion:'registrarPagoSitio'
	};
	$.ajax({
		url:'controladores/pagosController.php',
		method: "POST",
		data: datos,
		success:function(response){

			if(response.includes("ERROR"))
				abrir_gritter(response, "No puedes agregar mas pagos" ,"warning");
			else
				abrir_gritter("Correcto", response ,"info");
			cargarTablaReservas();
			agregarPagoSitio(reserva,cliente);

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

		cambiarTamanoModal("modalSize","lg",'resetear');
}
function conciliarPago(reserva,cliente){
	$("button[id^='btn']").remove();
	$("#cuerpoModalReservas").html("Conciliar Pagos para "+ cliente);
	$("#tituloModalReservas").html("Conciliar Pagos para "+ cliente);
	cambiarTamanoModal("modalSize","lg",'agregar');
	url="vistas/reservas/forms/conciliarPagos.php";
	parametros={reserva:reserva};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModalReservas").html(response);
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
function agregarReserva(id,accion){
	url="vistas/reservas/forms/";
	parametros={id:id};
	if(accion=="ver"){
		parametros={id:id,accion:accion};
	}
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		beforeSend:function(){
			$("#contenedor").html('<img src="../sources/images/icons/cargando.gif" style="max-width:70%;width:100%" >');
  		},
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
function ConfirmarAsistencia(reserva,cliente,accion){


	$.ajax({
		url:'controladores/reservaController.php',
		method: "POST",
  		data: {
				reserva:reserva,
  			accion:accion
  		},
  		success:function(response){
				if(accion=="cpc"){
					if(response=="")
						abrir_gritter(response, "No se pudo enviar a Cuentas por cobrar" ,"warning");
					else
						abrir_gritter("Correcto", "Se envío a Cuentas por Cobrar." ,"info");

				}else{
	  			if(response=="")
	  				abrir_gritter(response, "No se pudo confirmar la asitencia" ,"warning");
	  			else
	  				abrir_gritter("Correcto", "Gracias por confirmar la asistencia." ,"info");

				}
				cargarTablaReservas();
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
function checkAsistencia (reserva,nombre){

		$("button[id^='btn']").remove();
		$("#tituloModalReservas").html("Confirmar Asistencia para "+ nombre);
		cambiarTamanoModal("modalSize","lg",'agregar');
		$("#btnPago"+reserva).focus();
		url="vistas/reservas/forms/confirmarAsistencia.php";
		parametros={reserva:reserva};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModalReservas").html(response);
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
	cambiarTamanoModal("modalSize","lg",'resetear');
}
function mostrarCotizacion(id,accion){

	cambiarTamanoModal("modalSize","lg",'agregar');
	$("button[id^='btn']").remove();
	$("#tituloModalReservas").html("Cotización "+ id);
	url="vistas/reservas/tablaCotizacion.php";
	parametros={reserva:id, accion:accion};
	$("#cuerpoModalReservas").html("");
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		beforeSend:function(){
			$("#cuerpoModalReservas").html("<img src='../sources/images/icons/cargando.gif'>");
  		},
  		success:function(response){

				$("#cuerpoModalReservas").html(response);
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

function verBitacora(reserva){

		$("button[id^='btn']").remove();
		$("#tituloModalReservas").html("Bitacora de Reserva "+ reserva);
		cambiarTamanoModal("modalSize","lg",'agregar');
		url="vistas/reservas/forms/bitacora	.php";
		parametros={reserva:reserva};
  	$.ajax({
		url:url,
		method: "POST",
  		data: parametros,
  		success:function(response){
			$("#cuerpoModalReservas").html(response);
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
function asignarGlobo(reserva){

	url="vistas/reservas/forms/asignGlobo.php";
	parametros={reserva:reserva};
	$.ajax({
	url:url,
	method: "POST",
		data: parametros,
		success:function(response){
				$("#contenedor").html(response);
	//	$("#cuerpoModalReservas").html(response);
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
function confirmarAsignarGlobo(reserva){
	hora = $("#hora").val();
  turno = $("#turno").val();
	datos	=	{
			hora:hora,
			turno:turno,
			reserva:reserva,
			accion:'horario'
	};
	$.ajax({
			url:'controladores/reservaController.php',
			method: "POST",
  		data: datos,
  		success:function(response){
  			if(response=="ok")
  				abrir_gritter("Correcto", "Datos Correctos." ,"info");
  			else
					abrir_gritter("Error", "No se pudo registrar estos datos." + response,"warning");

				asignarGlobo(reserva);
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
function reprogramar(reserva, cliente){

	$("button[id^='btn']").remove();
	$("#tituloModalReservas").html("Reprogramar Rereserva para "+ cliente);
	cambiarTamanoModal("modalSize","lg",'resetear');
	$("#divBtnModalReservas").append('<button autofocus type="button"  data-dismiss="modal" id="btnReprograma'+reserva+'" class="btn btn-success" onclick="confirmarReprogramacion('+reserva+');" >Confirmar</button>');
	url="vistas/reservas/forms/reprogramacion.php";
	$.ajax({
		url:url,
		method: "POST",
		data: {reserva:reserva},
		success:function(response){
		 $("#cuerpoModalReservas").html(response)
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
function confirmarReprogramacion(reserva){
	url = 'controladores/reservaController.php';
	var motivo = $("#motivo").val();
	var fechavuelo = $("#fechavuelo").val();
	var cargo = $("#cargo").val();
	var comentario = $("#comentario").val();
	datos={
		motivo:motivo,
		fechavuelo:fechavuelo,
		cargo:cargo,
		comentario:comentario,
		reserva:reserva,
		accion:'reprogramar'
	};
	$.ajax({
		url:url,
		method: "POST",
		data: datos,
		success:function(response){
			if(response=="Reprogramado"){
				abrir_gritter("Ok!",response ,"info");
				cargarTablaReservas();
			}else{
				abrir_gritter("Error",response ,"danger");
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

function comentario(reserva,nombre){

	$("button[id^='btn']").remove();
	$("#tituloModalReservas").html("Agregar Comentario ");
	cambiarTamanoModal("modalSize","lg",'resetear');
	$("#divBtnModalReservas").append('<button autofocus type="button"  data-dismiss="modal" id="btnComentar'+reserva+'" class="btn btn-success" onclick="confirmarComentar('+reserva+');" >Confirmar</button>');
	url="vistas/reservas/forms/comentarios.php";
	$.ajax({
			url:url,
			method: "POST",
			data: {reserva:reserva},
			success:function(response){
			 $("#cuerpoModalReservas").html(response)
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

function confirmarComentar(reserva){
	url = 'controladores/reservaController.php';
	var comentario = $("#comentario").val();
	datos={
		comentario:comentario,
		reserva:reserva,
		accion:'comentar'
	};
	$.ajax({
			url:url,
			method: "POST",
			data: datos,
			success:function(response){
				if(response=="Actualizado"){
						abrir_gritter("Ok!",response ,"info");
				}else{
						abrir_gritter("Error",response ,"danger");
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



function agregarExtras(reserva,nombre,acciones){
	$("button[id^='btn']").remove();
	if(acciones==1)
		titulo = "Descuentos y Cargos";
	else if(acciones==2)
		titulo = "Descuentos";
	else
		titulo = "Cargos Extras ";
	$("#tituloModalReservas").html("Agregar "+ titulo);
	cambiarTamanoModal("modalSize","lg",'agregar');
	url="vistas/reservas/forms/cargosExtras.php";
	$.ajax({
			url:url,
			method: "POST",
			data: {reserva:reserva,nombre:nombre,acciones:acciones},
			success:function(response){
			 $("#cuerpoModalReservas").html(response)
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


function confirmarAgregarExtras(){
	motivoCar = $("#motivoCar").val();
	cantidadCar = $("#cantidadCar").val();
	comentarioCar = $("#comentarioCar").val();
	reserva = $("#reservaCar").val();
	nombre = $("#nombre").val();
	acciones = $("#acciones").val();
	if(motivoCar.trim()==""){
		$("#motivoCar").focus();
		abrir_gritter("Advertencia","Agrega un Motivo","warning");
		return false;
	}
	if(cantidadCar.trim()=="" || cantidadCar == 0){
		$("#cantidadCar").focus();
		abrir_gritter("Advertencia","Agrega una cantidad","warning");
		return false;
	}
	if(comentarioCar.trim()==""){
		$("#comentarioCar").focus();
		abrir_gritter("Advertencia","Agrega un Comentario","warning");
		return false;
	}
	url = 'controladores/pagosController.php';
	datos = {
		motivoCar:motivoCar,
		cantidadCar:cantidadCar,
		comentarioCar:comentarioCar,
		reserva:reserva,
		accion:'cargosExtras'
	};
	$.ajax({
			url:url,
			method: "POST",
			data: datos,
			success:function(response){
				if(response=="ok"){
						abrir_gritter("Ok!","Cargo registrado" ,"info");
				}else{
						abrir_gritter("Error",response ,"danger");
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
	agregarExtras(reserva,nombre,acciones);
	cargarTablaReservas();
}



function confirmarDescuento(){
	motivoCar = $("#motivoDesc").val();
	cantidadCar = $("#cantidadDesc").val();
	comentarioCar = $("#comentarioDesc").val();
	reserva = $("#reservaCar").val();
	nombre = $("#nombre").val();
	acciones = $("#acciones").val();
	if(motivoCar.trim()==""){
		$("#motivoDesc").focus();
		abrir_gritter("Advertencia","Agrega un Motivo","warning");
		return false;
	}
	if(cantidadCar.trim()=="" || cantidadCar == 0){
		$("#cantidadDesc").focus();
		abrir_gritter("Advertencia","Agrega una cantidad","warning");
		return false;
	}
	if(comentarioCar.trim()==""){
		$("#comentarioDesc").focus();
		abrir_gritter("Advertencia","Agrega un Comentario","warning");
		return false;
	}
	url = 'controladores/pagosController.php';
	datos = {
		motivoCar:motivoCar,
		cantidadCar:cantidadCar,
		comentarioCar:comentarioCar,
		reserva:reserva,
		accion:'descuentos'
	};
	$.ajax({
			url:url,
			method: "POST",
			data: datos,
			success:function(response){
				if(response=="ok"){
						abrir_gritter("Ok!","Cargo registrado" ,"info");
				}else{
						abrir_gritter("Error",response ,"danger");
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
	agregarExtras(reserva,nombre,acciones);
	cargarTablaReservas();
}
function guardaGlobo() {
	reserva = $("#reservaG").val();
	piloto = $("#piloto").val();
	globo = $("#globo").val();
	version = $("#version").val();
	peso = $("#peso").val().trim();
	pax = $("#pax").val().trim();
	comentario = $("#comentario").val().trim();
	datos	=	{
			piloto:piloto,
			globo:globo,
			reserva:reserva,
			version:version,
			peso:peso,
			pax:pax,
			comentario:comentario,
			accion:'globos'
	};
	if(globo=="0"){
		abrir_gritter("Advertencia","Debe elegir un globo","warning");
		return false;
	}
	if(peso==""){
		abrir_gritter("Advertencia","Debe elegir un peso","warning");
		return false;
	}
	$.ajax({
			url:'controladores/reservaController.php',
			type: "POST",
  		data: datos,
  		success:function(response){
  			if(response=="ok")
  				abrir_gritter("Correcto", "Datos Correctos." ,"info");
  			else
					abrir_gritter("Error", "No se pudo registrar estos datos." + response,"warning");

				asignarGlobo(reserva);
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

function eliminarGlobo(reserva,version){
datos	=	{
		reserva:reserva,
		version:version,
		accion:'eliminarGlobos'
};
	$.ajax({
			url:'controladores/reservaController.php',
			type: "POST",
			data: datos,
			success:function(response){
				if(response=="ok")
					abrir_gritter("Correcto", "Datos Correctos." ,"info");
				else
					abrir_gritter("Error", "No se pudo registrar estos datos." + response,"warning");

				asignarGlobo(reserva);
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

function asignarGlobos(){
	fechaI = $("#fechaI").val();

		url="vistas/reservas/forms/asignGlobo.php";
		parametros={fechaI:fechaI};
		$.ajax({
		url:url,
		method: "POST",
			data: parametros,
			success:function(response){
					$("#contenedor").html(response);
		//	$("#cuerpoModalReservas").html(response);
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


function conciliarMovimiento(movimiento, tipo,status){
	url = 'controladores/reservaController.php';
	datos={
		movimiento:movimiento,
		tipo:tipo,
		status:status,
		accion:'conciliarMovimiento'
	};
	$.ajax({
			url:url,
			method: "POST",
			data: datos,
			success:function(response){
				abrir_gritter("Ok!",response ,"info");
				cargarTablaReservas();
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
function enviarCorreoMovimiento(movimiento,reserva){
	url = 'vistas/reservas/correo/correoMovimiento.php';
	datos={
		movimiento:movimiento,
		reserva:reserva
	};
	$.ajax({
			url:url,
			method: "POST",
			data: datos,
			success:function(response){
				abrir_gritter("Ok!",response ,"info");
				cargarTablaReservas();
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
			"autoWidth": true,
			"scrollX": true,
	        "order": [[ '4','asc' ]]
		} );
}
