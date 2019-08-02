	$("input[id^='pasajeros']").attr("step",1);
	var date = new Date();
	var primerDia = new Date(date.getFullYear(), date.getMonth(), 1);
	var ultimoDia = new Date(date.getFullYear(), date.getMonth() + 1, 0);
 
	var currentDate = new Date();
	var wrong="";
	var dia = currentDate.getDate();
	var mes = currentDate.getMonth(); //Be careful! January is 0 not 1
	var year = currentDate.getFullYear();
	dia++;
	if(dia>ultimoDia.getDate()){
		dia=2;
		mes++;
	}

	dia2=dia;
	if(dia2<10){
		dia2="0"+dia2;
	}
	mes++;
	if(dia < 10){
		dia = "0"+dia;
	}

	if(mes < 10){
		mes = "0"+mes;
	}
	var fecha = year + "-" + (mes) + "-" + (dia);
	var fecha2 = year + "-" + (mes) + "-" + (dia2);
	$("#fechavuelo").attr("min",fecha2);
	$("input[id^='check']").attr("min",fecha);
	
	$("input[name='tdescuento']").on("click",function(){
		if($(this).val()=="1"){
			$("#cantdescuento1").attr("disabled","disabled");
			$("#cantdescuento").removeAttr("disabled");
		}else{
			$("#cantdescuento").attr("disabled","disabled");
			$("#cantdescuento1").removeAttr("disabled");

		}
		save_Data($(this).attr("name"),$(this).val());
	});
	$("#checkin").on("change",function(){
		$("#checkout").val(this.defaultValue);
		var checkIn=$(this).val();
		checkIn = checkIn.split("-");

		year=checkIn[0];
		mes=checkIn[1];
		dia=parseInt(checkIn[2])+1;
		if(dia>ultimoDia.getDate()){
			dia=1;
			mes++;
			if(mes < 10){
				mes = "0"+mes;
			}
		}
		if(dia < 10){
			dia = "0"+dia;
		}

		fecha= year + "-" + (mes) + "-" + (dia);
		$("#checkout").attr("min",fecha);
		$("#checkout").val(fecha);

	});
	$("input:not(:checkbox):not(#cantdescuento1)").on("blur",function(){
		if($(this).attr("name")=="mail"){
			if(!$(this).val().includes("@")){
				abrir_gritter("Error","No esta completo el correo","warning");
				$(this).val("");
				return false;
			}
		}else{

			$(this).val( $(this).val().toUpperCase() );
		}
		save_Data($(this).attr("name"),$(this).val());
	});
	$("#cantdescuento").on("change",function(){
		save_Data($(this).attr("name"),$(this).val());
	});
	$("#cantdescuento1").on("blur",function(){
		save_Data($(this).attr("name"),$(this).val());
	});
	$("select:not(#cantdescuento)").on("change",function(){
		save_Data($(this).attr("name"),$(this).val());
	});
	$("textarea").on("change",function(){
		save_Data($(this).attr("name"),$(this).val());
	});
	function validar_servicio(check, defa){
		campo=check.id;
		id=campo.split("_");
		servicio=id[1];
		if (defa==0) {
			pasajerosa = $("#pasajerosa").val();
			pasajerosn = $("#pasajerosn").val();
			if(pasajerosa==""){
				pasajerosa=0;
			}
			if(pasajerosn==""){
				pasajerosn=0;
			}
			defa=parseInt(pasajerosa)+parseInt(pasajerosn);
		}
		if(id[0]=="precio"){
			$("#cortesia_"+id[1]).prop("checked",false);
			value=defa;
			tipo=1;
		}else{
			$("#precio_"+id[1]).prop("checked",false);
			value=defa;
			tipo=2;
		}
		if(!$("#cortesia_"+servicio).is(":checked") && !$("#precio_"+servicio).is(":checked") ){
			value=0;
		}
		//2 es de cortesia ;1 es de paga
		guardarServicio(id[1],tipo,value);
		
	}
	$("#tdescuento").on("change",function(){
		$("#cantdescuento").val(0);
	});
	function enviarCotizacion(id){
		parametros={reserva:id};
		url="vistas/reservas/correo/correoCotizacion.php";
		$.ajax({
			url: url,
			method: "POST",
	  		data: parametros,
	  		success:function(response){
	  		    //$("body").html(response);
				abrir_gritter("Bien",response,"success");
	  		},
	  		error:function(){
	  			alert("Error");
	  		},
	  		statusCode: {
			    404: function() {
			     
					abrir_gritter("Error","URL no encontrada","danger");
			    }
			  }
		});
	}
	function save_Data(campo,value){
		url="controladores/reservaController.php";
		parametros={campo:campo, valor:value,id:idAct};
		
	  	$.ajax({
			url:url,
			method: "POST",
	  		data: parametros,
	  		success:function(response){
				if(response=="ok"){
					//abrir_gritter("Bien","Se registro Correctamente","success");
				}else{
					abrir_gritter("Error","No se pudo registrar" +response,"danger");
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
	function guardarServicio(servicio,tipo,defa){
		url="controladores/reservaController.php";
		parametros={servicio:servicio,tipo:tipo,valor:defa,id:idAct};
	  	$.ajax({
			url:url,
			method: "POST",
	  		data: parametros,
	  		success:function(response){
				if(response=="Actualizado" || response == "Agregado"){
					//abrir_gritter("Bien","Se registro Correctamente","success");
				}else{
					abrir_gritter("Error","No se pudo registrar" + response,"danger");
				}
	  		},
	  		error:function(){
	  		
	          abrir_gritter("Error","Error desconocido" ,"danger");
	  		},
	  		/**
be343816
17
	  		/
	  		statusCode: {
			    404: function() {
			     
	          abrir_gritter("Error","URL NO encontrada" ,"danger");
			    }
			  }
		});
	}
    $("input[type='number']").prop({'min':0,'max':9999999});

    function validar_datos(text,id){
		if($("#mail").val()==""){
			text="Error, debe de cargar un correo electronico";
			id="";
		}
		if($("#tipo").val()=="0"){
			text="Error, debe de cargar un Tipo de Vuelo";
			id="";
		}
		if($("#telcelular").val()==""){
				text="Error, debe de cargar un Teléfono Celular";
				id="";
		}
		if($("#fechavuelo").val()==""){
				text="Error, debe de cargar una Fecha de Vuelo";
				id="";
		}
		if($("#habitacion").val()!=""){
			
			if($("#checkin").val()==""){
				text="Error, debe de cargar un Checkin";
				id="";
			}if($("#checkout").val()==""){
				text="Error, debe de cargar un Checkout";
				id="";
			}
		}
	}
	function validarDatos(){
		var errores = 0;
		if($("#mail").val()==""){
			//abrir_gritter("Advertencia","Debe Cargar un correo","warning");
			errores++;
			wrong += "Error en el Correo. ";
		}
		if($("#telcelular").val()==""){
			//abrir_gritter("Advertencia","Debe Cargar un Telefono Celular","warning");
			errores++;
			wrong += "Error en el Telefono Celular. ";
		}
		if($("#tipo").val()==""){
			//abrir_gritter("Advertencia","Debe Seleccionar un tipo de Vuelo","warning");
			errores++;
			wrong += "Error en el Tipo de Vuelo. ";
		}
		if($("#fechavuelo").val()==""){
			//abrir_gritter("Advertencia","Debe Seleccionar una fecha de Vuelo","warning");
			errores++;
			wrong += "Error en la Fecha de Vuelo. ";
		}
		if($("#hotel").val()!=""){

			if($("#habitacion").val()==""){
				//abrir_gritter("Advertencia","Debe Seleccionar una Habitación","warning");
				errores++;
				wrong += "Error en la Habitación. ";
			}
			if($("#checkin").val()==""){
				//abrir_gritter("Advertencia","Debe Seleccionar su Checkin","warning");
				errores++;
				wrong += "Error en el CheckIn. ";
			}

			if($("#checkout").val()==""){
				//abrir_gritter("Advertencia","Debe Seleccionar su Checkout","warning");
				errores++;
				wrong += "Error en el CheckOut. ";
			}
			
		}
		pasajerosa=$("#pasajerosa").val();
		pasajerosn=$("#pasajerosn").val();
		if(pasajerosa==""){
			pasajerosa=0;
		}
		if(pasajerosn==""){
			pasajerosn=0;
		}
		if(parseInt(pasajerosn)+parseInt(pasajerosa)<1){
				//abrir_gritter("Advertencia","Debe Seleccionar la Canitdad de pasajeros","warning");
				errores++;
				wrong += "Debe de tener almenos un pasajero. ";
		}

		if($("#tdescuento").val()!="" || $("#tdescuento").val()!="0"){

			if($("#cantdescuento").val()==""){
				//abrir_gritter("Advertencia","Debe Seleccionar la cantidad de Descuento","warning");
				errores++;
				wrong += "Error en el Descuento. ";
			}
		}
		return errores;

	}
	function mostrarCotizacion(id,accion){
		wrong="";
		var errores = 0;
		$("#ConfirmarCotizacion").show();
		errores = validarDatos();
		if(errores>0){
			$("#ConfirmarCotizacion").hide();
		}
		url="vistas/reservas/tablaCotizacion.php";
		parametros={reserva:id, accion:accion};
		$("#cuerpoCotizacion").html("");
		$("#ConfirmarCotizacion").attr("onclick","enviarCotizacion("+id+")");
	  	$.ajax({
			url:url,
			method: "POST",
	  		data: parametros,
	  		beforeSend:function(){

				$("#cuerpoCotizacion").html("<img src='../sources/images/icons/cargando.gif'>");

	  		},
	  		success:function(response){
	  			if(errores>0)
					$("#cuerpoCotizacion").html("Errores: "+ wrong);
				else
					$("#cuerpoCotizacion").html(response);
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

	$("input[type='number']").attr("onkeypress","return isNumber(event)")
	function isNumber(event){
		var iKeyCode = (event.which) ? event.which : event.keyCode
        if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57))
            return false;

        return true;
	}


	$("#hotel").on("change",function(){
		cargarHabitaciones();
		habitacion="";
	});

	function cargarHabitaciones(){
		url="controladores/query_json.php";
		hotel=$("#hotel").val();
		if(hotel==""){
			return false;
		}
		var1="id_habitacion as value, nombre_habitacion as text";
		var2="habitaciones_volar";
		var3="status<>0 AND idhotel_habitacion="+hotel;
		//abrir_gritter("a","select " + var1 + " from "+ var2+ " where " + var3, "info");
        parametros={var1:var1,var2:var2,var3:var3};
      	$("#habitacion").empty().append("<option value=''>Selecciona una habitación </option>");
	  	$.ajax({
	      data: parametros,
	      dataType:"json",
	      url:'controladores/query_json.php',
	      type:"POST",
	      success: function(data){	
	        $.each( data, function( key, value ) {
			  text=value.text;
			  val=value.value;
			  attr="";
			  if(val==habitacion){
			  	attr="selected";
			  }
			  $("#habitacion").append("<option value='"+val+"' "+attr+">"+text+"</option>");
			});
	      },
	      error:function(){
	      	alert("Error al cargar habitación");
	      }

	    }); 
	}